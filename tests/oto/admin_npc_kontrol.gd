extends Node

class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_admin_npc.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 77)
		kayit = GuvenliKayit.new("user://test_admin_npc.json")
		theme = Tema.olustur(ayarlar)

var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var ekran := KapiEkrani.new()
	ekran.oturum = ana.oturum
	ekran.ayarlar = ana.ayarlar
	ana._kapi = ekran
	ana._goster(ekran)
	var aktif := ana.oturum._adli_gelen(&"chr_001")
	var bekleyen := ana.oturum._adli_gelen(&"chr_002")
	ekran._gelen = aktif
	ekran._kuyruk = [bekleyen]
	ekran.evre = &"karar"
	ana.oturum.ziyaret_basladi(aktif)
	ekran.sahne.kuyruk_doldur(["chr_002"])
	var aktif_model := Dunya3B.karakter("chr_001")
	ekran.sahne.add_child(aktif_model)
	ekran.sahne._gelen = aktif_model
	aktif_model.position = KapiSahnesi.DURMA
	var admin := AdminHud.new()
	admin.baglam = ana
	ana.add_child(admin)
	admin.ac(true)
	var p := admin.npc_paneli
	for i in range(1, 31):
		_kontrol(StringName("chr_%03d" % i) in p._kimlikler, "CHR_001–030 gerçek katalogdan seçilebilir")
	_kontrol(p.secim.is_item_disabled(p.secim.item_count - 1), "Henüz var olmayan tüccar çağrılmaz")
	var once := JSON.stringify(ana.oturum.kaydet())
	_kontrol(not (await NpcCagirma.cagir(ana, &"yok"))["ok"], "Bilinmeyen kimlik yan etkisiz reddedilir")
	_kontrol(not (await NpcCagirma.cagir(ana, &"chr_001"))["ok"], "Aktif kişi çoğaltılmaz")
	p.secim.select(p._kimlikler.find(&"chr_030"))
	p.cagir.pressed.emit()
	_kontrol(not NpcCagirma.uygun(ana), "Yükleme sırasında ikinci çağrı kilitli")
	while p._calisiyor:
		await get_tree().process_frame
	_kontrol(ekran._kuyruk.size() == 2 and ekran._kuyruk[0].id == &"chr_030" and ekran._kuyruk[1] == bekleyen, "Gerçek düğme yeni kişiyi başa ekler, eski sırayı korur")
	_kontrol(ekran._gelen == aktif and ekran.sahne._gelen == aktif_model, "Aktif sorgu ve model korunur")
	_kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Çağrı henüz ziyaret/karar/gün veya RNG çalıştırmaz")
	var yeni := ekran._kuyruk[0]
	await get_tree().process_frame
	var tasima := await NpcCagirma.cagir(ana, &"chr_002")
	_kontrol(tasima.get("tasindi", false) and ekran._kuyruk.size() == 2 and ekran._kuyruk[0] == bekleyen and ekran._kuyruk[1] == yeni, "Bekleyen kişi kopyalanmadan başa taşınır")
	for i in ekran.sahne._kuyruk_adlari.size():
		_kontrol(ekran.sahne._kuyruk_adlari[i] == ekran._model_adi(ekran._kuyruk[i]), "Gerçek 3B modeller kuyruk nesneleriyle eşleşir")
	var model := ekran.sahne._kuyruktakiler[0]
	await ekran.sahne.gelen_yaklas(ekran._model_adi(bekleyen))
	_kontrol(ekran.sahne._gelen == model, "Çağrılan sıradaki gerçek model yeniden yaratılmadan kapıya gelir")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("adm05_npc.png"))
	ekran.evre = &"sonuc"
	_kontrol(not (await NpcCagirma.cagir(ana, &"chr_029"))["ok"], "Karar animasyonu sırasında kuyruk değiştirilmez")
	ekran.evre = &"karar"
	NpcCagirma.cagir(ana, &"chr_029")
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(1.0).timeout
	print("ADMIN NPC: GEÇTİ" if hata == 0 else "ADMIN NPC: KALDI")
	await Ses.cik(hata)

func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
