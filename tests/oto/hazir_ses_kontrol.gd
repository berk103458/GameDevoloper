extends Node

var _hata := 0
func _ready() -> void:
 get_tree().create_timer(20).timeout.connect(func(): get_tree().quit(1))
 for ad in HazirSesKaynaklari.YOLLAR:
  _dene(ResourceLoader.exists(HazirSesKaynaklari.yol(ad)), ad)
  _dene(Ses._akis(ad) != null, ad)
 _dene(Ses._akis("sfx_adim") is AudioStreamOggVorbis, "hazir_ses_kontrol.gd:7")
 _dene(HazirSesKaynaklari.yol("muzik_gece_dongu") == "res://assets/ses/muzik_gece_dongu.wav", "hazir_ses_kontrol.gd:8")
 Ses.ortam_cal(&"ortam_koy_gunduz")
 _dene(Ses._ortam.stream is AudioStreamOggVorbis and Ses._ortam.stream.loop, "hazir_ses_kontrol.gd:10")
 _dene(absf(Ses._ortam.stream.get_length() - 8.0) < 0.05, "hazir_ses_kontrol.gd:11")
 _dene(FileAccess.get_file_as_bytes("res://assets/ses/quendel/dere_dongu.ogg").size() < 100000, "hazir_ses_kontrol.gd:12")
 var aktor := Node3D.new()
 var adim = preload("res://src/ses/hazir_adim_sesi.gd").new()
 aktor.add_child(adim)
 add_child(aktor)
 adim.set_process(false)
 adim._process(0)
 var once: int = Ses._sira
 aktor.position.x += 0.7
 adim._process(0.1)
 _dene(Ses._sira != once, "hazir_ses_kontrol.gd:22")
 var sonra: int = Ses._sira
 aktor.position.x += 0.7
 adim._process(0.1)
 _dene(Ses._sira == sonra, "hazir_ses_kontrol.gd:26") # Aynı karede havuz taşması yok.
 aktor.queue_free()
 await get_tree().process_frame
 await Ses.sustur()
 print("HAZIR SES: GEÇTİ" if _hata == 0 else "HAZIR SES: KALDI (%d hata)" % _hata)
 get_tree().quit(1 if _hata > 0 else 0)


func _dene(kosul: bool, ad: String) -> void:
 if not kosul:
  _hata += 1
  push_error(ad)
