## Karakter muayenesi (Tester için): her karakter modelini oyundaki gibi kurar (Dunya3B.karakter),
## her hareketini (bekle, yürü, konuş, sevinç, öfke, panik, gergin) önden ve yandan üçer karede çeker.
## Karakter başına TEK temas sayfası (satır = hareket, sütun = ön×3 + yan×3) ve sayısal ölçüm üretir:
##   ayak_y   : ayak kemiklerinin en alçak noktası (0 = zemin; >0.08 havada, <-0.08 gömülü)
##   el_aci   : ellerin kalçaya göre yanlara açıklığı / boy (T/A-pozu şüphesi > 0.45)
##   el_y     : ellerin kalça yüksekliğine göre konumu / boy (kollar havada şüphesi > 0.35)
##   boy      : görünen boy (m); ölçek hatası
##   eksik    : beklenen ama yüklenemeyen hareket klipleri
## Çalıştırma: KLASOR=<cikti> [MODELLER=ad1,ad2|CHR] godot --path . --audio-driver Dummy tests/oto/karakter_muayene.tscn
## --headless sayısal JSON raporu yazar. Pencereli koşuda ayrıca JPG üretilir.
extends Node3D

const KARE := Vector2i(200, 300)
const ANLAR := [0.25, 0.75, 1.25]
const AYAK_ESIGI := 0.08
const ESYA_KESISIM_ETIKETI := "SAH-EL-CAKISMA"
const HAREKET_SIRASI := ["bekle", "yuru", "konus", "sevinc", "ofke", "panik", "gergin"]

var _kamera: Camera3D
var _sonuc := {}
var _ayak_hatasi := 0


func _ready() -> void:
	await get_tree().process_frame
	# Yalnız doğrudan çalıştırılan geliştirici sahnesi oyun ağacını kapatabilir.
	if not OS.is_debug_build() or get_tree().current_scene != self:
		return
	var ciz := DisplayServer.get_name() != "headless"
	if ciz:
		_cekimi_kur()
	var klasor := OS.get_environment("KLASOR")
	if klasor.is_empty():
		klasor = "user://karakter_muayene"
	if DirAccess.make_dir_recursive_absolute(klasor) != OK:
		push_error("Muayene klasörü açılamadı: " + klasor)
		get_tree().quit(2)
		return
	var adlar := _model_adlari()
	print("MUAYENE başlıyor: %d model" % adlar.size())
	for ad in adlar:
		await _muayene(ad, klasor, ciz)
	var f := FileAccess.open(klasor.path_join("muayene.json"), FileAccess.WRITE)
	if f == null:
		push_error("Muayene raporu yazılamadı: " + klasor)
		get_tree().quit(2)
		return
	f.store_string(JSON.stringify(_sonuc, "  "))
	f.close()
	print("MUAYENE BİTTİ: %s, ayak hatası=%d" % [klasor, _ayak_hatasi])
	get_tree().quit(1 if _ayak_hatasi > 0 else 0)


func _cekimi_kur() -> void:
	get_window().size = KARE
	var ortam := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color("#3a4250")
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.85, 0.85, 0.9)
	env.ambient_light_energy = 0.9
	ortam.environment = env
	add_child(ortam)
	var gunes := DirectionalLight3D.new()
	gunes.rotation_degrees = Vector3(-45, 35, 0)
	gunes.light_energy = 1.2
	add_child(gunes)
	var zemin := MeshInstance3D.new()
	var pm := PlaneMesh.new()
	pm.size = Vector2(6, 6)
	zemin.mesh = pm
	var zm := StandardMaterial3D.new()
	zm.albedo_color = Color("#6b5a44")
	zemin.material_override = zm
	add_child(zemin)
	_kamera = Camera3D.new()
	_kamera.fov = 32
	add_child(_kamera)
	_kamera.make_current()

## Rota sonuna varmış ve ilgili hareketi oynatan modelleri sayar.
## Çizim veya temas sayfası gerektirmediği için headless kontrolde de kullanılır.
static func rutin_say(halk: KoyHalkHareketi) -> Dictionary:
	var sayim := {"tezgah": 0, "ates": 0}
	for id in halk.modeller:
		var d: Dictionary = halk._durum[id]
		if d.yol.is_empty() or int(d.adim) < d.yol.size():
			continue
		var model: KarakterModel = halk.modeller[id]
		var poz := model.duzeltici()
		if poz == null:
			continue
		if d.get("zanaat", false) and d.is and poz.surekli == StringName(d.zanaat_hareket):
			sayim.tezgah += 1
		if d.get("ates_basi", false) and poz.surekli == &"isin":
			sayim.ates += 1
	return sayim


## ANI-09: rota sonundaki açık tarla çalışanı ve sığınan model sayısı.
static func hava_say(halk: KoyHalkHareketi) -> Dictionary:
	var sayim := {"acikta": 0, "sacak": 0}
	var yonetim := halk.sahne.yonetim
	for id in halk.modeller:
		var d: Dictionary = halk._durum[id]
		if d.yol.is_empty() or int(d.adim) < d.yol.size():
			continue
		if d.siginma:
			sayim.sacak += 1
		elif d.is:
			var kisi := yonetim.koylu(id)
			if kisi != null and TarlaIsNoktalari.tarla(yonetim.bina(kisi.is_yeri)):
				sayim.acikta += 1
	return sayim


func ayak_zemini_yuksekligi(_konum: Vector3) -> float:
	return global_position.y


static func ayak_zemin_farklari(model: KarakterModel) -> PackedFloat32Array:
	var ayak := model.get_node_or_null("AyakZemini") as AyakZemini
	return ayak.temas_farklari() if ayak != null else PackedFloat32Array()


func _model_adlari() -> PackedStringArray:
	var secili := OS.get_environment("MODELLER")
	if secili == "CHR":
		var adli := PackedStringArray()
		for sira in range(1, 31):
			adli.append("chr_%03d" % sira)
		return adli
	if secili != "":
		return secili.split(",")
	var adlar := PackedStringArray(HazirKarakterler.MODEL_ADLARI)
	for d in DirAccess.get_files_at("res://assets/model/karakter"):
		var f := d.trim_suffix(".import").trim_suffix(".remap")
		if f.ends_with("_yuru.glb"):
			var ad := f.trim_suffix("_yuru.glb")
			if not ad in adlar:
				adlar.append(ad)
	adlar.sort()
	return adlar


func _muayene(ad: String, klasor: String, ciz: bool) -> void:
	var k := Dunya3B.karakter(ad)
	add_child(k)
	await get_tree().process_frame
	var sk: Skeleton3D = null
	var bulunan := k.find_children("*", "Skeleton3D", true, false)
	if not bulunan.is_empty():
		sk = bulunan[0]
	var kesisen := {}
	var esyalar: Array[ElEsyasi] = []
	for cocuk in k.get_children():
		if cocuk is ElEsyasi:
			esyalar.append(cocuk)
	if sk != null and not esyalar.is_empty():
		sk.skeleton_updated.connect(_esya_kesisimlerini_olc.bind(esyalar, kesisen))
	var kayit := {"kemik_sayisi": sk.get_bone_count() if sk != null else 0, "kemikler": _kemik_adlari(sk), "hareketler": {}, "eksik": [], "uyarilar": []}
	var var_olan: Array = []
	for h in HAREKET_SIRASI:
		if h == "yuru" or h == "bekle" or k.hareket_var(h):
			var_olan.append(h)
		else:
			kayit["eksik"].append(h)
	kayit["model_durumu"] = "yedek" if sk == null else "asıl"
	if sk == null:
		kayit["uyarilar"].append("Yedek model: animasyonsuz kapsül")
	var sayfa: Image
	if ciz:
		sayfa = Image.create(KARE.x * ANLAR.size() * 2, KARE.y * var_olan.size(), false, Image.FORMAT_RGB8)
		sayfa.fill(Color.BLACK)
	var en_alt := INF
	for satir in var_olan.size():
		var h: String = var_olan[satir]
		_baslat(k, h)
		var olcumler: Array = []
		for yan in (2 if ciz else 1):
			if ciz:
				_kamera_yerlestir(yan == 1)
			for i in ANLAR.size():
				_baslat(k, h)
				await get_tree().create_timer(ANLAR[i]).timeout
				if ciz:
					await RenderingServer.frame_post_draw
					var img := get_viewport().get_texture().get_image()
					img.resize(KARE.x, KARE.y)
					img.convert(Image.FORMAT_RGB8)
					sayfa.blit_rect(img, Rect2i(Vector2i.ZERO, KARE), Vector2i((yan * ANLAR.size() + i) * KARE.x, satir * KARE.y))
				else:
					await get_tree().process_frame
				if yan == 0 and sk != null:
					var olcum := _olc(sk, k)
					olcumler.append(olcum)
					en_alt = minf(en_alt, float(olcum.get("ayak_y", INF)))
		kayit["hareketler"][h] = _ozetle(olcumler)
		for u in _uyar(h, kayit["hareketler"][h]):
			kayit["uyarilar"].append(u)
	k.yurumeyi_durdur()
	if ciz:
		sayfa.save_jpg(klasor.path_join(ad + ".jpg"), 0.8)
		kayit["sayfa"] = klasor.path_join(ad + ".jpg")
	kayit["ayak_muayenesi"] = _ayak_satiri(ad, en_alt)
	var turler := kesisen.keys()
	turler.sort()
	kayit["esya_kesisimleri"] = turler
	kayit["rapor"] = uclu_rapor_olustur([kayit["ayak_muayenesi"]], turler, kayit["eksik"])
	for tur in turler:
		print("%s %s: %s" % [ESYA_KESISIM_ETIKETI, ad, tur])
	kayit["satirlar"] = var_olan
	_sonuc[ad] = kayit
	print("MUAYENE %s kemik=%d hareket=%s eksik=%s uyari=%d" % [ad, kayit["kemik_sayisi"], var_olan, kayit["eksik"], kayit["uyarilar"].size()])
	for u in kayit["uyarilar"]:
		print("  UYARI %s: %s" % [ad, u])
	k.queue_free()
	await get_tree().process_frame


func _esya_kesisimlerini_olc(esyalar: Array[ElEsyasi], kesisen: Dictionary) -> void:
	for esya in esyalar:
		var tur := esya.kemik_kesisimi_turu()
		if not tur.is_empty():
			kesisen[tur] = true


func _ayak_satiri(ad: String, en_alt: float) -> Dictionary:
	if not is_finite(en_alt):
		print("AYAK MUAYENE %s: ölçülemedi" % ad)
		return {"en_alt_y": null, "hata": false, "mesaj": "Ayak kemiği bulunamadı"}
	var olcum := ayak_muayenesi_yap(en_alt)
	# Yerden kopuk ayak uyarıdır, eşik altındaki kemik hata sayılır.
	olcum.hata = bool(olcum.hata) and en_alt < 0.0
	if olcum.hata:
		_ayak_hatasi += 1
	print("AYAK MUAYENE %s: en alt=%.5f m %s" % [ad, en_alt, "HATA" if olcum.hata else ""])
	return olcum


func _baslat(k: KarakterModel, h: String) -> void:
	k.position = Vector3.ZERO
	k.rotation = Vector3.ZERO
	if h == "yuru":
		# Yerinde yürüme: yürüme klibini oynat, konumu sabit tut (ayak kayması görsel olarak seçilir).
		if k._oynatici != null and k._anim != "":
			k._oynatici.speed_scale = 1.0
			if k._oynatici.current_animation != k._anim:
				k._oynatici.play(k._anim)
	elif h == "bekle":
		k.dur()
	else:
		if k.hareket_var(h) and k._oynatici.current_animation != k._klipler[h]:
			k._klip_oynat(h)


func _kamera_yerlestir(yan: bool) -> void:
	_kamera.position = Vector3(3.6, 1.0, 0.0) if yan else Vector3(0.0, 1.0, 3.6)
	_kamera.look_at(Vector3(0, 0.85, 0))


func _kemik_adlari(sk: Skeleton3D) -> PackedStringArray:
	var a: PackedStringArray = []
	if sk != null:
		for i in sk.get_bone_count(): a.append(sk.get_bone_name(i))
	return a


func _kemik(sk: Skeleton3D, parcalar: Array) -> Array:
	var sonuc: Array = []
	for i in sk.get_bone_count():
		var n := sk.get_bone_name(i).to_lower()
		for p in parcalar:
			if p in n:
				sonuc.append(sk.global_transform * sk.get_bone_global_pose(i).origin)
				break
	return sonuc


func _olc(sk: Skeleton3D, k: KarakterModel) -> Dictionary:
	var ayaklar := _kemik(sk, ["foot", "toe"])
	var eller := _kemik(sk, ["hand", "wrist"])
	var kalca := _kemik(sk, ["hips", "pelvis"])
	var bas := _kemik(sk, ["head"])
	var o := {}
	if not ayaklar.is_empty():
		var en_alt := INF
		for a in ayaklar: en_alt = minf(en_alt, a.y - ayak_zemini_yuksekligi(a))
		o["ayak_y"] = en_alt
	var farklar := ayak_zemin_farklari(k)
	if not farklar.is_empty():
		o["ayak_zemin_farki"] = Array(farklar).min()
	if not bas.is_empty():
		o["boy"] = bas[0].y
	if not eller.is_empty() and not kalca.is_empty():
		var boy: float = maxf(0.5, o.get("boy", 1.7))
		var aci := 0.0
		var yuks := -INF
		for e in eller:
			aci = maxf(aci, absf(e.x - kalca[0].x) + absf(e.z - kalca[0].z))
			yuks = maxf(yuks, e.y - kalca[0].y)
		o["el_aci"] = aci / boy
		o["el_y"] = yuks / boy
	return o


func _ozetle(olcumler: Array) -> Dictionary:
	var oz := {}
	for anahtar in ["ayak_y", "ayak_zemin_farki", "boy", "el_aci", "el_y"]:
		var degerler: Array = []
		for o in olcumler:
			if o.has(anahtar): degerler.append(o[anahtar])
		if degerler.is_empty():
			continue
		var mn: float = degerler.min()
		var mx: float = degerler.max()
		oz[anahtar] = [snappedf(mn, 0.01), snappedf(mx, 0.01)]
	return oz


func _uyar(h: String, oz: Dictionary) -> PackedStringArray:
	var u: PackedStringArray = []
	if oz.has("ayak_y"):
		if oz["ayak_y"][0] > AYAK_ESIGI: u.append("%s: ayaklar yerden kopuk (en alt %.2f m) — havada duruyor" % [h, oz["ayak_y"][0]])
		if oz["ayak_y"][0] < -AYAK_ESIGI: u.append("%s: ayak zemine gömülü (%.2f m)" % [h, oz["ayak_y"][0]])
	else:
		u.append("%s: ayak kemiği bulunamadı (ölçülemedi)" % h)
	if oz.has("el_aci") and oz["el_aci"][1] > 0.45 and h in ["bekle", "yuru"]:
		u.append("%s: kollar yanlara çok açık (%.2f) — T/A-pozu şüphesi" % [h, oz["el_aci"][1]])
	if oz.has("el_y") and oz["el_y"][1] > 0.35 and h in ["bekle", "yuru", "konus"]:
		u.append("%s: eller kalçanın çok üstünde (%.2f) — kollar havada şüphesi" % [h, oz["el_y"][1]])
	if oz.has("boy") and (oz["boy"][1] < 1.2 or oz["boy"][1] > 2.3):
		u.append("%s: baş yüksekliği olağandışı (%.2f m) — ölçek hatası" % [h, oz["boy"][1]])
	return u

# --- SAH-08, SAH-16, SAH-77: Muayene ve raporlama yardimcilari ---

static func ayak_muayenesi_yap(en_alt_y: float, esik: float = AYAK_ESIGI) -> Dictionary:
	var hata := en_alt_y < -esik or en_alt_y > esik
	var mesaj := ""
	if en_alt_y < -esik:
		mesaj = "ayak zemine gomulu (%.2f m)" % en_alt_y
	elif en_alt_y > esik:
		mesaj = "ayaklar yerden kopuk (%.2f m)" % en_alt_y
	return {"hata": hata, "en_alt_y": en_alt_y, "mesaj": mesaj}


static func esya_kesisim_muayenesi_yap(esya_turu: String, esya_pos: Vector3, kemik_noktalari: Array, min_aralik: float = 0.08) -> Dictionary:
	var kesisim := false
	for k_pos in kemik_noktalari:
		if k_pos is Vector3 and esya_pos.distance_to(k_pos) < min_aralik:
			kesisim = true
			break
	var mesaj := ""
	if kesisim:
		mesaj = "%s: %s kemik ile kesisiyor" % [ESYA_KESISIM_ETIKETI, esya_turu]
	return {"kesisim_var": kesisim, "tur": esya_turu, "mesaj": mesaj}


static func uclu_rapor_olustur(ayak_listesi: Array, esya_listesi: Array, klip_listesi: Array) -> Dictionary:
	return {
		"ayak": ayak_listesi,
		"esya": esya_listesi,
		"klip": klip_listesi
	}

