## Pazar tezgâhı, su bendi ve yanık ev: mevcut Dunya3B.nesne yolu.
## Model yoksa ya da yüklenemezse düz kutu yer tutucu kalır. İkinci kopya kurulmaz.
class_name OlayYapilari
extends RefCounted

const PAZAR_BOY := 1.2
const BENT_BOY := 0.8
const YANIK_BOY := 2.2
const YAPI_MAP := {
	"kisla": "muhafiz_kislasi",
	"avci": "avci_cadiri",
	"kulube": "ev",
	"han": "pazar_tezgahi",
	"degirmen": "degirmen_o76",
}


## Yapı türünü gerçek model kimliğine eşler (`avci` → `avci_cadiri`, `kisla` → `muhafiz_kislasi`, `han` → `pazar_tezgahi` / `kervansaray`).
static func yapi_adi(tur: String) -> String:
	return yapi_adi_seviyeli(tur, 1)


## Seviye duyarlı yapı kimliği (`han` seviye 2+ olduğunda `kervansaray`).
static func yapi_adi_seviyeli(tur: String, seviye: int = 1) -> String:
	if tur == "han":
		if seviye >= 2 and Dunya3B.model_var_mi("kervansaray", "yapi"):
			return "kervansaray"
		if Dunya3B.model_var_mi("pazar_tezgahi", "yapi"):
			return "pazar_tezgahi"
		return tur
	if YAPI_MAP.has(tur):
		return String(YAPI_MAP[tur])
	return tur


## Tezgâh han hücresine (2 m) sığsın; kervansaray 3.2 m, diğer yapılar çağıranın boyunu kullanır.
static func yukseklik(ad: String, varsayilan: float) -> float:
	if ad == "pazar_tezgahi":
		return PAZAR_BOY
	if ad == "kervansaray":
		return 3.2
	return varsayilan


static func kur(s: KoyYonetimSahnesi, ust: Node3D) -> void:
	if not _han_var(s):
		_yerlestir(ust, "pazar_tezgahi", "yapi", PAZAR_BOY, _pazar_yeri(s), Vector3(1.6, PAZAR_BOY, 1.2))
	_bent(s, ust)
	var yanik_yer := _yanik_yeri(s)
	if not yanik_yer.is_empty():
		_yerlestir(ust, "yanik_ev", "yapi", YANIK_BOY, yanik_yer["yer"], Vector3(2.2, YANIK_BOY, 2.0))


static func _han_var(s: KoyYonetimSahnesi) -> bool:
	for b in s.yonetim.binalar:
		if b.hazir() and b.tur == "han":
			return true
	return false


static func _pazar_yeri(s: KoyYonetimSahnesi) -> Vector3:
	var m := s.yonetim.a.meydan
	return s.alan_merkezi(m.position, m.size) + Vector3(2.6, 0.0, -2.6)


static func _bent(s: KoyYonetimSahnesi, ust: Node3D) -> void:
	var m := s.yonetim.a.meydan
	var hat := Node3D.new()
	hat.name = "su_bendi_hatti"
	ust.add_child(hat)
	if not Dunya3B.model_var_mi("su_bendi", "yapi"):
		_yerlestir(hat, "su_bendi", "yapi", BENT_BOY, Vector3(0, 0, 3.6), Vector3(3.0, BENT_BOY, 0.6))
		hat.position = s.alan_merkezi(m.position, m.size)
		return
	var ornek := Dunya3B.nesne("su_bendi", BENT_BOY, "yapi")
	var aralik := Dunya3B.boyut(ornek).x + 0.15
	ornek.position = Vector3(-aralik * 0.5, 0, 3.6)
	hat.add_child(ornek)
	var ikinci := Dunya3B.nesne("su_bendi", BENT_BOY, "yapi")
	ikinci.position = Vector3(aralik * 0.5, 0, 3.6)
	hat.add_child(ikinci)
	hat.position = s.alan_merkezi(m.position, m.size)


static func _yanik_yeri(s: KoyYonetimSahnesi) -> Dictionary:
	var h: Variant = s.yonetim.get_meta(&"yanik_ev_hucre") if s.yonetim.has_meta(&"yanik_ev_hucre") else null
	if h is Vector2i and not _cevre_dolu(s, h):
		return {"yer": s.alan_merkezi(h, Vector2i.ONE)}
	return {"yer": s.hucre_kosesi(Vector2i(-3, 4)) + Vector3(1.0, 0, 1.0)}


## Kulübe izi komşu yapıya binmesin diye üç hücrelik çevre boş olmalı.
static func _cevre_dolu(s: KoyYonetimSahnesi, h: Vector2i) -> bool:
	var cevre := Rect2i(h - Vector2i.ONE, Vector2i(3, 3))
	for b in s.yonetim.binalar:
		var boy := b.boyut(s.yonetim.katalog)
		if cevre.intersects(Rect2i(b.hucre, boy)):
			return true
	return false


static func _yerlestir(ust: Node3D, ad: String, tur: String, boy: float, yer: Vector3, kutu_boy: Vector3) -> void:
	var n: Node3D
	if Dunya3B.model_var_mi(ad, tur):
		n = Dunya3B.nesne(ad, boy, tur)
	else:
		n = _kutu(ad, kutu_boy)
	n.position = yer
	ust.add_child(n)


static func _kutu(ad: String, boy: Vector3) -> Node3D:
	var n := MeshInstance3D.new()
	n.name = ad + "_yer_tutucu"
	var mesh := BoxMesh.new()
	mesh.size = boy
	n.mesh = mesh
	n.position.y = boy.y * 0.5
	var malzeme := StandardMaterial3D.new()
	malzeme.albedo_color = Color(0.45, 0.32, 0.22)
	n.material_override = malzeme
	var kap := Node3D.new()
	kap.name = ad
	kap.add_child(n)
	return kap
