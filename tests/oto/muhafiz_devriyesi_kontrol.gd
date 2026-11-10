extends Node

const YAPI_BILGISI = preload("res://src/koy/yapi_bilgisi.gd")
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_patrol.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_patrol_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	y.akce = 1000
	for t in ["odun", "tas", "kereste"]: y.kaynaklar.ekle(t, 100)
	var k := y.kabul({"sinif": "asker", "stat": 5})
	YAPI_BILGISI.ekle(k, PackedStringArray(["kulube", "muhafiz_kislasi"]))
	var kulube := _kur(y, "kulube")
	kontrol(kulube != null, "K2 kışla için hazır K1 kulübe")
	if kulube == null:
		await Ses.cik(1)
		return
	var b := _kur(y, "muhafiz_kislasi")
	kontrol(b != null, "Gerçek hazır kışla")
	if b == null:
		await Ses.cik(1)
		return
	y.sur_seviye = 1
	kontrol(y.ata(k.id, b.id), "Kışla görevlisi")
	ana._koye_git()
	await get_tree().process_frame
	var once := JSON.stringify(ana.oturum.kaydet())
	var s: KoyYonetimSahnesi = ana._ekran.sahne3b
	var h := s.halk_hareketi
	h.set_process(false)
	h._process(0.0)
	var f: KarakterModel = h.modeller[k.id]
	var bas := f.position
	await get_tree().create_timer(0.5).timeout
	kontrol(f.position.distance_to(bas) > 0.01, "Gerçek animasyonlu asker yürür")
	s.faz(&"gece", 0.0)
	h._process(0.0)
	kontrol(h._durum[k.id].devriye and not h._durum[k.id].is, "Kışla askerinin gece devriyesi sürer")
	var adlar := {}
	for i in 6:
		var d: Dictionary = h._durum[k.id]
		adlar[d.devriye_ad] = true
		while int(d.adim) < d.yol.size():
			kontrol(f.hareket_bandi() != "kos" and f._oynatici.current_animation != HareketGecisi.tablo_klibi("kos"), "Devriye koşu bandı ve klibini kullanmaz")
			f.position = d.yol[d.adim]
			h._process(0.0)
		f.yurumeyi_durdur()
		kontrol(h.eylem(k.id) == d.devriye_ad, "Varış gözlemi nöbet yerini gösterir")
		h._process(float(MuhafizDevriyesi.AYAR.durak_suresi) + 0.1)
		h._process(0.0)
	kontrol(adlar.size() == 3, "Kapı, kışla, sur kuleleri dolaşılır")
	var kule_sayisi := 0
	for n in s._yapilar.get_children():
		if n.has_meta("devriye_kulesi") and not n.is_queued_for_deletion(): kule_sayisi += 1
	kontrol(kule_sayisi == 4, "Mevcut surda dört görsel kule")
	kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Devriye ekonomi/RNG/kayıt değiştirmez")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		h._durum[k.id].devriye_i = MuhafizDevriyesi.duraklar(y).size() - 1
		h._iste(k.id)
		h._process(0.0)
		var rota: Dictionary = h._durum[k.id]
		while int(rota.adim) < rota.yol.size():
			f.position = rota.yol[rota.adim]
			h._process(0.0)
		f.yurumeyi_durdur()
		s.set_process(false)
		s.kamera.position = f.position + Vector3(6, 5, 8)
		s.kamera.look_at(f.position + Vector3(0, 1, 0))
		await get_tree().create_timer(0.4).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("ani02_devriye.png"))
	y.bosalt(k.id)
	h.yenile()
	h._process(0.0)
	kontrol(not h._durum[k.id].devriye, "Görev bitince normal rutin")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("MUHAFIZ DEVRİYESİ UI: GEÇTİ" if hata == 0 else "MUHAFIZ DEVRİYESİ UI: KALDI")
	await Ses.cik(hata)
func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h).olur:
				var b := y.bina(y.bina_kur(tur, h).id)
				if b == null: return null
				b.insa_kalan = 0
				return b
	return null
func kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
