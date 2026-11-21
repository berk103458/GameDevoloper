## HAR-09: aynı olay kartında güvercin/ulak için tek kutu anlatı yer tutucusu.
class_name HaberciAnlatiPaneli
extends RefCounted

const IKON_YOL := "res://assets/art/icons/icon_map_yol.png"

## Yeni HUD/varlık üretmez; gerçek model gelince tek helper değişir.
static func ekle(e: KoyEkrani,kok: VBoxContainer,olay: OlayVerisi) -> void:
 if not HaberciAgi.uygun(e.oturum,olay,0): return
 var kanal:=HaberciAgi.kanal(e.oturum)
 var a: Dictionary=HaberciAgi.AYAR.kanallar[kanal]
 var satir:=HBoxContainer.new()
 kok.add_child(satir)
 var kutu := Kabuk.yer_tutucu("HaberciYerTutucu",String(a.renk),Vector2.ONE*int(HaberciAgi.AYAR.kutu_px))
 if ResourceLoader.exists(IKON_YOL):
  kutu.self_modulate.a = 0.0
  var tr := TextureRect.new()
  tr.texture = load(IKON_YOL)
  tr.modulate = kutu.color
  tr.set_anchors_preset(Control.PRESET_FULL_RECT)
  tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
  tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
  kutu.add_child(tr)
 satir.add_child(kutu)
 e._etiket(satir,String(a.ad)+" haberi",Tema.KUCUK_PX)
