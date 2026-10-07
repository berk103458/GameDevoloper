extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
func _initialize() -> void:
 var f := KarakterModel.new()
 var sk := Skeleton3D.new()
 sk.add_bone("RightHand")
 sk.add_bone("LeftHand")
 f.add_child(sk)
 root.add_child(f)
 var eski := ElEsyasi.new()
 eski.visible = false
 f.add_child(eski)
 var d := MuhafizDonanimi.new()
 f.add_child(d)
 dene(d.kur(f, 0), "Mevcut el kemiklerine donanım kurulur")
 dene(d.silah.name == "kilic" and d.kalkan != null, "Kılıç ve kalkan")
 d.faz(&"gunduz", true)
 dene(not d.mesale.visible and d.kalkan.visible and not d.isik.visible, "Gündüz ışık ve meşale kapalı")
 d.faz(&"gece", true)
 dene(d.mesale.visible and not d.kalkan.visible and d.isik.visible, "Gece sol elde meşale ve ışık")
 d.faz(&"gece", false)
 dene(d.mesale.visible and not d.isik.visible, "Işık bütçesi alev görünümünü silmez")
 await process_frame
 sk.set_bone_pose_position(0, Vector3(1, 2, 3))
 d.silah._guncelle()
 dene(d.silah.global_position.distance_to(Vector3(1, 1.94, 3)) < 0.001, "Donanım gerçek el pozunu izler")
 d.kaldir()
 dene(not eski.visible, "Önceden gizli CHR eşyası gizli kalır")
 await process_frame
 var mizrak := MuhafizDonanimi.new()
 f.add_child(mizrak)
 dene(mizrak.kur(f, 1) and mizrak.silah.name == "mizrak", "Diğer asker mızrak taşır")
 var eksik := KarakterModel.new()
 root.add_child(eksik)
 var e := MuhafizDonanimi.new()
 eksik.add_child(e)
 dene(not e.kur(eksik, 1), "İskeletsiz fallback'a sahte soket kurulmaz")
 f.queue_free()
 eksik.queue_free()
 await process_frame
 print("MUHAFIZ DONANIMI: GEÇTİ" if hata == 0 else "MUHAFIZ DONANIMI: KALDI")
 quit(hata)
