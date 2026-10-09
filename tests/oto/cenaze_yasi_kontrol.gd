## Gerçek ölüm → gece raporu kararı → iki günlük yas → GuvenliKayit/legacy.
extends Node
class OlaysizOturum extends Oturum:
	func olay_sec() -> OlayVerisi: return null
class TestAna extends Ana:
	static var ortak_katalog: Katalog
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_kri05.cfg")
		katalog = ortak_katalog
		oturum = OlaysizOturum.new(katalog, 224)
		kayit = GuvenliKayit.new("user://test_kri05_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	TestAna.ortak_katalog = Katalog.new()
	TestAna.ortak_katalog.yukle()
	await _akis(true)
	await _akis(false)
	await _pending_yukleme()
	print("CENAZE YASI UI: GEÇTİ" if hata == 0 else "CENAZE YASI UI: KALDI")
	await Ses.cik(hata)

func _hazir(ana: Ana) -> KoyYonetimi:
	var y := ana.oturum.yonetim
	y.a = y.a.duplicate(true)
	y.a.isyan_esigi = -1
	y.a.ambar_taban_kapasite = 10000
	y.a.iyilesme = 0
	y.a.tok_moral = 0
	y.a.evsiz_moral = 0
	ana.katalog.koy_ayarlari = y.a
	y.kaynaklar.kapasite = 10000
	y.akce = 100
	for tur in ["gida", "odun", "tas", "kereste"]: y.kaynaklar.ekle(tur, 500)
	for i in 8:
		var k := y.kabul({"ad": "Cenaze köylüsü %d" % i})
		k.moral = 50
	return y

func _akis(toren: bool) -> void:
	var ana := TestAna.new()
	add_child(ana)
	var y := _hazir(ana)
	var beklenen := 2 if toren else 3
	if toren:
		for k in y.koylular.slice(0, beklenen):
			SaglikYoneticisi.enfekte(y, k, "veba")
			k.saglik = 1
	else:
		y.gun = 21
		y.kaynaklar.azalt("odun", 10000)
		for k in y.koylular.slice(0, beklenen): k.saglik = 1
	var kisi := y.koylular[-1]
	ana._koye_git()
	await get_tree().process_frame
	var e: KoyEkrani = ana._ekran
	var cikis := {}
	e.devam_istendi.connect(func(r: Dictionary) -> void: cikis.merge(r, true))
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol(y.nufus() == 8 - beklenen and CenazeYasi.bekliyor(y), "Gerçek salgın/donma ölümü cenaze kararını açar")
	_kontrol(_metin(e._ust_kart).contains("Cenaze:") and _metin(e._ust_kart).contains("Yas:"), "Mevcut gece raporunda cenaze ve süre")
	var sabah := _dugme(e._ust_kart, tr("koy.rapor.sabah"))
	_kontrol(sabah != null and sabah.disabled, "Karar verilmeden sabah bekler")
	if sabah == null: await _bitir(ana); return
	sabah.pressed.emit()
	_kontrol(ana._ekran == e and e._ust_kart != null and CenazeYasi.bekliyor(y), "Programatik/bayat sabah da karar kapısını aşamaz")
	var mezar := e.sahne3b.find_child("cenaze_mezari", true, false)
	_kontrol(mezar != null and mezar.get_child(0) is MeshInstance3D and mezar.get_child(0).mesh is BoxMesh, "Gerçek meydanda tek kutu mezar yer tutucu")
	_kontrol(ana.kayit.yaz(ana.oturum.kaydet()), "Bekleyen cenaze gerçek güvenli kayıt")
	var geri := Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(CenazeYasi.bekliyor(geri.yonetim) and CenazeYasi.durum(geri.yonetim) == CenazeYasi.durum(y), "Bekleyen karar ve moral makbuzu kayıt turu")
	var ucret := CenazeYasi.bedel(y)
	var gida := y.kaynaklar.miktar("gida")
	var akce := y.akce
	var rng := y._rng.state
	var b := e._ust_kart.find_child("cenaze_toren" if toren else "cenaze_toplu_mezar", true, false) as Button
	_kontrol(b != null and not b.disabled, "Gerçek rapor seçim düğmesi hazır")
	if b == null: await _bitir(ana); return
	b.pressed.emit()
	var secim_sonrasi := JSON.stringify(y.kaydet())
	b.pressed.emit()
	await get_tree().process_frame
	_kontrol(JSON.stringify(y.kaydet()) == secim_sonrasi and y._rng.state == rng, "Gerçek çift tıklamada yalnız bir karar ve RNG değişmez")
	_kontrol(not sabah.disabled and y.akce == akce - (ucret if toren else 0) and y.kaynaklar.miktar("gida") == gida - (ucret if toren else 0), "Bedel kamu/ambar üzerinden ve sabah açılır")
	_kontrol(kisi.moral == (47 if toren else 41) and _metin(e._ust_kart).contains("Cenaze töreni" if toren else "Toplu mezar"), "Seçim moral ve rapor özetini anında yeniler")
	_kontrol(_metin(e._ust_kart).contains("Yas: moral −3" if toren else "Yas: moral −9"), "Eski yas olay satırı da kararın güncel cezasını gösterir")
	_kontrol(e.hud != null and e.sahne3b.find_child("cenaze_mezari", true, false) != null, "Karar sonrası mevcut HUD ve mezar yenilenir")
	_kontrol(ana.kayit.yaz(ana.oturum.kaydet()), "Aktif yas güvenli kayıt")
	geri = Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(CenazeYasi.durum(geri.yonetim) == CenazeYasi.durum(y) and geri.yonetim.koylu(kisi.id).moral == kisi.moral and geri.yonetim._rng.state == rng, "Seçilmiş yas/süre/bedel/RNG kayıt dönüşü")
	await _sabah(ana, e)
	_kontrol(cikis.rapor.cenaze.secim == ("toren" if toren else "toplu_mezar") and cikis.bilanco.kamu.sonra == y.akce and cikis.bilanco.stok.gida.sonra == y.kaynaklar.miktar("gida"), "Gerçek devam sinyali karar/bedel ve bilanço kapanışını taşır")
	if toren: _kontrol(cikis.bilanco.cenaze.akce == ucret and cikis.bilanco.cenaze.erzak == ucret, "Bilanço tören bedelini ayrı makbuzla gösterir")
	e = ana._ekran
	if not toren: y.kaynaklar.ekle("odun", 50)
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol(not CenazeYasi.durum(y).is_empty() and kisi.moral == (47 if toren else 41), "İkinci gerçek gün yas yığılmadan sürer")
	_kontrol(_metin(e._ust_kart).contains("1 gün kaldı"), "Rapor kalan yas gününü gösterir")
	await _sabah(ana, e)
	e = ana._ekran
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol(CenazeYasi.durum(y).is_empty() and kisi.moral == 50, "Üçüncü sabah geçici kayıp tam iade edilir")
	_kontrol(e.sahne3b.find_child("cenaze_mezari", true, false) == null and not _metin(e._ust_kart).contains("Cenaze:"), "Süre bitince geçici mezar/rapor temizlenir")
	_kontrol(ana.kayit.yaz(ana.oturum.kaydet()), "Bitmiş yas güvenli kayıt")
	geri = Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(CenazeYasi.durum(geri.yonetim).is_empty() and geri.yonetim.koylu(kisi.id).moral == 50, "Bitmiş kayıt hayalet yas üretmez")
	await _bitir(ana)

func _pending_yukleme() -> void:
	var ana := TestAna.new()
	add_child(ana)
	var y := _hazir(ana)
	y.gun = 2
	SaglikYoneticisi.enfekte(y, y.koylular[0], "veba")
	y.koylular[0].saglik = 1
	y.akce = 0
	y.gece()
	_kontrol(ana.kayit.yaz(ana.oturum.kaydet()), "Yetersiz kaynaklı pending kayıt")
	ana.oturum = Oturum.kayittan(ana.katalog, ana.kayit.oku())
	y = ana.oturum.yonetim
	ana._koye_git()
	await get_tree().process_frame
	var e: KoyEkrani = ana._ekran
	var b := e._ust_kart.find_child("cenaze_toren", true, false) as Button
	_kontrol(_metin(e._ust_kart).contains("Bekleyen cenaze kararı") and b != null and b.disabled, "Gerçek yükleme kartı bekleyen kararı geri açar; yetersiz tören kapalı")
	if b == null: await _bitir(ana); return
	var once := JSON.stringify(y.kaydet())
	e._gece_dugmesi.pressed.emit()
	_kontrol(JSON.stringify(y.kaydet()) == once and CenazeYasi.bekliyor(y), "Yükleme kartında gece kararı atlayamaz")
	b.pressed.emit()
	_kontrol(JSON.stringify(y.kaydet()) == once, "Disabled/bayat tören modeli atomik reddeder")
	var mezar := e._ust_kart.find_child("cenaze_toplu_mezar", true, false) as Button
	mezar.pressed.emit()
	await get_tree().process_frame
	_kontrol(KuyuKirliligi.kirli(y) and CenazeYasi.durum(y).secim == "toplu_mezar", "Yüklenen salgın cenazesi ücretsiz mezarla mevcut kuyu kirlenmesini açar")
	var don := _dugme(e._ust_kart, "Köye dön")
	don.pressed.emit()
	await get_tree().process_frame
	_kontrol(e._ust_kart == null, "Yüklenen karar tamamlanınca köye dönülür")
	await _bitir(ana)

func _sabah(ana: Ana, e: KoyEkrani) -> void:
	var sabah := _dugme(e._ust_kart, tr("koy.rapor.sabah"))
	_kontrol(sabah != null and not sabah.disabled, "Gerçek sabah düğmesi")
	if sabah == null: return
	sabah.pressed.emit()
	await get_tree().process_frame
	while ana._kapi_yukleniyor: await get_tree().process_frame
	ana._koye_git()
	await get_tree().process_frame

func _bitir(ana: Ana) -> void:
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame

func _dugme(n: Node, metin: String) -> Button:
	if n is Button and n.text == metin: return n
	for c in n.get_children():
		var b := _dugme(c, metin)
		if b != null: return b
	return null

func _metin(n: Node) -> String:
	if n == null: return ""
	var sonuc: String = n.text + "\n" if n is Label else ""
	for c in n.get_children(): sonuc += _metin(c)
	return sonuc

func _kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
