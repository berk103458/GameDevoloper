extends Node
const F = preload("res://tests/oto/atama_duraklat_kontrol.gd")
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _ready() -> void:
	call_deferred("_calistir")
func kart(e: KoyEkrani, tur: String) -> YapiKarti:
	for c in e._yapi_satiri.get_children():
		if c is YapiKarti and c.get_meta("yapi_turu", "") == tur: return c
	return null
func _calistir() -> void:
	TranslationServer.set_locale("tr")
	get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := F.TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar = Kaynaklar.new(10000, {"odun":100,"tas":100,"kereste":100,"harc":100,"alet":100})
	y.akce = 1000
	var k := y.kabul({"ad": "Usta"})
	ana._koye_git()
	await get_tree().process_frame
	var e := ana._ekran as KoyEkrani
	var kilitli := kart(e, "tas_ev")
	dene(kilitli != null and kilitli.disabled and kilitli.tooltip_text.contains("Gerekli:"), "Bilgisiz K2 mevcut menüde kapalı ve bilgi metinli")
	dene(kilitli.modulate.r < 1.0 and kilitli.find_child("YapiKademeBilgisi", true, false).text.begins_with("K2"), "Kilitli kart grileşir ve mevcut harf kademesini gösterir")
	dene(kart(e, "cadir") != null and not kart(e, "cadir").disabled, "K0 baştan açık")
	e._imlec = Vector2i(5, 5)
	e._kip_sec("insa", "tas_ev")
	dene(e.kip.is_empty() and not e.sahne3b._hayalet.visible, "Kilitli yapıda kip/hayalet açılmaz")
	var hazir := KoyBinasi.new()
	hazir.id = 90
	hazir.tur = "kulube"
	hazir.hucre = Vector2i(2, 2)
	y.binalar.append(hazir)
	y.izgara.yerlestir(hazir.id, hazir.hucreler(y.katalog))
	k.yapi_bilgisi = YapiKilidi.bilgi_oku(["tas_ev", "nobetci_kulesi"])
	e._yenile()
	await get_tree().process_frame
	dene(not kart(e, "tas_ev").disabled, "Bilgi ve alt kademe kartı açar")
	e._kip_sec("insa", "tas_ev")
	dene(e.sahne3b._hayalet.visible, "Açık yapının mevcut hayaleti görünür")
	k.saglik = 0
	e._hayalet_guncelle()
	dene(not e.sahne3b._hayalet.visible, "Bilgi sahibi ölünce etkin hayalet de gizlenir")
	k.saglik = 100
	y.kaynaklar.stok.tas = 0
	e._yenile()
	await get_tree().process_frame
	dene(kart(e, "tas_ev").disabled, "Yetersiz malzemede kart kapalı")
	var foto := y.kaydet()
	dene(not y.bina_kur("tas_ev", Vector2i(5, 5)).olur and y.kaydet() == foto, "Yetersiz bedelde kurulum/borç/kayıt farkı0")
	y.kaynaklar.stok.tas = 100
	y.akce = 0
	e._kategori = "savunma"
	e._yenile()
	await get_tree().process_frame
	dene(kart(e, "nobetci_kulesi").disabled, "Akçe yetmeyince ücretli yapı kapalı")
	# Uzun gerçek yapı bilgisi: otuz boş işçinin atama satırları ve son yıkım düğmesi.
	var odun := KoyBinasi.new()
	odun.id = 91
	odun.tur = "odunluk"
	odun.hucre = Vector2i(8, 2)
	y.binalar.append(odun)
	for i in 30: y.kabul({"ad": "Uzun bilgi işçi %d" % i})
	# YAP-61: gerçek hız düğmeleri ve mevcut yapı bilgi penceresi.
	for hiz in [1, 2, 3, 0]:
		(e._hiz_dugmeleri[hiz] as Button).pressed.emit()
		var olcek := Engine.time_scale
		var duraklat := get_tree().paused
		dene(is_equal_approx(olcek, float(hiz) if hiz > 0 else 1.0) and duraklat == (hiz == 0), "YAP-61: hız gerçekten seçildi %d" % hiz)
		e._secili_bina = odun.id
		e._bilgi_goster()
		dene(e._bilgi.visible and Engine.time_scale == olcek and get_tree().paused == duraklat, "YAP-61: açık kart hız/duraklatmayı korur %d" % hiz)
		e._secili_bina = -1
		e._bilgi_goster()
		dene(not e._bilgi.visible and Engine.time_scale == olcek and get_tree().paused == duraklat, "YAP-61: kapanan kart hız/duraklatmayı korur %d" % hiz)
	(e._hiz_dugmeleri[1] as Button).pressed.emit()
	e._secili_bina = odun.id
	e._bilgi_goster()
	await get_tree().process_frame
	await get_tree().process_frame
	var kaydir := e._bilgi_icerik.get_parent() as ScrollContainer
	dene(kaydir.get_v_scroll_bar().max_value > kaydir.size.y, "Uzun yapı kartı gerçekten kayar")
	kaydir.scroll_vertical = int(kaydir.get_v_scroll_bar().max_value)
	await get_tree().process_frame
	var son := e._bilgi_icerik.get_child(e._bilgi_icerik.get_child_count() - 1) as Button
	dene(son != null and son.get_global_rect().end.y <= kaydir.get_global_rect().end.y + 2, "Son yapı satırı kaydırınca kesilmez")
	ana.queue_free()
	await get_tree().process_frame
	print("YAPI KİLİDİ UI: GEÇTİ" if hata == 0 else "YAPI KİLİDİ UI: KALDI")
	await Ses.cik(hata)
