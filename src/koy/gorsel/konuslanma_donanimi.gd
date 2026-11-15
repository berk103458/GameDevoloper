## HAR-10: aynı gerçek el soketinde tek düz kutu yay/mızrak yer tutucusu.
class_name KonuslanmaDonanimi
extends RefCounted
## Görev kalkınca eski silah görünür; muhafız düğümü kalkınca çocuk da kaldırılır.
static func yenile(h: Node) -> void:
 for id in h.modeller:
  var f: KarakterModel=h.modeller[id]
  var d:=f.get_node_or_null("muhafiz_donanimi") as MuhafizDonanimi
  if d==null or d.is_queued_for_deletion() or d.silah==null: continue
  var rol:=SavunmaKonuslanmasi.etkin(h.sahne.yonetim,int(id))
  var eski:=d.get_node_or_null("taktik_silah") as ElEsyasi
  if eski!=null and eski.get_meta("rol","")==rol and not rol.is_empty(): continue
  if eski!=null:
   d.remove_child(eski)
   eski.queue_free()
  d.silah.visible=true
  if rol.is_empty(): continue
  var bulunan:=f.find_children("*","Skeleton3D",true,false)
  if bulunan.is_empty(): continue
  var sk: Skeleton3D=bulunan[0]
  if sk.find_bone("RightHand")<0: continue
  var a: Dictionary=SavunmaKonuslanmasi.AYAR.roller[rol]
  var e:=ElEsyasi.new()
  e.name="taktik_silah";e.dik=true;e.set_meta("rol",rol)
  d.add_child(e)
  var silah_ad:="yay" if rol=="sur" else "mizrak"
  if Dunya3B.model_var_mi(silah_ad):
   var glb:=Dunya3B.nesne(silah_ad,float(a.boyut[1]))
   glb.position=Vector3(0,-float(a.boyut[1])*0.2,0)
   e.add_child(glb)
  else:
   var m:=MeshInstance3D.new()
   var b:=BoxMesh.new()
   b.size=Vector3(a.boyut[0],a.boyut[1],a.boyut[2])
   m.mesh=b;m.material_override=Dunya3B.duz_malzeme(Color(a.renk))
   e.add_child(m)
  e.bagla(f,sk,true,f.duzeltici())
  d.silah.visible=false
