## ANI-13 yolunda görsel kökleri mevcut çarpışma payıyla ayırır.
class_name KoyRotaAraligi
extends RefCounted

const PAY_KARE := AyakZemini.CARPISMA_PAYI * AyakZemini.CARPISMA_PAYI - 0.000001
const YAN_ADIM_ACILARI := [PI / 4.0, -PI / 4.0, PI / 2.0, -PI / 2.0]


static func adim(hedef: Vector3, metre: float, h: KoyHalkHareketi, f: KarakterModel) -> Vector3:
	var bas := Vector2(f.position.x, f.position.z)
	var fark := Vector2(hedef.x, hedef.z) - bas
	var ilerleme := fark.limit_length(metre)
	var dogru := bas + ilerleme
	if _agda(h, dogru, false) and _aralik_var(h, f, bas, dogru):
		var y := lerpf(f.position.y, hedef.y, minf(1.0, metre / maxf(fark.length(), 0.001)))
		return Vector3(dogru.x, y, dogru.y)
	for aci in YAN_ADIM_ACILARI:
		var aday := bas + ilerleme.rotated(aci)
		if _agda(h, aday, true) and _aralik_var(h, f, bas, aday):
			return Vector3(aday.x, f.position.y, aday.y)
	return f.position


## Yan adımda aynı doğru üzerindeki ara noktaya geri dönme. Köşe ve son hedef tam varış ister.
static func duz_nokta_gecildi(h: KoyHalkHareketi, konum: Vector3, yol: Array, adim_no: int, varis: float) -> bool:
	if adim_no <= 0 or adim_no >= yol.size() - 1:
		return false
	var hedef: Vector3 = yol[adim_no]
	var giris: Vector3 = (hedef - yol[adim_no - 1]).normalized()
	var cikis: Vector3 = (yol[adim_no + 1] - hedef).normalized()
	if giris.dot(cikis) < 0.9999:
		return false
	var fark := konum - hedef
	var ileri := fark.dot(cikis)
	var yan_pay := h.sahne.HUCRE * 0.5 - float(KoyZeminNavigasyonu.AYAR.kenar_bosluk)
	return ileri >= -varis and ileri <= yan_pay and fark.slide(cikis).length() <= yan_pay


static func bos_hucre(h: KoyHalkHareketi, tercih: Vector2i, f: KarakterModel = null) -> Vector2i:
	var ilk := h.rotaci.yakin(tercih)
	if ilk.x < 0 or _hucre_bos(h, f, ilk):
		return ilk
	var boyut := h.sahne.yonetim.a.izgara_boyut
	var en_yakin := Vector2i(-1, -1)
	var uzaklik := INF
	for y in boyut.y:
		for x in boyut.x:
			var hucre := Vector2i(x, y)
			var mesafe := Vector2(hucre - tercih).length_squared()
			if mesafe < uzaklik and h.rotaci.gecilir(hucre) and _hucre_bos(h, f, hucre):
				en_yakin = hucre
				uzaklik = mesafe
	return en_yakin


## Yerinde duran kök ve planlanmış varış aynı hücreyi başka kişiye ayırmaz.
static func varis_yolu(h: KoyHalkHareketi, figur: KarakterModel, bas: Vector2i, hedef: Vector2i) -> Array[Vector2i]:
	var dolu := {}
	var trafik := {}
	for id in h.modeller:
		var diger: KarakterModel = h.modeller[id]
		if diger == figur or not is_instance_valid(diger) or diger.is_queued_for_deletion():
			continue
		var durum: Dictionary = h._durum[id]
		var yol: Array = durum.yol
		if int(durum.adim) >= yol.size():
			dolu[hucre(h, diger.position)] = true
		if not yol.is_empty():
			var durak := hucre(h, yol[-1])
			dolu[durak] = true
			if durak.distance_squared_to(hedef) <= 8:
				var iz := {}
				for i in range(int(durum.adim), yol.size()):
					iz[hucre(h, yol[i])] = true
				for nokta in iz:
					trafik[nokta] = int(trafik.get(nokta, 0)) + 1
	return KalabalikYol.bos_varis_yolu(h.rotaci, bas, hedef, dolu, trafik)


static func adim_dolu(h: KoyHalkHareketi, figur: KarakterModel, hedef: Vector3) -> bool:
	var hedef_hucresi := hucre(h, hedef)
	for id in h.modeller:
		var diger: KarakterModel = h.modeller[id]
		if diger == figur or not is_instance_valid(diger) or diger.is_queued_for_deletion():
			continue
		var durum: Dictionary = h._durum[id]
		if int(durum.adim) >= durum.yol.size() and hucre(h, diger.position) == hedef_hucresi:
			return true
	return false


static func hucre(h: KoyHalkHareketi, konum: Vector3) -> Vector2i:
	var kose := h.sahne.hucre_kosesi(Vector2i.ZERO)
	var boy := h.sahne.HUCRE
	return Vector2i(floori((konum.x - kose.x) / boy), floori((konum.z - kose.z) / boy))


static func _hucre_bos(h: KoyHalkHareketi, f: KarakterModel, hucre: Vector2i) -> bool:
	var konum := h._konum(hucre)
	var nokta := Vector2(konum.x, konum.z)
	return _aralik_var(h, f, nokta, nokta)


static func _aralik_var(h: KoyHalkHareketi, f: KarakterModel, bas: Vector2, son: Vector2) -> bool:
	var vektor := son - bas
	var uzunluk_kare := vektor.length_squared()
	for id in h.modeller:
		var diger: KarakterModel = h.modeller[id]
		if diger == f or not is_instance_valid(diger) or diger.is_queued_for_deletion():
			continue
		var kok := Vector2(diger.position.x, diger.position.z)
		var pay := clampf((kok - bas).dot(vektor) / uzunluk_kare, 0.0, 1.0) if uzunluk_kare > 0.0 else 0.0
		if kok.distance_squared_to(bas + vektor * pay) < PAY_KARE:
			return false
	return true


static func _agda(h: KoyHalkHareketi, konum: Vector2, yan_adim: bool) -> bool:
	if not h.rotaci.gecilir(hucre(h, Vector3(konum.x, 0.0, konum.y))):
		return false
	if not yan_adim:
		return true
	var bolge := h.get_node_or_null("zemin_navigasyonu") as KoyZeminNavigasyonu
	if bolge == null or not bolge.hazir():
		return false
	var dunya := h.sahne.to_global(Vector3(konum.x, 0.0, konum.y))
	var yakin := NavigationServer3D.map_get_closest_point(bolge.get_navigation_map(), dunya)
	return Vector2(yakin.x - dunya.x, yakin.z - dunya.z).length() <= float(KoyZeminNavigasyonu.AYAR.hedef_toleransi)
