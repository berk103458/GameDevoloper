## Gerçek gece düğmesi: iki gece açlık → rapor/HUD → onarım → GuvenliKayit.
extends Node
class OlaysizOturum extends Oturum:
	func olay_sec() -> OlayVerisi: return null
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_kri06.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = OlaysizOturum.new(katalog, 306)
		kayit = GuvenliKayit.new("user://test_kri06_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0

func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 1000
	ana.katalog.koy_ayarlari = y.a
	y.kaynaklar = Kaynaklar.new(1000, {"tas": 40, "kereste": 40, "odun": 30, "alet": 30})
	y.akce = 200
	ana.oturum.muhafiz_akce = 77
	var ambar := _kur(y, "ambar")
	_kontrol(ambar != null, "Gerçek ambar kuruldu")
	for i in 3:
		var k := y.kabul({"ad": "Aç köylü %d" % i})
		k.moral = 100
		k.saglik = 100
	y._ambar_kapasitesi()
	var saglam_kapasite := y.kaynaklar.kapasite
	ana._koye_git()
	await get_tree().process_frame
	var e: KoyEkrani = ana._ekran
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol(y.koylular.all(func(k: Koylu) -> bool: return k.ac), "Gerçek tüketim köylüleri aç bırakır")
	_kontrol(KitlikIsyani.durum(y).kitlik_gece_sayisi == 1 and not KitlikIsyani.durum(y).kapi_kirik, "İlk gece kapı kırılmaz")
	_kontrol(e.hud._ambar_bar.tooltip_text.contains("1/2 gece"), "Mevcut HUD sayaç")
	_kontrol(ana.kayit.yaz(ana.oturum.kaydet()), "Bir gecelik sayaç güvenli kaydı")
	var geri := Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(KitlikIsyani.durum(geri.yonetim).kitlik_gece_sayisi == 1, "İlk geceden yükleme geçmişi korur")
	await _sabah(ana, e)
	e = ana._ekran
	var sinyaller: Array[Dictionary] = []
	y.kitlik_tetiklendi.connect(func(r: Dictionary) -> void: sinyaller.append(r))
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol(sinyaller.size() == 1 and y.isyan_kalan == y.a.isyan_gun, "İkinci gerçek gece tek kıtlık/ortak isyan")
	_kontrol(_metin(e._ust_kart).contains("Kıtlık isyanı: ambar kapısı kırıldı") and _metin(e._ust_kart).contains("Yağma:"), "Gerçek rapor kapı ve stok kaybını gösterir")
	_kontrol(y.kaynaklar.kapasite == floori(saglam_kapasite * 0.8) and e.hud._ambar_bar.tooltip_text.contains("kırık"), "Hasarlı kapı HUD ve kapasite")
	var rapor_onar := e.hud.find_child("ambar_kapisi_onar", true, false) as Button
	var acik_rapor := JSON.stringify(y.kaydet())
	_kontrol(rapor_onar != null and rapor_onar.disabled, "Açık raporda gündüz onarımı kilitli")
	if rapor_onar != null: rapor_onar.pressed.emit()
	_kontrol(JSON.stringify(y.kaydet()) == acik_rapor, "Bayat/disabled onarım rapor bilançosunu değiştirmez")
	_kontrol(ana.oturum.muhafiz_akce == 77, "Yağma kişisel keseye dokunmaz")
	_kontrol(ana.kayit.yaz(ana.oturum.kaydet()), "Hasarlı kapı güvenli kaydı")
	geri = Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(KitlikIsyani.durum(geri.yonetim) == KitlikIsyani.durum(y) and geri.yonetim.kaynaklar.kapasite == y.kaynaklar.kapasite, "Hasar ve kıtlık kilidi restore")
	await _sabah(ana, e)
	e = ana._ekran
	if ambar != null:
		e._secili_bina = ambar.id
		e._bilgi_goster()
		_kontrol(_metin(e._bilgi_icerik).contains("Ambar kapısı kırık"), "Mevcut ambar bina bilgisi")
	var onar := e.hud.find_child("ambar_kapisi_onar", true, false) as Button
	_kontrol(onar != null and onar.visible and not onar.disabled, "Yapısız köyde de erişilen gerçek HUD onarımı")
	if onar != null:
		var tas := y.kaynaklar.miktar("tas")
		var kereste := y.kaynaklar.miktar("kereste")
		var rng := y._rng.state
		onar.pressed.emit()
		var onarilan := JSON.stringify(y.kaydet())
		onar.pressed.emit()
		_kontrol(y.kaynaklar.kapasite == saglam_kapasite and y.kaynaklar.miktar("tas") == tas - 4 and y.kaynaklar.miktar("kereste") == kereste - 6, "Gerçek onarım tam malzeme ve kapasite")
		_kontrol(JSON.stringify(y.kaydet()) == onarilan and y._rng.state == rng and not onar.visible, "Çift tıklama/RNG ve güncel HUD")
		if ambar != null: _kontrol(_metin(e._bilgi_icerik).contains("Ambar kapısı sağlam"), "HUD onarımı açık bina kartını da yeniler")
	_kontrol(ana.kayit.yaz(ana.oturum.kaydet()), "Onarılmış gerçek güvenli kayıt")
	geri = Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(not KitlikIsyani.durum(geri.yonetim).kapi_kirik and KitlikIsyani.durum(geri.yonetim).tetiklendi, "Onarım kaydı kıtlık kilidini korur")
	y.kaynaklar.ekle("gida", 20)
	_kontrol(KitlikIsyani.durum(y).kitlik_gece_sayisi == 0, "Gerçek erzak gelişinde anında sıfırlama")
	_kontrol(ana.kayit.yaz(ana.oturum.kaydet()), "Erzak dönüşü kaydı")
	geri = Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(y.gece() == geri.yonetim.gece(), "Restore sonraki gerçek gece/RNG aynı")
	var eski := ana.oturum.kaydet()
	eski.koy_yonetimi.erase("kitlik_isyani")
	_kontrol(not KitlikIsyani.durum(Oturum.kayittan(ana.katalog, eski).yonetim).kapi_kirik, "Gerçek oturum legacy optional alan")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	print("KITLIK İSYANI UI: GEÇTİ" if hata == 0 else "KITLIK İSYANI UI: KALDI")
	await Ses.cik(hata)

func _sabah(ana: Ana, e: KoyEkrani) -> void:
	var sabah := _dugme(e._ust_kart, tr("koy.rapor.sabah"))
	_kontrol(sabah != null and not sabah.disabled, "Gerçek sabah geçişi")
	if sabah == null: return
	sabah.pressed.emit()
	await get_tree().process_frame
	while ana._kapi_yukleniyor: await get_tree().process_frame
	ana._koye_git()
	await get_tree().process_frame

func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h).olur:
				var r := y.bina_kur(tur, h)
				if not r.olur: return null
				var b := y.bina(r.id)
				b.insa_kalan = 0
				return b
	return null

func _dugme(n: Node, metin: String) -> Button:
	if n is Button and n.text == metin: return n
	for c in n.get_children():
		var b := _dugme(c, metin)
		if b != null: return b
	return null

func _metin(n: Node) -> String:
	var r: String = n.text if n is Label else ""
	for c in n.get_children(): r += " " + _metin(c)
	return r

func _kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
