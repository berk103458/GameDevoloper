## OGR-42: Görünen ilk saat ipuçları ve ilk araç kullanımları. Oturum ölçümüdür.
extends RefCounted

const META := &"ogr42_ilk_saat"
const ILK_ALTI_GECE := 6
const ARACLAR := ["koy_hizi", "koy_atama", "kapi_selam", "kapi_konu", "kapi_karar", "heybe", "beyan", "bakmak"]

static func ipucu(o: Oturum, id: String) -> void:
	_yaz(o, "ipucu", id)

static func arac(o: Oturum, id: String) -> void:
	_yaz(o, "arac", id)

static func _yaz(o: Oturum, alan: String, id: String) -> void:
	if o == null or o.gun < 0 or o.gun >= ILK_ALTI_GECE: return
	var iz: Dictionary = o.get_meta(META, {"ipucu": {}, "arac": {}})
	if iz[alan].has(id): return
	iz[alan][id] = o.gun
	o.set_meta(META, iz)

static func satirlar(o: Oturum) -> Array[Dictionary]:
	var iz: Dictionary = o.get_meta(META, {"ipucu": {}, "arac": {}})
	var sonuc: Array[Dictionary] = []
	for id in iz.ipucu:
		sonuc.append({"ipucu": id, "gosterim_gecesi": iz.ipucu[id], "ilk_kullanim_gecesi": iz.arac.get(id, -1)})
	return sonuc

static func araclar(o: Oturum) -> Dictionary:
	var kullanilan: Dictionary = o.get_meta(META, {}).get("arac", {})
	var sonuc := {}
	for id in ARACLAR:
		sonuc[id] = int(kullanilan.get(id, -1))
	return sonuc

static func aktar(eski: Oturum, yeni: Oturum) -> void:
	if eski != null and yeni != null and eski != yeni and eski.has_meta(META):
		yeni.set_meta(META, eski.get_meta(META).duplicate(true))
