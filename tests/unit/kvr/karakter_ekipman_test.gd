extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
func _initialize() -> void:
 call_deferred("_calistir")
func _calistir() -> void:
 var f := KarakterModel.new()
 var sk := Skeleton3D.new()
 sk.add_bone("RightHand")
 f.add_child(sk)
 root.add_child(f)
 var m := KarakterEkipmanYoneticisi.al(f)
 dene(m != null and m.soket is BoneAttachment3D and not m.soket.override_pose, "Gerçek salt okunur kemik soketi")
 var sahip := Node.new()
 f.add_child(sahip)
 var alet := ElEsyasi.new()
 sahip.add_child(alet)
 dene(m.tak("demirhane", alet, sahip) == alet and alet.get_parent() == m.soket, "Alet tek el soketine bağlanır")
 await process_frame
 sk.set_bone_pose_position(0, Vector3(1, 2, 3))
 m._guncelle()
 dene(alet.global_position.distance_to(Vector3(1, 1.94, 3)) < 0.001, "Alet gerçek el pozunu izler")
 m.depoladir(sahip)
 dene(not alet.visible and alet.get_parent() == m.depo and m.stok.size() == 1, "Molada aynı alet görsel stokta saklanır")
 var yeni := ElEsyasi.new()
 sahip.add_child(yeni)
 dene(m.tak("atolye", yeni, sahip) == alet and m.stok.size() == 1, "Aynı alet türü yeniden kullanılır; çift çekiç yok")
 var diger := Node.new()
 f.add_child(diger)
 m._sahip = diger
 m.depoladir(sahip)
 dene(alet.visible, "Eski görev sahibinin kapanması yeni kullanımını gizlemez")
 m.depoladir(diger)
 dene(not alet.visible, "Gece/uyku işi bitince stokta")
 var eksik := KarakterModel.new()
 root.add_child(eksik)
 dene(KarakterEkipmanYoneticisi.al(eksik) == null, "Fallback'a sahte el kemiği eklenmez")
 f.queue_free()
 eksik.queue_free()
 await process_frame
 print("KARAKTER EKİPMAN: GEÇTİ" if hata == 0 else "KARAKTER EKİPMAN: KALDI")
 quit(hata)
