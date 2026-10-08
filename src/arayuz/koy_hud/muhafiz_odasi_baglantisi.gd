## ODA-01: mevcut köy eylem sütununa ince oda adaptörü.
class_name MuhafizOdasiBaglantisi
extends RefCounted
## Divan/oda yan yana, eylem sütununun yüksekliği artmaz.
static func kur(e: KoyEkrani,v: VBoxContainer) -> void:
 var s:=HBoxContainer.new()
 s.add_theme_constant_override("separation",8)
 var d:=v.get_node_or_null("divan_ac")
 if d!=null: v.remove_child(d)
 v.add_child(s)
 if d!=null: s.add_child(d)
 var b:=Button.new()
 b.name="oda_ac"
 b.text="Muhafızın Odası"
 b.custom_minimum_size.y=42
 s.add_child(b)
 b.pressed.connect(func() -> void: ac(e))

## Köyü duraklatır, bağımsız dünya açar; kapanışta yalnız önceki hız/duraklama geri gelir.
static func ac(e: KoyEkrani) -> MuhafizOdasiEkrani:
 if e._gece_kilidi.kilitli() or e._ust_kart!=null or e.has_node("DivanEkrani") or e.has_node("MuhafizOdasiEkrani") or e.oturum.yonetim.son!="": return null
 var hiz:=0 if e.get_tree().paused else int(Engine.time_scale)
 e._hiz_sec(0)
 var d:=MuhafizOdasiEkrani.new()
 d.name="MuhafizOdasiEkrani"
 d.oturum=e.oturum
 e.add_child(d)
 d.tree_exiting.connect(func() -> void:
  if is_instance_valid(e) and e.is_inside_tree() and not e.is_queued_for_deletion(): e._hiz_sec(hiz)
 )
 return d
