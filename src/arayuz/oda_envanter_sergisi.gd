## ODA-03: kişisel envanter tek Oturum kaydından salt okunur oda sergisi.
class_name OdaEnvanterSergisi
extends RefCounted

const MUHUR_IKON := "res://assets/art/icons/icon_stok_yasak_muhur.png"

## Her pozitif kayıt bir satır; miktar başına model üretilmez, 3B önizleme veri ayarlı üst sınırdadır.
static func kur(e: MuhafizOdasiEkrani,v: VBoxContainer) -> void:
 var baslik:=Label.new()
 baslik.text="Kişisel eşya sergisi"
 v.add_child(baslik)
 var grup:=Node3D.new()
 grup.name="kisisel_esya_sergisi"
 e.oda.add_child(grup)
 var sayi:=0
 for i in range(e.oturum.muhafiz_esyalari.size()):
  var kayit: Dictionary=e.oturum.muhafiz_esyalari[i]
  var adet:=maxi(0,int(kayit.get("adet",0)))
  if adet==0: continue
  var p:=PanelContainer.new()
  p.name="oda_esya_%d"%i
  p.set_meta("kayit_indeksi",i)
  p.add_theme_stylebox_override("panel",Kabuk.panel())
  v.add_child(p)
  var h:=HBoxContainer.new()
  h.add_theme_constant_override("separation",8)
  p.add_child(h)
  var ikon:=ColorRect.new()
  ikon.color=Color(String(MuhafizOdasi.AYAR.sergi_renk))
  ikon.custom_minimum_size=Vector2(28,28)
  ikon.mouse_filter=Control.MOUSE_FILTER_IGNORE
  var id_k:=String(kayit.get("id",kayit.get("tur","")))
  var yol:=String(GezginStokIkonu.DOKU.get(id_k,MUHUR_IKON))
  if not yol.is_empty() and ResourceLoader.exists(yol):
   ikon.self_modulate.a=0.0
   var tr:=TextureRect.new()
   tr.texture=load(yol)
   tr.modulate=Kabuk.BAR_DOLU
   tr.set_anchors_preset(Control.PRESET_FULL_RECT)
   tr.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
   tr.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
   tr.mouse_filter=Control.MOUSE_FILTER_IGNORE
   ikon.add_child(tr)
  h.add_child(ikon)
  var l:=Label.new()
  l.name="esya_adi"
  l.text="%s · %d adet"%[_ad(kayit),adet]
  var etiket: String = preload("res://src/koy/kisisel_iz.gd").raf_etiketi(kayit)
  if not etiket.is_empty(): l.text += " · " + etiket
  l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
  l.size_flags_horizontal=Control.SIZE_EXPAND_FILL
  h.add_child(l)
  if sayi<int(MuhafizOdasi.AYAR.sergi_azami): _kutu(grup,sayi)
  sayi+=1
 if sayi==0:
  var bos:=Label.new()
  bos.name="oda_envanter_bos"
  bos.text="Kişisel eşya yok."
  v.add_child(bos)

static func _ad(k: Dictionary) -> String:
 var ad:=String(k.get("ad",k.get("kaynak",""))).strip_edges()
 if not ad.is_empty() and not ad.begins_with("Clue_"): return ad
 var id:=String(k.get("id",k.get("tur","")))
 var anahtar:="esya."+id
 var ceviri:=String(TranslationServer.translate(StringName(anahtar)))
 return ceviri if ceviri!=anahtar else "Kişisel eşya"

static func _kutu(grup: Node3D,i: int) -> void:
 var n:=MeshInstance3D.new()
 n.name="esya_%d"%i
 var m:=BoxMesh.new()
 var a: Dictionary=MuhafizOdasi.AYAR
 m.size=Vector3(float(a.sergi_boyut[0]),float(a.sergi_boyut[1]),float(a.sergi_boyut[2]))
 n.mesh=m
 var renk:=StandardMaterial3D.new()
 renk.albedo_color=Color(String(a.sergi_renk))
 n.material_override=renk
 var sergi_modeller := ["hediye_bohcasi", "iksir_sisesi", "teslim_parcasi", "ahi_kusagi", "yemin_nesneleri", "ilac_kutusu", "kirik_kin", "muhur"]
 var s_ad: String = sergi_modeller[i % sergi_modeller.size()]
 if Dunya3B.model_var_mi(s_ad):
  renk.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
  renk.albedo_color = Color(0, 0, 0, 0)
  var glb_s := Dunya3B.nesne(s_ad, float(a.sergi_boyut[1]))
  glb_s.position.y = -float(a.sergi_boyut[1]) / 2.0
  n.add_child(glb_s)
 n.position=Vector3(float(a.sergi_yer[0])+float(i%int(a.sergi_sutun))*float(a.sergi_aralik),float(a.sergi_yer[1]),float(a.sergi_yer[2])+floor(float(i)/float(a.sergi_sutun))*float(a.sergi_aralik))
 grup.add_child(n)
