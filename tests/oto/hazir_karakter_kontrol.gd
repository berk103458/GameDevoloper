extends Node
func _ready() -> void:
 get_tree().create_timer(30).timeout.connect(func(): get_tree().quit(1))
 for ad in ["lowpo_demirci", "chr_006"]:
  var k := Dunya3B.karakter(ad)
  assert(k is HazirKarakterModeli and k.has_meta("hazir_kaynak"))
  add_child(k)
  await get_tree().process_frame
  var boy := Dunya3B.boyut(k.get_child(0)).y
  print(ad, " body size=", Dunya3B.boyut(k.get_child(0)))
  assert(absf(boy - (1.8 if ad == "lowpo_demirci" else 1.15)) < 0.01)
  var sk: Skeleton3D = k.find_children("*", "Skeleton3D", true, false)[0]
  assert(sk.find_bone("RightHand") >= 0 and sk.find_bone("LeftFoot") >= 0)
  for mesh in k.find_children("*", "MeshInstance3D", true, false):
   if mesh.skin != null:
    for i in mesh.skin.get_bind_count():
     var bind: String = mesh.skin.get_bind_name(i)
     assert(bind.is_empty() or sk.find_bone(bind) >= 0)
  for isim in ["bekle", "yuru", "calis", "dov", "konus"]:
   var anim: Animation = k._oynatici.get_animation(isim)
   assert(anim != null and anim.length > 0 and anim.get_track_count() >= 17)
   for iz in anim.get_track_count():
    var kemik := sk.find_bone(String(anim.track_get_path(iz).get_concatenated_subnames()))
    assert(kemik >= 0)
    if anim.track_get_type(iz) == Animation.TYPE_POSITION_3D:
     assert(sk.get_bone_name(kemik) == "Hips")
     var referans := sk.get_bone_rest(kemik).origin
     for key in anim.track_get_key_count(iz):
      var v: Vector3 = anim.track_get_key_value(iz,key)
      var dunya_farki := sk.global_transform.basis * (v-referans)
      assert(absf(dunya_farki.x)<0.001 and absf(dunya_farki.z)<0.001)
   k._oynatici.play(isim)
   k._oynatici.seek(anim.length * 0.4, true)
   sk.force_update_all_bone_transforms()
   for i in sk.get_bone_count():
    assert(sk.get_bone_global_pose(i).origin.is_finite())
  k.dur()
  assert(k._oynatici.current_animation == "bekle")
  k.calis(&"dov")
  assert(k._oynatici.current_animation == "dov")
  k.yuru(k.position + Vector3(0.2,0,0), 1.9)
  assert(k._oynatici.current_animation == "yuru")
  await get_tree().process_frame
  assert(k.duzeltici().influence == 0.0)
  k.yurumeyi_durdur()
  if ad == "chr_006": assert(k.get_meta("yas_grubu") == &"cocuk")
  k.queue_free()
  await get_tree().process_frame
 var kisi := Koylu.new()
 kisi.zanaat_turu = ZanaatTuru.Tur.DEMIRCI
 assert(HazirKarakterler.koy_adi(kisi,"esnaf") == "lowpo_demirci")
 kisi.adli_id=&"chr_003"
 assert(HazirKarakterler.koy_adi(kisi,"chr_003") == "chr_003")
 var y := KoyYonetimi.new(KoyAyarlari.new(), BinaKatalogu.new(), 28)
 var k := y.kabul({"sinif":"esnaf", "stat":5})
 k.zanaat_turu = ZanaatTuru.Tur.ESNAF
 var sahne := KoyYonetimSahnesi.new()
 sahne.yonetim = y
 add_child(sahne)
 var h := sahne.halk_hareketi
 h.set_process(false)
 await get_tree().process_frame
 var yer: Transform3D = h.modeller[k.id].transform
 k.zanaat_turu = ZanaatTuru.Tur.DEMIRCI
 var once := JSON.stringify(y.kaydet())
 var rng := y._rng.state
 h.yenile()
 assert(h.modeller[k.id] is HazirKarakterModeli)
 assert(h.modeller[k.id].transform.is_equal_approx(yer))
 assert(JSON.stringify(y.kaydet()) == once and y._rng.state == rng)
 sahne.queue_free()
 await get_tree().process_frame
 print("HAZIR KARAKTER: GEÇTİ")
 await Ses.cik()
