## Gerçek CHR kapı kabulü → kart ataması → reçete düğmesi → gece → kayıt.
extends Node
class OlaysizOturum extends Oturum:
	func olay_sec() -> OlayVerisi: return null
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_kri03.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = OlaysizOturum.new(katalog, 222)
		kayit = GuvenliKayit.new("user://test_kri03_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var o := ana.oturum
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.isyan_esigi = -1
	y.a.ambar_taban_kapasite = 10000
	ana.katalog.koy_ayarlari = y.a
	y.kaynaklar.kapasite = 10000
	for tur in ["gida", "odun", "tas", "kereste"]: y.kaynaklar.ekle(tur, 500)
	y.kaynaklar.ekle("afyon", 2)
	y.kaynaklar.ekle("su", 5)
	var sif := _kur(y, "sifahane")
	var ikon := TextureRect.new()
	_kontrol(GezginStokIkonu.ikon(ikon, "ilac") and ikon.get_child(0) is ColorRect, "İlaç mevcut kutu ikon adaptörünü kullanır")
	ikon.free()
	var hekim := y.koylu(o.karar_ver(o._adli_gelen(&"chr_008"), &"kabul").koylu_id)
	var g := Gelen.new()
	g.ad_anahtari = "İlaç bekleyen"
	g.gizli_bayraklar = ["humma"]
	var hasta := y.koylu(o.karar_ver(g, &"kabul").koylu_id)
	# KRI-13 triyajı tek kontenjanı en düşük sağlıklıya verir: ilaç bekleyen en ağır hastadır.
	hasta.saglik = 4
	g = Gelen.new()
	g.ad_anahtari = "Kritik hasta"
	g.gizli_bayraklar = ["veba"]
	var kritik := y.koylu(o.karar_ver(g, &"kabul").koylu_id)
	kritik.saglik = 8
	ana._koye_git()
	await get_tree().process_frame
	var e: KoyEkrani = ana._ekran
	KoyluKarti.ac(e, hekim.id)
	await get_tree().process_frame
	var ata: Button
	for dugme in e._ust_kart.find_children("*", "Button", true, false):
		if dugme.get_meta("hedef", -100) == sif.id: ata = dugme
	_kontrol(ata != null, "Kartta mevcut Şifahane ataması")
	if ata == null: await Ses.cik(1); return
	ata.pressed.emit()
	await get_tree().process_frame
	_kontrol(hekim.is_yeri == sif.id and HekimIlac.etkin(y), "Karttan gerçek hekim atandı")
	var satir := e.find_child("hekim_ilac_bilgisi", true, false) as Label
	_kontrol(satir != null and satir.text.contains("−%80"), "Kart etkin sağlık etkisini gösterir")
	KoyluKarti.ac(e, hasta.id)
	await get_tree().process_frame
	_kontrol(e.find_child("salgin_bilgisi", true, false) == null and not _metin(e._ust_kart).contains("Humma"), "Hekim hizmet bilgisi gizli kuluçkayı açmaz")
	_kontrol(not _metin(e._ust_kart).contains("chr_") and not _metin(e._ust_kart).contains("Flag_"), "Kimlik/anahtar ifşası yok")
	e._kart_kapat()
	e._secili_bina = sif.id
	e._bilgi_goster()
	await get_tree().process_frame
	var recete := _dugme(e._bilgi_icerik, "İlaç · 1 afyon + 1 su")
	_kontrol(recete != null and sif.recete == "bakim", "Şifahane bilgisinde varsayılan bakım ve ilaç reçetesi")
	if recete == null: await Ses.cik(1); return
	recete.pressed.emit()
	await get_tree().process_frame
	_kontrol(sif.recete == "ilac" and _metin(e._bilgi_icerik).contains("−%80"), "Gerçek reçete düğmesi ve Şifahane bilgisi")
	var gun := y.gun
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol(y.gun == gun + 1 and y.kaynaklar.miktar("afyon") == 1, "Gerçek gece mevcut üretimi çalıştırır")
	_kontrol(not SaglikYoneticisi.hasta(hasta) and hasta.saglik == 29, "Üretilen ilaç aynı gecede tedavi edilir (triyaj: en ağır hasta önce)")
	var kalan_ilac := y.kaynaklar.miktar("ilac")
	_kontrol(y.koylu(kritik.id) != null and kritik.saglik == 6 and SaglikYoneticisi.hasta(kritik) and SifahaneKontenjani.durum(y).kullanilan == 1, "Ortak kontenjan sonrası kritik hastada hekim hasarı 12→2")
	_kontrol(_metin(e._ust_kart).contains("1 ilaç"), "Gerçek rapor ilaç tüketimini gösterir")
	var sabah := _dugme(e._ust_kart, tr("koy.rapor.sabah"))
	_kontrol(sabah != null, "Gerçek sabah düğmesi")
	if sabah == null: await Ses.cik(1); return
	sabah.pressed.emit()
	await get_tree().process_frame
	while ana._kapi_yukleniyor: await get_tree().process_frame
	ana._koye_git()
	await get_tree().process_frame
	e = ana._ekran
	_kontrol(ana.kayit.yaz(o.kaydet()), "Gerçek güvenli ilaç/Şifahane kaydı")
	var geri := Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(geri.yonetim.bina(sif.id).recete == "ilac" and HekimIlac.etkin(geri.yonetim) and geri.yonetim._rng.state == y._rng.state and geri.yonetim.koylu(kritik.id).enfeksiyon == kritik.enfeksiyon, "Reçete/yetkin hekim/enfeksiyon/RNG kayıt dönüşü")
	# Hekimi gerçek kart düğmesiyle izole et: aynı bina rezervasyonu kalır,
	# ertesi gece ilaç üretimi/koruma/tedavi durur ve tek ölüm yolu işler.
	KoyluKarti.ac(e, hekim.id)
	await get_tree().process_frame
	(e.find_child("karantina_dugmesi", true, false) as Button).pressed.emit()
	await get_tree().process_frame
	_kontrol(KarantinaYoneticisi.aktif(hekim) and not HekimIlac.etkin(y) and _metin(e._ust_kart).contains("etkin değil"), "Karantinadaki hekimde hizmet ve kart etkisi durur")
	e._kart_kapat()
	await get_tree().process_frame
	# KRI-15: açık salgında boştaki vasıfsız köylü ot (afyon) toplar; ilaç üretimi yine durur.
	var ot := KoyYonetimi.SIFALI_OT.toplayicilar(y).size() * int(KoyYonetimi.SIFALI_OT.AYAR.kisi_basina_ot)
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol(y.koylu(kritik.id) == null and y.kaynaklar.miktar("afyon") == 1 + ot and y.kaynaklar.miktar("ilac") == kalan_ilac, "Hekim durunca gerçek gece üretim yok, mevcut tek ölüm yolu")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	print("HEKIM ILAC UI: GEÇTİ" if hata == 0 else "HEKIM ILAC UI: KALDI")
	await Ses.cik(hata)
func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	# YAP: oyundaki gibi önce yapı bilgisi, 2. kademe için hazır bir 1. kademe yapı.
	var gecici: Koylu = null
	if YapiKilidi.durum(y, tur).neden == "yapi_bilgisi":
		if y.koylular.is_empty(): gecici = y.kabul({"ad": "Kurulum bilgisi", "sinif": "ciftci", "stat": 8})
		preload("res://src/koy/yapi_bilgisi.gd").ekle(y.koylular[0], PackedStringArray([tur]))
	if YapiKilidi.durum(y, tur).neden == "yapi_on_kademe":
		_kur(y, "tas_ocagi")  # barınak olmayan 1. kademe; sağlık hesabını değiştirmez
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h).olur:
				var b := y.bina(y.bina_kur(tur, h).id)
				b.insa_kalan = 0
				if gecici != null: y.koylular.erase(gecici)
				return b
	if gecici != null: y.koylular.erase(gecici)
	return null
func _dugme(n: Node, metin: String) -> Button:
	if n is Button and n.text == metin: return n
	for c in n.get_children():
		var b := _dugme(c, metin)
		if b != null: return b
	return null
func _metin(n: Node) -> String:
	var sonuc: String = n.text + "\n" if n is Label else ""
	for c in n.get_children(): sonuc += _metin(c)
	return sonuc
func _kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
