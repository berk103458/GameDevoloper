## ODA-02: gizli zemin kasası mevcut kişisel kesenin oda yüzeyidir; ikinci cüzdan yok.
class_name OdaKasasiPaneli
extends RefCounted
## Açma/kapama yalnız görünümü değiştirir; kişisel para ve eşya tek Oturum kaynağından okunur.
static func kur(e: MuhafizOdasiEkrani,v: VBoxContainer) -> void:
 var b:=Button.new()
 b.name="oda_kasa_ac"
 b.text="Zemin kasasını aç"
 b.toggle_mode=true
 b.custom_minimum_size.y=48
 v.add_child(b)
 var alan:=VBoxContainer.new()
 alan.name="oda_kasasi"
 alan.visible=false
 alan.add_theme_constant_override("separation",12)
 v.add_child(alan)
 var kese:=KeseGostergesi.new()
 kese.name="oda_kese"
 alan.add_child(kese)
 var esya:=Label.new()
 esya.name="oda_kasa_esya"
 esya.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 alan.add_child(esya)
 var notu:=Label.new()
 notu.text="Rüşvet ve kişisel gelirlerin burada saklı. Köy kasası ve kamu ambarı ayrıdır. Kapağı kapatmak yalnız kasayı gizler."
 notu.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 notu.add_theme_font_size_override("font_size",Tema.KUCUK_PX)
 alan.add_child(notu)
 var kapak:=e.oda.get_node("gizli_kasa") as MeshInstance3D
 var once:=kapak.transform
 b.toggled.connect(func(acik: bool) -> void:
  alan.visible=acik
  b.text="Kasayı kapat" if acik else "Zemin kasasını aç"
  kapak.transform=once
  if acik:
   kapak.rotation_degrees.x=float(MuhafizOdasi.AYAR.kasa_acik_aci)
   kapak.position.y+=float(MuhafizOdasi.AYAR.kasa_acik_y)
   kese.guncelle(e.oturum)
   var adet:=0
   for kayit in e.oturum.muhafiz_esyalari: adet+=maxi(0,int(kayit.get("adet",0)))
   esya.text="Kişisel eşya: %d adet"%adet
 )
