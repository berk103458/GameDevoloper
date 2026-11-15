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
	if ad in ["masa", "yatak", "ors"] and Dunya3B.model_var_mi(ad):
		var m := HazirSahneModeli.al("res://assets/model/nesne/" + ad + ".glb", hedef)
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
			yol = "res://assets/hayvan/vertexcat/inek.gltf"
			boy = Vector3(2.2, 1.45, 2.2)
		"kopek":
			yol = "res://assets/hayvan/styloo/kopek.glb"
			boy = Vector3(1.6, 0.8, 1.6)
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
	if tur in ["hizarhane", "odunluk"]:
		for i in 2:
			var e := esya("odun")
			if e != null:
				e.position = Vector3(i * 0.3, 0, derin * 0.35)
				n.add_child(e)

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
