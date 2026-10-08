## ODA-10: aynı BilgiEkrani içeriği için okunabilir opak zemin ve sıkı kadraj.
class_name MuhafizEpiloguSunumu
extends RefCounted
## Mevcut başlık/metin/gün/düğmeler korunur; ikinci HUD veya son ekranı yaratılmaz.
static func kur(e: Control) -> void:
 for c in e.get_children():
  if not c is MarginContainer: continue
  c.add_theme_constant_override("margin_top",int(MuhafizEpilogu.AYAR.ust_bosluk))
  c.add_theme_constant_override("margin_bottom",int(MuhafizEpilogu.AYAR.alt_bosluk))
  var v:=c.get_child(0) as VBoxContainer
  if v!=null:
   v.add_theme_constant_override("separation",int(MuhafizEpilogu.AYAR.ayrim_px))
   var ayar:=e.get("ayarlar") as Ayarlar
   var kaydir:=ScrollContainer.new()
   kaydir.name="epilogue_kaydir"
   kaydir.size_flags_vertical=Control.SIZE_EXPAND_FILL
   kaydir.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
   var icerik:=VBoxContainer.new()
   icerik.size_flags_horizontal=Control.SIZE_EXPAND_FILL
   icerik.add_theme_constant_override("separation",int(MuhafizEpilogu.AYAR.ayrim_px))
   var bas:=v.get_child(0)
   for l in v.get_children():
    if l is Label:
     var px:=int(MuhafizEpilogu.AYAR.metin_px)
     if l==bas: px=int(MuhafizEpilogu.AYAR.baslik_px)
     elif String(l.text).is_valid_int(): px=int(MuhafizEpilogu.AYAR.gun_px)
     l.add_theme_font_size_override("font_size",ayar.boyut(px) if ayar!=null and not String(l.text).is_valid_int() else px)
     v.remove_child(l)
     icerik.add_child(l)
   v.add_child(kaydir)
   v.move_child(kaydir,0)
   kaydir.add_child(icerik)
  if e.has_node("teftis_okuma_zemini"): return
  var n:=ColorRect.new()
  n.name="epilogue_okuma_zemini"
  n.color=Color(String(MuhafizEpilogu.AYAR.okuma_renk))
  n.mouse_filter=Control.MOUSE_FILTER_IGNORE
  n.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  n.anchor_right=float(MuhafizEpilogu.AYAR.okuma_sag)
  e.add_child(n)
  e.move_child(n,c.get_index())
  return
