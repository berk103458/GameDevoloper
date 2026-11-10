## El soketinin konumunu değiştirmeden eşya parçalarını göğüs ve uyluk kemiklerinden ayırır.
extends RefCounted

const KEMIKLER := ["Spine", "Spine01", "Spine02", "LeftLeg", "RightLeg"]
const ACILAR := [0.18, -0.18, 0.35, -0.35, 0.55, -0.55, 0.8, -0.8, 1.05, -1.05, 1.35, -1.35]
const ASILI_EKSENLER := [Vector3.BACK, Vector3.RIGHT, Vector3.UP]
const DIK_EKSENLER := [Vector3.UP]

var _iskelet: Skeleton3D
var _kemikler := PackedInt32Array()
var _kesitler := PackedVector3Array()
var _kutular: Array[AABB] = []
var _parca_tersleri: Array[Transform3D] = []


func _init(esya: Node3D, iskelet: Skeleton3D) -> void:
	_iskelet = iskelet
	for ad in KEMIKLER:
		var id := iskelet.find_bone(ad)
		if id >= 0 and iskelet.get_bone_parent(id) >= 0:
			_kemikler.append(id)
			_kemikler.append(iskelet.get_bone_parent(id))
	_kesitler.resize(_kemikler.size())
	for dugum in esya.find_children("*", "MeshInstance3D", true, false):
		var parca := dugum as MeshInstance3D
		_kutular.append(parca.get_aabb())
		var yerel := parca.transform
		var ata := parca.get_parent()
		while ata != esya:
			if ata is Node3D:
				yerel = ata.transform * yerel
			ata = ata.get_parent()
		_parca_tersleri.append(yerel.affine_inverse())


func yon(avuc: Vector3, tercih: Basis, dik: bool) -> Basis:
	if _kemikler.is_empty() or _kutular.is_empty():
		return tercih
	var iskelet_dunya := _iskelet.global_transform
	for i in _kemikler.size():
		_kesitler[i] = iskelet_dunya * _iskelet.get_bone_global_pose(_kemikler[i]).origin - avuc
	if not _kesisir(tercih):
		return tercih
	for aci in ACILAR:
		for eksen in (DIK_EKSENLER if dik else ASILI_EKSENLER):
			var aday := tercih * Basis(eksen, aci)
			if not _kesisir(aday):
				return aday
	return tercih


func _kesisir(yonelim: Basis) -> bool:
	var ters := yonelim.inverse()
	for p in _kutular.size():
		var parcaya := _parca_tersleri[p]
		var kutu := _kutular[p]
		for i in range(0, _kesitler.size(), 2):
			var bas := parcaya * (ters * _kesitler[i])
			var son := parcaya * (ters * _kesitler[i + 1])
			if kutu.intersects_segment(bas, son) != null:
				return true
	return false
