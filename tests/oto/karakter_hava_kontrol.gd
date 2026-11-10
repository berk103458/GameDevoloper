extends Node

const MUAYENE = preload("res://tests/oto/karakter_muayene.gd")
const YAPI_BILGISI = preload("res://src/koy/yapi_bilgisi.gd")
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_weather.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_weather_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0

class OmuzOlcer extends SkeletonModifier3D:
	var omuz_no: int
	var bacak_no: int
	var omuz := Quaternion.IDENTITY
	var bacak := Quaternion.IDENTITY

	func _process_modification_with_delta(_delta: float) -> void:
		var iskelet := get_skeleton()
		omuz = iskelet.get_bone_global_pose(omuz_no).basis.get_rotation_quaternion()
		bacak = iskelet.get_bone_global_pose(bacak_no).basis.get_rotation_quaternion()

func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	y.kaynaklar.kapasite = 10000
	for t in ["odun", "tas", "kereste"]: y.kaynaklar.ekle(t, 100)
	var k := y.kabul({"sinif": "ciftci", "stat": 5})
	k.zanaat_turu = ZanaatTuru.Tur.DEMIRCI
	YAPI_BILGISI.ekle(k, PackedStringArray(["kulube"]))
	var b := _kur(y, "kulube")
	var tarla := _kur(y, "tarla")
	kontrol(b != null and tarla != null, "Gerçek kulübe saçağı ve açık tarla")
	if b == null or tarla == null:
		await Ses.cik(1)
		return
	kontrol(y.ata(k.id, tarla.id), "SAH-59: Gerçek tarla ataması")
	var guard := y.kabul({"sinif": "asker", "stat": 5})
	guard.is_yeri = KoyYonetimi.MUHAFIZ
	IklimDeneyi.degistir(ana.oturum, 0, "normal")
	ana._koye_git()
	await get_tree().process_frame
	var s: KoyYonetimSahnesi = ana._ekran.sahne3b
	var h := s.halk_hareketi
	h.set_process(false)
	for i in 3: h._process(0.0)
	var d: Dictionary = h._durum[k.id]
	var f: KarakterModel = h.modeller[k.id]
	_varis(h, f, d)
	# Sulama rotası kuyu durağında başlar. Mevcut süreyi ilerletip iş durağına var.
	h._process(float(SulamaRutini.AYAR.sureler[0]) + 0.01)
	h._process(0.0)
	_varis(h, f, d)
	var kuru := MUAYENE.hava_say(h)
	var kose := s.hucre_kosesi(tarla.hucre)
	var acik_alan := Rect2(Vector2(kose.x, kose.z), Vector2(tarla.boyut(y.katalog)) * s.HUCRE)
	kontrol(kuru.acikta == 1 and kuru.sacak == 0 and acik_alan.has_point(Vector2(f.position.x, f.position.z)), "SAH-59: Açık havada işçi tarla içinde")
	IklimDeneyi.degistir(ana.oturum, 0, "yagmur")
	var once := JSON.stringify(ana.oturum.kaydet())
	h.yenile()
	for i in 3: h._process(0.0)
	kontrol(d.siginma and not d.is and not d.ates_basi, "Yağmurda iş/ateş yerine saçak")
	kontrol(h._durum[guard.id].devriye and not h._durum[guard.id].siginma, "Yağmurda muhafız görevi korunur")
	_varis(h, f, d)
	var yagmur := MUAYENE.hava_say(h)
	kontrol(yagmur.acikta < kuru.acikta and yagmur.sacak > kuru.sacak, "SAH-59: Yağmurda açık tarla azalır, saçak dolar")
	print("SAH-59 HAVA SAYIMI: ", JSON.stringify({"kuru": kuru, "yagmur": yagmur}))
	kontrol(f.position.distance_to(h._konum(KarakterHavaTepkisi.durak(y, b))) < s.HUCRE / 2 and h.eylem(k.id).contains("saçak"), "Erişilebilir gerçek saçak altında")
	kontrol(s.find_children("hava_sacagi_hazir", "", true, false).size() == 1, "Tek hazır MegaKit saçağı")
	kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Sığınma kayıt/RNG/stok değiştirmez")
	var panel := IklimDenetcisiPaneli.new()
	panel.baglam = ana
	ana.add_child(panel)
	panel.ac(true)
	kontrol(panel.hava.item_count == IklimDeneyi.HAVALAR.size() and panel.hava.selected == 3 and panel.hava.get_item_text(4) == "Sis", "Mevcut denetçide yağmur seçimi")
	panel.ac(false)
	await _goruntu(s, f, "ani09_yagmur.png")
	IklimDeneyi.degistir(ana.oturum, 0, "normal")
	h.yenile()
	for i in 3: h._process(0.0)
	kontrol(not d.siginma and f.find_child("KoyHavaKatmani", true, false) == null, "Yağmur bitince günlük rutin")
	var bas := f.position
	d.yol = [bas + Vector3(2, 0, 0)]
	d.adim = 0
	h._adim(k.id)
	f._yurume.pause()
	f._yurume.custom_step(0.25)
	var normal := f.position.distance_to(bas)
	var normal_klip := f._oynatici.current_animation
	f.yurumeyi_durdur()
	f.position = bas
	IklimDeneyi.degistir(ana.oturum, 0, "kar_firtinasi")
	h.yenile()
	for i in 3: h._process(0.0)
	f.yurumeyi_durdur()
	f.position = bas
	d.yol = [bas + Vector3(2, 0, 0)]
	d.adim = 0
	h._adim(k.id)
	f._yurume.pause()
	f._yurume.custom_step(0.25)
	var karda := f.position.distance_to(bas)
	kontrol(karda > 0 and karda < normal * 0.9, "Gerçek yürüyüş tweeni karda yavaş")
	await _hava_katmanini_olc(f, normal_klip)
	f.yurumeyi_durdur()
	IklimGorseli.uygula(s)
	await _goruntu(s, f, "ani09_kar.png")
	IklimDeneyi.degistir(ana.oturum, 0, "yagmur")
	y.bina_yik(b.id)
	h.yenile()
	for i in 3: h._process(0.0)
	kontrol(not d.siginma, "Hazır saçak kalmayınca geçersiz hedef yok")
	var katman := f.find_child("KoyHavaKatmani", true, false) as SkeletonModifier3D
	kontrol(katman != null and not katman.active, "SAH-30: Kar bittiğinde omuz katmanı kapanır")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("KARAKTER HAVA UI: GEÇTİ" if hata == 0 else "KARAKTER HAVA UI: KALDI")
	await Ses.cik(hata)
func _hava_katmanini_olc(f: KarakterModel, normal_klip: StringName) -> void:
	var katman := f.find_child("KoyHavaKatmani", true, false) as SkeletonModifier3D
	kontrol(f is HazirKarakterModeli and is_zero_approx(f.duzeltici().influence), "SAH-30: LOWPO kendi yürüyüş oynatıcısını kullanır")
	kontrol(f.hareket_bandi() == "yuru" and f._oynatici.current_animation == normal_klip, "SAH-30: Kar aynı yürüyüş klibini korur")
	kontrol(katman != null and katman.active, "SAH-30: Ayrı kar katmanı canlı")
	if katman == null:
		return
	var iskelet := katman.get_skeleton()
	var once := OmuzOlcer.new()
	var sonra := OmuzOlcer.new()
	for olcer in [once, sonra]:
		olcer.omuz_no = iskelet.find_bone("RightShoulder")
		olcer.bacak_no = iskelet.find_bone("RightUpLeg")
		iskelet.add_child(olcer)
	iskelet.move_child(once, katman.get_index())
	await sonra.modification_processed
	var omuz := sonra.omuz.angle_to(once.omuz)
	var bacak := sonra.bacak.angle_to(once.bacak)
	kontrol(absf(omuz - float(KarakterHavaTepkisi.AYAR.kar_egim)) < 0.003 and bacak < 0.003, "SAH-30: Kar omuza biner, bacak yürüyüş pozu korunur")
	print("SAH-30 klip=%s, omuz farkı=%.5f rad, bacak farkı=%.5f rad" % [f._oynatici.current_animation, omuz, bacak])
	once.queue_free()
	sonra.queue_free()

func _goruntu(s: KoyYonetimSahnesi, f: KarakterModel, ad: String) -> void:
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if dizin.is_empty() or DisplayServer.get_name() == "headless": return
	s.set_process(false)
	s.kamera.position = f.position + Vector3(5, 2.5, 3)
	s.kamera.look_at(f.position + Vector3(0, 0.9, 0))
	await get_tree().create_timer(0.3).timeout
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(dizin.path_join(ad))
func _varis(h: KoyHalkHareketi, model: KarakterModel, d: Dictionary) -> void:
	for _adim in range(d.yol.size() + 1):
		if int(d.adim) >= d.yol.size(): break
		model.position = d.yol[d.adim]
		h._process(0.0)
	model.yurumeyi_durdur()


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
