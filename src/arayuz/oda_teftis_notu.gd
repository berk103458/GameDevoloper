## ODA-07: mevcut oda listesine tek risk etiketi; yeni HUD veya kasa yok.
class_name OdaTeftisNotu
extends RefCounted
## Mekanik risk ve zamanı aynı oda yüzeyinde açıklar.
static func kur(o: Oturum,v: VBoxContainer) -> void:
 var l:=Label.new()
 l.name="oda_teftis_notu"
 l.text=SancakTeftisi.tip(o)
 l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 l.add_theme_font_size_override("font_size",Tema.KUCUK_PX)
 v.add_child(l)

## Teftiş sonlarında mevcut metin altında opak okuma zemini; diğer sonları değiştirmez.
static func son_kur(e: Control,son: StringName) -> void:
 if son not in [SancakTeftisi.SON_AZIL,SancakTeftisi.SON_IDAM]: return
 for c in e.get_children():
  if c is MarginContainer:
   var n:=ColorRect.new()
   n.name="teftis_okuma_zemini"
   n.color=Color(String(SancakTeftisi.AYAR.son_okuma_renk))
   n.mouse_filter=Control.MOUSE_FILTER_IGNORE
   n.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
   n.anchor_right=float(SancakTeftisi.AYAR.son_okuma_sag)
   e.add_child(n)
   e.move_child(n,c.get_index())
   return
