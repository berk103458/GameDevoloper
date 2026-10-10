## Gerçek CHR kabulü → kuyu krizi → gece/fısıltı kartı → koru/sürgün → kayıt.
extends Node
const H = preload("res://src/koy/batil_inanc_histerisi.gd")
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_kri08.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 808)
		kayit = GuvenliKayit.new("user://test_kri08_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0

func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var o := ana.oturum
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.isyan_esigi = -1
	y.a.ambar_taban_kapasite = 10000
	y.a.emniyet_nufus = 100000
	ana.katalog.koy_ayarlari = y.a
	y.kaynaklar = Kaynaklar.new(10000, {"gida": 500, "su": 100, "kirec": 10, "odun": 100, "tas": 100, "kereste": 100})
	y.akce = 200
	y.gun = 6
	o.muhafiz_akce = 77
	for idx in 3: y.kabul({"ad": "Komşu %d" % idx})
	var k := y.koylu(o.karar_ver(o._adli_gelen(&"chr_008"), &"kabul").koylu_id)
	var sif := _kur(y, "sifahane")
	_kontrol(k != null and sif != null and y.ata(k.id, sif.id) and HekimIlac.etkin(y), "Gerçek kapı kabulü/otacı/Şifahane")
	var id := k.id
	ana._koye_git()
	await get_tree().process_frame
	var e: Node = ana._ekran
	_kontrol(KrizEnjektoru.uygula(ana, "kuyu").ok, "Gerçek debug kirli kuyu krizi")
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol(H.bekliyor(y) and H.durum(y).vaka.hedef == id and _metin(e._ust_kart).contains("Haksız söylenti"), "Gerçek gece raporunda masum Dudu hedefi")
	await _bas_text(e._ust_kart, tr("koy.rapor.sabah"))
	_kontrol(_metin(e._ust_kart).contains("masum") and _metin(e._ust_kart).contains("Histeri 1/3") and not _metin(e._ust_kart).contains("Clue_") and not _metin(e._ust_kart).contains("chr_"), "Mevcut fısıltı/olay kartı açık masumiyet, sır/Clue ifşası yok")
	var kanit := _dugme(e._ust_kart, "Gerçek sebebi göster")
	_kontrol(kanit != null and kanit.disabled, "Kirli kuyu sürerken sebep açıklaması kilitli")
	_kontrol(ana.kayit.yaz(o.kaydet()), "Gerçek GuvenliKayit pending histeri")
	var pending := ana.kayit.oku()
	var adalet := y.adalet
	var moral := y.koylular[0].moral
	await _bas_text(e._ust_kart, "Koru")
	_kontrol(H.durum(y).vaka.karar == "koru" and y.koylu(id) != null and y.koylu(id).is_yeri == sif.id, "Mevcut sabah kartından koruma, Dudu/hekim ataması kalır")
	_kontrol(y.adalet == mini(100, adalet + 8) and y.koylular[0].moral == maxi(0, moral - 4) and _metin(e._ust_kart).contains("Muhafızın adalet kararı"), "Somut adalet ve kısa moral sonucu görünür")
	await _bas_text(e._ust_kart, tr("arayuz.olay.devam"))
	while ana._kapi_yukleniyor: await get_tree().process_frame
	ana._koye_git()
	await get_tree().process_frame
	e = ana._ekran
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol(H.durum(y).iade.is_empty() and H.durum(y).vaka.karar == "koru", "Ertesi gerçek gece iade, aynı krizde yeniden suçlama yok")
	_kontrol(ana.kayit.yaz(o.kaydet()), "Korunmuş hedef ve iade sonrası güvenli kayıt")
	var geri := Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(geri.yonetim.koylu(id) != null and H.durum(geri.yonetim).vaka.karar == "koru" and geri.yonetim.koylu(id).is_yeri == sif.id, "Koruma restore, hekim ataması korunur")
	# Aynı pending gerçek kayıttan ayrı göz yum ve sürgün dalları; HUD erişimi.
	for secim in ["goz_yum", "surgun"]:
		ana.oturum = Oturum.kayittan(ana.katalog, pending)
		y = ana.oturum.yonetim
		o = ana.oturum
		ana._koye_git()
		await get_tree().process_frame
		e = ana._ekran
		await _bas(e.hud, "histeri_karari")
		_kontrol(_metin(e._ust_kart).contains("masum"), "Pending yükleme HUD'dan karar erişimi")
		adalet = y.adalet
		var stok := y.kaynaklar.kaydet()
		var rng := y._rng.state
		var b := e._ust_kart.find_child("histeri_" + secim, true, false) as Button
		_kontrol(b != null and not b.disabled, "Gerçek haksızlık düğmesi")
		if b != null:
			b.pressed.emit()
			var once := JSON.stringify(o.kaydet())
			b.pressed.emit()
			_kontrol(JSON.stringify(o.kaydet()) == once, "Aynı kare çift tık tek sonuç")
		await get_tree().process_frame
		_kontrol(y.koylu(id) == null and not HekimIlac.etkin(y) and Sifahane.tedavi_kapasitesi(y) == 0, "Gerçek ayrılık/Şifahane-hekim kaybı")
		_kontrol(y.adalet == maxi(0, adalet - 25) and o.muhafiz_vicdani.yuk >= 50 and DivanHaksizligi.durum(y).has(str(id)), "Gerçek adalet/vicdan/ortak haksızlık bedeli")
		_kontrol(KuyuKirliligi.kirli(y) and y.kaynaklar.kaydet() == stok and y._rng.state == rng and o.muhafiz_akce == 77 and _metin(e._ust_kart).contains("Kriz çözülmedi"), "Haksızlık çözüm/ödül değildir, sonuç kartında açık")
		await _bas(e._ust_kart, "histeri_don")
		_kontrol(ana.kayit.yaz(o.kaydet()), "Haksızlık gerçek güvenli kaydı")
		geri = Oturum.kayittan(ana.katalog, ana.kayit.oku())
		_kontrol(geri.yonetim.koylu(id) == null and H.durum(geri.yonetim).vaka.karar == secim and geri.muhafiz_vicdani == o.muhafiz_vicdani and geri.kadro.durumlar[&"chr_008"].durum == &"kalici_ayrildi", "Kalıcı ayrılık/histeri/vicdan restore")
	# Gerçek kuyu bilgi düğmesi ile kireçleme, sonra açıklama.
	ana.oturum = Oturum.kayittan(ana.katalog, pending)
	y = ana.oturum.yonetim
	ana._koye_git()
	await get_tree().process_frame
	e = ana._ekran
	e._secili_bina = KuyuKireclemePaneli.MEYDAN_KUYUSU
	e._bilgi_goster()
	await _bas(e._bilgi_icerik, "kuyu_kirecle")
	_kontrol(not KuyuKirliligi.kirli(y) and KrizEnjektoru.kalan(y) == 0, "Gerçek kuyu kireçleme krizi çözer")
	await _bas(e.hud, "histeri_karari")
	await _bas(e._ust_kart, "histeri_gercek")
	_kontrol(H.durum(y).vaka.karar == "gercek" and y.koylu(id) != null and _metin(e._ust_kart).contains("histeri söndü"), "Gerçek sebebi açıklama hızlı sönüm, Dudu korunur")
	_kontrol(ana.kayit.yaz(ana.oturum.kaydet()), "Gerçek sebep güvenli kaydı")
	geri = Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(H.durum(geri.yonetim).vaka.karar == "gercek" and not KuyuKirliligi.kirli(geri.yonetim), "Kireçleme ve sönüm restore")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	print("BATIL İNANÇ HİSTERİSİ UI: GEÇTİ" if hata == 0 else "BATIL İNANÇ HİSTERİSİ UI: KALDI")
	await Ses.cik(hata)

func _bas(n: Node, ad: String) -> void:
	var b := n.find_child(ad, true, false) as Button if n != null else null
	_kontrol(b != null and not b.disabled, "Gerçek düğme: " + ad)
	if b != null and not b.disabled: b.pressed.emit()
	await get_tree().process_frame

func _bas_text(n: Node, metin: String) -> void:
	var b := _dugme(n, metin)
	_kontrol(b != null and not b.disabled, "Gerçek düğme: " + metin)
	if b != null and not b.disabled: b.pressed.emit()
	await get_tree().process_frame

func _dugme(n: Node, metin: String) -> Button:
	if n == null: return null
	for b in n.find_children("*", "Button", true, false):
		if b.text.contains(metin) and not b.is_queued_for_deletion(): return b
	return null

func _metin(n: Node) -> String:
	if n == null: return ""
	var r: String = n.text if n is Label else ""
	for c in n.get_children(): r += " " + _metin(c)
	return r

func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h).olur:
				var b := y.bina(y.bina_kur(tur, h).id)
				b.insa_kalan = 0
				return b
	return null

func _kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
