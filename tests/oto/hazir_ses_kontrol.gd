extends Node
func _ready() -> void:
 get_tree().create_timer(20).timeout.connect(func(): get_tree().quit(1))
 for ad in HazirSesKaynaklari.YOLLAR:
  assert(ResourceLoader.exists(HazirSesKaynaklari.yol(ad)), ad)
  assert(Ses._akis(ad) != null, ad)
 assert(Ses._akis("sfx_adim") is AudioStreamOggVorbis)
 assert(HazirSesKaynaklari.yol("muzik_gece_dongu") == "res://assets/ses/muzik_gece_dongu.wav")
 Ses.ortam_cal(&"ortam_koy_gunduz")
 assert(Ses._ortam.stream is AudioStreamOggVorbis and Ses._ortam.stream.loop)
 assert(absf(Ses._ortam.stream.get_length() - 8.0) < 0.05)
 assert(FileAccess.get_file_as_bytes("res://assets/ses/quendel/dere_dongu.ogg").size() < 100000)
 var aktor := Node3D.new()
 var adim = preload("res://src/ses/hazir_adim_sesi.gd").new()
 aktor.add_child(adim)
 add_child(aktor)
 adim.set_process(false)
 adim._process(0)
 var once: int = Ses._sira
 aktor.position.x += 0.7
 adim._process(0.1)
 assert(Ses._sira != once)
 var sonra: int = Ses._sira
 aktor.position.x += 0.7
 adim._process(0.1)
 assert(Ses._sira == sonra) # Aynı karede havuz taşması yok.
 aktor.queue_free()
 await get_tree().process_frame
 await Ses.sustur()
 print("HAZIR SES: GEÇTİ")
 get_tree().quit()
