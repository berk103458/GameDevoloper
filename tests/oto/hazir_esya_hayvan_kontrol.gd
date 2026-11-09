extends Node

var _hata := 0
func _ready() -> void:
 get_tree().create_timer(20).timeout.connect(func(): get_tree().quit(1))
 for ad in HazirEsyaHayvan.MODELLER:
  var n := HazirEsyaHayvan.esya(ad)
  _dene(n != null and n.has_meta("asset_yolu"), "hazir_esya_hayvan_kontrol.gd:6")
  var a := Dunya3B._kutu(n)
  _dene(absf(a.position.y) < 0.001 and a.size.y > 0, "hazir_esya_hayvan_kontrol.gd:8")
  n.free()
 var koyun := CobanSurusu.koyun()
 _dene(koyun.has_meta("asset_yolu") and koyun.get_node("bas") != null, "hazir_esya_hayvan_kontrol.gd:11")
 _dene(Dunya3B.boyut(koyun).y <= 0.801, "hazir_esya_hayvan_kontrol.gd:12")
 koyun.free()
 var inek := CelepHayvanGorseli._yer_tutucu("inek")
 inek.position.y = float(CelepHamdullah.AYAR.gorsel.boyut[1]) / 2
 _dene(inek.get_child_count() == 1 and inek.get_child(0).has_meta("asset_yolu"), "hazir_esya_hayvan_kontrol.gd:16")
 inek.free()
 _dene(ResourceLoader.exists("res://assets/model/nesne/okuz.glb"), "hazir_esya_hayvan_kontrol.gd:18")
 var kok := Node3D.new()
 HazirEsyaHayvan.kopek_kur(kok, Vector3.ZERO)
 _dene(kok.get_child_count() == 1, "hazir_esya_hayvan_kontrol.gd:21")
 kok.free()
 var o := MuhafizOdasi.new()
 add_child(o)
 for ad in ["masa", "yatak"]:
  var n := o.get_node(ad)
  _dene(n.has_meta("asset_yolu"), "hazir_esya_hayvan_kontrol.gd:27")
  _dene(absf(n.position.y) < 0.001, "hazir_esya_hayvan_kontrol.gd:28")
 o.queue_free()
 await get_tree().process_frame
 await Ses.sustur()
 print("HAZIR EŞYA HAYVAN: GEÇTİ" if _hata == 0 else "HAZIR EŞYA HAYVAN: KALDI (%d hata)" % _hata)
 get_tree().quit(1 if _hata > 0 else 0)


func _dene(kosul: bool, ad: String) -> void:
 if not kosul:
  _hata += 1
  push_error(ad)
