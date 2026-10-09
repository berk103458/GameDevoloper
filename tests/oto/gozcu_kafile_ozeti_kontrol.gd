extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar=Ayarlar.new("user://unused_har13.cfg")
		katalog=Katalog.new()
		katalog.yukle()
		oturum=Oturum.new(katalog,1932)
		kayit=GuvenliKayit.new("user://test_har13_ui.json")
		theme=Tema.olustur(ayarlar)

func _ready() -> void:
	process_mode=Node.PROCESS_MODE_ALWAYS
	get_tree().create_timer(60).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var o := ana.oturum
	var y := o.yonetim
	o.ayarlar=o.ayarlar.duplicate(true); y.a=y.a.duplicate(true)
	y.akce=100; y.kaynaklar.kapasite=1000
	for tur in ["odun","tas","kereste","gida","su"]: y.kaynaklar.ekle(tur,100)
	var kule: KoyBinasi
	for yy in y.a.izgara_boyut.y:
		for x in y.a.izgara_boyut.x:
			var konum := Vector2i(x,yy)
			if not y.yerlesim(GozcuKulesi.TUR,konum).olur: continue
			var r := y.bina_kur(GozcuKulesi.TUR,konum)
			assert(r.olur)
			kule=y.bina(int(r.id))
			break
		if kule!=null: break
	assert(kule!=null)
	kule.insa_kalan=0
	var k := y.kabul({"ad":"Gözcü","sinif":"asker","stat":5})
	assert(y.ata(k.id,kule.id))
	y.gun=24; y.agalik=true
	y.a.harac_araligi=25; y.a.kervan_araligi=26
	o.ayarlar.perde2_gece_basina_gelen=12
	o.muhafiz_akce=41
	o.set_meta(DiplomatikHeyet.META,{"tekfur_gun":18,"mogol":[2]})
	ana._koye_git()
	await get_tree().process_frame
	var e := ana._ekran as KoyEkrani
	e._hiz_sec(2)
	var once := JSON.stringify(o.kaydet())
	var rng := [o._rng.state,o._rng_donus.state,o._rng_ad.state,o._rng_heybe.state,y._rng.state]
	e.find_children("harita_ac","Button",true,false)[0].pressed.emit()
	var h := e.get_node("HaritaEkrani") as HaritaEkrani
	assert(h!=null and get_tree().paused)
	await get_tree().process_frame
	var metin := h._bilgi.text
	assert(metin.contains("Gözcü öngörüsü · 26. gün") and metin.contains("Kafile özeti:"))
	assert(metin.contains("Gezgin tüccar: 1 · Heyet: 2"))
	assert(metin.contains("Öncelikli heyet: Moğol öncü heyeti") and metin.contains("Öncelikli heyet: Tekfur haraç heyeti"))
	assert(metin.find("Moğol öncü heyeti",metin.find("Kafile özeti:"))<metin.find("Tekfur haraç heyeti",metin.find("Kafile özeti:")))
	assert(not metin.to_lower().contains("chr_") and not metin.contains("Flag_") and not metin.contains("Clue_"))
	assert(e.find_children("harita_bolge_bilgi","Label",true,false).size()==1 and HaritaBaglantisi.ac(e)==null)
	# Aynı gerçek bölge düğmeleri; geri seçim özeti yeniler, ikinci HUD oluşmaz.
	h.find_children("sec_tekfur","Button",true,false)[0].pressed.emit()
	assert(not h._bilgi.text.contains("Kafile özeti:"))
	h.find_children("sec_hisar","Button",true,false)[0].pressed.emit()
	assert(h._bilgi.text==metin and JSON.stringify(o.kaydet())==once)
	assert([o._rng.state,o._rng_donus.state,o._rng_ad.state,o._rng_heybe.state,y._rng.state]==rng)
	h.find_children("harita_kapat","Button",true,false)[0].pressed.emit()
	await get_tree().process_frame
	assert(not get_tree().paused and Engine.time_scale==2 and not e.has_node("HaritaEkrani"))
	# Büyük yazıda aynı kaydırılabilir bilgi alanı ve ulaşılabilir geri düğmesi.
	ana.ayarlar.degerler[&"metin_olcegi"]=150
	h=HaritaBaglantisi.ac(e)
	await get_tree().process_frame
	await get_tree().process_frame
	assert(h._bilgi.text==metin and h._bilgi.get_theme_font_size("font_size")==ana.ayarlar.boyut(24))
	var kaydir := h._bilgi.get_parent().get_parent() as ScrollContainer
	assert(kaydir!=null)
	kaydir.scroll_vertical=10000
	await get_tree().process_frame
	assert(kaydir.scroll_vertical>0)
	assert((h.find_children("harita_kapat","Button",true,false)[0] as Button).get_global_rect().end.y<=get_viewport().get_visible_rect().end.y)
	assert(JSON.stringify(o.kaydet())==once)
	h.queue_free()
	await get_tree().process_frame
	# Sonraki açılış kule koşulunu yeniden okur; eski özet ekranda kalmaz.
	k.bayrak_ekle("zindanda")
	h=HaritaBaglantisi.ac(e)
	assert(h._bilgi.text.contains("öngörüsü kapalı") and not h._bilgi.text.contains("Kafile özeti:"))
	h.queue_free()
	await get_tree().process_frame
	k.bayraklar.clear()
	y.gun=0; y.agalik=false
	h=HaritaBaglantisi.ac(e)
	assert(h._bilgi.text.contains("Heyet: 0") and not h._bilgi.text.contains("Öncelikli heyet:"))
	h.queue_free()
	await get_tree().process_frame
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	print("GOZCU KAFILE UI: GEÇTİ")
	await Ses.cik(0)
