extends Node
func _ready() -> void:
 get_tree().create_timer(20).timeout.connect(func(): get_tree().quit(1))
 for tur in ["alev", "ocak", "duman"]:
  var p := HazirAtesEfektleri.olustur(tur, 1.0, 100)
  assert(p is GPUParticles3D and p.amount == 32)
  assert(p.draw_pass_1 is QuadMesh and p.process_material is ParticleProcessMaterial)
  assert(p.draw_pass_1.material.albedo_texture != null)
  assert(p.draw_pass_1.material.billboard_mode == BaseMaterial3D.BILLBOARD_PARTICLES)
  assert(p.visibility_aabb.size.y >= 6)
  p.free()
 var kok := Node3D.new()
 add_child(kok)
 var light := Dunya3B.mesale_kur(kok, Vector3.ZERO)
 assert(light.get_meta("alev").find_children("*", "GPUParticles3D", true, false).size() == 1)
 kok.queue_free()
 await get_tree().process_frame
 print("HAZIR VFX: GEÇTİ")
 await Ses.cik()
