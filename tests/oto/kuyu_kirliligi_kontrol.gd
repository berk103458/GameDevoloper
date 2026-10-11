## Gerçek gizli CAS kabulü → iki gece → kuyu/hasta kartı → kireç → kayıt.
extends Node
class OlaysizOturum extends Oturum:
	func olay_sec() -> OlayVerisi: return null
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_kri04.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = OlaysizOturum.new(katalog, 222)
		kayit = GuvenliKayit.new("user://test_kri04_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	# CAS kuyu tur-offset arayüzü; alışma süresi ayrı testte.
	preload("res://src/sistemler/tehdit_takvimi.gd").AYAR.tehdit_baslangic_gunu = 0
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var o := ana.oturum
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.isyan_esigi = -1
	y.a.ambar_taban_kapasite = 10000
	y.a.iyilesme = 0
	ana.katalog.koy_ayarlari = y.a
	y.kaynaklar.kapasite = 10000
	for tur in ["gida", "odun", "tas", "kereste"]: y.kaynaklar.ekle(tur, 500)
	var kisi := y.kabul({"ad": "Kuyu kullanıcısı"})
	var fail := y.koylu(o.karar_ver(o._adli_gelen(&"chr_002"), &"kabul").koylu_id)
	y.gun = 2 # Kaynağın gerçek kabul tur3 zehirlemesi; ilk gece düğmesi uygular.
	ana._koye_git()
	await get_tree().process_frame
	var e: KoyEkrani = ana._ekran
	_kuyu_sec(e)
	await get_tree().process_frame
	_kontrol(_metin(e._bilgi_icerik).contains("Meydan su kuyusu") and _metin(e._bilgi_icerik).contains("Kuyu temiz"), "Gerçek kuyunun hücresine tıklayınca mevcut bina bilgisi açılır")
	# Risk yalnız fixture'da kesinleştirilir; üretim denge değeri sonunda geri bırakılır.
	var risk: int = SaglikYoneticisi.AYAR.tifo.risk
	SaglikYoneticisi.AYAR.tifo.risk = 100
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol(SaglikYoneticisi.hasta(kisi) and kisi.enfeksiyon.tur == "tifo" and "hasta" not in kisi.bayraklar, "Gerçek su gecesi tifo kuluçkası oluşturur")
	_kontrol(_metin(e._ust_kart).contains("Kirli kuyu"), "Gerçek gece raporu su riskini gösterir")
	_kontrol(CasusGeceTakibi.acik_izler(y).is_empty() and "sabotajci" not in fail.bayraklar, "Gerçek sabotaj fiili gizli; sağlık belirtisi fail kanıtı sayılmaz")
	await _sabah(ana, e)
	e = ana._ekran
	_kuyu_sec(e)
	await get_tree().process_frame
	var dugme := e._bilgi_icerik.find_child("kuyu_kirecle", true, false) as Button
	_kontrol(dugme != null and dugme.disabled and _metin(e._bilgi_icerik).contains("Kirli kuyu"), "Kirli kuyu bilgisi ve yetersiz kireçte kapalı düğme")
	_kontrol(not _metin(e._bilgi_icerik).contains(fail.ad), "Kuyu bilgisinde gizli fail adı gösterilmez")
	e._pazar_ac()
	await get_tree().process_frame
	var doldur := e._ust_kart.find_child("su_rezerv_doldur", true, false) as Button
	_kontrol(doldur != null and doldur.disabled and e._ust_kart.find_child("kuyu_kirecle", true, false) != null, "Mevcut pazarda kirli rezerv kapalı ve aynı dezenfeksiyon hizmeti görünür")
	e._kart_kapat()
	KoyluKarti.ac(e, kisi.id)
	await get_tree().process_frame
	_kontrol(not _metin(e._ust_kart).contains("Tifo"), "Gizli tifo kuluçkası kartta açıklanmaz")
	e._kart_kapat()
	# İkinci gerçek sağlık gecesi tifo belirtilerini açar.
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	await _sabah(ana, e)
	e = ana._ekran
	KoyluKarti.ac(e, kisi.id)
	await get_tree().process_frame
	_kontrol(_metin(e._ust_kart).contains("Tifo") and _metin(e._ust_kart).contains("su kaynaklı"), "Hasta kartı mevcut sağlık motorundan tifo ve su yolunu gösterir")
	_kontrol(not _metin(e._ust_kart).contains("chr_") and not _metin(e._ust_kart).contains("Flag_"), "Hasta kartında gizli fail/anahtar ifşası yok")
	e._kart_kapat()
	_kontrol(ana.kayit.yaz(o.kaydet()), "Aktif kirlenme/tifo gerçek güvenli kaydı")
	var geri := Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(KuyuKirliligi.kirli(geri.yonetim) and geri.yonetim.koylu(kisi.id).enfeksiyon == kisi.enfeksiyon and geri.yonetim._rng.state == y._rng.state, "Aktif kuyu/tifo/RNG kayıt turu")
	y.kaynaklar.ekle("kirec", 2)
	_kuyu_sec(e)
	await get_tree().process_frame
	dugme = e._bilgi_icerik.find_child("kuyu_kirecle", true, false) as Button
	_kontrol(dugme != null and not dugme.disabled, "Kaynak geldikten sonra gerçek bina dezenfeksiyon düğmesi açılır")
	if dugme == null: SaglikYoneticisi.AYAR.tifo.risk = risk; await Ses.cik(1); return
	var rng := y._rng.state
	dugme.pressed.emit()
	dugme.pressed.emit() # Aynı karede bayat düğmeye ikinci tıklama da modelde doğrulanır.
	await get_tree().process_frame
	_kontrol(not KuyuKirliligi.kirli(y) and KrizEnjektoru.kalan(y) == 0 and y.kaynaklar.miktar("kirec") == 0 and SaglikYoneticisi.hasta(kisi) and y._rng.state == rng, "Gerçek düğme 2 kireçle kuyu/debug kaynağını temizler; hasta tedavi edilmez")
	_kontrol(_metin(e._bilgi_icerik).contains("Kuyu temiz"), "Aynı bina bilgi alanı temizlikten sonra yenilenir")
	_kontrol(ana.kayit.yaz(o.kaydet()), "Dezenfeksiyon sonrası güvenli kayıt")
	geri = Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(not KuyuKirliligi.kirli(geri.yonetim) and geri.yonetim.koylu(kisi.id).enfeksiyon == kisi.enfeksiyon and geri.yonetim.kaynaklar.miktar("kirec") == 0, "Temiz kuyu/tifo/harcanmış kireç kayıt dönüşü")
	# Temizlikten sonra yeni kullanıcıda üçüncü gerçek gece tifo oluşmaz.
	var yeni := y.kabul({"ad": "Temiz su kullanıcısı"})
	e._yenile()
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol(not SaglikYoneticisi.hasta(yeni) and kisi.saglik > 0 and not _metin(e._ust_kart).contains("Debug: Zehirli"), "Temiz kaynak yeni tifo/debug hasarı üretmez; eski hasta doğal hastalığı sürdürür")
	SaglikYoneticisi.AYAR.tifo.risk = risk
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	print("KUYU KİRLİLİĞİ UI: GEÇTİ" if hata == 0 else "KUYU KİRLİLİĞİ UI: KALDI")
	await Ses.cik(hata)

func _kuyu_sec(e: KoyEkrani) -> void:
	e.kip = ""
	var nokta := e.sahne3b.kamera.unproject_position(SulamaRutini.kuyu_konumu(e.sahne3b))
	var tik := InputEventMouseButton.new()
	tik.button_index = MOUSE_BUTTON_LEFT
	tik.pressed = true
	tik.position = nokta * e._kap.size / Vector2(e._vp.size)
	e._kap.gui_input.emit(tik)
func _sabah(ana: Ana, e: KoyEkrani) -> void:
	var sabah := _dugme(e._ust_kart, tr("koy.rapor.sabah"))
	_kontrol(sabah != null, "Gerçek sabah düğmesi")
	if sabah == null: return
	sabah.pressed.emit()
	await get_tree().process_frame
	while ana._kapi_yukleniyor: await get_tree().process_frame
	ana._koye_git()
	await get_tree().process_frame
func _dugme(n: Node, metin: String) -> Button:
	if n is Button and n.text == metin: return n
	for c in n.get_children():
		var b := _dugme(c, metin)
		if b != null: return b
	return null
func _metin(n: Node) -> String:
	var sonuc: String = n.text + "\n" if n is Label else ""
	for c in n.get_children(): sonuc += _metin(c)
	return sonuc
func _kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
