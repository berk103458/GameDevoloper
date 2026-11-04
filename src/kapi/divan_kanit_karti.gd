## CAS-14: aynı keşif kaydının kaynak açıklamalı kartı; yeni kanıt/HUD deposu yok.
class_name DivanKanitKarti
extends RefCounted
## Kart yalnız bulunan kimlikte; sunma mevcut DivanKanit atomik işlemidir.
static func ekle(e: DivanEkrani,v: VBoxContainer,id: int,clue: String,kaynak: Dictionary,d: Dictionary) -> PanelContainer:
 var p:=PanelContainer.new()
 p.name="kanit_"+clue
 p.set_meta("clue",clue)
 p.add_theme_stylebox_override("panel",Kabuk.panel())
 v.add_child(p)
 var n:=VBoxContainer.new()
 n.add_theme_constant_override("separation",8)
 p.add_child(n)
 var b:=Button.new()
 b.text="%s · %s" % [String(kaynak.baslik),"sunuldu" if clue in d.sunulan else "sun"]
 b.custom_minimum_size.y=42
 b.disabled=clue in d.sunulan or d.itiraf
 b.tooltip_text="Kapıda bulunan bu kanıtı mevcut duruşmaya sun. Tekrar sunma etkisizdir."
 if b.disabled: b.add_theme_color_override("font_disabled_color",Renkler.KUL)
 n.add_child(b)
 var l:=Label.new()
 l.name="kaynak_aciklamasi"
 l.text=String(kaynak.aciklama)
 l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 l.add_theme_font_size_override("font_size",Kabuk.KUCUK)
 l.add_theme_color_override("font_color",Renkler.KUL)
 n.add_child(l)
 b.pressed.connect(func() -> void:
  if DivanKanit.sun(e.oturum.yonetim,id,clue): e._goster(id)
 )
 return p
