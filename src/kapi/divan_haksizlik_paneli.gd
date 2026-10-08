## CAS-10 aynı divan listesinde iddia uyarısı veya tek kamu onarım düğmesi.
class_name DivanHaksizlikPaneli
extends RefCounted
## Duruşma alt metni gerçek hüküm/onarım durumunu söyler.
static func aciklama(y: KoyYonetimi,id: int) -> String:
 if DivanHukmu.verildi(y,id): return "Zindan hükmü kayıtta. Haksız yargı tazminatı ve tahliye bekleniyor."
 if DivanOturumu.izler(y,id).is_empty(): return "Kanıtsız iddia incelemesi; henüz hüküm verilmedi."
 return "Tutanak incelemesi; henüz hüküm verilmedi."
static func kur(e: DivanEkrani,v: VBoxContainer,id: int) -> void:
 if v.has_node("divan_haksizlik"):
  var eski:=v.get_node("divan_haksizlik")
  v.remove_child(eski)
  eski.queue_free()
 var n:=VBoxContainer.new()
 n.name="divan_haksizlik"
 v.add_child(n)
 var y:=e.oturum.yonetim
 if DivanHaksizligi.suphe(y,id) and DivanOturumu.izler(y,id).is_empty():
  var l:=Label.new()
  l.text="İmzasız iddia, kanıt yok. Zindana atmak haksız yargıdır: köydeki doğrulanmış aile üyeleri ayrılır, moral %d, adalet %d." % [int(DivanHaksizligi.AYAR.moral),int(DivanHaksizligi.AYAR.adalet)]
  l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
  n.add_child(l)
 if DivanHaksizligi.durum(y).has(str(id)) and not DivanHaksizligi.odendi(y,id):
  var b:=Button.new()
  b.name="haksiz_tazmin"
  b.text="%d kamu akçesi tazmin et · serbest bırak" % int(DivanHaksizligi.AYAR.tazminat)
  b.disabled=not DivanHaksizligi.onarilabilir(e.oturum,id)
  b.custom_minimum_size.y=44
  n.add_child(b)
  b.pressed.connect(func() -> void:
   if DivanHaksizligi.tazmin(e.oturum,id):
    e.set_meta("hukum_verildi",true)
    e.queue_free()
  )
