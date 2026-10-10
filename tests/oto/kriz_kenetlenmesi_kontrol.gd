## Gerçek gece → kuyu dezenfeksiyonu → kenetlenme raporu → sabah/kart/kayıt.
extends Node
const KENET = preload("res://src/koy/kriz_kenetlenmesi.gd")
class OlaysizOturum extends Oturum:
	func olay_sec() -> OlayVerisi: return null
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_kri10.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = OlaysizOturum.new(katalog, 310)
		kayit = GuvenliKayit.new("user://test_kri10_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0

func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var o := ana.oturum
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 1000
	y.a.isyan_esigi = -1
	ana.katalog.koy_ayarlari = y.a
	y.kaynaklar = Kaynaklar.new(1000, {"gida": 150, "odun": 100, "su": 100, "kirec": 10})
	y.akce = 200
	o.muhafiz_akce = 77
	var k := y.kabul({"ad": "Krizden çıkan komşu"})
	k.moral = 85
	k.sadakat = 60
	k.refah = 50
	# Gerçek kirli su kuluçkası kesinleştirilir; temizlemek hastayı iyileştirmez.
	var risk: int = SaglikYoneticisi.AYAR.tifo.risk
	SaglikYoneticisi.AYAR.tifo.risk = 100
	KuyuKirliligi.kirlet(y)
	ana._koye_git()
	await get_tree().process_frame
	var e: Node = ana._ekran
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol(KENET.durum(y).baslangic == 0 and SaglikYoneticisi.hasta(k) and not _metin(e._ust_kart).contains("Toplumsal kenetlenme"), "Gerçek kriz gecesi, kenetlenme yok")
	await _sabah(ana, e)
	e = ana._ekran
	e._pazar_ac()
	await get_tree().process_frame
	var temizle := e._ust_kart.find_child("kuyu_kirecle", true, false) as Button
	_kontrol(temizle != null and not temizle.disabled, "Gerçek pazarda dezenfeksiyon işlemi")
	if temizle == null: SaglikYoneticisi.AYAR.tifo.risk = risk; await Ses.cik(1); return
	temizle.pressed.emit()
	await get_tree().process_frame
	_kontrol(not KuyuKirliligi.kirli(y) and SaglikYoneticisi.hasta(k) and k.sadakat == 60, "Kuyuyu temizlemek hastalık bitişi/bonus değildir")
	e._kart_kapat()
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol("hasta" in k.bayraklar and not _metin(e._ust_kart).contains("Toplumsal kenetlenme"), "Belirtili salgın sürerken bonus yok")
	_kontrol(ana.kayit.yaz(o.kaydet()), "Aktif birleşik kriz GuvenliKayit")
	var geri := Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(KENET.durum(geri.yonetim) == KENET.durum(y) and geri.yonetim.koylu(k.id).enfeksiyon == k.enfeksiyon, "Aktif dönem/enfeksiyon makbuzu kalıcı")
	await _sabah(ana, e)
	# Doğal iyileşme gerçek SaglikYoneticisi.gece içinde çalışır.
	# Fixture yalnız süreyi bir sonraki geceye kısaltır, iyileşme/ödül çağırmaz.
	k.enfeksiyon.bitis = y.gun
	_kontrol(ana.kayit.yaz(o.kaydet()), "İyileşme öncesi güvenli kayıt")
	geri = Oturum.kayittan(ana.katalog, ana.kayit.oku())
	var beklenen := geri.gece_sonu()
	e = ana._ekran
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol(not SaglikYoneticisi.hasta(k) and k.sadakat == 68 and k.refah == 60, "Gerçek sağlık kapanışı sadakat/refah bonusu")
	var metin := _metin(e._ust_kart)
	_kontrol(metin.contains("Toplumsal kenetlenme") and metin.contains("Kirli kuyu") and metin.contains("Salgın") and metin.contains("Sadakat +8") and metin.contains("Refah +10"), "Gerçek raporda tek birleşik kenetlenme ve somut kazanım")
	_kontrol(beklenen.rapor.olaylar.filter(func(v: Dictionary) -> bool: return v.has("kriz_kenetlenmesi")).size() == 1 and JSON.stringify(o.kaydet()) == JSON.stringify(geri.kaydet()), "Gerçek UI ve kayıt devamında aynı tek ödül/RNG")
	_kontrol(o.muhafiz_akce == 77 and EkonomikRefah.oku(y) == 60, "Tek Refah ve korunmuş kişisel kese")
	_kontrol(ana.kayit.yaz(o.kaydet()), "Ödül sonrası güvenli kayıt")
	geri = Oturum.kayittan(ana.katalog, ana.kayit.oku())
	var olay: Array[Dictionary] = []
	KENET.bitir(geri.yonetim, olay)
	_kontrol(olay.is_empty() and geri.yonetim.koylu(k.id).sadakat == 68 and geri.yonetim.koylu(k.id).refah == 60, "Kapanmış dönem restore ikinci ödül vermez")
	await _sabah(ana, e)
	e = ana._ekran
	KoyluKarti.ac(e, k.id)
	await get_tree().process_frame
	_kontrol(_metin(e._ust_kart).contains("Sadakat 68") and _metin(e._ust_kart).contains("Refah 60/100"), "Mevcut köylü kartı tek gerçek puanı okur")
	e._kart_kapat()
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol(not _metin(e._ust_kart).contains("Toplumsal kenetlenme") and k.sadakat == 68 and k.refah == 60, "Krizsiz sonraki gerçek gecede ikinci bonus yok")
	SaglikYoneticisi.AYAR.tifo.risk = risk
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	print("KRİZ KENETLENMESİ UI: GEÇTİ" if hata == 0 else "KRİZ KENETLENMESİ UI: KALDI")
	await Ses.cik(hata)

func _sabah(ana: Node, e: Node) -> void:
	var b := _dugme(e._ust_kart, tr("koy.rapor.sabah"))
	_kontrol(b != null and not b.disabled, "Gerçek sabah düğmesi")
	if b == null: return
	b.pressed.emit()
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
	var r: String = n.text if n is Label else ""
	for c in n.get_children(): r += " " + _metin(c)
	return r

func _kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
