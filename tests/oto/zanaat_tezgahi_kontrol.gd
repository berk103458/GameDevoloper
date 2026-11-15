extends Node

const MUAYENE = preload("res://tests/oto/karakter_muayene.gd")
const YAPI_BILGISI = preload("res://src/koy/yapi_bilgisi.gd")
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_craft.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_craft_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	y.kaynaklar.kapasite = 10000
	for t in ["odun", "tas", "kereste", "demir", "un"]: y.kaynaklar.ekle(t, 100)
	# K1 yatak ve yaşayan yapı bilgisi, K2 demirhanenin gerçek önkoşuludur.
	var bos := y.kabul({"sinif": "ciftci", "stat": 5})
	YAPI_BILGISI.ekle(bos, PackedStringArray(["kulube", "demirhane", "firin"]))
	var ev := _kur(y, "kulube")
	kontrol(ev != null and y.yatak_kapasitesi() > 0, "SAH-57: Ölçümde kullanılabilir yatak")
	if ev == null:
		await Ses.cik(1)
		return
	bos.ev = ev.id
	var bs: Array[KoyBinasi] = []
	var ids: Array[int] = []
	for tur in ["demirhane", "firin"]:
		var b := _kur(y, tur)
		kontrol(b != null, "Gerçek zanaat binası")
		if b == null:
			await Ses.cik(1)
			return
		var k := y.kabul({"sinif": "ciftci", "stat": 5})
		k.zanaat_turu = ZanaatTuru.Tur.DEMIRCI if tur == "demirhane" else ZanaatTuru.Tur.ESNAF
		kontrol(y.ata(k.id, b.id), "Gerçek zanaat ataması")
		kontrol(y.recete_sec(b.id, "alet" if tur == "demirhane" else "ekmek"), "Gerçek reçete")
		bs.append(b)
		ids.append(k.id)
	var once := ana.oturum.kaydet().merged({"faz": "koy"}, true)
	ana._koye_git()
	await get_tree().process_frame
	# Köy girişindeki ilk görüş kaydı, tezgâh hareketi başlamadan yazılır.
	once["ogretici"] = ana.oturum.kaydet()["ogretici"]
	var s: KoyYonetimSahnesi = ana._ekran.sahne3b
	var h := s.halk_hareketi
	h.set_process(false)
	for i in 3: h._process(0.0)
	var tezgah_kokleri := {}
	for id in ids:
		var f: KarakterModel = h.modeller[id]
		var d: Dictionary = h._durum[id]
		kontrol(d.zanaat and d.is, "Çalışan/girdili tezgâh aktif")
		kontrol(f.get_node_or_null("zanaat_tezgahi") != null, "Gerçek el bağlantısı")
		var olcer: Node3D = _yuruyus_olceri_kur(f) if id == ids[0] else null
		_varis(h, f, d, false)
		tezgah_kokleri[id] = f.global_position
		kontrol(f.hareket_bandi() == "dur" and (f._yurume == null or not f._yurume.is_running()), "SAH-29: İşe varış yürüyüşü bitirir")
		kontrol(f.duzeltici().surekli == StringName(d.zanaat_hareket), "Varınca çekiç/kürek döngüsü")
		if olcer != null:
			f._oynatici.advance(1.0 / 120.0)
			kontrol(is_zero_approx(olcer.position.x) and f._oynatici.current_animation == "dov", "SAH-29: Örsün ilk karesinde gerçek çekiç klibi ve sıfır yürüyüş ağırlığı")
			print("SAH-29 ilk yürüyüş ağırlığı=%.6f, klip=%s" % [olcer.position.x, f._oynatici.current_animation])
			f._oynatici.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_IDLE
	await get_tree().create_timer(0.45).timeout
	for id in ids:
		var f: KarakterModel = h.modeller[id]
		var kok_farki := f.global_position.distance_to(tezgah_kokleri[id])
		kontrol(kok_farki <= 0.00001 and f._oynatici.current_animation != f._anim, "SAH-29: Tezgâh çalışırken kök ve yürüyüş durur")
		if id == ids[0]:
			kontrol(f._oynatici.current_animation == "dov", "SAH-29: Çekiç klibi yürüyüş tween'i tarafından kesilmez")
		print("SAH-29 tezgâh=%d, kök farkı=%.6f m, klip=%s" % [id, kok_farki, f._oynatici.current_animation])
	var gunduz := MUAYENE.rutin_say(h)
	kontrol(gunduz.tezgah >= 1 and gunduz.ates == 0, "SAH-57: Gündüz çalışan tezgâh")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		s.set_process(false)
		for i in ids.size():
			var f: KarakterModel = h.modeller[ids[i]]
			var merkez := s.alan_merkezi(bs[i].hucre, bs[i].boyut(y.katalog))
			var disari := f.position - merkez
			disari.y = 0
			s.kamera.position = f.position + Vector3(5, 2.5, 3)
			s.kamera.look_at(f.position + Vector3(0, 0.9, 0))
			await get_tree().create_timer(0.4).timeout
			await RenderingServer.frame_post_draw
			get_viewport().get_texture().get_image().save_png(dizin.path_join("ani08_%s.png" % bs[i].tur))
	kontrol(JSON.stringify(ana.oturum.kaydet()) == JSON.stringify(once), "Görsel zanaat kayıt/RNG/stok değiştirmez")
	h._process(float(h._ayar.calisma_suresi) + 0.1)
	for i in 3: h._process(0.0)
	await get_tree().process_frame
	for id in ids:
		kontrol(h._durum[id].dinlen and not h._durum[id].is and h.modeller[id].get_node_or_null("zanaat_tezgahi") == null, "Dinlenmede alet/motion kapanır")
	# Aynı karakter farklı zanaata geçtiğinde eski çekiç kalmaz.
	var f: KarakterModel = h.modeller[ids[0]]
	ZanaatTezgahi.esya(f, "demirhane")
	ZanaatTezgahi.esya(f, "firin")
	kontrol((f.get_node("zanaat_tezgahi") as ZanaatTezgahi)._tur == "firin", "Görev değişiminde doğru alet")
	s.faz(&"gece", 0.0)
	for i in 3: h._process(0.0)
	await get_tree().process_frame
	for id in ids: kontrol(h.modeller[id].get_node_or_null("zanaat_tezgahi") == null, "Gece iş eşyası temizlenir")
	_varis(h, h.modeller[bos.id], h._durum[bos.id])
	var gece := MUAYENE.rutin_say(h)
	kontrol(gece.ates >= 1 and gece.tezgah == 0, "SAH-57: Gece gerçek ısınma, tezgâh kapalı")
	print("SAH-57 RUTİN SAYIMI: ", JSON.stringify({"gunduz": gunduz, "gece": gece}))
	var un := y.kaynaklar.miktar("un")
	y.kaynaklar.harca({"un": un})
	s.faz(&"gunduz", 0.0)
	for i in 3: h._process(0.0)
	kontrol(not h._durum[ids[1]].is, "Unsuz fırın küreği çalışmaz")
	y.kaynaklar.ekle("un", un)
	var bina_sayisi := y.binalar.size()
	y.koylular.clear()
	h.yenile()
	for faz in [&"gunduz", &"gece"]:
		s.faz(faz, 0.0)
		h._process(0.5)
		var sayim := MUAYENE.rutin_say(h)
		kontrol(h.modeller.is_empty() and h._bekleyen.is_empty() and sayim.tezgah == 0 and sayim.ates == 0, "SAH-61: Nüfus sıfırken hazır yapılarda bile iş veya ateş rutini yok")
	kontrol(y.binalar.size() == bina_sayisi, "SAH-61: Boş köyün mevcut yapıları korunur")
	print("SAH-61 nüfus=0, tezgâh=0, ateş=0, mevcut bina=%d" % bina_sayisi)
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("ZANAAT TEZGÂHI UI: GEÇTİ" if hata == 0 else "ZANAAT TEZGÂHI UI: KALDI")
	await Ses.cik(hata)
func _varis(h: KoyHalkHareketi, model: KarakterModel, d: Dictionary, durdur: bool = true) -> void:
	for _adim in range(d.yol.size() + 1):
		if int(d.adim) >= d.yol.size(): break
		model.position = d.yol[d.adim]
		h._process(0.0)
	if durdur:
		model.yurumeyi_durdur()


func _yuruyus_olceri_kur(model: KarakterModel) -> Node3D:
	var oynatici := model._oynatici
	var olcer := Node3D.new()
	olcer.name = "YuruyusOlceri"
	oynatici.get_node(oynatici.root_node).add_child(olcer)
	var kitap := oynatici.get_animation_library(&"").duplicate() as AnimationLibrary
	for ad in [&"yuru", &"bekle", &"dov"]:
		var klip := kitap.get_animation(ad).duplicate() as Animation
		var iz := klip.add_track(Animation.TYPE_POSITION_3D)
		klip.track_set_path(iz, NodePath("YuruyusOlceri"))
		klip.position_track_insert_key(iz, 0.0, Vector3.RIGHT if ad == &"yuru" else Vector3.ZERO)
		kitap.remove_animation(ad)
		kitap.add_animation(ad, klip)
	oynatici.remove_animation_library(&"")
	oynatici.add_animation_library(&"", kitap)
	oynatici.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	oynatici.play(&"yuru", 0.0)
	oynatici.advance(0.0)
	kontrol(is_equal_approx(olcer.position.x, 1.0), "SAH-29: Ölçer gerçek yürüyüşü tam ağırlıkta okur")
	return olcer


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
