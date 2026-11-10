## ANI-09 üşümesini mevcut klibin omuz kuşağına ekler.
class_name KoyHavaKatmani
extends SkeletonModifier3D

const DUGUM_ADI := &"KoyHavaKatmani"

var _govde := -1
var _egim := 0.0


static func uygula(figur: KarakterModel, egim: float) -> void:
	var katman := figur.find_child(String(DUGUM_ADI), true, false) as KoyHavaKatmani
	if katman != null:
		katman._egim = egim
		katman.active = not is_zero_approx(egim)
		return
	if is_zero_approx(egim):
		return
	var iskeletler := figur.find_children("*", "Skeleton3D", true, false)
	if iskeletler.is_empty():
		return
	var iskelet := iskeletler[0] as Skeleton3D
	var govde := _omuz_koku(iskelet)
	if govde < 0:
		return
	katman = KoyHavaKatmani.new()
	katman.name = DUGUM_ADI
	katman._govde = govde
	katman._egim = egim
	iskelet.add_child(katman)


static func _omuz_koku(iskelet: Skeleton3D) -> int:
	var sol := iskelet.find_bone("LeftShoulder")
	var sag := iskelet.find_bone("RightShoulder")
	if sol >= 0 and sag >= 0:
		var ust := iskelet.get_bone_parent(sol)
		if ust >= 0 and ust == iskelet.get_bone_parent(sag) and iskelet.get_bone_name(ust).to_lower().begins_with("spine"):
			return ust
	return iskelet.find_bone("Spine01")


func _process_modification_with_delta(_delta: float) -> void:
	var iskelet := get_skeleton()
	var ust := iskelet.get_bone_parent(_govde)
	var eksen := Vector3.RIGHT
	if ust >= 0:
		eksen = iskelet.get_bone_global_pose(ust).basis.orthonormalized().inverse() * eksen
	var donus := Quaternion(eksen.normalized(), _egim)
	iskelet.set_bone_pose_rotation(_govde, (donus * iskelet.get_bone_pose_rotation(_govde)).normalized())
