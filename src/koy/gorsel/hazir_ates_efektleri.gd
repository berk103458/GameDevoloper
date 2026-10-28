## HAE-05: yalnız mevcut izinli dokular; sınırlı, gölgesiz GPU parçacıkları.
class_name HazirAtesEfektleri
extends RefCounted

static func olustur(tur: String, boy: float = 1.0, adet: int = 18) -> GPUParticles3D:
	var duman := tur == "duman"
	var yol := "res://assets/vfx/kenney/smoke_01.png" if duman else ("res://assets/vfx/kronbits/ates_01.png" if tur == "ocak" else "res://assets/vfx/kenney/flame_01.png")
	if not ResourceLoader.exists(yol):
		return null
	var p := GPUParticles3D.new()
	p.name = "hazir_" + tur
	p.amount = clampi(adet, 1, 32)
	p.set_meta("taban_adet", p.amount)
	p.lifetime = 2.2 if duman else 0.65
	p.preprocess = 0.5
	p.fixed_fps = 20
	p.local_coords = true
	p.use_fixed_seed = true
	p.seed = 28
	p.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	p.visibility_aabb = AABB(Vector3(-2, -1, -2) * boy, Vector3(4, 6, 4) * boy)
	var mat := StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.billboard_mode = BaseMaterial3D.BILLBOARD_PARTICLES
	mat.vertex_color_use_as_albedo = true
	mat.albedo_texture = load(yol)
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	if not duman:
		mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
		mat.emission_enabled = true
		mat.emission = Color("ffae56")
		mat.emission_texture = mat.albedo_texture
		mat.emission_energy_multiplier = 1.2
	var quad := QuadMesh.new()
	quad.size = Vector2(0.55, 0.55 if duman else 0.7) * boy
	quad.material = mat
	p.draw_pass_1 = quad
	var hareket := ParticleProcessMaterial.new()
	hareket.direction = Vector3.UP
	hareket.spread = 12.0
	hareket.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	hareket.emission_sphere_radius = 0.08 * boy
	hareket.gravity = Vector3(0.06 if duman else 0, 0.12, 0) * boy
	hareket.initial_velocity_min = 0.3 * boy
	hareket.initial_velocity_max = (0.7 if duman else 1.1) * boy
	hareket.scale_min = 0.5
	hareket.scale_max = 1.2
	var gradient := Gradient.new()
	gradient.offsets = PackedFloat32Array([0.0, 0.15, 0.7, 1.0])
	gradient.colors = PackedColorArray([Color(0.4, 0.4, 0.4, 0), Color(0.45, 0.45, 0.45, 0.5), Color(0.3, 0.3, 0.3, 0.3), Color(0.3, 0.3, 0.3, 0)]) if duman else PackedColorArray([Color(1, 0.65, 0.25, 0), Color(1, 0.8, 0.4, 0.8), Color(1, 0.35, 0.08, 0.3), Color(1, 0.15, 0, 0)])
	var renk := GradientTexture1D.new()
	renk.gradient = gradient
	hareket.color_ramp = renk
	p.process_material = hareket
	return p
