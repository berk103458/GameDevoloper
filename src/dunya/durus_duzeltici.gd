## Meshy iskeletleri için duruş düzeltici (SkeletonModifier3D): animasyondan sonra her karede çalışır.
## 1) Kolları gövdeye indirir, 2) bileği dinlenme duruşundaki düz hâline getirir, 3) eli önkol ekseni
## etrafında döndürüp avucu bacağa çevirir (Meshy yürüyüşünde avuç öne dönük, bilek dışa kırık).
## Kemik eksenleri modelden modele farklı olduğu için düzeltme eksene değil, kemik konumlarından
## ölçülen yönlere göre yapılır. `bekleme` 0 (yürüyüş) ile 1 (durma) arasında; durmada nefes, ağırlık
## aktarma ve baş hareketi de eklenir.
class_name DurusDuzeltici
extends SkeletonModifier3D

## 0 = yürüyüş (hafif düzeltme), 1 = durma (tam duruş + nefes).
var bekleme: float = 0.0
## Karakterler aynı anda nefes almasın.
var faz: float = 0.0

## Kol hedef yönü (iskelet uzayı; x yana, z öne). Durmada kollar gövdenin yanında hafif önde.
@export var kol_yana := 0.13
@export var kol_one := 0.04
@export var onkol_one := 0.14
## Elin önkola göre dönüşünün önkola düşen payı (bilekte burulmayı önler).
@export var onkol_payi := 0.4
## Parmakların öne eğimi (0 = tam aşağı).
@export var parmak_one := 0.06
## Yürüyüşte kolların hedefe ne kadar çekileceği (salınım korunur).
@export var yuru_kol := 0.6
@export var yuru_onkol := 0.5

## Anlık duygu hareketi: &"sevinc" (eller göğüste, baş eğilir) ya da &"ofke" (yumruk sallanır, baş sallanır).
var duygu: StringName = &""
## Sürekli hareket (döngü): &"calis" — eğilip orak sallar (tarlada çiftçi). Boş = yok.
var surekli: StringName = &""
## Duygu hareketinin süresi (s).
@export var duygu_suresi := 1.6
var _duygu_t := 0.0

var _k := {}
var _zaman := 0.0
var _el_dinlenme := {}
## Elin kendi kemik uzayında parmak ve başparmak yönleri (mesh'ten ölçülür): {"LeftHand": [parmak, basparmak]}.
var _el_sekli := {}

## Aynı mesh için ölçüm bir kez yapılır.
static var _sekil_onbellek := {}


func _ready() -> void:
	var sk := get_skeleton()
	if sk == null:
		return
	for ad in ["Hips", "Spine01", "Spine", "neck", "Head", "LeftShoulder", "LeftArm", "LeftForeArm", "LeftHand",
			"RightShoulder", "RightArm", "RightForeArm", "RightHand"]:
		_k[ad] = sk.find_bone(ad)
	for ad in ["LeftHand", "RightHand"]:
		if _k[ad] >= 0:
			_el_dinlenme[ad] = sk.get_bone_rest(_k[ad]).basis.get_rotation_quaternion()
	_el_sekli = _el_seklini_olc(sk)


func _process_modification() -> void:
	var sk := get_skeleton()
	if sk == null or _k.is_empty() or _k["LeftHand"] < 0 or _k["RightHand"] < 0:
		return
	var dt := get_process_delta_time()
	_zaman += dt
	if duygu != &"":
		_duygu_t += dt
		if _duygu_t >= duygu_suresi and surekli == &"":
			duygu = &""
	elif surekli != &"":
		duygu = surekli
		_duygu_t = 0.0
	if bekleme > 0.0:
		_nefes(sk)
	if duygu != &"":
		_duygu_govde(sk)
	_kol(sk, "Left", 1.0)
	_kol(sk, "Right", -1.0)


func _kol(sk: Skeleton3D, yan_ad: String, yan: float) -> void:
	var omuz: int = _k[yan_ad + "Shoulder"]
	var kol: int = _k[yan_ad + "Arm"]
	var onkol: int = _k[yan_ad + "ForeArm"]
	var el: int = _k[yan_ad + "Hand"]
	var g_omuz := sk.get_bone_global_pose(omuz)
	var l_kol := sk.get_bone_pose(kol)
	var l_on := sk.get_bone_pose(onkol)
	# Bilek: elin önkola göre dönüşü dinlenme duruşundaki gibi (düz bilek).
	var l_el := Transform3D(Basis(_el_dinlenme[yan_ad + "Hand"]), sk.get_bone_pose_position(el))
	var w_kol := lerpf(yuru_kol, 1.0, bekleme)
	var w_on := lerpf(yuru_onkol, 1.0, bekleme)
	var zarf := _zarf()
	var d_kol := Vector3.ZERO
	var d_on := Vector3.ZERO
	if zarf > 0.0:
		var hedefler := _duygu_hedefleri(yan)
		d_kol = hedefler[0]
		d_on = hedefler[1]
		if d_kol != Vector3.ZERO:
			w_kol = lerpf(w_kol, 1.0, zarf)
			w_on = lerpf(w_on, 1.0, zarf)

	# 1) Üst kol: Arm→ForeArm yönü hedefe.
	var g_kol := g_omuz * l_kol
	var g_on := g_kol * l_on
	var hedef_kol := Vector3(yan * kol_yana, -1.0, kol_one).normalized()
	if d_kol != Vector3.ZERO:
		hedef_kol = hedef_kol.slerp(d_kol.normalized(), zarf)
	g_kol.basis = Basis(_yay((g_on.origin - g_kol.origin).normalized(), hedef_kol, w_kol)) * g_kol.basis
	l_kol.basis = g_omuz.basis.inverse() * g_kol.basis

	# 2) Önkol: ForeArm→Hand yönü hedefe (dirsek hafif bükük, el önde).
	g_on = g_kol * l_on
	var g_el := g_on * l_el
	var hedef_on := Vector3(yan * kol_yana, -1.0, onkol_one).normalized()
	if d_on != Vector3.ZERO:
		hedef_on = hedef_on.slerp(d_on.normalized(), zarf)
	var on_yon := (g_el.origin - g_on.origin).normalized()
	g_on.basis = Basis(_yay(on_yon, hedef_on, w_on)) * g_on.basis
	g_el = g_on * l_el
	on_yon = (g_el.origin - g_on.origin).normalized()

	# 3) El: parmaklar önkolun devamında (hafif önde), başparmak öne — doğal sarkan el.
	#    Gereken dönüşün önkol eksenindeki burgu payı kısmen önkola verilir.
	if _el_sekli.has(yan_ad + "Hand"):
		var sekil: Array = _el_sekli[yan_ad + "Hand"]
		var hedef_parmak := (on_yon + Vector3(0, 0, parmak_one)).normalized()
		var r := _cerceve_donusu(g_el.basis * sekil[0], g_el.basis * sekil[1], hedef_parmak, Vector3.BACK)
		var burgu := _burgu(r, on_yon)
		g_on.basis = Basis(Quaternion.IDENTITY.slerp(burgu, onkol_payi)) * g_on.basis
		g_el = g_on * l_el
		r = _cerceve_donusu(g_el.basis * sekil[0], g_el.basis * sekil[1], hedef_parmak, Vector3.BACK)
		g_el.basis = Basis(r) * g_el.basis
	l_on.basis = g_kol.basis.inverse() * g_on.basis
	l_el.basis = g_on.basis.inverse() * g_el.basis

	sk.set_bone_pose_rotation(kol, l_kol.basis.get_rotation_quaternion())
	sk.set_bone_pose_rotation(onkol, l_on.basis.get_rotation_quaternion())
	sk.set_bone_pose_rotation(el, l_el.basis.get_rotation_quaternion())


## Duygu hareketini başlatır.
func duygu_baslat(ad: StringName) -> void:
	duygu = ad
	_duygu_t = 0.0


## Duygu zarfı: hızlı giriş, tutuş, yumuşak çıkış (0..1).
func _zarf() -> float:
	if duygu == &"":
		return 0.0
	if surekli != &"" and duygu == surekli:
		return 1.0
	var t := _duygu_t / duygu_suresi
	return smoothstep(0.0, 0.18, t) * (1.0 - smoothstep(0.75, 1.0, t))


## Duyguya göre üst kol ve önkol hedef yönleri (iskelet uzayı); ZERO = bu kol değişmez.
func _duygu_hedefleri(yan: float) -> Array[Vector3]:
	match duygu:
		&"dov", &"pisir":
			return ZanaatTezgahi.kol(yan, _zaman + faz, duygu)
		&"isin":
			return AtesBasiRutini.kol(yan, _zaman + faz)
		&"sevinc":
			# Sağ el göğse (şükran); sol kol yanda kalır.
			if yan < 0.0:
				return [Vector3(-0.1, -0.8, 0.6), Vector3(0.8, 0.35, 0.45)]
			return [Vector3.ZERO, Vector3.ZERO]
		&"calis":
			# Eğilip orakla biçer: iki kol aşağı-öne, sağ kol yay çizerek sallanır.
			var salla := sin(_zaman * 2.6 + faz)
			if yan < 0.0:
				return [Vector3(-0.15 + salla * 0.35, -0.75, 0.6), Vector3(0.2 + salla * 0.5, -0.8, 0.55)]
			return [Vector3(0.2, -0.85, 0.5), Vector3(-0.1, -0.85, 0.45)]
		&"ofke":
			if yan < 0.0:
				# Sağ kol bekçiye uzanır ve sert sert sallanır.
				var salla := sin(_duygu_t * 16.0) * 0.3
				return [Vector3(-0.15, 0.05, 1.0), Vector3(-0.05, 0.4 + salla, 0.9)]
			return [Vector3.ZERO, Vector3.ZERO]
	return [Vector3.ZERO, Vector3.ZERO]


## Duygu: gövde ve baş (sevinçte eğilme ve baş sallama, öfkede baş iki yana ve öne yüklenme).
func _duygu_govde(sk: Skeleton3D) -> void:
	var z := _zarf()
	if z <= 0.0:
		return
	match duygu:
		&"sevinc":
			_dondur_global(sk, _k["Spine01"], Vector3.RIGHT, deg_to_rad(16.0) * z)
			_dondur_global(sk, _k["Head"], Vector3.RIGHT, deg_to_rad(12.0) * z * (0.5 + 0.5 * sin(_duygu_t * 9.0)))
		&"calis":
			_dondur_global(sk, _k["Spine01"], Vector3.RIGHT, deg_to_rad(38.0 + 6.0 * sin(_zaman * 2.6 + faz)))
			_dondur_global(sk, _k["Spine"], Vector3.RIGHT, deg_to_rad(12.0))
			_dondur_global(sk, _k["Head"], Vector3.RIGHT, deg_to_rad(10.0))
		&"ofke":
			_dondur_global(sk, _k["Spine01"], Vector3.RIGHT, deg_to_rad(8.0) * z)
			_dondur_global(sk, _k["Head"], Vector3.UP, deg_to_rad(16.0) * z * sin(_duygu_t * 12.0))


## Durma: nefes (gövde), yavaş ağırlık aktarma (kalça), ara sıra bakış (baş). Hepsi küçük açılar.
func _nefes(sk: Skeleton3D) -> void:
	var t := _zaman + faz
	var nefes := sin(t * TAU / 3.6) * deg_to_rad(1.6) * bekleme
	var agirlik := sin(t * TAU / 7.0) * deg_to_rad(1.8) * bekleme
	var bakis := (sin(t * 0.37) * 0.7 + sin(t * 0.13 + 1.0) * 0.3) * deg_to_rad(9.0) * bekleme
	_dondur_global(sk, _k["Spine01"], Vector3.RIGHT, -nefes)
	_dondur_global(sk, _k["Hips"], Vector3.BACK, agirlik)
	_dondur_global(sk, _k["Spine"], Vector3.BACK, -agirlik * 0.8)
	_dondur_global(sk, _k["Head"], Vector3.UP, bakis)


## Bir kemiği iskelet uzayındaki bir eksen etrafında döndürür (yerel eksenlerden bağımsız).
func _dondur_global(sk: Skeleton3D, kemik: int, eksen: Vector3, aci: float) -> void:
	if kemik < 0 or absf(aci) < 0.00001:
		return
	var ust := sk.get_bone_parent(kemik)
	var g_ust := sk.get_bone_global_pose(ust) if ust >= 0 else Transform3D.IDENTITY
	var g := g_ust * sk.get_bone_pose(kemik)
	g.basis = Basis(eksen, aci) * g.basis
	sk.set_bone_pose_rotation(kemik, (g_ust.basis.inverse() * g.basis).get_rotation_quaternion())


## `a` yönünü `b`ye çeviren en kısa dönüşün `w` kadarı.
func _yay(a: Vector3, b: Vector3, w: float) -> Quaternion:
	if a.is_zero_approx() or b.is_zero_approx() or a.dot(b) > 0.9999:
		return Quaternion.IDENTITY
	if a.dot(b) < -0.9999:
		return Quaternion.IDENTITY
	return Quaternion.IDENTITY.slerp(Quaternion(a, b), clampf(w, 0.0, 1.0))


## (p, t) çiftini (hedef_p, hedef_t) çiftine götüren dönüş (ikisi de Gram-Schmidt ile dikleştirilir).
func _cerceve_donusu(p: Vector3, t: Vector3, hedef_p: Vector3, hedef_t: Vector3) -> Quaternion:
	var c := _cerceve(p, t)
	var h := _cerceve(hedef_p, hedef_t)
	if c == Basis() and h == Basis():
		return Quaternion.IDENTITY
	return (h * c.transposed()).orthonormalized().get_rotation_quaternion()


func _cerceve(p: Vector3, t: Vector3) -> Basis:
	var x := p.normalized()
	var y := (t - x * t.dot(x)).normalized()
	return Basis(x, y, x.cross(y))


## Dönüşün `eksen` etrafındaki burgu bileşeni (swing-twist ayrıştırması).
func _burgu(q: Quaternion, eksen: Vector3) -> Quaternion:
	var v := Vector3(q.x, q.y, q.z)
	var p := eksen * v.dot(eksen)
	var b := Quaternion(p.x, p.y, p.z, q.w)
	if b.length_squared() < 0.000001:
		return Quaternion.IDENTITY
	return b.normalized()


## Her elin şeklini mesh'ten ölçer: el kemiğine bağlı köşelerin kemik uzayındaki ağırlık merkezi
## parmak yönünü, bileğe yakın köşelerin yana taşması başparmak yönünü verir.
## Avuç ortası (el kemiğinin uzayında, mesh'ten ölçülen); ölçülemediyse null.
func avuc(el_ad: String) -> Variant:
	return _el_sekli.get(el_ad + "_merkez")


func _el_seklini_olc(sk: Skeleton3D) -> Dictionary:
	var sonuc := {}
	var mi: MeshInstance3D = null
	for n in sk.find_children("*", "MeshInstance3D", true, false):
		if (n as MeshInstance3D).skin != null:
			mi = n
			break
	if mi == null:
		mi = _ilk_derili_mesh(sk.get_parent())
	if mi == null or mi.mesh == null:
		return sonuc
	var anahtar := mi.mesh.get_instance_id()
	if _sekil_onbellek.has(anahtar):
		return _sekil_onbellek[anahtar]
	var skin := mi.skin
	for ad in ["LeftHand", "RightHand"]:
		var kemik: int = _k[ad]
		var bind := -1
		for b in skin.get_bind_count():
			var bb := skin.get_bind_bone(b)
			if bb == kemik or (bb < 0 and String(skin.get_bind_name(b)) == ad):
				bind = b
				break
		if bind < 0:
			continue
		var bind_poz := skin.get_bind_pose(bind)
		var noktalar := PackedVector3Array()
		for yuzey in mi.mesh.get_surface_count():
			var d := mi.mesh.surface_get_arrays(yuzey)
			var konum: PackedVector3Array = d[Mesh.ARRAY_VERTEX]
			var kemikler = d[Mesh.ARRAY_BONES]
			var agirliklar = d[Mesh.ARRAY_WEIGHTS]
			if kemikler == null or agirliklar == null or konum.is_empty():
				continue
			var adim: int = kemikler.size() / konum.size()
			for v in konum.size():
				for j in adim:
					if int(kemikler[v * adim + j]) == bind and float(agirliklar[v * adim + j]) > 0.5:
						noktalar.append(bind_poz * konum[v])
						break
		if noktalar.size() < 12:
			continue
		var merkez := Vector3.ZERO
		for p in noktalar:
			merkez += p
		merkez /= noktalar.size()
		var parmak := merkez.normalized()
		# Parmağa dik düzlemde ana genişlik ekseni (2x2 kovaryans).
		var u := parmak.cross(Vector3.UP if absf(parmak.y) < 0.9 else Vector3.RIGHT).normalized()
		var w := parmak.cross(u).normalized()
		var suu := 0.0
		var sww := 0.0
		var suw := 0.0
		for p in noktalar:
			var q := p - merkez
			var a := q.dot(u)
			var b := q.dot(w)
			suu += a * a
			sww += b * b
			suw += a * b
		var aci := 0.5 * atan2(2.0 * suw, suu - sww)
		var genislik := (u * cos(aci) + w * sin(aci)).normalized()
		# Başparmak tarafı: bileğe yakın yarıdaki köşelerin genişlik ekseninde ortalaması.
		var uzunluk := merkez.length()
		var toplam := 0.0
		var sayi := 0
		for p in noktalar:
			if p.dot(parmak) < uzunluk:
				toplam += (p - merkez).dot(genislik)
				sayi += 1
		if sayi > 0 and toplam < 0.0:
			genislik = -genislik
		sonuc[ad] = [parmak, genislik]
		# Elin mesh ağırlık merkezi (kemik uzayında): avuç ortası; elde taşınan eşya buraya oturur.
		sonuc[ad + "_merkez"] = merkez
	_sekil_onbellek[anahtar] = sonuc
	return sonuc


func _ilk_derili_mesh(kok: Node) -> MeshInstance3D:
	if kok == null:
		return null
	for n in kok.find_children("*", "MeshInstance3D", true, false):
		if (n as MeshInstance3D).skin != null:
			return n
	return null
