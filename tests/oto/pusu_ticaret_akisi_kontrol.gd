## Gerçek pazar temizliği → kayıt → harita öngörüsü → gece düğmesi → kapı kararı.
extends Node
const AKIS = preload("res://src/koy/ticaret/pusu_ticaret_akisi.gd")
const OZET = preload("res://src/sistemler/gozcu_kafile_ozeti.gd")
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar=Ayarlar.new("user://unused_har14.cfg")
		katalog=Katalog.new(); katalog.yukle()
		oturum=Oturum.new(katalog,1942)
		kayit=GuvenliKayit.new("user://test_har14_ui.json")
		theme=Tema.olustur(ayarlar)

func _ready() -> void:
	process_mode=Node.PROCESS_MODE_ALWAYS
	get_tree().create_timer(60).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new(); add_child(ana)
	var o := ana.oturum; var y := o.yonetim
	o.ayarlar=o.ayarlar.duplicate(true); y.a=y.a.duplicate(true)
	o.ayarlar.gece_basina_gelen=12; o.ayarlar.adli_olasiligi=0.0
	o._gemini_sira=20 # Hazır diyalog sonrası gerçek esnaf ağırlığı; kaynak liste değişmez.
	y.akce=100; y.kaynaklar.kapasite=2000
	for tur in ["odun","tas","kereste","gida","su"]: y.kaynaklar.ekle(tur,150)
	var kule: KoyBinasi
	for yy in y.a.izgara_boyut.y:
		for x in y.a.izgara_boyut.x:
			var konum := Vector2i(x,yy)
			if not y.yerlesim(GozcuKulesi.TUR,konum).olur: continue
			var r := y.bina_kur(GozcuKulesi.TUR,konum)
			kule=y.bina(int(r.id)); break
		if kule!=null: break
	assert(kule!=null); kule.insa_kalan=0
	var gozcu := y.kabul({"ad":"Gözcü","sinif":"asker","stat":5})
	assert(y.ata(gozcu.id,kule.id))
	for i in 2:
		var k := y.kabul({"ad":"Pusu nöbetçisi %d" % i,"sinif":"asker","stat":5})
		y.muhafiz_ata(k.id)
	o.gun=2; y.husumet.puan=y.a.sizma_esigi
	ana._koye_git(); await get_tree().process_frame
	var e := ana._ekran as KoyEkrani
	e._pazar_ac(); await get_tree().process_frame
	var dugme := e.find_child("goc_yolu_temizle",true,false) as Button
	assert(dugme!=null and not dugme.disabled)
	dugme.pressed.emit(); await get_tree().process_frame
	dugme=e.find_child("goc_yolu_temizle",true,false) as Button
	assert(dugme.disabled and AKIS.durum(o).bitis==6 and not AKIS.aktif(o))
	var metin := ""
	for l in e.find_children("*","Label",true,false): metin+=l.text+"\n"
	assert(metin.contains("yarından itibaren 3 gün") and metin.contains("varış garantisi yok"))
	var once := JSON.stringify(o.kaydet())
	dugme.pressed.emit(); assert(JSON.stringify(o.kaydet())==once)
	assert(ana.kayit.yaz(o.kaydet()))
	var z := Oturum.kayittan(ana.katalog,ana.kayit.oku())
	assert(z!=null and AKIS.durum(z)==AKIS.durum(o) and not GocYoluGuvenligi.temizle(z).ok)
	e._kart_kapat(); await get_tree().process_frame
	var ongoru := GozcuOngoru.durum(o)
	assert(ongoru.aktif and ongoru.ozet.ticaret_yolcusu>0 and ongoru.ozet.tuccar==1)
	e.find_children("harita_ac","Button",true,false)[0].pressed.emit()
	var h := e.get_node("HaritaEkrani") as HaritaEkrani
	assert(h._bilgi.text.contains("ticaret yolcusu (esnaf): %d" % int(ongoru.ozet.ticaret_yolcusu)))
	h.find_children("sec_goc_yolu","Button",true,false)[0].pressed.emit()
	assert(h._bilgi.text.contains("yarından itibaren 3 gün") and JSON.stringify(o.kaydet())==once)
	h.find_children("harita_kapat","Button",true,false)[0].pressed.emit()
	await get_tree().process_frame
	e._gece_dugmesi.pressed.emit()
	assert(o.gun==3 and AKIS.aktif(o))
	var liste := o.gece_kuyrugu()
	assert(OZET.kuyruktan(liste)==ongoru.ozet)
	assert(TuccarKapiGecisi.ilgilenir(liste[0]) and y.tuccar_girisi.karar=="bekliyor")
	# Ticaret yolcusu aynı normal kapı karar UI'sında; uzman bacı verilmez.
	var esnaf: Gelen
	for g in liste:
		if g.sinif==&"esnaf" and not TuccarKapiGecisi.ilgilenir(g): esnaf=g; break
	assert(esnaf!=null and esnaf.heybe!=null)
	var kapi := KapiEkrani.new(); kapi.oturum=o; kapi.ayarlar=ana.ayarlar
	ana._goster(kapi)
	kapi._gelen=esnaf; kapi._ad.text=o.tr_gelen(esnaf)
	await kapi.sahne.gelen_yaklas(kapi._model_adi(esnaf))
	kapi._karar_goster()
	var nufus := y.nufus(); var kamu := o.koy_akce; var kisisel := o.muhafiz_akce
	var ret := kapi._karar_dugmeleri[kapi._karar_anahtarlari.find("ret")]
	ret.pressed.emit()
	assert(kapi._secili=="ret" and kapi.evre==&"karar")
	ret.pressed.emit() # Gerçek iki adımlı karar onayı ve çıkış animasyonu.
	if kapi.evre!=&"gecis": await kapi.gece_bitti
	assert(kapi.evre==&"gecis")
	assert(kapi.get_meta(&"sonuclanan_gelen")==esnaf)
	assert(y.nufus()==nufus and o.koy_akce==kamu-1 and o.muhafiz_akce==kisisel) # Eski esnaf ret etkisi -1 kamu; yeni bac/ödül yok.
	assert(y.tuccar_girisi.karar=="bekliyor")
	ana.kayit.sil(); ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	print("PUSU TICARET AKISI UI: GEÇTİ")
	await Ses.cik(0)
