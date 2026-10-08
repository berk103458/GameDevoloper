## ODA-01: köy üstünde tek oda yüzeyi; mevcut kişisel kasa veya keşif kaydını çoğaltmaz.
class_name MuhafizOdasiEkrani
extends Control
var oturum: Oturum
var oda: MuhafizOdasi

func _ready() -> void:
 process_mode=Node.PROCESS_MODE_ALWAYS
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 var arka:=ColorRect.new()
 arka.color=Color("181c22")
 arka.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 add_child(arka)
 var kap:=SubViewportContainer.new()
 kap.stretch=true
 kap.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 kap.anchor_right=0.7
 add_child(kap)
 var vp:=SubViewport.new()
 vp.own_world_3d=true
 vp.render_target_update_mode=SubViewport.UPDATE_ALWAYS
 kap.add_child(vp)
 oda=preload("res://src/dunya/muhafiz_odasi.tscn").instantiate() as MuhafizOdasi
 vp.add_child(oda)
 var panel:=PanelContainer.new()
 panel.name="oda_paneli"
 panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 panel.anchor_left=0.7
 panel.offset_left=12
 panel.offset_right=-12
 panel.offset_top=24
 panel.offset_bottom=-24
 panel.add_theme_stylebox_override("panel",Tema.koy_paneli())
 add_child(panel)
 var kenar:=MarginContainer.new()
 for y in ["margin_left","margin_right","margin_top","margin_bottom"]: kenar.add_theme_constant_override(y,16)
 panel.add_child(kenar)
 var v:=VBoxContainer.new()
 v.add_theme_constant_override("separation",18)
 kenar.add_child(v)
 var baslik:=Label.new()
 baslik.text="Muhafızın Odası"
 baslik.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 v.add_child(baslik)
 var bilgi:=Label.new()
 bilgi.text="Yatak, masa, meşale ve zemin kasası.\n\nBurası muhafızın kişisel alanıdır. Köyün kamu kasası ve ambarı mevcut köy ekranında kalır."
 bilgi.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 bilgi.size_flags_vertical=Control.SIZE_EXPAND_FILL
 v.add_child(bilgi)
 var b:=Button.new()
 b.name="oda_kapat"
 b.text="Köye dön"
 b.custom_minimum_size.y=48
 v.add_child(b)
 b.pressed.connect(queue_free)
 b.grab_focus()

func _unhandled_input(olay: InputEvent) -> void:
 if olay is InputEventKey:
  if olay.pressed and not olay.echo and olay.keycode==KEY_ESCAPE: queue_free()
  get_viewport().set_input_as_handled()
