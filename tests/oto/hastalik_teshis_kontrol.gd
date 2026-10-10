## KRI-11: gerçek kapı yüz/heybe/CHR düğmeleri → kilit → karantinalı kabul → kayıt.
extends Node
const T := preload("res://src/kapi/hastalik_teshis_adaptoru.gd")
var hata := 0

func _ready() -> void:
	get_tree().create_timer(90.0).timeout.connect(func() -> void: get_tree().quit(1))
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 711)
	var y := o.yonetim
	var kok := Control.new()
	var a := Ayarlar.new("user://unused_kri11.cfg")
	a.degerler[&"belirme_hizi"] = &"aninda"
	kok.theme = Tema.olustur(a)
	add_child(kok)
	var e := KapiEkrani.new()
	e.oturum = o
	e.ayarlar = a
	kok.add_child(e)
	var g := Gelen.new()
	g.ad_anahtari = "Ateşli ziyaretçi"
	g.portre = "farmer_01"
	g.acik_bayraklar = ["humma", "belirti_kanli_oksuruk"]
	g.secenekler = ["kabul", "ret", "rusvet"]
	g.heybe = Heybe.new()
	e._gelen = g
	e._karar_goster()
	await get_tree().process_frame
	_kontrol(e._karar_dugmeleri[0].disabled and not e._karar_dugmeleri[1].disabled, "Açık belirtili kabul kilitli, ret açık")
	var sabit := o.kaydet()
	e._karar_bas("kabul")
	e._karar_ver("rusvet")
	_kontrol(o.kaydet() == sabit and e.evre == &"karar" and e._secili.is_empty(), "Klavye/zorlanmış rüşvet de atomik kilitli")
	(e._eylemler.get_node("HastalikIncele") as Button).pressed.emit()
	await get_tree().process_frame
	_kontrol(T.kaydet(g).size() == 1 and e._kayit.get_parsed_text().contains("enfeksiyon şüphesi"), "Gerçek yüz düğmesi ibreyi ve Clue'yu açar")
	_kontrol(e._karar_dugmeleri[0].disabled, "İnceleme tek başına Şifahane oluşturmaz")
	# Gerçek heybe panelindeki öksürük bezi yüzeyi ayrı ikinci ipucudur.
	e._heybe_ac()
	await get_tree().create_timer(0.8).timeout
	(e._heybe_paneli.get_node("HastalikHeybeIncele") as Button).pressed.emit()
	_kontrol(T.kaydet(g).size() == 2 and (e._heybe_paneli.get_node("HastalikIbre") as Label).text.contains("kan"), "Heybe düğmesi kanlı öksürük ipucunu keşfeder")
	await _foto("kri11_heybe")
	e._heybe_paneli.kapandi.emit()
	await get_tree().process_frame
	var sif := _kur(y)
	var hekim := y.kabul({"ad": "Hekim"})
	hekim.zanaat_turu = ZanaatTuru.Tur.CERRAH
	_kontrol(y.ata(hekim.id, sif.id), "Gerçek hazır Şifahane ve hekim")
	y.kaynaklar.ekle("gida", 30)
	e._karar_goster()
	await get_tree().process_frame
	_kontrol(not e._karar_dugmeleri[0].disabled and e._karar_dugmeleri[0].alt_yazi.contains("karantina"), "Kabul satırı süre/bedelle açılır")
	await e.sahne.gelen_yaklas(e._model_adi(g))
	await _foto("kri11_karar")
	var adet := y.nufus()
	var gida := y.kaynaklar.miktar("gida")
	e._karar_dugmeleri[0].pressed.emit()
	e._karar_dugmeleri[0].pressed.emit()
	await get_tree().process_frame
	var k: Koylu = y.koylular.back()
	_kontrol(y.nufus() == adet+1 and KarantinaYoneticisi.aktif(k) and y.kaynaklar.miktar("gida") == gida-1, "İki adımlı gerçek kapı kabulünde tek kişi/tek bedel")
	_kontrol(SaglikYoneticisi.hasta(k) and not SaglikYoneticisi.temas_edebilir(y,k) and e._kayit.get_parsed_text().contains("karantina başladı"), "Hastalığı korunur; sonuç metni ve temas engeli")
	await e.gece_bitti
	var kayit := GuvenliKayit.new("user://test_kri11_akis.json")
	_kontrol(kayit.yaz(o.kaydet()), "Gerçek güvenli kayıt")
	var geri := Oturum.kayittan(kat, kayit.oku())
	_kontrol(geri.yonetim.koylu(k.id).karantina == k.karantina and geri.yonetim.koylu(k.id).enfeksiyon == k.enfeksiyon, "Devam aynı karantina ve enfeksiyonla döner")
	kayit.sil()
	# CHR inceleme portresi mevcut sinyal ve servis üzerinden aynı ibreyi çalıştırır.
	var chr := o._adli_gelen(&"chr_008")
	chr.acik_bayraklar = ["belirti_ates"]
	e._gelen = chr
	e._sohbet_goster()
	await get_tree().process_frame
	(e._eylemler.get_child(0) as Button).pressed.emit()
	await get_tree().process_frame
	var panel := e.get_node("ChrInceleme") as Control
	(panel.find_child("GorselIz", true, false) as BaseButton).pressed.emit()
	_kontrol(chr.chr_sorgusu().ipuclari.has(&"Clue_Enfeksiyon_Ates") and (panel.find_child("HastalikIbre", true, false) as Label).text.contains("şüphe"), "CHR portre tıklaması aynı IpucuYoneticisi'ne yazar")
	await _foto("kri11_chr")
	panel.queue_free()
	await get_tree().process_frame
	# Gizli kuluçka ve sağlıklı kişinin incelemesi/karar kilidi eşittir.
	var gizli := Gelen.new()
	gizli.ad_anahtari = "Gizli kuluçka"
	gizli.gizli_bayraklar = ["veba"]
	gizli.secenekler = ["kabul", "ret"]
	e._gelen = gizli
	e._karar_goster()
	await get_tree().process_frame
	(e._eylemler.get_node("HastalikIncele") as Button).pressed.emit()
	await get_tree().process_frame
	_kontrol(T.kaydet(gizli).is_empty() and not e._karar_dugmeleri[0].disabled and T.metin(gizli) == T.metin(Gelen.new()), "Gerçek UI gizli kuluçkayı ifşa etmez")
	kok.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.8).timeout
	print("KAPI HASTALIK UI: GEÇTİ" if hata == 0 else "KAPI HASTALIK UI: KALDI")
	await Ses.cik(hata)

func _kur(y: KoyYonetimi) -> KoyBinasi:
	for tur in ["odun","tas","kereste"]: y.kaynaklar.ekle(tur,30)
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx,cy)
			if y.yerlesim("sifahane",h).olur:
				var b := y.bina(y.bina_kur("sifahane",h).id)
				b.insa_kalan = 0
				return b
	return null

func _foto(ad: String) -> void:
	var yol := OS.get_environment("ADMIN_TEST_CIKTI")
	if yol.is_empty() or DisplayServer.get_name() == "headless": return
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(yol.path_join(ad + ".png"))

func _kontrol(ok: bool, mesaj: String) -> void:
	if not ok:
		hata += 1
		push_error(mesaj)
