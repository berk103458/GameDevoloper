## HAE-03: hazır görseller; hayvan/üretim sayısı ve aktör davranışı değiştirilmez.
class_name HazirEsyaHayvan
extends RefCounted

const MODELLER := {
	"ors": ["kaykit_alet/anvil.gltf", Vector3(1.0, 0.8, 0.6)],
	"cekic": ["kaykit_alet/hammer.gltf", Vector3(0.2, 0.35, 0.15)],
	"balta": ["kaykit_alet/axe.gltf", Vector3(0.25, 0.6, 0.15)],
	"kazma": ["kaykit_alet/pickaxe.gltf", Vector3(0.6, 0.8, 0.15)],
	"masa": ["kaykit_mobilya/table_medium.gltf", Vector3(2.0, 0.9, 1.2)],
	"yatak": ["kaykit_mobilya/bed_single_A.gltf", Vector3(1.7, 0.6, 2.6)],
	"odun": ["kaykit_kaynak/Wood_Log_A.gltf", Vector3(0.2, 0.2, 0.7)],
	"demir_cubuk": ["kaykit_kaynak/Iron_Bar.gltf", Vector3(0.2, 0.12, 0.4)],
}

static func esya(ad: String, boy: Vector3 = Vector3.ZERO) -> Node3D:
	if not MODELLER.has(ad):
		return null
	var veri: Array = MODELLER[ad]
	var hedef: Vector3 = veri[1] if boy == Vector3.ZERO else boy
	var meshy_ad := "el_cekic" if ad == "cekic" else ad
	if ad in ["masa", "yatak", "ors", "balta", "cekic"] and Dunya3B.model_var_mi(meshy_ad):
		var m := HazirSahneModeli.al("res://assets/model/nesne/" + meshy_ad + ".glb", hedef)
		if m != null:
			m.name = "hazir_" + ad
			return m
	var n := HazirSahneModeli.al("res://assets/esya/" + veri[0], hedef)
	if n != null:
		n.name = "hazir_" + ad
	return n

static func hayvan(tur: String) -> Node3D:
	var yol := ""
	var boy := Vector3.ZERO
	match tur:
		"koyun":
			yol = "res://assets/hayvan/vertexcat/koyun.gltf"
			boy = Vector3(1.5, 0.8, 1.5)
		"inek":
			yol = "res://assets/model/hayvan/inek.glb" if Dunya3B.model_var_mi("inek", "hayvan") else "res://assets/hayvan/vertexcat/inek.gltf"
			boy = Vector3(2.2, 1.45, 2.2)
		"kopek":
			yol = "res://assets/model/hayvan/kopek.glb" if Dunya3B.model_var_mi("kopek", "hayvan") else "res://assets/hayvan/styloo/kopek.glb"
			boy = Vector3(1.6, 0.8, 1.6)
		"koc":
			if not Dunya3B.model_var_mi("koc", "hayvan"):
				return null
			yol = "res://assets/model/hayvan/koc.glb"
			boy = Vector3(1.55, 0.9, 1.55)
		"beygir":
			if not Dunya3B.model_var_mi("beygir", "hayvan"):
				return null
			yol = "res://assets/model/hayvan/beygir.glb"
			boy = Vector3(2.3, 1.65, 2.3)
		"at":
			if not Dunya3B.model_var_mi("at", "hayvan"):
				return null
			yol = "res://assets/model/hayvan/at.glb"
			boy = Vector3(2.3, 1.65, 2.3)
		"keci":
			if not Dunya3B.model_var_mi("keci", "hayvan"):
				return null
			yol = "res://assets/model/hayvan/keci.glb"
			boy = Vector3(1.4, 0.85, 1.4)
		"deve":
			if not Dunya3B.model_var_mi("deve", "hayvan"):
				return null
			yol = "res://assets/model/hayvan/deve.glb"
			boy = Vector3(2.6, 2.1, 2.6)
		"okuz":
			if not Dunya3B.model_var_mi("okuz"):
				return null
			yol = "res://assets/model/nesne/okuz.glb"
			boy = Vector3(2.3, 1.55, 2.3)
		"kurt":
			if not Dunya3B.model_var_mi("kurt", "hayvan"):
				return null
			yol = "res://assets/model/hayvan/kurt.glb"
			boy = Vector3(1.4, 0.75, 1.4)
		_:
			return null
	var n := HazirSahneModeli.al(yol, boy, true)
	if n != null:
		n.name = "hazir_" + tur
	return n

static func bina(n: Node3D, tur: String, en: float, derin: float) -> void:
	if tur in ["demirhane", "atolye"]:
		for ad in ["cekic", "demir_cubuk"]:
			var e := esya(ad)
			if e != null:
				e.position = Vector3(-en * 0.32, 0.0, derin * 0.35 + (0.3 if ad == "cekic" else 0.0))
				n.add_child(e)
		if tur == "atolye" and Dunya3B.model_var_mi("dokuma_tezgahi"):
			var dt := Dunya3B.nesne("dokuma_tezgahi", 1.55)
			dt.position = Vector3(en * 0.28, 0.0, derin * 0.28)
			n.add_child(dt)
	if tur in ["hizarhane", "odunluk"]:
		for i in 2:
			var e := esya("odun")
			if e != null:
				e.position = Vector3(i * 0.3, 0, derin * 0.35)
				n.add_child(e)
	if tur == "sifahane" and Dunya3B.model_var_mi("hasta_cadiri"):
		var hc := Dunya3B.nesne("hasta_cadiri", 1.8)
		hc.position = Vector3(en * 0.35, 0.0, derin * 0.3)
		n.add_child(hc)
	if tur == "han" and Dunya3B.model_var_mi("kervan_yuku"):
		var ky := Dunya3B.nesne("kervan_yuku", 0.95)
		ky.position = Vector3(-en * 0.35, 0.0, derin * 0.35)
		n.add_child(ky)

static func kopek_kur(kok: Node3D, yer: Vector3) -> void:
	var n := hayvan("kopek")
	if n == null:
		return
	n.position = yer
	kok.add_child(n)
	for p in n.find_children("*", "AnimationPlayer", true, false):
		for ad in p.get_animation_list():
			if "idle" in String(ad).to_lower():
				p.get_animation(ad).loop_mode = Animation.LOOP_LINEAR
				p.play(ad)
				return
