## Debug kaydı için açık alan listesi; script/Resource yolu JSON'dan yüklenmez.
class_name KapiAnlikGoruntusu
extends RefCounted

const BASIT := ["adli", "id", "ad_anahtari", "sinif", "portre", "giris_anahtari", "acilis", "etkiler", "yanitlar", "azami_soru", "tehlikeli", "stat"]
const METIN_DIZILERI := ["secenekler", "soru_bayraklari", "gizli_bayraklar", "acik_bayraklar"]
const SAYI_DIZILERI := ["soru_ust", "esikler"]

static func gelen_kaydet(g: Gelen) -> Dictionary:
	var v := {}
	for alan in BASIT + METIN_DIZILERI + SAYI_DIZILERI + ["sorular"]:
		v[alan] = g.get(alan)
	v["heybe"] = null
	if g.heybe != null:
		v["heybe"] = {"esyalar": g.heybe.esyalar.duplicate(true), "teklif": g.heybe.teklif, "astar_yoklandi": g.heybe.astar_yoklandi, "soruldu": g.heybe.soruldu}
	v["chr_kontrol_edildi"] = g._chr_kontrol_edildi
	v["chr"] = null
	var s: ChrSorgusu = g._chr_sorgusu
	if s != null:
		v["chr"] = {"bayraklar": s.bayraklar.duplicate(true), "ipuclari": s.ipuclari.keys(), "tansiyon": s.tansiyon,
			"dugum_id": s.dugum_id, "tecrube": s.tecrube, "son_zar": s.son_zar.duplicate(true),
			"rng": str(s._rng.state), "denemeler": s._denemeler.duplicate(true), "son_konusulan": s._son_konusulan}
	return v.duplicate(true)

static func gelen_yukle(v: Dictionary, katalog: Katalog) -> Gelen:
	# Sadece katalogdaki adlı kimlikler veya gerçek adsız figürler kabul edilir.
	if not v.get("adli") is bool or not v.get("id") is String or not v.get("sinif") is String:
		return null
	if v["adli"]:
		var ids: Array[StringName] = []
		for k in katalog.karakterler(): ids.append(k.id)
		if StringName(v["id"]) not in ids: return null
	for alan in ["etkiler", "yanitlar"]:
		if not v.get(alan) is Dictionary: return null
	for alan in METIN_DIZILERI + SAYI_DIZILERI + ["sorular"]:
		if not v.get(alan) is Array: return null
	for soru in v["sorular"]:
		if not soru is Array or soru.size() != 2 or not soru.all(func(x: Variant) -> bool: return x is String): return null
	for alan in METIN_DIZILERI:
		if not v[alan].all(func(x: Variant) -> bool: return x is String): return null
	for alan in SAYI_DIZILERI:
		if not v[alan].all(func(x: Variant) -> bool: return x is int or x is float): return null
	for alan in ["ad_anahtari", "portre", "giris_anahtari", "acilis"]:
		if not v.get(alan) is String: return null
	for alan in ["azami_soru", "stat"]:
		if not (v.get(alan) is int or v.get(alan) is float): return null
	if not v.get("tehlikeli") is bool: return null
	var g := Gelen.new()
	for alan in BASIT:
		g.set(alan, StringName(v[alan]) if alan in ["id", "sinif"] else v[alan])
	g.etkiler = {}
	for karar in v["etkiler"]:
		var etki: Variant = v["etkiler"][karar]
		if not etki is Array or not etki.all(func(x: Variant) -> bool: return x is int or x is float): return null
		g.etkiler[StringName(karar)] = PackedInt32Array(etki)
	for alan in METIN_DIZILERI: g.set(alan, PackedStringArray(v[alan]))
	for alan in SAYI_DIZILERI: g.set(alan, PackedInt32Array(v[alan]))
	for soru in v["sorular"]: g.sorular.append(PackedStringArray(soru))
	var h: Variant = v.get("heybe")
	if h != null:
		if not h is Dictionary or not h.get("esyalar") is Array: return null
		for e in h["esyalar"]:
			if not e is Dictionary: return null
			for a in ["id", "tur"]:
				if not e.get(a) is String: return null
			for a in ["deger", "adet", "alinan"]:
				if not (e.get(a) is int or e.get(a) is float): return null
			for a in ["gizli", "kesfedildi"]:
				if not e.get(a) is bool: return null
		if not (h.get("teklif") is int or h.get("teklif") is float) or not h.get("astar_yoklandi") is bool or not h.get("soruldu") is bool: return null
		g.heybe = Heybe.new()
		g.heybe.esyalar.assign(h["esyalar"])
		for e in g.heybe.esyalar:
			for a in ["deger", "adet", "alinan"]: e[a] = int(e[a])
		g.heybe.teklif = int(h["teklif"])
		g.heybe.astar_yoklandi = h["astar_yoklandi"]
		g.heybe.soruldu = h["soruldu"]
	var c: Variant = v.get("chr")
	if c != null:
		if not c is Dictionary or not c.get("bayraklar") is Dictionary or not c.get("ipuclari") is Array or not c.get("son_zar") is Dictionary or not c.get("denemeler") is Dictionary or not c.get("rng") is String or not c.get("dugum_id") is String or not c.get("son_konusulan") is String: return null
		if not (c.get("tansiyon") is int or c.get("tansiyon") is float) or not (c.get("tecrube") is int or c.get("tecrube") is float): return null
		var s := g.chr_sorgusu() as ChrSorgusu
		if s == null or not s.karakter.diyalog_dugumleri.has(c["dugum_id"]): return null
		for flag in s.bayraklar:
			if not c["bayraklar"].get(flag) is bool: return null
		s.bayraklar = c["bayraklar"].duplicate(true)
		for ipucu in c["ipuclari"]:
			if not ipucu is String or not ipucu.begins_with("Clue_"): return null
			s._ipucu_servisi.kaydet(StringName(ipucu))
		s.tansiyon = int(c["tansiyon"])
		s.dugum_id = StringName(c["dugum_id"])
		s.tecrube = int(c["tecrube"])
		s.son_zar = c["son_zar"].duplicate(true)
		s._denemeler = c["denemeler"].duplicate(true)
		s._rng.state = c["rng"].to_int()
		s._son_konusulan = StringName(c["son_konusulan"])
	else:
		g._chr_kontrol_edildi = bool(v.get("chr_kontrol_edildi", false))
	return g

static func kaydet(e: Node) -> Dictionary:
	var kuyruk: Array = []
	for g: Gelen in e.get("_kuyruk"): kuyruk.append(gelen_kaydet(g))
	var kamera: Camera3D = e.get("sahne").get("kamera")
	return {"gelen": gelen_kaydet(e.get("_gelen")), "kuyruk": kuyruk, "evre": String(e.get("evre")),
		"sorulan": e.get("_sorulan").duplicate(), "secili": e.get("_secili"), "gece_gelen": e.get("_gece_gelen"),
		"yalan_yazildi": e.get("_yalan_yazildi"), "kayit": e.get("_kayit").text,
		"kamera": {"position": [kamera.position.x, kamera.position.y, kamera.position.z], "rotation": [kamera.rotation.x, kamera.rotation.y, kamera.rotation.z], "fov": kamera.fov}}

static func yukle(v: Dictionary, katalog: Katalog) -> Dictionary:
	if not v.get("gelen") is Dictionary or not v.get("kuyruk") is Array or v.get("evre") not in ["sohbet", "karar"] or not v.get("sorulan") is Array or not v.get("secili") is String or not v.get("kayit") is String or not v.get("kamera") is Dictionary or not (v.get("gece_gelen") is int or v.get("gece_gelen") is float) or not v.get("yalan_yazildi") is bool:
		return {}
	var g := gelen_yukle(v["gelen"], katalog)
	if g == null: return {}
	if v["secili"] != "" and v["secili"] not in g.secenekler and v["secili"] != "elkoy": return {}
	for alan in ["position", "rotation"]:
		var x: Variant = v["kamera"].get(alan)
		if not x is Array or x.size() != 3 or not x.all(func(n: Variant) -> bool: return (n is int or n is float) and is_finite(float(n))): return {}
	var fov: Variant = v["kamera"].get("fov")
	if not (fov is int or fov is float) or not is_finite(float(fov)) or float(fov) < 1.0 or float(fov) > 179.0: return {}
	var kuyruk: Array[Gelen] = []
	for x in v["kuyruk"]:
		if not x is Dictionary: return {}
		var bekleyen := gelen_yukle(x, katalog)
		if bekleyen == null: return {}
		kuyruk.append(bekleyen)
	var sorulan: Array[int] = []
	for i in v["sorulan"]:
		if not (i is int or i is float) or int(i) < 0 or int(i) >= g.sorular.size(): return {}
		sorulan.append(int(i))
	var sonuc := v.duplicate(true)
	sonuc["gelen"] = g
	sonuc["kuyruk"] = kuyruk
	sonuc["sorulan"] = sorulan
	return sonuc

static func goster(e: Node, v: Dictionary) -> void:
	e.set("_gelen", v["gelen"])
	e.set("_kuyruk", v["kuyruk"])
	e.set("_sorulan", v["sorulan"])
	e.set("_gece_gelen", int(v["gece_gelen"]))
	e.set("_yalan_yazildi", v["yalan_yazildi"])
	var g: Gelen = v["gelen"]
	var adlar: Array[String] = [e.call("_model_adi", g)]
	for bekleyen: Gelen in v["kuyruk"]: adlar.append(e.call("_model_adi", bekleyen))
	var kaynak := await VarlikYuklemePaneli.hazirla(e, GirisVarliklari.karakterler(adlar))
	if not is_instance_valid(e):
		kaynak.bosalt()
		return
	var s: Node = e.get("sahne")
	s.call("kuyruk_doldur", adlar.slice(1))
	var model := Dunya3B.karakter(adlar[0])
	s.add_child(model)
	s.set("_gelen", model)
	model.position = s.DURMA
	model.bak(s.get("kamera").position)
	e.get("_ad").text = e.tr(g.ad_anahtari)
	e.get("_levha_ad").text = e.tr(g.ad_anahtari)
	e.get("_sinif").text = e.tr("arayuz.sinif.gibi") % e.tr("arayuz.sinif." + String(g.sinif))
	e.get("_kayit").text = v["kayit"]
	e.call("_bilgi_yaz")
	e.call("_sohbet_goster" if v["evre"] == "sohbet" else "_karar_goster")
	e.call("_tumunu_goster")
	if v["evre"] == "karar" and v["secili"] != "": e.call("_karar_bas", v["secili"])
	# Yeniden kurulan karar kamerasının geçişi snapshot pozunu sonradan ezmesin.
	s.get("_kamera_gecisi").call("_baslat")
	var kamera: Camera3D = s.get("kamera")
	for alan in ["position", "rotation"]:
		var x: Variant = v["kamera"].get(alan)
		if x is Array and x.size() == 3: kamera.set(alan, Vector3(float(x[0]), float(x[1]), float(x[2])))
	kamera.fov = float(v["kamera"].get("fov", kamera.fov))
	e.get("hud").call("guncelle")
	await VarlikYuklemePaneli.bitir(e, kaynak)
