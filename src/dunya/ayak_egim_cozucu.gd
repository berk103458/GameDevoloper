## SAH-02: Mevcut animasyon pozunda iki bacağın eğime ayrı uyumu.
extends SkeletonModifier3D

const EGIM_FARKI := 0.004
const SALINIM_PAYI := 0.035
const AZAMI_GOVDE_INISI := 0.08
const SAYISAL_PAY := 0.00001
const AZAMI_TABAN_EGIMI := 0.55

var model: Node3D
var gorsel: Node3D
var taban_konum: Vector3
var zemin: Callable
var ofset_ayarla: Callable
var topuklar: PackedInt32Array
var topuk_tabanlari: PackedVector3Array
var parmaklar: PackedInt32Array
var parmak_tabanlari: PackedVector3Array


func _process_modification() -> void:
	var iskelet := get_skeleton()
	var sol := _topuk(iskelet, 0)
	var sag := _topuk(iskelet, 1)
	var sol_zemin := float(zemin.call(sol))
	var sag_zemin := float(zemin.call(sag))
	if absf(sol_zemin - sag_zemin) < EGIM_FARKI:
		ofset_ayarla.call(0.0, false)
		return
	var gorsel_y := (model.global_basis * (gorsel.position - taban_konum)).y
	var kok_y := model.global_position.y
	var sol_aciklik := sol.y - gorsel_y - kok_y
	var sag_aciklik := sag.y - gorsel_y - kok_y
	# Aşağıdaki temas için tam açılmış bacağı uzatma. Gerektiğinde yalnız görsel gövdeyi indir.
	var yeni_ofset := 0.0
	if sol_aciklik <= SALINIM_PAYI:
		yeni_ofset = minf(yeni_ofset, sol_zemin - sol.y + gorsel_y)
	if sag_aciklik <= SALINIM_PAYI:
		yeni_ofset = minf(yeni_ofset, sag_zemin - sag.y + gorsel_y)
	yeni_ofset = maxf(-AZAMI_GOVDE_INISI, yeni_ofset)
	ofset_ayarla.call(yeni_ofset, true)
	var degisim := yeni_ofset - gorsel_y
	sol.y += degisim
	sag.y += degisim
	_ayagi_hizala(iskelet, 0, sol, sol_zemin, sol_aciklik)
	_ayagi_hizala(iskelet, 1, sag, sag_zemin, sag_aciklik)


func _topuk(iskelet: Skeleton3D, i: int) -> Vector3:
	return iskelet.global_transform * (iskelet.get_bone_global_pose(topuklar[i]) * topuk_tabanlari[i])


func _taban_yonu(iskelet: Skeleton3D, i: int, topuk: Vector3, zemin_y: float, ayak: Basis) -> Basis:
	if parmaklar[i] < 0:
		return ayak
	var parmak := iskelet.global_transform * (iskelet.get_bone_global_pose(parmaklar[i]) * parmak_tabanlari[i])
	var onceki := parmak - topuk
	var yatay := Vector3(onceki.x, 0.0, onceki.z)
	if yatay.length_squared() <= SAYISAL_PAY * SAYISAL_PAY:
		return ayak
	var istenen := yatay + Vector3.UP * (float(zemin.call(parmak)) - zemin_y)
	var ters := iskelet.global_basis.inverse()
	var donus := Quaternion((ters * onceki).normalized(), (ters * istenen).normalized())
	var aci := donus.get_angle()
	if aci > AZAMI_TABAN_EGIMI:
		donus = Quaternion.IDENTITY.slerp(donus, AZAMI_TABAN_EGIMI / aci)
	return Basis(donus) * ayak


func _ayagi_hizala(iskelet: Skeleton3D, i: int, topuk: Vector3, zemin_y: float, ham_aciklik: float) -> void:
	# Yukarı kalkan ayağı yere çekme. Zemine giren ayağın korunması sürer.
	if topuk.y > zemin_y and ham_aciklik > SALINIM_PAYI:
		return
	var ayak_id := topuklar[i]
	var diz_id := iskelet.get_bone_parent(ayak_id)
	var kalca_id := iskelet.get_bone_parent(diz_id) if diz_id >= 0 else -1
	if kalca_id < 0:
		return
	var kalca := iskelet.get_bone_global_pose(kalca_id)
	var diz := iskelet.get_bone_global_pose(diz_id)
	var ayak := iskelet.get_bone_global_pose(ayak_id)
	var uyluk := diz.origin - kalca.origin
	var baldir := ayak.origin - diz.origin
	var a := uyluk.length()
	var b := baldir.length()
	ayak.basis = _taban_yonu(iskelet, i, topuk, zemin_y, ayak.basis)
	var hedef := iskelet.to_local(Vector3(topuk.x, zemin_y, topuk.z)) - ayak.basis * topuk_tabanlari[i]
	var vektor := hedef - kalca.origin
	if minf(a, b) <= SAYISAL_PAY or vektor.length_squared() <= SAYISAL_PAY * SAYISAL_PAY:
		return
	var yon := vektor.normalized()
	var mesafe := clampf(vektor.length(), absf(a - b) + SAYISAL_PAY, a + b - SAYISAL_PAY)
	var bukum := uyluk.slide(yon)
	if bukum.length_squared() <= SAYISAL_PAY * SAYISAL_PAY:
		var ileri := iskelet.global_basis.inverse() * model.global_basis.z
		bukum = ileri.slide(yon)
	if bukum.length_squared() <= SAYISAL_PAY * SAYISAL_PAY:
		return
	# Diz, mevcut bükülme düzleminde uyluk ve baldır uzunluklarını korur.
	var ileri_mesafe := (a * a - b * b + mesafe * mesafe) / (2.0 * mesafe)
	var yan_mesafe := sqrt(maxf(0.0, a * a - ileri_mesafe * ileri_mesafe))
	var diz_yeri := kalca.origin + yon * ileri_mesafe + bukum.normalized() * yan_mesafe
	var ayak_yeri := kalca.origin + yon * mesafe
	var kalca_donus := Quaternion(uyluk.normalized(), (diz_yeri - kalca.origin).normalized())
	kalca.basis = Basis(kalca_donus) * kalca.basis
	iskelet.set_bone_global_pose(kalca_id, kalca)
	var yeni_diz := iskelet.get_bone_global_pose(diz_id)
	var yeni_ayak := iskelet.get_bone_global_pose(ayak_id)
	var diz_donus := Quaternion((yeni_ayak.origin - yeni_diz.origin).normalized(), (ayak_yeri - yeni_diz.origin).normalized())
	yeni_diz.basis = Basis(diz_donus) * yeni_diz.basis
	iskelet.set_bone_global_pose(diz_id, yeni_diz)
	# Bacağın dönüşünden sonra, tabanın zemine hizalanmış yönünü uygula.
	ayak.origin = iskelet.get_bone_global_pose(ayak_id).origin
	iskelet.set_bone_global_pose(ayak_id, ayak)
