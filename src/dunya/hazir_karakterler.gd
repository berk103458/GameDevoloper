class_name HazirKarakterler
extends RefCounted

const MODEL_ADLARI := ["chr_006", "lowpo_cocuk", "lowpo_demirci"]
const ISIMLER := {"spine":"Hips", "spine_001":"Spine", "spine_002":"Spine01", "spine_003":"Spine02", "spine_004":"neck", "spine_005":"Head", "spine_006":"head_end", "shoulder_L":"LeftShoulder", "upper_arm_L":"LeftArm", "forearm_L":"LeftForeArm", "hand_L":"LeftHand", "shoulder_R":"RightShoulder", "upper_arm_R":"RightArm", "forearm_R":"RightForeArm", "hand_R":"RightHand", "thigh_L":"LeftUpLeg", "shin_L":"LeftLeg", "foot_L":"LeftFoot", "toe_L":"LeftToeBase", "thigh_R":"RightUpLeg", "shin_R":"RightLeg", "foot_R":"RightFoot", "toe_R":"RightToeBase"}
static var _kitaplar: Dictionary = {}

static func koy_adi(k: Koylu, eski: String) -> String:
	if k.yas_grubu == &"cocuk":
		if k.adli_id == &"chr_006":
			return "chr_006"
		return "cocuk" if Dunya3B.model_var_mi("cocuk_yuru", "karakter") else "lowpo_cocuk"
	if k.yas_grubu == &"yasli" and k.adli_id == &"" and Dunya3B.model_var_mi("yasli_yuru", "karakter"):
		return "yasli"
	if k.adli_id == &"" and not k.egitim.is_empty() and not bool(k.egitim.get("tamamlandi", false)):
		var cirak_ad := "kiz_cirak" if k.portre == "farmer_02" else "erkek_cirak"
		if Dunya3B.model_var_mi(cirak_ad + "_yuru", "karakter"):
			return cirak_ad
	if k.adli_id == &"" and k.zanaat_turu == ZanaatTuru.Tur.DEMIRCI and k.portre != "farmer_02":
		return "lowpo_demirci"
	return eski

static func olustur(ad: String) -> KarakterModel:
	if ad not in MODEL_ADLARI:
		return null
	var tur := "demirci" if ad == "lowpo_demirci" else "cocuk"
	var boy := HazirKarakterModeli.YETISKIN_BOYU if tur == "demirci" else 1.15
	var model := HazirSahneModeli.al("res://assets/karakter/lowpo/" + tur + ".gltf", Vector3(3, boy, 3), true)
	if model == null:
		return null
	var sk: Skeleton3D = model.find_children("*", "Skeleton3D", true, false)[0]
	# Mevcut el/duruş API'si için adlar ve Skin bind adları birlikte değiştirilir.
	for i in sk.get_bone_count():
		var isim := sk.get_bone_name(i)
		if ISIMLER.has(isim):
			sk.set_bone_name(i, ISIMLER[isim])
	for mesh in model.find_children("*", "MeshInstance3D", true, false):
		if mesh.skin == null:
			continue
		mesh.skin = mesh.skin.duplicate()
		for i in mesh.skin.get_bind_count():
			var isim: String = mesh.skin.get_bind_name(i)
			if ISIMLER.has(isim):
				mesh.skin.set_bind_name(i, ISIMLER[isim])
	if not _kitaplar.has(tur):
		_kitaplar[tur] = HazirKarakterAnimasyonu.kitaplik(model, sk, boy)
	var kitap: AnimationLibrary = _kitaplar[tur]
	if not kitap.has_animation("yuru") or not kitap.has_animation("bekle"):
		model.free()
		return null
	var oynatici := AnimationPlayer.new()
	oynatici.name = "HazirAnimationPlayer"
	model.add_child(oynatici)
	oynatici.add_animation_library("", kitap)
	var k := HazirKarakterModeli.new()
	k.boy = boy
	k.set_meta("hazir_kaynak", tur)
	k.kur(model, "")
	return k

## Meslek/yaş görünümü değişirse yalnız aktörü aynı dönüşümde değiştirir; _durum/rota kaydı korunur.
static func gorunumu_yenile(h: KoyHalkHareketi, k: Koylu) -> void:
	if not h.modeller.has(k.id):
		return
	var temel_ad := Dunya3B.karakter_adi(k.adli_id, k.portre, k.sinif)
	var ad := koy_adi(k, temel_ad)
	var eski: KarakterModel = h.modeller[k.id]
	if String(eski.get_meta("model_adi", "")) == ad:
		return
	var yeni := Dunya3B.karakter(ad, temel_ad)
	yeni.transform = eski.transform
	yeni.set_meta("koylu_id", k.id)
	h.sahne._halk.add_child(yeni)
	h.modeller[k.id] = yeni
	eski.yurumeyi_durdur()
	eski.queue_free()
	KarakterBeklemeCesitliligi.uygula(yeni, k.id)
	preload("res://src/koy/gorsel/acilis_hane_gorunumu.gd").kur(yeni, k)
