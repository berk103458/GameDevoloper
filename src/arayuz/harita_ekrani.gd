## HAR-01: mevcut köyün üzerinde tek şematik çevre haritası; salt okunur modal.
class_name HaritaEkrani
extends Control
var oturum: Oturum
var ayarlar: Ayarlar
var _alan: Control
var _bilgi: Label
var _baslik: Label
var _noktalar: Dictionary={}
var _yollar: Array[ColorRect]=[]
const IKON_HISAR := "res://assets/art/icons/icon_map_hisar.png"
const IKON_YOL := "res://assets/art/icons/icon_map_yol.png"
func _ready() -> void:
 process_mode=Node.PROCESS_MODE_ALWAYS
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 var arka:=ColorRect.new()
 arka.color=Color(String(CevreHaritasi.AYAR.arka))
 arka.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 add_child(arka)
 var kenar:=MarginContainer.new()
 kenar.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 for a in ["left","right","top","bottom"]: kenar.add_theme_constant_override("margin_"+a,32)
 add_child(kenar)
 var v:=VBoxContainer.new()
 v.add_theme_constant_override("separation",20)
 kenar.add_child(v)
 var h:=Label.new()
 h.text="Çevre haritası"
 h.add_theme_font_size_override("font_size",ayarlar.boyut(36))
 v.add_child(h)
 var notu:=Label.new()
 notu.text="Şematik görünüm · Bir bölgeyi seçerek incele."
 notu.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 v.add_child(notu)
 var s:=HBoxContainer.new()
 s.size_flags_vertical=Control.SIZE_EXPAND_FILL
 s.add_theme_constant_override("separation",24)
 v.add_child(s)
 var panel:=PanelContainer.new()
 panel.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 panel.add_theme_stylebox_override("panel",Kabuk.panel())
 s.add_child(panel)
 _alan=Control.new()
 _alan.name="harita_alan"
 _alan.custom_minimum_size=Vector2(640,360)
 panel.add_child(_alan)
 var renk:=ColorRect.new()
 renk.color=Color(String(CevreHaritasi.AYAR.harita_renk))
 renk.mouse_filter=Control.MOUSE_FILTER_IGNORE
 renk.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 _alan.add_child(renk)
 for y in CevreHaritasi.AYAR.yollar:
  var c:=ColorRect.new()
  c.color=Color(String(CevreHaritasi.AYAR.yol_renk))
  c.mouse_filter=Control.MOUSE_FILTER_IGNORE
  _alan.add_child(c)
  _yollar.append(c)
 for b in CevreHaritasi.bolgeler():
  var nokta:=ColorRect.new()
  nokta.name="bolge_"+String(b.id)
  nokta.color=Color(String(b.renk))
  nokta.size=Vector2(float(CevreHaritasi.AYAR.nokta_genislik),float(CevreHaritasi.AYAR.nokta_yukseklik))
  _alan.add_child(nokta)
  var dugme:=Button.new()
  var stil:=StyleBoxFlat.new()
  stil.bg_color=Color(String(b.renk))
  stil.set_border_width_all(2)
  stil.border_color=Color("a0a29b")
  dugme.add_theme_stylebox_override("normal",stil)
  dugme.text=String(b.ad)
  dugme.name="sec_"+String(b.id)
  var iy := IKON_HISAR if String(b.id) == "hisar" else IKON_YOL
  if ResourceLoader.exists(iy):
   dugme.icon = load(iy)
   dugme.expand_icon = true
  dugme.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  dugme.add_theme_font_size_override("font_size",ayarlar.boyut(Kabuk.KUCUK))
  dugme.pressed.connect(func() -> void: bolge_sec(String(b.id)))
  nokta.add_child(dugme)
  _noktalar[String(b.id)]=nokta
 _alan.resized.connect(_yerlestir)
 var kaydir:=ScrollContainer.new()
 kaydir.custom_minimum_size.x=320
 kaydir.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
 s.add_child(kaydir)
 var bilgi:=VBoxContainer.new()
 bilgi.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 bilgi.add_theme_constant_override("separation",24)
 kaydir.add_child(bilgi)
 _baslik=Label.new()
 _baslik.name="harita_bolge_baslik"
 _baslik.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 _baslik.add_theme_font_size_override("font_size",ayarlar.boyut(28))
 bilgi.add_child(_baslik)
 _bilgi=Label.new()
 _bilgi.name="harita_bolge_bilgi"
 _bilgi.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 _bilgi.add_theme_font_size_override("font_size",ayarlar.boyut(24))
 bilgi.add_child(_bilgi)
 var geri:=Button.new()
 geri.name="harita_kapat"
 geri.text="Köye dön"
 geri.custom_minimum_size.y=48
 geri.pressed.connect(queue_free)
 v.add_child(geri)
 bolge_sec("hisar")
 _yerlestir.call_deferred()
 geri.grab_focus()
## Aynı bilgi alanı seçilen bölgeyle güncellenir; oyun durumuna yazılmaz.
func bolge_sec(id: String) -> void:
 var d:=CevreHaritasi.bilgi(oturum,id)
 if d.is_empty(): return
 _baslik.text=String(d.ad)
 _bilgi.text=String(d.metin)
func _yerlestir() -> void:
 for b in CevreHaritasi.AYAR.bolgeler:
  var n:=_noktalar[String(b.id)] as ColorRect
  n.position=Vector2(float(b.x)*_alan.size.x,float(b.y)*_alan.size.y)-n.size/2
 for i in _yollar.size():
  var y: Array=CevreHaritasi.AYAR.yollar[i]
  var a:=Vector2(float(y[0])*_alan.size.x,float(y[1])*_alan.size.y)
  var b:=Vector2(float(y[2])*_alan.size.x,float(y[3])*_alan.size.y)
  _yollar[i].position=a
  _yollar[i].size=Vector2(a.distance_to(b),3)
  _yollar[i].rotation=(b-a).angle()
func _unhandled_input(olay: InputEvent) -> void:
 if olay is InputEventKey:
  if olay.pressed and not olay.echo and olay.keycode==KEY_ESCAPE: queue_free()
  get_viewport().set_input_as_handled()
