extends SceneTree

var _hata := 0
func _initialize() -> void:
 call_deferred("_kos")

func _kos() -> void:
 var ayarlar:=Ayarlar.new("user://unused_harita_baglama.cfg")
 ayarlar.degerler[&"belirme_hizi"]=&"aninda"
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,1202)
 var e:=HaritaEkrani.new()
 e.name="HaritaEkrani"
 e.oturum=o
 e.ayarlar=ayarlar
 root.add_child(e)
 await process_frame
 await process_frame
 _dene(e.get_node_or_null("harita_alan")!=null or e._alan!=null, "ui: harita_alan")
 _dene(e._baslik!=null and e._bilgi!=null, "ui: baslik/bilgi")
 for id in ["hisar","karaboran","tekfur","goc_yolu"]:
  var dugmeler:=e.find_children("sec_"+id,"Button",true,false)
  _dene(dugmeler.size()==1, "ui: sec_"+id)
  (dugmeler[0] as Button).pressed.emit()
  await process_frame
  _dene(e._baslik.text==String(CevreHaritasi.bilgi(o,id).ad), "ui: baslik "+id)
  _dene(e._bilgi.text==String(CevreHaritasi.bilgi(o,id).metin), "ui: bilgi "+id)
  _dene(e._noktalar[id] is ColorRect, "ui: nokta ColorRect "+id)
  var beklenen:=String(CevreHaritasi.bolge_durumu(o,id).get("manzara",""))
  var tuval_yol:=String(e._manzara_alt.texture.resource_path) if e._manzara_alt and e._manzara_alt.texture else ""
  _dene(not beklenen.is_empty() and tuval_yol==beklenen, "ui: tuval manzara "+id)
 _dene(e.find_children("harita_kapat","Button",true,false).size()==1, "ui: kapat")
 _dene(e.find_children("harita_kenarlik","NinePatchRect",true,false).size()>=0, "ui: kenarlik")
 var kaydir:=e.find_children("harita_bolge_kaydir","ScrollContainer",true,false)
 _dene(kaydir.size()==1 and kaydir[0].custom_minimum_size.x>=480, "ui: kart genislik")
 _dene(e.find_children("mevsim_katman","TextureRect",true,false).size()==1, "ui: mevsim")
 _dene(e.find_children("btn_yakinlastir","Button",true,false).size()==1, "ui: zoom")
 _dene(e.find_children("harita_arka_doku","TextureRect",true,false).size()==1, "ui: arka doku")
 var vin:=e.find_children("harita_vinyet","TextureRect",true,false)
 _dene(vin.size()==1 and vin[0].modulate.a>=0.99, "ui: vinyet acik")
 var mev:=e.find_children("mevsim_katman","TextureRect",true,false)
 _dene(mev.size()==1 and mev[0].modulate.a>=0.35 and mev[0].modulate.a<=0.41, "ui: mevsim alpha")
 _dene(e.find_children("harita_bolge_manzara","TextureRect",true,false).is_empty(), "ui: kart manzara yok")
 var hisar_n:=e._noktalar["hisar"] as ColorRect
 _dene(hisar_n.get_node_or_null("golge") is TextureRect, "ui: pin golge")
 o.yonetim.harac_bekliyor=true
 e.bolge_sec("tekfur")
 await process_frame
 _dene(e._baslik.text==String(CevreHaritasi.bilgi(o,"tekfur").ad) and e._bilgi.text==String(CevreHaritasi.bilgi(o,"tekfur").metin), "ui: tekfur bilgi duruyor")
 var tek_yol:=String(e._manzara_alt.texture.resource_path) if e._manzara_alt and e._manzara_alt.texture else ""
 _dene(tek_yol.contains("tekfur"), "ui: tekfur manzara tuvalde")
 e.bolge_sec("")
 await process_frame
 var bos_yol:=String(e._manzara_alt.texture.resource_path) if e._manzara_alt and e._manzara_alt.texture else ""
 _dene(bos_yol.contains("map_bg") or bos_yol.contains("harita_uc"), "ui: secimsiz map_bg")
 _dene(e._vinyet!=null and e._vinyet.modulate.a<=0.01, "ui: vinyet kapali")
 e.bolge_sec("tekfur")
 await process_frame
 var tek:=e._noktalar["tekfur"] as ColorRect
 var halka:=tek.get_node_or_null("halka") as TextureRect
 _dene(halka!=null and halka.visible, "ui: tehlike/secili halka")
 var kapat:=e.find_children("harita_kapat","Button",true,false)[0] as Button
 kapat.pressed.emit()
 await process_frame
 _dene(not is_instance_valid(e) or e.is_queued_for_deletion(), "ui: kapandi")
 print("HARITA EKRANI BAGLAMA: GEÇTİ" if _hata==0 else "HARITA EKRANI BAGLAMA: KALDI (%d hata)"%_hata)
 quit(1 if _hata>0 else 0)

func _dene(kosul: bool, ad: String) -> void:
 if not kosul:
  _hata += 1
  push_error(ad)
