## CAS-07: mevcut kapı hücresi kutu işareti; tutsak eski kişi modelidir, dış rutin görünmez.
class_name DivanZindanGorseli
extends RefCounted
static func kur(s: KoyYonetimSahnesi,n: Node3D) -> void:
 var sayi:=0
 for k in s.yonetim.koylular:
  if DivanHukmu.zindanda(k):
   sayi+=1
   var f: KarakterModel=s.halk_hareketi.modeller.get(k.id)
   if f!=null: f.visible=false
 if sayi==0: return
 var k:=MeshInstance3D.new()
 k.name="zindan_kutu"
 var m:=BoxMesh.new()
 m.size=Vector3(1.2,2,0.3)
 k.mesh=m
 var mat:=StandardMaterial3D.new()
 mat.albedo_color=Color("655d50")
 k.material_override=mat
 var kapı:=s.kapi_noktasi()
 k.position=Vector3(kapı.x+2,1,kapı.y)
 n.add_child(k)
 var l:=Label3D.new()
 l.text="Zindan · %d kişi" % sayi
 l.position=k.position+Vector3(0,1.2,0)
 l.billboard=BaseMaterial3D.BILLBOARD_ENABLED
 n.add_child(l)
