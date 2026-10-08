## CAS-07: aynı duruşmada üç hüküm, stat dengesi önceden görünür.
class_name DivanHukumPaneli
extends RefCounted
static func kur(e: DivanEkrani,v: VBoxContainer,id: int) -> void:
 if v.has_node("divan_hukum"):
  var eski:=v.get_node("divan_hukum")
  v.remove_child(eski)
  eski.queue_free()
 var n:=VBoxContainer.new()
 n.name="divan_hukum"
 v.add_child(n)
 for karar in DivanHukmu.KARARLAR:
  var a: Dictionary=DivanHukmu.AYAR[karar]
  var b:=Button.new()
  b.name="hukum_"+String(karar)
  b.text="%s · Asayiş riski %+d · Moral %+d" % [String(a.ad),int(a.asayis),int(a.moral)]
  b.custom_minimum_size.y=42
  b.disabled=not DivanHukmu.uygun(e.oturum,id,String(karar))
  b.tooltip_text="Tek hüküm. Zindan hücresinde %d yer kalır; tutsak çalışmaz, gıda tüketir. Sürgün ve infaz köy nüfusundan çıkarır." % DivanHukmu.kalan(e.oturum.yonetim)
  n.add_child(b)
  b.pressed.connect(func() -> void:
   if DivanHukmu.uygula(e.oturum,id,String(karar)):
    e.set_meta("hukum_verildi",true)
    e.kapandi.emit()
    e.queue_free()
  )
