## `Oturum` ile QuestSystem havuzları arasındaki ince köprü.
## Bayrakların sahibi oturum ve köylüdür; bu sınıf onları okur, SYS-18 anahtarlarını yazmaz.
class_name GorevAdaptoru
extends RefCounted

const DENEMELER: Array[Dictionary] = [
	{"id": 1, "yol": "res://data/gorev/quest_gate_admit_three.tres"},
	{"id": 2, "yol": "res://data/gorev/quest_granary_food_36.tres"},
	{"id": 3, "yol": "res://data/gorev/quest_zeynep_usta_ciftci.tres"},
]


## Havuz durumu. Tekil yoksa boş sözlük (hiç `null` değil).
static func kaydet() -> Dictionary:
	return _paketle(_sistem())


## Kayıttaki `gorev` anahtarını havuzlara yazar. Anahtar yoksa denemeler baştan açılır.
static func yukle(veri: Dictionary) -> void:
	var sistem := _sistem()
	if sistem == null:
		return
	sistem.reset_pool()
	var havuzlar: Dictionary = veri.get("pools", {})
	if not veri.has("pools") or havuzlar.is_empty():
		_denemeleri_baslat(sistem)
		return
	var kopyalar := _kopyalar()
	for ad in havuzlar:
		var ham: Variant = havuzlar[ad]
		if not (ham is Array):
			continue
		for x in ham:
			var id := int(x)
			var tek: Array[Quest] = []
			for q in kopyalar:
				if q.id == id:
					tek.append(q)
					break
			if tek.is_empty():
				push_warning("Görev kaydında bilinmeyen id: %d" % id)
				continue
			sistem.restore_pool_state_from_dict({String(ad).to_lower(): [id]}, tek)
	sistem.deserialize_quests(veri.get("quests", {}))


## Kapı kararı işlendikten sonra: kabul sayacı ve kapıda açılan bayrak.
static func bildir_karar(oturum: Oturum, gelen: Gelen, _karar: StringName, _ek: Dictionary) -> void:
	var sistem := _sistem()
	if sistem == null:
		return
	_emin_ol(sistem)
	_guncelle(sistem, oturum, gelen, false)


## Gece çözüldükten sonra: erzak eşiği ve köylüye işlemiş bayrak.
static func bildir_gece(oturum: Oturum) -> void:
	var sistem := _sistem()
	if sistem == null:
		return
	_emin_ol(sistem)
	_guncelle(sistem, oturum, null, true)


## Test ve yükleme için havuzları boşaltıp üç denemeyi yeniden açar.
static func sifirla() -> void:
	var sistem := _sistem()
	if sistem == null:
		return
	sistem.reset_pool()
	_denemeleri_baslat(sistem)


static func _paketle(sistem: Node) -> Dictionary:
	if sistem == null:
		return {}
	_emin_ol(sistem)
	return {
		"pools": sistem.pool_state_as_dict(),
		"quests": sistem.serialize_quests(),
	}


static func _sistem() -> Node:
	var agac := Engine.get_main_loop() as SceneTree
	if agac == null or agac.root == null:
		return null
	var n := agac.root.get_node_or_null("QuestSystem")
	if n == null or not n.has_method("pool_state_as_dict"):
		return null
	return n


static func _emin_ol(sistem: Node) -> void:
	var biten: Array = sistem.get("completed").get_all_quests()
	if sistem.get_active_quests().is_empty() \
			and sistem.get_available_quests().is_empty() \
			and biten.is_empty():
		_denemeleri_baslat(sistem)


static func _denemeleri_baslat(sistem: Node) -> void:
	for q in _kopyalar():
		sistem.mark_quest_as_available(q)
		sistem.start_quest(q)


static func _kopyalar() -> Array[Quest]:
	var sonuc: Array[Quest] = []
	for d in DENEMELER:
		var ham := load(String(d["yol"])) as GorevKaydi
		if ham == null:
			push_error("Görev kaynağı yok: %s" % d["yol"])
			continue
		var kopya := ham.duplicate(true) as GorevKaydi
		kopya.id = int(d["id"])
		sonuc.append(kopya)
	return sonuc


static func _guncelle(sistem: Node, oturum: Oturum, gelen: Gelen, gece: bool) -> void:
	var aktif: Array[Quest] = []
	aktif.assign(sistem.get_active_quests())
	for q in aktif:
		if not (q is GorevKaydi):
			continue
		var g := q as GorevKaydi
		if not _bu_bildirim(g, gece):
			continue
		if _tamam_mi(g, oturum, gelen):
			_bitir(sistem, g, oturum)
		else:
			sistem.update_quest(g)


static func _bu_bildirim(g: GorevKaydi, gece: bool) -> bool:
	if g.tur == "bayrak":
		return true
	return gece == (g.tur == "gida_esik")


static func _tamam_mi(g: GorevKaydi, oturum: Oturum, gelen: Gelen) -> bool:
	match g.tur:
		"kabul_sayisi":
			g.ilerleme = oturum.yonetim.kabul_sayisi
			return g.ilerleme >= g.hedef
		"gida_esik":
			g.ilerleme = oturum.yonetim.kaynaklar.miktar("gida")
			return g.ilerleme >= g.hedef
		"bayrak":
			if _bayrak_acik(g, oturum, gelen):
				g.ilerleme = 1
				return true
			return false
		_:
			return false


## Kapıda duyulan bayrak, ya da içeri alınmış köylünün açık bayrağı. Oturum sözlüğüne yazılmaz.
static func _bayrak_acik(g: GorevKaydi, oturum: Oturum, gelen: Gelen) -> bool:
	if g.bayrak == "":
		return false
	if g.bayrak_yeri == "oturum":
		return bool(oturum.bayraklar.get(StringName(g.bayrak), false))
	if gelen != null and g.bayrak in gelen.acik_bayraklar:
		return true
	for k in oturum.yonetim.koylular:
		if k.bayrak_var(g.bayrak):
			return true
	return false


static func _bitir(sistem: Node, g: GorevKaydi, oturum: Oturum) -> void:
	g.objective_completed = true
	g.bitti_gun = oturum.gun
	sistem.complete_quest(g)
