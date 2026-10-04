## Model önizleme: MODEL ortam değişkenindeki .glb'yi (ya da klasördeki hepsini) gece ışığında çizer, PNG kaydeder.
extends Node3D

func _ready() -> void:
	var cikti := OS.get_environment("CIKTI")
	var yollar := OS.get_environment("MODEL").split(",")
	var ortam := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color("#0D0F14")
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("#4A6B8A")
	env.ambient_light_energy = 0.6
	ortam.environment = env
	add_child(ortam)
	var isik := OmniLight3D.new()
	isik.light_color = Color("#C4843A")
	isik.light_energy = 3.0
	isik.omni_range = 8.0
	isik.position = Vector3(-1.2, 2.0, 1.5)
	add_child(isik)
	var ay := DirectionalLight3D.new()
	ay.light_color = Color("#4A6B8A")
	ay.light_energy = 0.5
	ay.rotation_degrees = Vector3(-40, 30, 0)
	add_child(ay)
	var x := 0.0
	for y in yollar:
		var s: PackedScene = load(y)
		var n := s.instantiate()
		n.position.x = x
		add_child(n)
		x += 1.4
	var kam := Camera3D.new()
	kam.position = Vector3((x - 1.4) / 2.0, 1.1, 3.2 + x * 0.35)
	kam.look_at_from_position(kam.position, Vector3((x - 1.4) / 2.0, 0.9, 0))
	add_child(kam)
	await get_tree().create_timer(1.0).timeout
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(cikti)
	get_tree().quit()
