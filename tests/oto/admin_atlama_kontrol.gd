## Gerçek kapı/karar ve Ana köy geçişi; yalnız test kayıt dosyası.
extends Node

class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_admin_atlama.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 89)
		kayit = GuvenliKayit.new("user://test_admin_atlama.json")
		theme = Tema.olustur(ayarlar)

var hata := 0

func _ready() -> void:
	get_tree().create_timer(35.0).timeout.connect(func() -> void: get_tree().quit(1))
	await _durum(false)
	await _durum(true)
	print("ADMIN ATLAMA: GEÇTİ" if hata == 0 else "ADMIN ATLAMA: KALDI")
	await Ses.cik(hata)

func _durum(sonuc_verildi: bool) -> void:
	var ana := TestAna.new()
	add_child(ana)
	var kapi := KapiEkrani.new()
	kapi.ayarlar = ana.ayarlar
	kapi.oturum = ana.oturum
	ana._kapi = kapi
	ana._goster(kapi)
	var g := ana.oturum._adli_gelen(&"chr_001")
	ana.oturum.ziyaret_basladi(g)
	var diger := ana.oturum._adli_gelen(&"chr_002")
	diger.chr_sorgusu().tansiyon = 9
	kapi._gelen = g
	kapi._kuyruk = [diger, diger] # Aynı nesne iki kez sonuçlandırılamaz.
	kapi.evre = &"karar"
	if sonuc_verildi:
		kapi.sahne._gelen = Dunya3B.karakter("chr_001")
		kapi.sahne.add_child(kapi.sahne._gelen)
		kapi.sahne._gelen.position = KapiSahnesi.DURMA
		kapi._karar_ver("ret")
		_kontrol(kapi.get_meta(&"sonuclanan_gelen") == g, "Gerçek karar aktif kişi referansını işaretler")
	var tecrube := ana.oturum.muhafiz_tecrubesi
	var gun := ana.oturum.gun
	var admin := AdminHud.new()
	admin.baglam = ana
	ana.add_child(admin)
	admin.ac(true)
	_kontrol(not admin.kapi_atla.disabled, "Gerçek kapıda atlama düğmesi açık")
	var beklenen := 1 if sonuc_verildi else 2
	if sonuc_verildi:
		admin.kapi_atla.pressed.emit()
		_kontrol(admin.cikti.text.contains("1 kişi · 0 kabul / 1 ret"), "Gerçek düğme yalnız bekleyen panik ziyaretini reddeder")
	else:
		var sonuc := KapiAtlamaAdaptoru.atla(ana, 123)
		_kontrol(sonuc["ok"] and sonuc["toplam"] == beklenen, "Yalnız bekleyen tekil ziyaretler sonuçlandı")
		_kontrol(sonuc["ret"] >= 1, "Panikteki kişi kabul edilemez")
	_kontrol(ana.oturum.muhafiz_tecrubesi == tecrube + beklenen, "Sonuç evresindeki kişi ikinci kez sayılmaz")
	_kontrol(ana._ekran is KoyEkrani and ana._ekran.sahne3b is KoyYonetimSahnesi, "Gerçek yönetim köyüne geçilir")
	_kontrol(ana.oturum.gun == gun, "Kapı atlama gece tüketimi veya gün artışı yapmaz")
	_kontrol(ana.kayit.oku()["muhafiz_tecrubesi"] == ana.oturum.muhafiz_tecrubesi, "Normal geçişin güvenli kaydı test slotuna yazılır")
	var kayit := JSON.stringify(ana.oturum.kaydet())
	admin._durum_yenile()
	_kontrol(admin.kapi_atla.disabled and not KapiAtlamaAdaptoru.atla(ana)["ok"], "Köyde tekrarlı atlama engellenir")
	_kontrol(JSON.stringify(ana.oturum.kaydet()) == kayit, "Tekrar denemesi yan etkisizdir")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if sonuc_verildi and not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("adm02_koy.png"))
	# Ayrılış/kamera gibi gerçek bekleyen coroutine'ler de temiz kapanmalıdır.
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.6).timeout

func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
