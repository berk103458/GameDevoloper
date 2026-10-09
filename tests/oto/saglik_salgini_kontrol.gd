## KRI-01: gerçek kapı kabulü → ortak çadır → gece düğmesi → köylü kartı → kayıt.
extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_kri01.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 222)
		kayit = GuvenliKayit.new("user://test_kri01_ui.json")
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
	y.kaynaklar.kapasite = 10000
	for tur in ["gida", "odun", "tas", "kereste"]: y.kaynaklar.ekle(tur, 500)
	var cadir := _kur(y, "cadir")
	# Gerçek kapı kararıyla gizli hasta sığınmacı; belirti henüz açık değil.
	var g := Gelen.new()
	g.ad_anahtari = "Sığınmacı"
	g.gizli_bayraklar = ["hasta"]
	var kaynak := y.koylu(o.karar_ver(g, &"kabul").koylu_id)
	_kontrol(SaglikYoneticisi.hasta(kaynak) and "hasta" not in kaynak.bayraklar, "Kabul gizli kuluçka getirir")
	var komsular: Array[Koylu] = []
	for i in 3:
		var k := y.kabul({"ad": "Komşu %d" % i, "sinif": "ciftci"})
		komsular.append(k)
	for k in [kaynak] + komsular: k.ev = cadir.id
	ana._koye_git()
	await get_tree().process_frame
	var e: KoyEkrani = ana._ekran
	KoyluKarti.ac(e, kaynak.id)
	await get_tree().process_frame
	_kontrol(e.find_child("salgin_bilgisi", true, false) == null, "Gizli kuluçka kartta ifşa edilmez")
	var oran: int = SaglikYoneticisi.AYAR.humma.risk
	SaglikYoneticisi.AYAR.humma.risk = 100
	var gun := o.gun
	e._kart_kapat()
	await get_tree().process_frame
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	SaglikYoneticisi.AYAR.humma.risk = oran
	_kontrol(o.gun == gun + 1, "Gerçek gece düğmesi bir gün ilerletir")
	var yeni := komsular.filter(func(k: Koylu) -> bool: return SaglikYoneticisi.hasta(k))
	_kontrol(yeni.size() == SaglikYoneticisi.AZAMI_YENI, "Ortak çadırda gece tavanı kadar bulaşma")
	_kontrol(kaynak.bayrak_var("hasta") and kaynak.saglik < 100, "Kaynakta belirti açılır ve sağlık düşer")
	KoyluKarti.ac(e, kaynak.id)
	await get_tree().process_frame
	var satir := e.find_child("salgin_bilgisi", true, false) as Label
	_kontrol(satir != null and satir.text.begins_with("Humma belirtisi") and satir.text.contains("bulaşıcı"), "Kartta açık belirti satırı")
	_kontrol(not _metin(e._ust_kart).contains("chr_") and not _metin(e._ust_kart).contains("Flag_"), "Gizli anahtar sızmaz")
	_kontrol(ana.kayit.yaz(o.kaydet()), "Kayıt yazılır")
	var geri := Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(geri != null and geri.yonetim.koylu(kaynak.id).enfeksiyon == kaynak.enfeksiyon, "Enfeksiyon kayıttan aynen döner")
	if not OS.get_environment("ADMIN_TEST_CIKTI").is_empty() and DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(OS.get_environment("ADMIN_TEST_CIKTI").path_join("kri01_kart.png"))
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	print("SAGLIK SALGINI UI: GEÇTİ" if hata == 0 else "SAGLIK SALGINI UI: KALDI")
	await Ses.cik(hata)
func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h).olur:
				var b := y.bina(y.bina_kur(tur, h).id)
				b.insa_kalan = 0
				return b
	return null
func _metin(n: Node) -> String:
	var sonuc: String = n.text + "\n" if n is Label else ""
	for c in n.get_children(): sonuc += _metin(c)
	return sonuc
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
