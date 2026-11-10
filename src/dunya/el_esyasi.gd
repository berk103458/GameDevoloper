## Karakterin elinde taşıdığı eşya (torba, asa, testi, kova…): Meshy modelinde olmayan ya da sırtta kalan yükü
## karakter sayfasındaki gibi ele verir. İskelette parmak kemiği olmadığı için eşyanın tutma noktası avuç
## ortasına konur; parmaklar kavramanın içinde kalır.
## Eşya el kemiğinin konumunu izler ama dönüşü yerçekimine göredir (asılı eşya aşağı sarkar, asa dik durur):
## Meshy iskeletlerinde kemik eksenleri modelden modele değiştiği için kemik dönüşüne güvenilmez.
## Hangi karaktere ne verileceği: data/el_esyalari.json (tools/icerik/karakter_sayfalari.py üretir).
class_name ElEsyasi
extends Node3D

## Eşya renkleri (toprak tonları; modellerin dokusuyla uyumlu, sanat kitabı paletinin sıcak ucu).
const KETEN := Color("#9C8A68")
const KIL := Color("#8A5A3A")
const KOYU_AHSAP := Color("#4A3524")
const ACIK_AHSAP := Color("#7A5C3C")
const DERI := Color("#5A3E28")
const YUN := Color("#8F8268")
const DEMIR := Color("#5C5F63")
const SAZ := Color("#6E5F3A")
## Avuç ölçülemezse: bilekten önkol yönünde bu kadar ileri (m).
const AVUC := 0.06
const TEMAS = preload("res://src/dunya/el_esyasi_temas.gd")
## Asılı eşyanın gövdesi bacağa girmesin diye yana kaydırılır (tutma noktası elde kalır) (m).
const BACAKTAN := 0.06
## Asılı eşyanın el hızına bağlı sallanma katsayısı ve en büyük açısı.
const SALINIM := 0.35
const AZAMI_ACI := 0.45

var _iskelet: Skeleton3D
var _el := -1
var _onkol := -1
var _govde: Node3D
var _yan := 1.0
## Avuç ortası el kemiğinin uzayında (DurusDuzeltici mesh'ten ölçer); yoksa önkol yönü kullanılır.
var _avuc: Variant = null
var _duzeltici: DurusDuzeltici
var _onceki := Vector3.ZERO
var _aci := Vector2.ZERO
var _temas: TEMAS
var _soket_hazir := false
var _ayak: AyakZemini
var _tercih := Basis.IDENTITY
var _sapta_kayabilir := false
var _sap_kaymasi := 0.0
var _yuk_olcegi := 1.0
## Dik eşya (asa, çapa): sallanmaz, avuçtan aşağı/yukarı uzanır.
var dik := false


## `tur` eşyasını kurar; tanınmayan tür null döner.
static func olustur(tur: String) -> ElEsyasi:
	var e := ElEsyasi.new()
	e.name = "esya_" + tur
	if tur in ["cekic", "kazma", "odun"]:
		var hazir := HazirEsyaHayvan.esya(tur)
		if hazir != null:
			e.add_child(hazir)
			e.dik = tur != "odun"
			hazir.position.y = -0.15
			return e
	match tur:
		"torba":
			e._torba(0.14, 0.24, KETEN.darkened(0.15))
		"cuval":
			e._torba(0.22, 0.4, SAZ)
		"heybe":
			e._heybe()
		"bohca":
			e._bohca(0.17, YUN)
		"kurk":
			e._bohca(0.22, Color("#6B4A32"))
		"sepet":
			e._sepet(0.17, 0.2)
		"sepet_buyuk":
			e._sepet(0.23, 0.28)
		"testi":
			e._testi()
		"kabak":
			e._kabak()
		"kova":
			e._kova()
		"sandik":
			e._sandik()
		"kile":
			e._kile()
		"kalbur":
			e._kalbur()
		"odun":
			e._odun()
		"asa":
			e._asa(1.45, 0.72, ACIK_AHSAP)
		"degnek":
			e._asa(1.5, 0.74, KOYU_AHSAP, true)
		"capa":
			e._capa()
		"kazma":
			e._kazma()
		"kamci":
			e._kamci()
		"cubuk":
			e._cubuk()
		"cekic":
			e._cekic()
		"kilic_bez":
			e._kilic_bez()
		_:
			e.free()
			return null
	return e


## Eşyayı karakterin bir eline bağlar (`sag` = true sağ el). Karakterin altına eklenir, el kemiğini izler.
func bagla(govde: Node3D, iskelet: Skeleton3D, sag: bool, duzeltici: DurusDuzeltici = null) -> void:
	_govde = govde
	var hazir := govde as HazirKarakterModeli
	_yuk_olcegi = cocuk_olcekle(hazir.boy / HazirKarakterModeli.YETISKIN_BOYU) if hazir != null else 1.0
	_duzeltici = duzeltici
	_iskelet = iskelet
	_el = iskelet.find_bone("RightHand" if sag else "LeftHand")
	_onkol = iskelet.find_bone("RightForeArm" if sag else "LeftForeArm")
	_yan = -1.0 if sag else 1.0
	# Konum, değiştiriciler (DurusDuzeltici) uygulandıktan sonraki son pozdan okunur; _process'te okunursa
	# kolu indirilmemiş animasyon pozu gelir ve eşya elin dışında kalır.
	_temas = TEMAS.new(self, iskelet)
	iskelet.skeleton_updated.connect(_guncelle)
	_ayak = govde.get_node_or_null("AyakZemini") as AyakZemini
	if _ayak != null:
		_ayak.gorsel_ofset_degisti.connect(_gorsel_kaydir)


## Yürüyüş kökü güncellenince ayak çözümü iskeleti poz sinyalinden sonra kaldırabilir.
func _gorsel_kaydir(fark: Vector3) -> void:
	if _soket_hazir and is_inside_tree():
		global_position += fark
		var zemin := _zemin_olcer()
		if _sapta_kayabilir:
			_sapi_kaydir(zemin)
		elif not dik and _temas.zemin_farki(global_position, global_basis, zemin) > 0.00001:
			global_basis = _temas.yon(global_position, _tercih, false, zemin)


func _zemin_olcer() -> Callable:
	return _ayak.zemin_olcer() if is_instance_valid(_ayak) else Callable()


## Düz şaft avuçta kalır. Alt uç yere değince yalnız şaft yukarı kayar.
func _sapi_kaydir(zemin: Callable) -> void:
	var kayma := _temas.zemin_farki(global_position, global_basis, zemin)
	var fark := kayma - _sap_kaymasi
	if is_zero_approx(fark):
		return
	for parca: Node3D in get_children():
		parca.position.y += fark / _yuk_olcegi
	_sap_kaymasi = kayma


func _guncelle() -> void:
	# Zaten skeleton_updated ile çağrılır; delta için ayrı boş _process gerekmez.
	var delta := get_process_delta_time()
	if _iskelet == null or _el < 0 or not is_instance_valid(_iskelet) or not is_inside_tree():
		return
	var t := _iskelet.global_transform
	var el_poz := _iskelet.get_bone_global_pose(_el)
	if _avuc == null and _duzeltici != null and is_instance_valid(_duzeltici):
		# Düzeltici ölçümü ağaca girince yapar; o zamana dek önkol yönü kullanılır.
		_avuc = _duzeltici.avuc(_iskelet.get_bone_name(_el))
	var avuc: Vector3
	if _avuc != null:
		avuc = t * (el_poz * (_avuc as Vector3))
	else:
		var bilek := t * el_poz.origin
		var dirsek := t * _iskelet.get_bone_global_pose(_onkol).origin if _onkol >= 0 else bilek + Vector3.UP * 0.25
		avuc = bilek + (bilek - dirsek).normalized() * AVUC
	# Yalnız gövdenin dönüşü (yaw): eşya karakterle döner, eğilmez.
	var ileri := -_govde.global_basis.z
	ileri.y = 0.0
	ileri = ileri.normalized() if ileri.length() > 0.01 else Vector3.FORWARD
	var yan := Vector3.UP.cross(ileri).normalized()
	var taban := Basis(yan, Vector3.UP, -ileri).scaled(Vector3.ONE * _yuk_olcegi)
	global_position = avuc
	_soket_hazir = true
	var zemin := _zemin_olcer()
	if dik:
		global_basis = _temas.yon(avuc, taban, true)
		if _sapta_kayabilir:
			_sapi_kaydir(zemin)
		return
	# Sarkaç: el hızlanınca eşya geride kalır, yavaşça dik konuma döner.
	var hiz := (avuc - _onceki) / maxf(delta, 0.001)
	_onceki = avuc
	var hedef := Vector2(clampf(hiz.dot(ileri) * SALINIM, -AZAMI_ACI, AZAMI_ACI),
			clampf(hiz.dot(yan) * SALINIM, -AZAMI_ACI, AZAMI_ACI))
	_aci = _aci.lerp(hedef, clampf(delta * 6.0, 0.0, 1.0))
	# Bacaktan uzak: gövde dışa doğru hafif açılı sarkar (tutma noktası elde kalır).
	var aci_disa := atan2(BACAKTAN, 0.3) * -_yan
	_tercih = taban * Basis(Vector3.RIGHT, -_aci.x) * Basis(Vector3.BACK, _aci.y + aci_disa)
	global_basis = _temas.yon(avuc, _tercih, false, zemin)


# ── Biçimler: tutma noktası orijinde; asılı eşyalar −Y yönünde sarkar. ──

func _parca(mesh: Mesh, renk: Color, konum: Vector3, donus := Vector3.ZERO) -> MeshInstance3D:
	var m := MeshInstance3D.new()
	m.mesh = mesh
	m.material_override = Dunya3B.duz_malzeme(renk)
	m.position = konum
	m.rotation = donus
	add_child(m)
	return m


func _silindir(ust: float, alt: float, boy: float) -> CylinderMesh:
	var c := CylinderMesh.new()
	c.top_radius = ust
	c.bottom_radius = alt
	c.height = boy
	c.radial_segments = 12
	return c


func _kure(r: float, boy: float) -> SphereMesh:
	var s := SphereMesh.new()
	s.radius = r
	s.height = boy
	s.radial_segments = 14
	s.rings = 8
	return s


func _kutu(boyut: Vector3) -> BoxMesh:
	var b := BoxMesh.new()
	b.size = boyut
	return b


func _torba(r: float, boy: float, renk: Color) -> void:
	# Ağzı büzülmüş çuval: el boğazı kavrar, gövde aşağıda.
	_parca(_silindir(0.025, 0.04, 0.08), renk.darkened(0.15), Vector3(0, -0.02, 0))
	_parca(_kure(r, boy), renk, Vector3(0, -0.06 - boy * 0.5, 0))


func _heybe() -> void:
	# Deri çanta: kayış elde, yumuşak gövde altta, kapağı önde.
	var kayis := TorusMesh.new()
	kayis.inner_radius = 0.06
	kayis.outer_radius = 0.075
	_parca(kayis, DERI.darkened(0.25), Vector3(0, -0.05, 0), Vector3(PI / 2.0, 0, PI / 2.0))
	var govde := _parca(_kure(0.15, 0.24), DERI, Vector3(0, -0.21, 0))
	govde.scale = Vector3(1.0, 0.85, 0.45)
	var kapak := _parca(_kutu(Vector3(0.24, 0.1, 0.02)), DERI.darkened(0.15), Vector3(0, -0.15, 0.065), Vector3(-0.15, 0, 0))
	kapak.scale = Vector3.ONE


func _bohca(r: float, renk: Color) -> void:
	# Düğümlü bez bohça: düğüm ve iki kulak elde, yassı gövde altta.
	_parca(_kure(0.035, 0.05), renk.darkened(0.25), Vector3.ZERO)
	for x in [-0.03, 0.03]:
		_parca(_kure(0.025, 0.07), renk.darkened(0.2), Vector3(x, 0.03, 0), Vector3(0, 0, x * 8.0))
	var govde := _parca(_kure(r, r * 1.6), renk, Vector3(0, -r * 0.85, 0))
	govde.scale = Vector3(1.15, 0.8, 0.7)


func _sepet(r: float, boy: float) -> void:
	# Saz sepet: kulp elde, sepet altta.
	var kulp := TorusMesh.new()
	kulp.inner_radius = r * 0.85
	kulp.outer_radius = r * 0.85 + 0.018
	_parca(kulp, SAZ.darkened(0.2), Vector3(0, -r * 0.9, 0), Vector3(PI / 2.0, 0, 0))
	_parca(_silindir(r, r * 0.8, boy), SAZ, Vector3(0, -r * 0.9 - boy * 0.5, 0))
	# Örgü halkaları.
	for k in 3:
		var h := TorusMesh.new()
		h.inner_radius = r * (0.97 - k * 0.07)
		h.outer_radius = h.inner_radius + 0.012
		_parca(h, SAZ.darkened(0.3), Vector3(0, -r * 0.9 - boy * (0.2 + k * 0.3), 0))


func _testi() -> void:
	# Kulplu toprak testi: kulp elde.
	_parca(_silindir(0.03, 0.03, 0.06), KIL.darkened(0.1), Vector3(0, -0.04, 0.04))
	_parca(_silindir(0.035, 0.05, 0.07), KIL, Vector3(0, -0.06, 0))
	_parca(_kure(0.12, 0.24), KIL, Vector3(0, -0.2, 0))


func _kabak() -> void:
	_parca(_silindir(0.008, 0.008, 0.1), DERI, Vector3(0, -0.04, 0))
	_parca(_kure(0.05, 0.1), Color("#B59A5A"), Vector3(0, -0.12, 0))
	_parca(_kure(0.08, 0.15), Color("#B59A5A"), Vector3(0, -0.24, 0))


func _kova() -> void:
	# Deri su kovası: sap elde.
	var sap := TorusMesh.new()
	sap.inner_radius = 0.1
	sap.outer_radius = 0.115
	_parca(sap, DERI.darkened(0.2), Vector3(0, -0.1, 0), Vector3(PI / 2.0, 0, 0))
	_parca(_silindir(0.12, 0.1, 0.22), DERI, Vector3(0, -0.22, 0))


func _sandik() -> void:
	_parca(_kutu(Vector3(0.06, 0.03, 0.04)), DEMIR, Vector3(0, -0.01, 0))
	_parca(_kutu(Vector3(0.34, 0.22, 0.2)), KOYU_AHSAP, Vector3(0, -0.14, 0))


func _kile() -> void:
	# Tahta ölçek (kile): kenarından tutulur.
	_parca(_silindir(0.11, 0.1, 0.13), ACIK_AHSAP, Vector3(0.08, -0.06, 0))


func _kalbur() -> void:
	# Kalbur kasnağı: kenarından tutulur, dik durur.
	var k := TorusMesh.new()
	k.inner_radius = 0.2
	k.outer_radius = 0.23
	_parca(k, ACIK_AHSAP, Vector3(0, -0.22, 0), Vector3(0, 0, PI / 2.0))


func _odun() -> void:
	# İple bağlı çubuk / kütük demeti: bağdan tutulur.
	for i in 5:
		var x := (i - 2) * 0.035
		_parca(_silindir(0.02, 0.02, 0.6), ACIK_AHSAP.darkened(0.1 * (i % 2)), Vector3(x, -0.18, (i % 2) * 0.03))
	_parca(_silindir(0.1, 0.1, 0.03), DERI, Vector3(0, -0.02, 0.015))


func _asa(boy: float, tutma: float, renk: Color, kivrik := false) -> void:
	# Dik asa / değnek: avuç asanın `tutma` yüksekliğinde, alt ucu yere yakın.
	dik = true
	_sapta_kayabilir = true
	_parca(_silindir(0.016, 0.02, boy), renk, Vector3(0, boy * 0.5 - tutma, 0))
	if kivrik:
		var k := TorusMesh.new()
		k.inner_radius = 0.05
		k.outer_radius = 0.07
		_parca(k, renk, Vector3(0.05, boy - tutma, 0), Vector3(PI / 2.0, 0, 0))


func _capa() -> void:
	dik = true
	_parca(_silindir(0.015, 0.018, 1.1), ACIK_AHSAP, Vector3(0, -0.15, 0))
	_parca(_kutu(Vector3(0.14, 0.02, 0.12)), DEMIR, Vector3(0, -0.7, 0.05), Vector3(0.4, 0, 0))


func _kazma() -> void:
	_parca(_silindir(0.014, 0.016, 0.55), ACIK_AHSAP, Vector3(0, -0.2, 0))
	_parca(_kutu(Vector3(0.32, 0.03, 0.03)), DEMIR, Vector3(0, -0.47, 0))


func _kamci() -> void:
	_parca(_silindir(0.012, 0.012, 0.28), DERI, Vector3(0, -0.1, 0))
	_parca(_silindir(0.005, 0.003, 0.5), DERI.darkened(0.3), Vector3(0.02, -0.48, 0.02), Vector3(0, 0, 0.12))


func _cubuk() -> void:
	# Kertikli tahta çubuk (ölçek, yoklama çubuğu).
	_parca(_kutu(Vector3(0.025, 0.42, 0.012)), ACIK_AHSAP, Vector3(0, -0.15, 0))


func _cekic() -> void:
	_parca(_silindir(0.012, 0.012, 0.3), ACIK_AHSAP, Vector3(0, -0.1, 0))
	_parca(_kutu(Vector3(0.1, 0.04, 0.04)), DEMIR, Vector3(0, -0.26, 0))


func _kilic_bez() -> void:
	# Beze sarılı eğri kılıç: kabzadan tutulur, ucu aşağıda.
	_parca(_silindir(0.016, 0.016, 0.12), DERI, Vector3(0, 0.02, 0))
	_parca(_kutu(Vector3(0.05, 0.75, 0.035)), YUN.darkened(0.15), Vector3(0, -0.42, 0), Vector3(0, 0, 0.05))

# --- SAH-09..SAH-16: Esya soket ve kesisim denetimleri ---

## SAH-09: Esya gogus veya uyluk kemikleriyle kesismez.
static func kesisiyor_mu(esya_pos: Vector3, kemik_pos: Vector3, min_aralik: float = 0.08) -> bool:
	return esya_pos.distance_to(kemik_pos) < min_aralik


## SAH-10: Yururken esya ele gore 2 santimden fazla gecikmez.
static func gecikme_uygun_mu(gecikme_m: float) -> bool:
	return gecikme_m <= 0.02


## SAH-11: Egilince asili esya zeminin altina inmez, asa dik kalir.
static func zemin_altina_inmez(esya_alt_y: float, zemin_y: float = 0.0) -> float:
	return maxf(esya_alt_y, zemin_y)


## SAH-12: Iki elde iki esya omurgayi ve birbirini delmez.
static func cift_soket_kesisimi_var_mi(sol_pos: Vector3, sag_pos: Vector3, govde_pos: Vector3, min_aralik: float = 0.08) -> bool:
	if sol_pos.distance_to(sag_pos) < min_aralik:
		return true
	if sol_pos.distance_to(govde_pos) < min_aralik or sag_pos.distance_to(govde_pos) < min_aralik:
		return true
	return false


## SAH-13: Konuşma klibi eşyayı düşürmez; el kemiği ve iskelet bağlantısı geçerlidir.
func soket_dolu_mu() -> bool:
	if get_parent() == null:
		return false
	if _iskelet != null:
		return is_instance_valid(_iskelet) and _el >= 0
	return true


## SAH-14: data/el_esyalari.json uzerinden soket tanimi alir.
static func soket_tanimi(karakter_id: String) -> Array:
	var yol := "res://data/el_esyalari.json"
	if not FileAccess.file_exists(yol):
		return []
	var metin := FileAccess.get_file_as_string(yol)
	var veri: Variant = JSON.parse_string(metin)
	if veri is Dictionary and veri.has(karakter_id):
		return veri[karakter_id]
	return []


## SAH-15: Cocuk modelinde buyuk yuk oraninda kuculur.
static func cocuk_olcekle(model_olcegi: float) -> float:
	return clampf(model_olcegi, 0.4, 1.0)

