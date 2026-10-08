## CAS-05: mevcut köy meydanı üstünde tek divan; tutanak niyetle karıştırılmaz.
class_name DivanEkrani
extends Control
signal kapandi
signal kisi_secildi(id: int)
var oturum: Oturum
var _liste: VBoxContainer
var _bilgi: Label
## Scene ağacı sabit dış kabuk; ölçü ekranla uyarlanır.
func _ready() -> void:
 process_mode = Node.PROCESS_MODE_ALWAYS
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 mouse_filter = Control.MOUSE_FILTER_STOP
 var panel := PanelContainer.new()
 panel.name = "divan_paneli"
 panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 panel.anchor_left = 0.52
 panel.offset_left = 12
 panel.offset_right = -24
 panel.offset_top = 155
 panel.offset_bottom = -24
 panel.add_theme_stylebox_override("panel",Tema.koy_paneli())
 add_child(panel)
 var kenar := MarginContainer.new()
 for a in ["margin_left","margin_right","margin_top","margin_bottom"]: kenar.add_theme_constant_override(a,20)
 panel.add_child(kenar)
 var v := VBoxContainer.new()
 v.add_theme_constant_override("separation",12)
 kenar.add_child(v)
 var bas := Label.new()
 bas.text = "Muhafız Divanı · Köy Meydanı"
 bas.add_theme_font_size_override("font_size",Tema.BASLIK_PX)
 bas.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 v.add_child(bas)
 var kaydir := ScrollContainer.new()
 kaydir.size_flags_vertical = Control.SIZE_EXPAND_FILL
 kaydir.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
 v.add_child(kaydir)
 _liste = VBoxContainer.new()
 _liste.size_flags_horizontal = Control.SIZE_EXPAND_FILL
 kaydir.add_child(_liste)
 _bilgi = Label.new()
 _bilgi.name = "divan_tutanagi"
 _bilgi.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 _bilgi.add_theme_font_size_override("font_size",Tema.KUCUK_PX)
 v.add_child(_bilgi)
 var kapat := Button.new()
 kapat.name = "divan_kapat"
 kapat.text = "Duruşmayı ertele · köye dön"
 kapat.custom_minimum_size.y = 48
 v.add_child(kapat)
 kapat.pressed.connect(func() -> void: kapandi.emit(); queue_free())
 yenile()
 kapat.grab_focus.call_deferred()
## Yenileme aynı canlı kaynak üzerinde; ek açık kanıt uydurmaz veya ceza uygulamaz.
func yenile() -> void:
 for c in _liste.get_children():
  _liste.remove_child(c)
  c.queue_free()
 var y := oturum.yonetim
 var ids := DivanOturumu.adaylar(y)
 for id in ids:
  var b := Button.new()
  b.text = "%s · tutanağı aç" % y.koylu(id).ad
  b.custom_minimum_size.y = 44
  _liste.add_child(b)
  b.pressed.connect(func() -> void: sec(id))
 var d := DivanOturumu.durum(y)
 if int(d.kisi) in ids: _goster(int(d.kisi))
 elif not ids.is_empty(): _goster(ids[0])
 else: _bilgi.text = "Gözlenmiş fiil tutanağı bulunmuyor. Şüphe tek başına yargılama kanıtı değildir."
## Gerçek seçim makbuzu; henüz hüküm verilmez.
func sec(id: int) -> void:
 if DivanOturumu.sec(oturum.yonetim,id): _goster(id)
func _goster(id: int) -> void:
 var y := oturum.yonetim
 var k := y.koylu(id)
 if k == null: yenile(); return
 var metin := "%s\nGözlenen fiiller:\n" % k.ad
 for x in DivanOturumu.izler(y,id):
  metin += "• %d. gece · %s · %s · kayıp %d %s\n" % [int(x.gun)+1,{"hirsizlik":"Hırsızlık","sabotaj":"Sabotaj","zehirleme":"Zehirleme","kundaklama":"Kundaklama"}.get(String(x.durum),"Fiil"),{"ambar":"Ambar","kuyu":"Kuyu","cephanelik":"Cephanelik"}.get(String(x.hedef),"Hedef"),int(x.kayip),{"gida":"erzak","saglik":"toplam sağlık","alet":"alet"}.get(String(x.kaynak),String(x.kaynak))]
 DivanSorguPaneli.kur(self,_liste,id)
 DivanHukumPaneli.kur(self,_liste,id)
 DivanHaksizlikPaneli.kur(self,_liste,id)
 kisi_secildi.emit(id)
 _bilgi.text = metin+"\n"+DivanHaksizlikPaneli.aciklama(y,id)
## Divan modalında köy kısayolları ve kamera hareketi tüketilir; Escape geri döner.
func _unhandled_input(e: InputEvent) -> void:
 if e is InputEventKey:
  if e.pressed and e.physical_keycode == KEY_ESCAPE: kapandi.emit(); queue_free()
  get_viewport().set_input_as_handled()
