## Gerçek kriz API'si -> HUD -> toplu oy -> uygulama/ret -> GuvenliKayit.
extends Node
class OlaysizOturum extends Oturum:
	func olay_sec() -> OlayVerisi: return null
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_kri07.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = OlaysizOturum.new(katalog, 307)
		kayit = GuvenliKayit.new("user://test_kri07_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0

func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	await _kuyu_uygulama_ve_ret()
	await _kitlik_gecesi()
	await _salgin_ve_yas()
	await _haftalik_dis_hat()
	print("ÇINAR ALTI MECLİSİ UI: GEÇTİ" if hata == 0 else "ÇINAR ALTI MECLİSİ UI: KALDI")
	await Ses.cik(hata)

func _hazir(ana: Ana) -> KoyYonetimi:
	var y := ana.oturum.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	ana.katalog.koy_ayarlari = y.a
	y.kaynaklar = Kaynaklar.new(10000, {"gida": 100, "kirec": 10, "odun": 100, "tas": 100, "kereste": 100})
	y.akce = 200
	ana.oturum.muhafiz_akce = 77
	for idx in 4:
		var k := y.kabul({"ad": "Gizli kimlik %d" % idx})
		k.moral = 60
		k.sadakat = 80
		k.gizli_egilim.tur = "haydut"
	return y

func _kuyu_uygulama_ve_ret() -> void:
	var ana := TestAna.new()
	add_child(ana)
	var y := _hazir(ana)
	ana._koye_git()
	await get_tree().process_frame
	var e: KoyEkrani = ana._ekran
	_kontrol(KrizEnjektoru.uygula(ana, "kuyu").ok, "Gerçek debug kuyu krizi ve normal HUD yenilemesi")
	var rng := y._rng.state
	await _bas(e.hud, "cinar_meclisi")
	_kontrol(_metin(e._ust_kart).contains("Kuyuyu 2 kireçle") and _metin(e._ust_kart).contains("Ambarı aç"), "Somut iki seçenek kartta gösterilir")
	await _bas(e._ust_kart, "meclis_topla_kuyu")
	var o: Dictionary = CinarAltiMeclisi.durum(y).oylama
	_kontrol(o.oylar == [4, 0] and _metin(e._ust_kart).contains("4 oy (%100)") and _metin(e._ust_kart).contains("Halkın kararı"), "Gerçek HUD kartında sonuç ve oy dağılımı")
	_kontrol(not _metin(e._ust_kart).contains("Gizli kimlik") and not _metin(e._ust_kart).contains("haydut") and y._rng.state == rng, "UI yalnız toplamları gösterir, RNG yok")
	var once := JSON.stringify(y.kaydet())
	e._gece_dugmesi.pressed.emit()
	_kontrol(JSON.stringify(y.kaydet()) == once and e._gece_dugmesi.disabled, "Pending karar gerçek gece akışını atlayamaz")
	_kontrol(ana.kayit.yaz(ana.oturum.kaydet()), "Gerçek GuvenliKayit pending meclis")
	var pending := ana.kayit.oku()
	ana.oturum = Oturum.kayittan(ana.katalog, pending)
	y = ana.oturum.yonetim
	ana._koye_git()
	await get_tree().process_frame
	e = ana._ekran
	_kontrol(e._ust_kart != null and e._ust_kart.find_child("meclis_uygula", true, false) != null and CinarAltiMeclisi.durum(y).oylama == o, "Yükleme pending sonuç kartını otomatik geri açar")
	var moral := y.koylular[0].moral
	var sadakat := y.koylular[0].sadakat
	var kirec := y.kaynaklar.miktar("kirec")
	var uygula := e._ust_kart.find_child("meclis_uygula", true, false) as Button
	_kontrol(uygula != null and not uygula.disabled, "Gerçek uygulama açık")
	if uygula != null:
		uygula.pressed.emit()
		once = JSON.stringify(y.kaydet())
		uygula.pressed.emit()
		_kontrol(JSON.stringify(y.kaydet()) == once, "Aynı kare çift tık tek bedel/ödül")
	await get_tree().process_frame
	_kontrol(not KuyuKirliligi.kirli(y) and KrizEnjektoru.kalan(y) == 0 and y.kaynaklar.miktar("kirec") == kirec - 2, "Halkın kireçleme kararı mevcut kriz API'sini uygular")
	_kontrol(y.koylular[0].moral == moral + 3 and y.koylular[0].sadakat == sadakat + 4 and int(e.hud._huzur_bar.value) == y.huzur(), "Gerçek moral/sadakat ve HUD huzuru")
	_kontrol(ana.oturum.muhafiz_akce == 77 and _metin(e._ust_kart).contains("Halkın kararı uygulandı"), "Kişisel kese korunur, karar gösterilir")
	await _bas(e._ust_kart, "meclis_don")
	_kontrol(e._ust_kart == null and not e._gece_dugmesi.disabled, "Karardan sonra köye/geceye dönüş")
	_kontrol(ana.kayit.yaz(ana.oturum.kaydet()), "Uygulanan karar güvenli kaydı")
	var geri := Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(CinarAltiMeclisi.durum(geri.yonetim).oylama.karar == "uygulandi" and not KuyuKirliligi.kirli(geri.yonetim), "Uygulanan kriz/karar makbuzu restore")
	# Aynı pending güvenli kayıttan ayrı gerçek ret dalı.
	ana.oturum = Oturum.kayittan(ana.katalog, pending)
	y = ana.oturum.yonetim
	ana._koye_git()
	await get_tree().process_frame
	e = ana._ekran
	var adalet := y.adalet
	sadakat = y.koylular[0].sadakat
	var stok := y.kaynaklar.stok.duplicate(true)
	await _bas(e._ust_kart, "meclis_ret")
	_kontrol(y.adalet == adalet - 5 and y.koylular[0].sadakat == sadakat - 6 and KuyuKirliligi.kirli(y) and y.kaynaklar.stok == stok, "Gerçek ret bedelsiz; adalet/sadakat düşer, kriz sürer")
	_kontrol(_metin(e._ust_kart).contains("Muhafız kararıyla reddedildi"), "Gerçek ret sonucu görünür")
	await _bas(e._ust_kart, "meclis_don")
	await _bas(e.hud, "cinar_meclisi")
	var ikinci := e._ust_kart.find_child("meclis_topla_kuyu", true, false) as Button
	_kontrol(ikinci != null and ikinci.disabled, "Aynı kriz için yeniden meclis kilidi")
	if ikinci != null:
		once = JSON.stringify(y.kaydet())
		ikinci.pressed.emit()
		_kontrol(JSON.stringify(y.kaydet()) == once, "Disabled/bayat toplama modelde etki yapmaz")
	await _bas(e._ust_kart, "meclis_don")
	_kontrol(ana.kayit.yaz(ana.oturum.kaydet()), "Reddedilen karar güvenli kaydı")
	geri = Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(CinarAltiMeclisi.durum(geri.yonetim).oylama.karar == "reddedildi" and geri.yonetim.adalet == y.adalet, "Ret ve adalet kayıt restore")
	var legacy := ana.oturum.kaydet()
	legacy.koy_yonetimi.erase("cinar_alti_meclisi")
	_kontrol(CinarAltiMeclisi.durum(Oturum.kayittan(ana.katalog, legacy).yonetim).oylama.is_empty(), "Gerçek legacy oturum güvenli")
	await _bitir(ana)

func _kitlik_gecesi() -> void:
	var ana := TestAna.new()
	add_child(ana)
	var y := _hazir(ana)
	y.a.isyan_esigi = -1
	for k in y.koylular:
		k.moral = 100
		k.gizli_egilim.tur = "yok"
	y.kaynaklar.azalt("gida", 10000)
	ana._koye_git()
	await get_tree().process_frame
	for idx in 2:
		var e: KoyEkrani = ana._ekran
		e._gece_dugmesi.pressed.emit()
		await get_tree().process_frame
		_kontrol(e._ust_kart != null and e.hud.find_child("cinar_meclisi", true, false).disabled, "Gerçek gece raporunda meclis açılmaz")
		var sabah := _dugme(e._ust_kart, tr("koy.rapor.sabah"))
		_kontrol(sabah != null, "Gece raporunda sabah düğmesi")
		if sabah != null: sabah.pressed.emit()
		await get_tree().process_frame
		while ana._kapi_yukleniyor: await get_tree().process_frame
		ana._koye_git()
		await get_tree().process_frame
	var e: KoyEkrani = ana._ekran
	_kontrol(KitlikIsyani.durum(y).tetiklendi and y.isyan_kalan >= 0, "İki gerçek sıfır gece kıtlık isyanı")
	await _bas(e.hud, "cinar_meclisi")
	await _bas(e._ust_kart, "meclis_topla_kitlik")
	_kontrol(CinarAltiMeclisi.durum(y).oylama.secenekler[CinarAltiMeclisi.durum(y).oylama.kazanan] == "as", "Aç köy gerçek akışta aş dağıtımını seçer")
	var uygulama := e._ust_kart.find_child("meclis_uygula", true, false) as Button
	_kontrol(uygulama != null and uygulama.disabled, "Erzaksız aş uygulaması kapalı; ret açık")
	y.kaynaklar.ekle("gida", 100)
	# Kaynak tedarikinden sonra bekleyen kartı HUD'dan yeniden aç.
	await _bas(e._ust_kart, "meclis_don")
	await _bas(e.hud, "cinar_meclisi")
	var gida := y.kaynaklar.miktar("gida")
	await _bas(e._ust_kart, "meclis_uygula")
	_kontrol(y.kaynaklar.miktar("gida") == gida - y.nufus() * y.a.as_dagit_gida and CinarAltiMeclisi.durum(y).oylama.karar == "uygulandi", "Mevcut as_dagit API'si, tam bedel, isyan dönemi korunur")
	_kontrol(ana.kayit.yaz(ana.oturum.kaydet()), "Gerçek kıtlık meclisi kaydı")
	await _bitir(ana)

func _haftalik_dis_hat() -> void:
	var ana := TestAna.new()
	add_child(ana)
	var y := _hazir(ana)
	y.agalik = true
	y.set_meta(KoyYonetimi.PERDE_GECISI.META, 1)
	var hafta := y.a.mevsim_gun
	var hafta_baslari: Array[int] = []
	for gun in range(hafta, hafta + 12):
		y.gun = gun
		if CinarAltiMeclisi.haftalik_bekliyor(y): hafta_baslari.append(gun)
	var beklenen: Array[int] = []
	for gun in range(hafta, hafta + 12, hafta): beklenen.append(gun)
	_kontrol(hafta_baslari == beklenen, "OMR-44: 12 gecede yalnız takvimin hafta başları")
	y.gun = hafta
	ana.oturum.haberci_agi = {"bekleyen": [
		{"kaynak": "oba", "gun": y.gun, "metin": "Oba anlaşması görüşülüyor."},
		{"kaynak": "sancak", "gun": y.gun, "metin": "Sancak fermanı görüşülüyor."},
	]}
	KuyuKirliligi.kirlet(y)
	ana._koye_git()
	await get_tree().process_frame
	var e := ana._ekran as KoyEkrani
	_kontrol(KuyuKirliligi.kirli(y), "OMR-44: aynı gece canlı kuyu şikâyeti")
	_kontrol(_metin(e._ust_kart).contains("Sancak fermanı görüşülüyor.") and not _metin(e._ust_kart).contains("Oba anlaşması"), "OMR-44: dış hat önceliği mevcut HaberciAgi kaydından")
	_kontrol(not CinarAltiMeclisi.topla(y, "kuyu"), "OMR-44: aynı gece yeni köy şikâyeti açılmaz")
	e._geceye_gec()
	_kontrol(y.gun == hafta and e._ust_kart != null and e._ust_kart.find_child("meclis_haftalik_bitti", true, false) != null, "OMR-44: toplantı gece hesabından önce")
	await _bas(e._ust_kart, "meclis_haftalik_bitti")
	_kontrol(not CinarAltiMeclisi.haftalik_bekliyor(y) and not CinarAltiMeclisi.topla(y, "kuyu"), "OMR-44: bitince aynı gece tekrar açılmaz")
	CinarMeclisPaneli.ac(e)
	_kontrol(e._ust_kart == null, "OMR-44: bitince aynı gece şikâyet kartı açılmaz")
	var veri: Dictionary = JSON.parse_string(JSON.stringify(ana.oturum.kaydet()))
	ana.oturum = Oturum.kayittan(ana.katalog, veri)
	y = ana.oturum.yonetim
	ana._koye_git()
	await get_tree().process_frame
	e = ana._ekran
	_kontrol(e._ust_kart == null and not CinarAltiMeclisi.haftalik_bekliyor(y), "OMR-44: kayıt dönüşünde tamamlanan toplantı açılmaz")
	y.gun = hafta + 1
	_kontrol(CinarAltiMeclisi.topla(y, "kuyu"), "OMR-44: ertesi uygun gece köy şikâyeti sürebilir")
	await _bitir(ana)


func _bas(n: Node, ad: String) -> void:
	var b := n.find_child(ad, true, false) as Button if n != null else null
	_kontrol(b != null and not b.disabled, "Gerçek düğme: " + ad)
	if b != null and not b.disabled: b.pressed.emit()
	await get_tree().process_frame

func _salgin_ve_yas() -> void:
	var ana := TestAna.new()
	add_child(ana)
	var y := _hazir(ana)
	var hekim := y.kabul({"ad": "Hekim"})
	hekim.zanaat_turu = ZanaatTuru.Tur.CERRAH
	hekim.yapi_bilgisi = PackedStringArray(["ambar", "sifahane"])
	_kontrol(_kur(y, "ambar") != null, "Şifahane için mevcut yapı kademesi")
	var sif := _kur(y, "sifahane")
	_kontrol(sif != null and y.ata(hekim.id, sif.id), "Gerçek Şifahane/hekim")
	if sif == null:
		await _bitir(ana)
		return
	ana._koye_git()
	await get_tree().process_frame
	var e: KoyEkrani = ana._ekran
	# Hekim dışındaki halkın gerçek açık enfeksiyonları.
	for k in y.koylular:
		if k == hekim: continue
		SaglikYoneticisi.enfekte(y, k)
		k.bayrak_ac("hasta")
	e._yenile()
	await _bas(e.hud, "cinar_meclisi")
	await _bas(e._ust_kart, "meclis_topla_salgin")
	await _bas(e._ust_kart, "meclis_uygula")
	_kontrol(KarantinaYoneticisi.dolu(y, sif.id) == 2 and not KarantinaYoneticisi.aktif(hekim), "Gerçek salgın meclisi mevcut iki yatağı doldurur; hekim işler")
	_kontrol(ana.kayit.yaz(ana.oturum.kaydet()), "Gerçek salgın meclisi/izolasyon kaydı")
	var geri := Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(KarantinaYoneticisi.dolu(geri.yonetim, sif.id) == 2 and CinarAltiMeclisi.durum(geri.yonetim).oylama.karar == "uygulandi", "Karantina ve meclis birlikte restore")
	await _bitir(ana)
	ana = TestAna.new()
	add_child(ana)
	y = _hazir(ana)
	for k in y.koylular: k.gizli_egilim.tur = "yok"
	var kayip := y.koylular[0]
	SaglikYoneticisi.enfekte(y, kayip, "veba")
	kayip.saglik = 1
	ana._koye_git()
	await get_tree().process_frame
	e = ana._ekran
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol(y.koylu(kayip.id) == null and CenazeYasi.bekliyor(y), "Gerçek ölüm gecesi/cenaze raporu")
	await _bas(e._ust_kart, "cenaze_toplu_mezar")
	var sabah := _dugme(e._ust_kart, tr("koy.rapor.sabah"))
	_kontrol(sabah != null and not sabah.disabled, "Cenaze tamamlanınca sabah")
	if sabah != null: sabah.pressed.emit()
	await get_tree().process_frame
	while ana._kapi_yukleniyor: await get_tree().process_frame
	ana._koye_git()
	await get_tree().process_frame
	e = ana._ekran
	for k in y.koylular: k.ac = true
	await _bas(e.hud, "cinar_meclisi")
	await _bas(e._ust_kart, "meclis_topla_yas")
	_kontrol(CinarAltiMeclisi.durum(y).oylama.secenekler == ["as", "vergi"], "Gerçek yas meclisi verilmiş cenaze kararını korur")
	await _bas(e._ust_kart, "meclis_uygula")
	_kontrol(CenazeYasi.durum(y).secim == "toplu_mezar" and CinarAltiMeclisi.durum(y).oylama.karar == "uygulandi", "Gerçek yas desteği/aş uygulaması")
	_kontrol(ana.kayit.yaz(ana.oturum.kaydet()), "Gerçek yas meclisi güvenli kaydı")
	await _bitir(ana)

func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h).olur:
				var b := y.bina(y.bina_kur(tur, h).id)
				b.insa_kalan = 0
				return b
	return null

func _dugme(n: Node, metin: String) -> Button:
	if n == null: return null
	if n is Button and n.text == metin: return n
	for c in n.get_children():
		var b := _dugme(c, metin)
		if b != null: return b
	return null

func _metin(n: Node) -> String:
	if n == null: return ""
	var r: String = n.text if n is Label else ""
	for c in n.get_children(): r += " " + _metin(c)
	return r

func _bitir(ana: Ana) -> void:
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame

func _kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
