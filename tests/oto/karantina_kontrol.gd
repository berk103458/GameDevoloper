## KRI-02: gerçek kart düğmesi → gece/rapor/sabah → 2 gün → güvenli kayıt.
extends Node
class OlaysizOturum extends Oturum:
	func olay_sec() -> OlayVerisi: return null
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_kri02.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = OlaysizOturum.new(katalog,222)
		kayit = GuvenliKayit.new("user://test_kri02_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var o := ana.oturum
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.isyan_esigi = -1
	y.a.ambar_taban_kapasite = 10000
	ana.katalog.koy_ayarlari = y.a
	y.kaynaklar.kapasite = 10000
	for tur in ["gida","odun","tas","kereste"]: y.kaynaklar.ekle(tur,500)
	var cadir := _kur(y,"cadir")
	var tarla := _kur(y,"tarla")
	var sif := _kur(y,"sifahane")
	var hekim := y.kabul({"ad":"Hekim"})
	hekim.zanaat_turu = ZanaatTuru.Tur.CERRAH
	_kontrol(y.ata(hekim.id,sif.id), "Mevcut Şifahane hekimi")
	var g := Gelen.new()
	g.ad_anahtari = "Sığınmacı"
	g.gizli_bayraklar = ["humma"]
	var kaynak := y.koylu(o.karar_ver(g,&"kabul").koylu_id)
	var supheli := y.kabul({"ad":"Şüpheli çalışan"})
	var komsu := y.kabul({"ad":"Komşu"})
	for k in [kaynak,supheli,komsu]: k.ev = cadir.id
	_kontrol(y.ata(supheli.id,tarla.id), "Şüphelinin gerçek işi")
	ana._koye_git()
	await get_tree().process_frame
	var e: KoyEkrani = ana._ekran
	KoyluKarti.ac(e,kaynak.id)
	await get_tree().process_frame
	var ilk := e.find_child("karantina_dugmesi",true,false) as Button
	var yazi := ilk.text
	_kontrol(not ilk.disabled and e.find_child("salgin_bilgisi",true,false) == null and not _metin(e._ust_kart).contains("Humma"), "Gizli kuluçka kartta ifşa edilmez")
	KoyluKarti.ac(e,supheli.id)
	await get_tree().process_frame
	_kontrol((e.find_child("karantina_dugmesi",true,false) as Button).text == yazi, "Sağlıklı ve gizli kuluçka aynı şüphe kararı")
	# Açık belirtili köylü de aynı gerçek düğmeyle alınır.
	kaynak.bayrak_ac("hasta")
	KoyluKarti.ac(e,kaynak.id)
	await get_tree().process_frame
	var rng := y._rng.state
	(e.find_child("karantina_dugmesi",true,false) as Button).pressed.emit()
	await get_tree().process_frame
	_kontrol(KarantinaYoneticisi.aktif(kaynak) and y._rng.state == rng and _metin(e._ust_kart).contains("temas engelli"), "Açık belirti kartından RNG'siz giriş")
	# Erken çıkış da gerçek kart sinyali; tekrar isteğe bağlı giriş.
	(e.find_child("karantina_dugmesi",true,false) as Button).pressed.emit()
	await get_tree().process_frame
	_kontrol(not KarantinaYoneticisi.aktif(kaynak) and SaglikYoneticisi.temas_edebilir(y,kaynak), "Karttan erken çıkış")
	(e.find_child("karantina_dugmesi",true,false) as Button).pressed.emit()
	await get_tree().process_frame
	KoyluKarti.ac(e,supheli.id)
	await get_tree().process_frame
	(e.find_child("karantina_dugmesi",true,false) as Button).pressed.emit()
	await get_tree().process_frame
	_kontrol(KarantinaYoneticisi.aktif(supheli) and supheli.is_yeri == tarla.id and supheli.ev == cadir.id, "Şüpheli atamalarını korur")
	var h := e.sahne3b.halk_hareketi
	h._planla(supheli.id)
	var d: Dictionary = h._durum[supheli.id]
	_kontrol(d.get("karantina",false) and not d.is and not d.devriye and not d.sinsi and h.eylem(supheli.id) != "Çalışıyor", "Gerçek figür karantina rutininde çalışmaz")
	KoyluKarti.ac(e,komsu.id)
	await get_tree().process_frame
	var dolu := e.find_child("karantina_dugmesi",true,false) as Button
	_kontrol(dolu.disabled, "Kart dolu kontenjanı gösterir")
	var sabit := y.kaydet()
	dolu.pressed.emit() # Disabled düğmeye zorlanmış sinyal bile modelde atomik ret.
	await get_tree().process_frame
	_kontrol(y.kaydet() == sabit, "Bayat/zorlanmış kart kontenjanı aşamaz")
	_kontrol(ana.kayit.yaz(o.kaydet()), "Aktif karantina güvenli kaydı")
	var geri := Oturum.kayittan(ana.katalog,ana.kayit.oku())
	_kontrol(geri.yonetim.koylu(supheli.id).karantina == supheli.karantina and geri.yonetim._rng.state == y._rng.state, "Aktif süre/atama/RNG JSON roundtrip")
	var oran: int = SaglikYoneticisi.AYAR.humma.risk
	SaglikYoneticisi.AYAR.humma.risk = 100
	var gun := y.gun
	for i in 2:
		e._kart_kapat()
		await get_tree().process_frame
		e._gece_dugmesi.pressed.emit()
		await get_tree().process_frame
		_kontrol(y.gun == gun+i+1 and not SaglikYoneticisi.hasta(komsu) and not SaglikYoneticisi.hasta(supheli), "Gerçek gece karantina bulaşmasını engeller")
		_kontrol(KarantinaYoneticisi.aktif(supheli) == (i == 0) and KarantinaYoneticisi.aktif(kaynak) == (i == 0), "İlk gece kalır, ikinci sabah iki kişi döner")
		# Raporun gerçek sabah düğmesiyle gece kilidi/kapı geçişi tamamlanır.
		var sabah := _dugme(e._ust_kart,tr("koy.rapor.sabah"))
		_kontrol(sabah != null, "Gece raporunda sabah düğmesi")
		sabah.pressed.emit()
		await get_tree().process_frame
		while ana._kapi_yukleniyor: await get_tree().process_frame
		ana._koye_git()
		await get_tree().process_frame
		e = ana._ekran
	SaglikYoneticisi.AYAR.humma.risk = oran
	_kontrol(supheli.is_yeri == tarla.id and supheli.ev == cadir.id and SaglikYoneticisi.temas_edebilir(y,supheli), "İki gün sonra aynı ev/işe dönüş")
	var calismalar := {}
	y._uret({},[],calismalar)
	_kontrol(calismalar.has(supheli.id), "Dönen şüpheli gerçek işinde üretir")
	KoyluKarti.ac(e,supheli.id)
	await get_tree().process_frame
	_kontrol((e.find_child("karantina_dugmesi",true,false) as Button).text == yazi and not _metin(e._ust_kart).contains("Humma"), "Dönüş kartı teşhis uydurmaz")
	_kontrol(ana.kayit.yaz(o.kaydet()), "Dönüş sonrası güvenli kayıt")
	geri = Oturum.kayittan(ana.katalog,ana.kayit.oku())
	var donen := geri.yonetim.koylu(supheli.id)
	_kontrol(not KarantinaYoneticisi.aktif(donen) and donen.is_yeri == tarla.id and donen.ev == cadir.id, "Dönüş kayıttan aynı atamayla döner")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	print("KARANTINA UI: GEÇTİ" if hata == 0 else "KARANTINA UI: KALDI")
	await Ses.cik(hata)
func _kur(y: KoyYonetimi,tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx,cy)
			if y.yerlesim(tur,h).olur:
				var b := y.bina(y.bina_kur(tur,h).id)
				b.insa_kalan = 0
				return b
	return null
func _metin(n: Node) -> String:
	var sonuc: String = n.text + "\n" if n is Label or n is Button else ""
	for c in n.get_children(): sonuc += _metin(c)
	return sonuc
func _dugme(n: Node,metin: String) -> Button:
	if n is Button and n.text == metin: return n
	for c in n.get_children():
		var b := _dugme(c,metin)
		if b != null: return b
	return null
func _kontrol(olur: bool,metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
