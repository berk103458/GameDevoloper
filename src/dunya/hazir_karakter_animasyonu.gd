## UAL ana kaynak; yalnız eksik çekiç döngüsü KayKit. Rig/rest ile gerçek dönüşüm.
class_name HazirKarakterAnimasyonu
extends RefCounted

const REFERANS := "res://data/animasyon/ual_referans.json"
const UAL := {"pelvis":"Hips", "spine_01":"Spine", "spine_02":"Spine01", "spine_03":"Spine02", "neck_01":"neck", "Head":"Head", "clavicle_l":"LeftShoulder", "upperarm_l":"LeftArm", "lowerarm_l":"LeftForeArm", "hand_l":"LeftHand", "thigh_l":"LeftUpLeg", "calf_l":"LeftLeg", "foot_l":"LeftFoot", "ball_l":"LeftToeBase", "clavicle_r":"RightShoulder", "upperarm_r":"RightArm", "lowerarm_r":"RightForeArm", "hand_r":"RightHand", "thigh_r":"RightUpLeg", "calf_r":"RightLeg", "foot_r":"RightFoot", "ball_r":"RightToeBase"}
const KAYKIT := {"hips":"Hips", "spine":"Spine", "chest":"Spine02", "head":"Head", "upperarm.l":"LeftArm", "lowerarm.l":"LeftForeArm", "hand.l":"LeftHand", "upperarm.r":"RightArm", "lowerarm.r":"RightForeArm", "hand.r":"RightHand", "upperleg.l":"LeftUpLeg", "lowerleg.l":"LeftLeg", "foot.l":"LeftFoot", "toes.l":"LeftToeBase", "upperleg.r":"RightUpLeg", "lowerleg.r":"RightLeg", "foot.r":"RightFoot", "toes.r":"RightToeBase"}
const KLIPLER := {
	"bekle": ["A01", "quaternius/general.res", "Idle_Loop"],
	"yuru": ["A01", "quaternius/movement.res", "Walk_Loop"],
	"konus": ["A01", "quaternius/general.res", "Idle_Talking_Loop"],
	"calis": ["A02", "quaternius/ual2_tarim.res", "Farm_Harvest"],
	"dov": ["A03", "kaykit/tools.res", "Hammering"],
}

static func donus(a: Array) -> Transform3D:
	return Transform3D(Basis(Vector3(a[0], a[1], a[2]), Vector3(a[3], a[4], a[5]), Vector3(a[6], a[7], a[8])), Vector3(a[9], a[10], a[11]))

static func kitaplik(model: Node3D, hedef: Skeleton3D, boy: float) -> AnimationLibrary:
	var veriler: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(REFERANS))
	var sonuc := AnimationLibrary.new()
	for ad in KLIPLER:
		var cfg: Array = KLIPLER[ad]
		var kutuphane := load("res://assets/animasyon/" + cfg[1]) as AnimationLibrary
		if kutuphane == null or not veriler.has(cfg[0]) or not kutuphane.has_animation(cfg[2]):
			continue
		var a := _uyarla(kutuphane.get_animation(cfg[2]), veriler[cfg[0]], KAYKIT if cfg[0] == "A03" else UAL, model, hedef, boy)
		if a != null:
			sonuc.add_animation(ad, a)
	return sonuc

static func _uyarla(anim: Animation, veri: Dictionary, harita: Dictionary, model: Node3D, hedef: Skeleton3D, boy: float) -> Animation:
	var kaynak := Skeleton3D.new()
	for b in veri.kemikler:
		kaynak.add_bone(b.ad)
	for i in veri.kemikler.size():
		kaynak.set_bone_parent(i, int(veri.kemikler[i].ebeveyn))
		kaynak.set_bone_rest(i, donus(veri.kemikler[i].rest))
	kaynak.reset_bone_poses()
	var ciftler := {}
	for ad in harita:
		var ki := kaynak.find_bone(ad)
		var hi := hedef.find_bone(harita[ad])
		if ki >= 0 and hi >= 0:
			ciftler[hi] = ki
	if ciftler.size() < 16:
		kaynak.free()
		return null
	var kaynak_kok := donus(veri.kok)
	var hedef_kok := Transform3D.IDENTITY
	var p: Node = hedef
	while p != model and p is Node3D:
		hedef_kok = (p as Node3D).transform * hedef_kok
		p = p.get_parent()
	var sonuc := Animation.new()
	sonuc.length = anim.length
	sonuc.loop_mode = Animation.LOOP_LINEAR
	var izler := {}
	for hi in ciftler:
		var iz := sonuc.add_track(Animation.TYPE_ROTATION_3D)
		sonuc.track_set_path(iz, NodePath(String(model.get_path_to(hedef)) + ":" + hedef.get_bone_name(hi)))
		izler[hi] = iz
	var hips := hedef.find_bone("Hips")
	var konum_izi := sonuc.add_track(Animation.TYPE_POSITION_3D)
	sonuc.track_set_path(konum_izi, NodePath(String(model.get_path_to(hedef)) + ":Hips"))
	var kaynak_hips := int(ciftler[hips])
	var adim := 1.0 / 30.0
	var adet := ceili(anim.length / adim)
	var iz_kemikleri := []
	for i in anim.get_track_count():
		iz_kemikleri.append(kaynak.find_bone(String(anim.track_get_path(i).get_concatenated_subnames())))
	for kare in range(adet + 1):
		var zaman := minf(kare * adim, anim.length)
		kaynak.reset_bone_poses()
		for i in anim.get_track_count():
			var ki: int = iz_kemikleri[i]
			if ki < 0:
				continue
			match anim.track_get_type(i):
				Animation.TYPE_ROTATION_3D:
					kaynak.set_bone_pose_rotation(ki, anim.rotation_track_interpolate(i, zaman))
				Animation.TYPE_POSITION_3D:
					kaynak.set_bone_pose_position(ki, anim.position_track_interpolate(i, zaman))
		kaynak.force_update_all_bone_transforms()
		var pozlar: Array[Quaternion] = []
		for hi in hedef.get_bone_count():
			var ebeveyn := hedef.get_bone_parent(hi)
			var ebeveyn_poz := pozlar[ebeveyn] if ebeveyn >= 0 else hedef_kok.basis.orthonormalized().get_rotation_quaternion()
			var yerel := hedef.get_bone_rest(hi).basis.orthonormalized().get_rotation_quaternion()
			if ciftler.has(hi):
				var ki: int = ciftler[hi]
				var dinlenme := (kaynak_kok * kaynak.get_bone_global_rest(ki)).basis.orthonormalized().get_rotation_quaternion()
				var hareket := (kaynak_kok * kaynak.get_bone_global_pose(ki)).basis.orthonormalized().get_rotation_quaternion()
				var hedef_rest := (hedef_kok * hedef.get_bone_global_rest(hi)).basis.orthonormalized().get_rotation_quaternion()
				var dunya := hareket * dinlenme.inverse() * hedef_rest
				yerel = (ebeveyn_poz.inverse() * dunya).normalized()
				sonuc.rotation_track_insert_key(izler[hi], zaman, yerel)
			pozlar.append(ebeveyn_poz * yerel)
		# Kaynak kök hareketi rota tween'ini sürüklemez; yalnız sınırlı dikey nefes/adım.
		var fark := (kaynak_kok * kaynak.get_bone_global_pose(kaynak_hips)).origin.y - (kaynak_kok * kaynak.get_bone_global_rest(kaynak_hips)).origin.y
		var yukari := hedef_kok.basis.inverse() * Vector3(0, clampf(fark * boy / 1.8, -0.12, 0.12), 0)
		sonuc.position_track_insert_key(konum_izi, zaman, hedef.get_bone_rest(hips).origin + yukari)
	kaynak.free()
	sonuc.set_meta("kaynak_klip", anim.resource_name)
	return sonuc
