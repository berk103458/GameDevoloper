## CAS-05: çekirdekte tek kur çağrısı; aynı köyün üstünde modal duruşma.
class_name DivanBaglantisi
extends RefCounted
## Mevcut sağ eylem sütununa tek düğme.
static func kur(e: KoyEkrani,v: VBoxContainer) -> void:
 var b := Button.new()
 b.name = "divan_ac"
 b.text = "Muhafız Divanı"
 b.custom_minimum_size.y = 42
 b.tooltip_text = "Meydanda gözlenmiş fiil tutanaklarını incele; şüphe tek başına hüküm değildir."
 v.add_child(b)
 b.pressed.connect(func() -> void: ac(e))
## Aynı gece/olay modalı sırasında veya ikinci divanda giriş yok. Hız/pausa/kamera kapanışta geri gelir.
static func ac(e: KoyEkrani) -> DivanEkrani:
 if e._gece_kilidi.kilitli() or e._ust_kart != null or e.has_node("DivanEkrani") or e.has_node("MuhafizOdasiEkrani") or e.oturum.yonetim.son != "": return null
 var eski_hiz := 0 if e.get_tree().paused else int(Engine.time_scale)
 e._hiz_sec(0)
 var s := e.sahne3b
 var hedef := s.hedef
 var uzaklik := s.uzaklik
 var meydan := DivanMeydani.kur(s)
 s.hedef = meydan.position+s.kamera.global_basis.x*float(DivanMeydani.AYAR.kamera_sag_kaydir)
 s.uzaklik = float(DivanMeydani.AYAR.kamera_uzaklik)
 s._kamera_yerlestir()
 var d := preload("res://src/kapi/divan_ekrani.tscn").instantiate() as DivanEkrani
 d.oturum = e.oturum
 d.kisi_secildi.connect(func(id: int) -> void: DivanMeydani.goster(s,meydan,id))
 e.add_child(d)
 d.tree_exiting.connect(func() -> void:
  if is_instance_valid(meydan):
   DivanMeydani.temizle(s,meydan)
   meydan.queue_free()
  if is_instance_valid(e) and e.is_inside_tree() and not e.is_queued_for_deletion():
   s.hedef = hedef
   s.uzaklik = uzaklik
   s._kamera_yerlestir()
   e._hiz_sec(eski_hiz)
   if d.get_meta("hukum_verildi",false): e._yenile()
 )
 return d
