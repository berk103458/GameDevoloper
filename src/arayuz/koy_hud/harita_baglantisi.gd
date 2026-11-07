## HAR-01: mevcut eylem grubuna tek harita düğmesi, mevcut modal/hız protokolü.
class_name HaritaBaglantisi
extends RefCounted
## Mevcut divan/oda satırını genişletir; ikinci HUD veya kaynak şeridi yaratmaz.
static func kur(e: KoyEkrani,v: VBoxContainer) -> void:
 var oda:=v.find_children("oda_ac","Button",true,false)
 var hedef: Node=oda[0].get_parent() if not oda.is_empty() else v
 var b:=Button.new()
 b.name="harita_ac"
 b.text="Harita"
 b.custom_minimum_size.y=42
 hedef.add_child(b)
 e.hud._katman.izle(b, "harita_baglantisi.gd")
 b.pressed.connect(func() -> void: ac(e))
## Gece/terminal/diğer modal sırasında açılmaz; kapanış önceki hız/duraklama durumunu korur.
static func ac(e: KoyEkrani) -> HaritaEkrani:
 if not e.hud._katman.acik("harita_baglantisi.gd"): return null
 if e._gece_kilidi.kilitli() or e._ust_kart!=null or e.has_node("DivanEkrani") or e.has_node("MuhafizOdasiEkrani") or e.has_node("HaritaEkrani") or e.oturum.yonetim.son!="": return null
 var hiz:=0 if e.get_tree().paused else int(Engine.time_scale)
 e._hiz_sec(0)
 var d:=HaritaEkrani.new()
 d.name="HaritaEkrani"
 d.oturum=e.oturum
 d.ayarlar=e.ayarlar
 e.add_child(d)
 d.tree_exiting.connect(func() -> void:
  if is_instance_valid(e) and e.is_inside_tree() and not e.is_queued_for_deletion():
   e._hiz_sec(hiz)
   e.hud.guncelle()
 )
 return d
