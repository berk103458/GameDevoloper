## HAR-09: aynı olay kartında güvercin/ulak için tek kutu anlatı yer tutucusu.
class_name HaberciAnlatiPaneli
extends RefCounted

const KART_GUVERCIN := "res://assets/art/cards/guvercin.png"
const KART_ULAK := "res://assets/art/cards/ulak.png"
const IKON_YOL := "res://assets/art/icons/icon_map_yol.png"

## Yeni HUD/varlık üretmez; gerçek model gelince tek helper değişir.
static func ekle(e: KoyEkrani,kok: VBoxContainer,olay: OlayVerisi) -> void:
 if not HaberciAgi.uygun(e.oturum,olay,0): return
 var kanal:=HaberciAgi.kanal(e.oturum)
 var a: Dictionary=HaberciAgi.AYAR.kanallar[kanal]
 var satir:=HBoxContainer.new()
 kok.add_child(satir)
 var kutu := Kabuk.yer_tutucu("HaberciYerTutucu",String(a.renk),Vector2.ONE*int(HaberciAgi.AYAR.kutu_px))
 var kart_yol := KART_GUVERCIN if String(kanal) == "guvercin" else KART_ULAK
 var gorsel_yol := kart_yol if ResourceLoader.exists(kart_yol) else IKON_YOL
 if ResourceLoader.exists(gorsel_yol):
  kutu.self_modulate.a = 0.0
  var tr := TextureRect.new()
  tr.texture = load(gorsel_yol)
  tr.set_anchors_preset(Control.PRESET_FULL_RECT)
  tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
  tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
  kutu.add_child(tr)
 satir.add_child(kutu)
 e._etiket(satir,String(a.ad)+" haberi",Tema.KUCUK_PX)
