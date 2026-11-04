## ODA-08: mevcut oda listesinde geliştirme/dinlenme; kutu görseli tek JSON yolu.
class_name OdaGelistirmePaneli
extends RefCounted
## Aynı panel yenilenir; satın alınan kutular çoğaltılmaz.
static func kur(e: MuhafizOdasiEkrani,v: VBoxContainer) -> void:
 var indeks:=v.get_child_count()
 if v.has_node("oda_gelistirmeleri"):
  var once:=v.get_node("oda_gelistirmeleri")
  indeks=once.get_index()
  v.remove_child(once)
  once.queue_free()
 var n:=VBoxContainer.new()
 n.name="oda_gelistirmeleri"
 n.add_theme_constant_override("separation",12)
 v.add_child(n)
 v.move_child(n,indeks)
 var l:=Label.new()
 l.name="oda_yorgunluk"
 l.text="Muhafız yorgunluğu: %d/%d · sorguda etkin tecrübe %d/%d. Her karar +%d, gece +%d; oda dinlenmesi bu yükü azaltır."%[int(MuhafizOdaGelisimi.oku(e.oturum.oda_gelisimi).yorgunluk),int(MuhafizOdaGelisimi.AYAR.yorgunluk_azami),MuhafizOdaGelisimi.etkin_tecrube(e.oturum),e.oturum.muhafiz_tecrubesi,int(MuhafizOdaGelisimi.AYAR.karar_yorgunluk),int(MuhafizOdaGelisimi.AYAR.gece_yorgunluk)]
 l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 n.add_child(l)
 for id in MuhafizOdaGelisimi.GELISTIRMELER:
  var a: Dictionary=MuhafizOdaGelisimi.AYAR[id]
  var b:=Button.new()
  b.name="oda_gelistir_"+id
  b.text=String(a.ad)+(" · alındı" if MuhafizOdaGelisimi.var_mi(e.oturum,id) else " · %d kişisel akçe"%int(a.bedel))
  b.disabled=not MuhafizOdaGelisimi.alinabilir(e.oturum,id)
  b.add_theme_color_override("font_disabled_color",Renkler.KUL)
  b.custom_minimum_size.y=48
  b.tooltip_text="Alım yorgunluğu sıfırlar; gece dinlenmesi −%d. Önkoşul: %s."%[int(a.dinlenme),"yok" if String(a.on_kosul).is_empty() else String(MuhafizOdaGelisimi.AYAR[a.on_kosul].ad)]
  n.add_child(b)
  b.pressed.connect(func() -> void:
   if MuhafizOdaGelisimi.al(e.oturum,id):
    OdaKasasiPaneli.guncelle(e)
    OdaYetenekPaneli.kur(e,v)
    kur(e,v)
  )
 var dinlen:=Button.new()
 dinlen.name="oda_dinlen"
 dinlen.text="Yatakta dinlen · günde bir kez"
 var d:=MuhafizOdaGelisimi.oku(e.oturum.oda_gelisimi)
 dinlen.disabled=e.oturum.yonetim.son!="" or not MuhafizOdaGelisimi.var_mi(e.oturum,"yatak") or int(d.yorgunluk)<=0 or int(d.son_dinlenme)>=e.oturum.gun
 dinlen.add_theme_color_override("font_disabled_color",Color("94999e"))
 dinlen.tooltip_text="Yatak ve yorgunluk gerekir; aynı gün tekrar dinlenilmez."
 dinlen.custom_minimum_size.y=48
 n.add_child(dinlen)
 dinlen.pressed.connect(func() -> void:
  if MuhafizOdaGelisimi.dinlen(e.oturum): kur(e,v)
 )
 gorsel(e)

## Var olan yatak renklendirilir; askılık/kütüphane aynı odanın kutu API'sini kullanır.
static func gorsel(e: MuhafizOdasiEkrani) -> void:
 for id in MuhafizOdaGelisimi.GELISTIRMELER:
  if not MuhafizOdaGelisimi.var_mi(e.oturum,id): continue
  var a: Dictionary=MuhafizOdaGelisimi.AYAR[id]
  if id=="yatak":
   var b:=e.oda.get_node("yatak") as MeshInstance3D
   if b != null:
    (b.material_override as StandardMaterial3D).albedo_color=Color(String(a.renk))
  elif not e.oda.has_node(id): e.oda.call("_kutu",a.parca)
