extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_snow.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_snow_ui.json")
  theme = Tema.olustur(ayarlar)
func _ready() -> void:
 get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var y := ana.oturum.yonetim
 y.kaynaklar.kapasite = 10000
 for t in ["odun", "tas", "kereste"]: y.kaynaklar.ekle(t, 100)
 var b := kur(y)
 assert(b != null)
 y.gun = 21
 var once := JSON.stringify(ana.oturum.kaydet())
 ana._koye_git()
 var s: KoyYonetimSahnesi = ana._ekran.sahne3b
 await get_tree().process_frame
 assert(is_equal_approx(float(s.arazi._zemin_mat.get_shader_parameter("kar_ortusu")), 0.15))
 var sayi := catilar(s, 0.15)
 assert(sayi > 0 and s.get_node("DebugKarYagisi").multimesh.mesh is BoxMesh)
 IklimGorseli.uygula(s)
 assert(catilar(s, 0.15) == sayi and JSON.stringify(ana.oturum.kaydet()) == once)
 y.gun = 27
 s.yenile()
 await get_tree().process_frame
 assert(is_equal_approx(float(s.arazi._zemin_mat.get_shader_parameter("kar_ortusu")), 0.85) and catilar(s, 0.85) > 0)
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  await get_tree().create_timer(0.7).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("mev04_kar.png"))
 y.gun = 28
 IklimGorseli.uygula(s)
 assert(catilar(s, 0.0) > 0 and not s.get_node("DebugKarYagisi").visible)
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("MEVSİM KAR UI: GEÇTİ")
 await Ses.cik(0)
func catilar(s: KoyYonetimSahnesi, oran: float) -> int:
 var sayi := 0
 for mi in s._yapilar.find_children("*", "MeshInstance3D", true, false):
  if mi.has_meta(&"mevsim_kar_mat"):
   for mat in mi.get_meta(&"mevsim_kar_mat"):
    assert(is_equal_approx(float(mat.get_shader_parameter("kar_ortusu")), oran))
    sayi += 1
 return sayi
func kur(y: KoyYonetimi) -> KoyBinasi:
 for cy in y.a.izgara_boyut.y:
  for cx in y.a.izgara_boyut.x:
   var h := Vector2i(cx, cy)
   if y.yerlesim("kulube", h).olur:
    var b := y.bina(y.bina_kur("kulube", h).id)
    b.insa_kalan = 0
    return b
 return null
