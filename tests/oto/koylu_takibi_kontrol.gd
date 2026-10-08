extends Node
class TestAna extends Ana:
 func _ready() -> void:
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  ayarlar = Ayarlar.new("user://unused_follow.cfg")
  katalog = Katalog.new()
  katalog.yukle()
  oturum = Oturum.new(katalog, 76)
  kayit = GuvenliKayit.new("user://test_follow_ui.json")
  theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
 get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
 var ana := TestAna.new()
 add_child(ana)
 var y := ana.oturum.yonetim
 var k := y.kabul({"ad": "Ali", "sinif": "ciftci", "gizli": ["haydut"]})
 var ikinci := y.kabul({"ad": "Ayşe", "sinif": "ciftci"})
 var once := JSON.stringify(ana.oturum.kaydet())
 ana._koye_git()
 await get_tree().process_frame
 var e := ana._ekran as KoyEkrani
 var h := e.sahne3b.halk_hareketi
 h.set_process(false)
 h._bekleyen.clear()
 var f := h.modeller[k.id] as KarakterModel
 f.yurumeyi_durdur()
 f.position = Vector3.ZERO
 h.modeller[ikinci.id].position = Vector3(8, 0, 8)
 var nokta := e.sahne3b.kamera.unproject_position(f.global_position + Vector3.UP * 0.9)
 var tik := InputEventMouseButton.new()
 tik.button_index = MOUSE_BUTTON_LEFT
 tik.pressed = true
 tik.position = nokta * e._kap.size / Vector2(e._vp.size)
 e._dunya_girdisi(tik)
 var n := e.sahne3b.get_node_or_null("koylu_takibi") as KoyluTakibi
 kontrol(n != null and n.kisi == k.id and n.takip and is_instance_valid(e._ust_kart), "Mevcut figür tıklaması kart ve takip açar")
 e._kart_kapat()
 var kamera_once := e.sahne3b.kamera.position
 f.position += Vector3(2, 0, 1)
 n.guncelle()
 kontrol(e.sahne3b.hedef.is_equal_approx(f.position) and not e.sahne3b.kamera.position.is_equal_approx(kamera_once), "Yürüyen figürle mevcut kamera taşınır")
 kontrol(n.etiket.global_position.is_equal_approx(f.global_position + Vector3.UP * float(KoyluTakibi.AYAR.etiket_yukseklik)), "Etiket figürün üzerinde kalır")
 kontrol(n.etiket.text.contains("Ali") and not n.etiket.text.contains("haydut"), "Yüzen bilgi gizli bayrak sızdırmaz")
 var w := InputEventKey.new()
 w.physical_keycode = KEY_W
 w.keycode = KEY_W
 w.pressed = true
 Input.parse_input_event(w)
 Input.flush_buffered_events()
 n._process(0.01)
 var birak := w.duplicate() as InputEventKey
 birak.pressed = false
 Input.parse_input_event(birak)
 Input.flush_buffered_events()
 kontrol(not n.takip, "WASD serbest kameraya bırakır")
 KoyluTakibi.sec(e.sahne3b, ikinci.id)
 kontrol(n.kisi == ikinci.id and n.takip and n.etiket.text.contains("Ayşe"), "Seçim değişimi aynı etiketi kullanır")
 kontrol(e.sahne3b.find_children("koylu_durum_etiketi", "Label3D", true, false).size() == 1, "İkinci HUD veya etiketi yok")
 e.sahne3b.yakinlas(1.0)
 var zoom := e.sahne3b.uzaklik
 n.guncelle()
 kontrol(is_equal_approx(zoom, e.sahne3b.uzaklik), "Takipte mevcut tekerlek zoomu korunur")
 var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name() != "headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("ani14_takip.png"))
 tik.button_index = MOUSE_BUTTON_RIGHT
 e._dunya_girdisi(tik)
 kontrol(n.kisi == -1 and not n.etiket.visible, "Sağ tık takibi ve etiketi kapatır")
 KoyluTakibi.sec(e.sahne3b, k.id)
 e._kip_sec("yol")
 kontrol(not n.takip and not n.etiket.visible, "Yol/inşaat kipinde kamera hedefi kaymaz")
 e._kip_sec("")
 KoyluTakibi.sec(e.sahne3b, k.id)
 f.queue_free()
 n.guncelle()
 kontrol(n.kisi == -1 and not n.takip, "Ayrılan/ölen görsel figür güvenle temizlenir")
 KoyluTakibi.sec(e.sahne3b, 99999)
 kontrol(n.kisi == -1, "Sahne sınırı dışı kişi için sahte figür üretilmez")
 kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Takip kamera ve bilgi kayıt/RNG değiştirmez")
 ana.kayit.sil()
 ana.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.3).timeout
 print("KÖYLÜ TAKİBİ UI: GEÇTİ" if hata == 0 else "KÖYLÜ TAKİBİ UI: KALDI")
 await Ses.cik(hata)
func kontrol(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
