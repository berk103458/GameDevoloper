extends Node
func bekle(e: KapiEkrani,tur: String) -> void:
 for i in 300:
  if e.evre==&"karar" and DiplomatikHeyet.bilet(e._gelen).get("tur","")==tur: return
  await get_tree().create_timer(0.05).timeout
 assert(false,"Heyet gerçek kapıya ulaşamadı: "+tur)
func _ready() -> void:
 process_mode=Node.PROCESS_MODE_ALWAYS
 get_tree().create_timer(60).timeout.connect(func() -> void: get_tree().quit(1))
 var kat:=Katalog.new();kat.yukle()
 var o:=Oturum.new(kat,1922)
 var y:=o.yonetim
 y.agalik=true;y.harac_bekliyor=true;y.gun=25;y.akce=9;y.kaynaklar.stok.bugday=20
 o.mogol_oncusu={"son_gece":25,"uyarilar":[5]}
 o.muhafiz_akce=100
 var kok:=Control.new()
 kok.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 var a:=Ayarlar.new("user://unused_heyet.cfg")
 kok.theme=Tema.olustur(a)
 add_child(kok)
 var e:=KapiEkrani.new()
 e.oturum=o;e.ayarlar=a
 kok.add_child(e)
 DiplomatikHeyet.ekle(o,e._kuyruk)
 var adlar: Array[String]=[]
 for g in e._kuyruk: adlar.append(e._model_adi(g))
 e.sahne.kuyruk_doldur(adlar)
 var bitti: Array[bool]=[false]
 e.gece_bitti.connect(func(_r: Dictionary) -> void: bitti[0]=true)
 e._siradaki()
 await bekle(e,"mogol")
 var ilk:=e._gelen
 var kuyruk:=e._kuyruk.duplicate()
 var once:=JSON.stringify(o.kaydet())
 e._siradaki()
 assert(e._gelen==ilk and e._kuyruk==kuyruk and not bitti[0])
 assert(not await preload("res://src/kapi/sira_atlama_adaptoru.gd").uygula(e,"atlama",{"akce":2}))
 assert(JSON.stringify(o.kaydet())==once and e._gelen==ilk)
 e._karar_ver("ret")
 assert(e.evre==&"karar" and JSON.stringify(o.kaydet())==once)
 var kabul:=e._karar_dugmeleri[e._karar_anahtarlari.find("kabul")]
 assert(not kabul.disabled and kabul.text.contains("Heyeti dinle"))
 kabul.pressed.emit()
 assert(e._secili=="kabul" and DiplomatikHeyet.gecis_engeli(o,ilk))
 kabul.pressed.emit()
 await bekle(e,"tekfur")
 assert(not DiplomatikHeyet.gecis_engeli(o,ilk) and y.harac_bekliyor and y.akce==9 and y.nufus()==0)
 var odeme:=e._karar_dugmeleri[e._karar_anahtarlari.find("harc")]
 assert(odeme.disabled and odeme.alt_yazi.contains("kamu"))
 once=JSON.stringify(o.kaydet())
 e._karar_ver("harc")
 assert(e.evre==&"karar" and JSON.stringify(o.kaydet())==once)
 y.akce=10
 e.hud.guncelle()
 e._karar_goster()
 odeme=e._karar_dugmeleri[e._karar_anahtarlari.find("harc")]
 assert(not odeme.disabled)
 var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
 if not dizin.is_empty() and DisplayServer.get_name()!="headless":
  await get_tree().create_timer(0.5).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png(dizin.path_join("har12_heyet.png"))
 odeme.pressed.emit();odeme.pressed.emit()
 for i in 300:
  if bitti[0]: break
  await get_tree().create_timer(0.05).timeout
 assert(bitti[0] and not y.harac_bekliyor and y.akce==0 and y.kaynaklar.miktar("bugday")==0 and o.muhafiz_akce==100 and y.nufus()==0)
 kok.queue_free()
 await get_tree().process_frame
 await get_tree().create_timer(0.5).timeout
 print("DIPLOMATIK HEYET UI: GEÇTİ")
 await Ses.cik(0)
