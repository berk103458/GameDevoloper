## CIL-08: İskeletli GLB varlıklarında (k05, k13, k09, k12, styloo/kopek) döngülü klip seçimi ve root motion kırpması.
class_name AnimasyonluVarlik
extends RefCounted

const DURUM_ADAYLARI := {
	&"kos": ["running", "runfast", "run", "walking", "walksent", "walk", "baselayer"],
	&"yuru": ["walking", "walksent", "walk", "baselayer", "running"],
	&"saldir": ["attack1", "attack", "indoor_swing"],
	&"dur": ["idle", "iddle", "checkout_gesture", "agree_gesture", "baselayer", "walking", "walk"],
}


## Düğüm altındaki tüm AnimationPlayer'ları LOOP_LINEAR ile kurar, root XZ kaymasını kırpar ve rastgele fazda başlatır.
static func kur(dugum: Node3D, durum: StringName = &"dur", rastgele_faz: bool = true) -> void:
	if dugum == null:
		return
	var oynaticilar := dugum.find_children("*", "AnimationPlayer", true, false)
	if oynaticilar.is_empty():
		return
	dugum.set_meta(&"animasyonlu_varlik", true)
	for ap_v in oynaticilar:
		var ap := ap_v as AnimationPlayer
		if ap == null:
			continue
		for ad in ap.get_animation_list():
			var anim := ap.get_animation(ad)
			if anim == null:
				continue
			anim.loop_mode = Animation.LOOP_LINEAR
			_root_motion_kirp(anim)
		var klip := _klip_sec(ap, durum)
		if klip != &"":
			ap.speed_scale = _durum_hizi(klip, durum)
			ap.play(klip, 0.15)
			if rastgele_faz:
				var a := ap.get_animation(klip)
				if a != null and a.length > 0.05:
					ap.seek(randf_range(0.0, a.length), true)


## Hız veya davranış durumuna göre (`dur`, `yuru`, `kos`, `saldir`) en uygun klibi seçer.
static func durum_ayarla(dugum: Node3D, durum: StringName, hiz: float = 0.0) -> void:
	if dugum == null:
		return
	var hedef_durum := durum
	if hiz > 2.6:
		hedef_durum = &"kos"
	elif hiz > 0.15 and durum == &"dur":
		hedef_durum = &"yuru"
	for ap_v in dugum.find_children("*", "AnimationPlayer", true, false):
		var ap := ap_v as AnimationPlayer
		if ap == null:
			continue
		var klip := _klip_sec(ap, hedef_durum)
		if klip == &"":
			continue
		var hedef_hiz := _durum_hizi(klip, hedef_durum)
		if ap.current_animation != klip or not ap.is_playing():
			ap.play(klip, 0.20)
		ap.speed_scale = hedef_hiz


## Düğümde en az bir AnimationPlayer aktif oynatıyor mu.
static func calisiyor_mu(dugum: Node3D) -> bool:
	if dugum == null:
		return false
	for ap_v in dugum.find_children("*", "AnimationPlayer", true, false):
		var ap := ap_v as AnimationPlayer
		if ap != null and ap.is_playing():
			return true
	return false


static func _klip_sec(ap: AnimationPlayer, durum: StringName) -> StringName:
	var liste := ap.get_animation_list()
	if liste.is_empty():
		return &""
	var adaylar: Array = DURUM_ADAYLARI.get(durum, DURUM_ADAYLARI[&"dur"])
	for kalip_v in adaylar:
		var kalip := String(kalip_v)
		for ad in liste:
			if kalip in String(ad).to_lower():
				return ad
	return liste[0]


static func _durum_hizi(klip: StringName, durum: StringName) -> float:
	var k := String(klip).to_lower()
	if durum == &"dur" and ("walking" in k or "walk" in k or "baselayer" in k):
		# Yalnız yürüme/döngü klibi olan modellerde (ör. k12, k05, k13) beklemede yavaş canlı döngü.
		return 0.45 if "baselayer" in k else 0.18
	return 1.0


static func _root_motion_kirp(anim: Animation) -> void:
	for i in anim.get_track_count():
		var tur := anim.track_get_type(i)
		var sub := String(anim.track_get_path(i).get_concatenated_subnames()).to_lower()
		var yol_metni := String(anim.track_get_path(i)).to_lower()
		if tur == Animation.TYPE_POSITION_3D:
			if sub in ["hips", "pelvis", "root", "armature"] or ("armature" in yol_metni and sub.is_empty()):
				var k_say := anim.track_get_key_count(i)
				if k_say <= 1:
					continue
				var bas_p: Vector3 = anim.track_get_key_value(i, 0)
				for k in k_say:
					var p: Vector3 = anim.track_get_key_value(i, k)
					anim.track_set_key_value(i, k, Vector3(bas_p.x, p.y, bas_p.z))
		elif tur == Animation.TYPE_SCALE_3D:
			# Armature scale izlerinin normalize edilmiş dış kapsayıcı ölçeğini bozmamasını garanti et.
			if sub in ["root", "armature"] or ("armature" in yol_metni and sub.is_empty()):
				var k_say := anim.track_get_key_count(i)
				if k_say > 1:
					var bas_s: Vector3 = anim.track_get_key_value(i, 0)
					for k in k_say:
						anim.track_set_key_value(i, k, bas_s)
