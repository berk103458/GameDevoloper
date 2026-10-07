extends Node

class OlaysizOturum extends Oturum:
	func olay_sec() -> OlayVerisi:
		return null

class OlayliOturum extends OlaysizOturum:
	var test_olay: OlayVerisi
	func olay_sec() -> OlayVerisi:
		return test_olay

class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_admin_zaman.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = OlaysizOturum.new(katalog, 89)
		kayit = GuvenliKayit.new("user://test_admin_zaman.json")
		theme = Tema.olustur(ayarlar)

var hata := 0

func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	for i in 3:
		ana.oturum.yonetim.kabul({"ad": "Test %d" % i, "sinif": "ciftci", "stat": 5})
	ana.oturum.yonetim.kaynaklar.ekle("gida", 100)
	var a := ana.oturum.yonetim.a
	var hucre := Vector2i(a.meydan.position.x + a.meydan.size.x / 2 + 1, a.meydan.end.y + 1)
	var d := ana.oturum.yonetim.bina_kur("cadir", hucre)
	ana.oturum.yonetim.bina(d["id"]).insa_kalan = 0
	ana._koye_git()
	var admin := AdminHud.new()
	admin.baglam = ana
	ana.add_child(admin)
	admin.ac(true)
	for i in 3:
		var adet: int = [1, 5, 10][i]
		var once := ana.oturum.gun
		ana._ekran._hiz_sec(2)
		_kontrol(not admin.zaman_dugmeleri[i].disabled, "Köyde zaman düğmesi etkin")
		admin.zaman_dugmeleri[i].pressed.emit()
		_kontrol(ana.oturum.gun == once + adet and admin.son_zaman_raporu["raporlar"].size() == adet, "Gerçek düğme tam 1/5/10 gece çalıştırır")
		_kontrol(Engine.time_scale == 1.0 and not get_tree().paused, "2x simülasyon sonrası hız normal; gece çift hesaplanmaz")
		var geri := Oturum.kayittan(ana.katalog, ana.kayit.oku())
		_kontrol(geri != null and geri.gun == ana.oturum.gun, "Yeni gün güvenli test slotuna yazılır")
		await get_tree().process_frame
	_kontrol(ana.oturum.gun == 16 and admin.son_zaman_raporu["raporlar"].size() == 10, "Toplam 16 gün ve son 10 rapor korunur")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("adm03_zaman.png"))
	ana._ekran._geceye_gec()
	admin._durum_yenile()
	var kayit := JSON.stringify(ana.oturum.kaydet())
	_kontrol(admin.zaman_dugmeleri[1].disabled, "Normal gece raporu açıkken zaman makinesi kilitli")
	admin.zaman_dugmeleri[1].pressed.emit()
	_kontrol(JSON.stringify(ana.oturum.kaydet()) == kayit and not admin.son_zaman_raporu["ok"], "Rapor sırasında doğrudan sinyal de ikinci hesaplaşma yapmaz")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	await _ek_durum(true)
	await _ek_durum(false)
	print("ADMIN ZAMAN: GEÇTİ" if hata == 0 else "ADMIN ZAMAN: KALDI")
	await Ses.cik(hata)

func _ek_durum(bekleyen: bool) -> void:
	var ana := TestAna.new()
	add_child(ana)
	if bekleyen:
		var o := OlayliOturum.new(ana.katalog, 9)
		o.test_olay = OlayVerisi.new()
		o.test_olay.id = &"debug_fixture"
		o.test_olay.baslik_anahtari = "debug_fixture.baslik"
		o.test_olay.metin_anahtari = "debug_fixture.metin"
		o.test_olay.secenek_anahtarlari = ["debug_fixture.sec0"]
		o.test_olay.secenek_etkileri = [{"gerekli": {"akce": 1000000}}]
		ana.oturum = o
	else:
		ana.oturum.yonetim.gun = ana.oturum.yonetim.a.emniyet_gun
		ana.oturum.yonetim.en_yuksek_nufus = ana.oturum.yonetim.a.emniyet_nufus
	ana._koye_git()
	var sonuc := ZamanMakinesi.uygula(ana, 10)
	_kontrol(sonuc["ok"] and sonuc["gecen"] == 1, "Terminal/bekleyen olayda UI da tek gecede durur")
	if bekleyen:
		_kontrol(ana._ekran is KoyEkrani and ana._ekran._ust_kart != null and ana._ekran._gece_dugmesi.disabled, "Bekleyen olay gerçek kartta gösterilir; gece kilitli")
		_kontrol(not ZamanMakinesi.uygun(ana), "Bekleyen olay varken ek batch engellenir")
	else:
		_kontrol(not ana._ekran is KoyEkrani and not ana.kayit.var_mi(), "Terminal sonuç normal son ekranı/kayıt kapanışını kullanır")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout

func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
