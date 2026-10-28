extends Node
func _ready() -> void:
 get_tree().create_timer(20).timeout.connect(func(): get_tree().quit(1))
 for ad in HazirEsyaHayvan.MODELLER:
  var n := HazirEsyaHayvan.esya(ad)
  assert(n != null and n.has_meta("asset_yolu"))
  var a := Dunya3B._kutu(n)
  assert(absf(a.position.y) < 0.001 and a.size.y > 0)
  n.free()
 var koyun := CobanSurusu.koyun()
 assert(koyun.has_meta("asset_yolu") and koyun.get_node("bas") != null)
 assert(Dunya3B.boyut(koyun).y <= 0.801)
 koyun.free()
 var inek := CelepHayvanGorseli._yer_tutucu("inek")
 inek.position.y = float(CelepHamdullah.AYAR.gorsel.boyut[1]) / 2
 assert(inek.get_child_count() == 1 and inek.get_child(0).has_meta("asset_yolu"))
 inek.free()
 assert(ResourceLoader.exists("res://assets/model/nesne/okuz.glb"))
 var kok := Node3D.new()
 HazirEsyaHayvan.kopek_kur(kok, Vector3.ZERO)
 assert(kok.get_child_count() == 1)
 kok.free()
 var o := MuhafizOdasi.new()
 add_child(o)
 for ad in ["masa", "yatak"]:
  var n := o.get_node(ad)
  assert(n.has_meta("asset_yolu"))
  assert(absf(n.position.y) < 0.001)
 o.queue_free()
 await get_tree().process_frame
 await Ses.sustur()
 print("HAZIR EŞYA HAYVAN: GEÇTİ")
 get_tree().quit()
