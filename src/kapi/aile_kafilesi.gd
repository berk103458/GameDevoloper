## KAP-17: kafile tek Gelen ve tek karar olarak kalır; üyeler kuyruğa saçılmaz.
extends RefCounted
const META := &"kap17_aile_kararlari"
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/aile_kafileleri.json"))

static func kisi_sayisi(g: Gelen) -> int:
	return maxi(1, g.aile.size()) if g != null else 1

static func bolunur(g: Gelen) -> bool:
	if g == null or g.aile.size() < 2: return false
	var cocuk := 0
	for u in g.aile:
		if u.get("yas_grubu", "yetiskin") == "cocuk": cocuk += 1
	return cocuk > 0 and cocuk < g.aile.size()

static func ilgilenir(g: Gelen) -> bool:
	return g.aile.size() > 1 and not g.get_meta(&"kap17_isleniyor", false)

static func durum(o: Oturum) -> Dictionary:
	return o.get_meta(META, {"sonuclar": {}, "dedikodular": []}).duplicate(true)

static func yukle(o: Oturum, v: Variant) -> void:
	var d := {"sonuclar": {}, "dedikodular": []}
	if v is Dictionary:
		if v.get("sonuclar") is Dictionary:
			for id in v.sonuclar:
				if id is String and v.sonuclar[id] is String: d.sonuclar[id] = v.sonuclar[id]
		if v.get("dedikodular") is Array:
			for satir in v.dedikodular:
				if satir is String: d.dedikodular.append(satir)
	o.set_meta(META, d)

## DIY-13 bu makbuzları okur; burada yayılım/seçim veya ikinci söylenti motoru yok.
static func dedikodular(o: Oturum) -> Array:
	return durum(o).dedikodular

static func karar(o: Oturum, g: Gelen, secim: StringName, is_yeri: StringName) -> Dictionary:
	var engel := {"engellendi": true, "kaldi": false, "kirilan": -1}
	if uyeleri_oku(g.aile).size() != g.aile.size(): return engel
	if secim not in [&"kabul", &"ret", &"rusvet", &"harc", &"kisla", &"elkoy", &"cocuklari_al"]: return engel
	if secim == &"cocuklari_al" and not bolunur(g): return engel
	if g.aile_id.is_empty(): g.aile_id = "aile_%d_%d" % [o.gun, g.get_instance_id()]
	var d := durum(o)
	if d.sonuclar.has(g.aile_id): return engel
	# Mevcut bar, heybe, kadro ve ret mantığı reiste bir kez çalışır.
	g.set_meta(&"kap17_isleniyor", true)
	var r := o.karar_ver(g, &"ret" if secim == &"cocuklari_al" else secim, is_yeri)
	g.remove_meta(&"kap17_isleniyor")
	if r.get("engellendi", false): return r
	var kabul: Array[Koylu] = []
	if r.kaldi:
		var reis := o.yonetim.koylu(int(r.koylu_id))
		reis.yas_grubu = YasRolleri.oku(g.aile[0].get("yas_grubu"), &"")
		kabul.append(reis)
	for i in range(1, g.aile.size()):
		var u: Dictionary = g.aile[i]
		if r.kaldi or (secim == &"cocuklari_al" and u.get("yas_grubu") == "cocuk"):
			kabul.append(o.yonetim.kabul(u))
	if secim == &"cocuklari_al" and g.aile[0].get("yas_grubu") == "cocuk":
		kabul.append(o.yonetim.kabul(g.aile[0]))
	if not kabul.is_empty():
		var hane: int = kabul[0].id
		for k in kabul:
			k.hane_id = hane
			k.bayrak_ekle("kap17_aile")
		r.kaldi = true
		r.koylu_id = kabul[0].id
	if secim == &"cocuklari_al":
		MuhafizVicdani.haksizlik(o, int(AYAR.bolme_vicdan_yuku))
		o.yonetim.adalet = maxi(0, o.yonetim.adalet - int(AYAR.bolme_adalet_kaybi))
		d.dedikodular.append("%d. gün: %s kafilesinin çocukları alındı, yakınları kapı dışında kaldı." % [o.gun + 1, o.tr_gelen(g)])
	d.sonuclar[g.aile_id] = String(secim)
	o.set_meta(META, d)
	r["aile"] = true
	r["kabul_edilen"] = kabul.size()
	r["disarida_kalan"] = g.aile.size() - kabul.size()
	o._koy_esitle()
	return r

## Takvim deterministiktir; ayrı kişi kuyruğu veya aile RNG'si yok.
static func ekle(o: Oturum, kuyruk: Array[Gelen]) -> void:
	if o.gun < int(AYAR.ilk_gun) or (o.gun - int(AYAR.ilk_gun)) % maxi(1, int(AYAR.aralik)) != 0: return
	for i in kuyruk.size():
		var g := kuyruk[i]
		if g.adli or not String(g.id).is_empty() or not g.aile.is_empty() or DiplomatikHeyet.ilgilenir(g) or TuccarKapiGecisi.ilgilenir(g): continue
		g.aile_id = "kap17_%d_%d" % [o.gun, i]
		g.aile = [{"ad": o.tr_gelen(g), "yas_grubu": "yetiskin", "sinif": String(g.sinif), "stat": g.stat, "portre": g.portre}]
		g.aile.append_array(AYAR.uyeler.duplicate(true))
		g.giris_anahtari += "\nYanında ailesi var: iki yetişkin, bir çocuk ve bir yaşlı."
		return

## Snapshot ve veri kataloğu aynı dar üye şemasını kullanır.
static func uyeleri_oku(v: Variant) -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	if not v is Array or v.size() > 16: return sonuc
	for u in v:
		if not u is Dictionary or not u.get("ad") is String or u.ad.is_empty() or u.ad.length() > 128: return []
		for alan in ["sinif", "portre", "yas_grubu"]:
			if u.has(alan) and not u[alan] is String: return []
		var stat: Variant = u.get("stat", 4)
		if not (stat is int or stat is float) or not is_finite(float(stat)): return []
		if u.get("yas_grubu", "yetiskin") not in ["cocuk", "yetiskin", "yasli"]: return []
		var d := {"ad": String(u.ad), "yas_grubu": String(u.get("yas_grubu", "yetiskin")), "sinif": String(u.get("sinif", "ciftci")), "portre": String(u.get("portre", "peasant_01")), "stat": clampi(int(u.get("stat", 4)), 1, 10)}
		sonuc.append(d)
	return sonuc
