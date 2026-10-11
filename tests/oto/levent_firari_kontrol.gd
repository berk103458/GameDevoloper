## Gerçek gece düğmesi → firar raporu → sabah → model/HUD → güvenli kayıt.
extends Node
const FIRAR = preload("res://src/koy/levent_firari.gd")
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_kri09.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		# UI ve restore aynı gerçek seçiciyi/RNG akışını kullanır; rastgele kart kapalıdır.
		katalog.ayarlar = katalog.ayarlar.duplicate(true)
		katalog.ayarlar.olay_olasiligi = 0.0
		oturum = Oturum.new(katalog, 309)
		kayit = GuvenliKayit.new("user://test_kri09_ui.json")
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
	ana.katalog.koy_ayarlari = y.a
	y.kaynaklar = Kaynaklar.new(1000, {"gida": 150, "odun": 100, "su": 100, "kirec": 10})
	y.akce = 200
	o.muhafiz_akce = 77
	y.agalik = true
	var k := y.kabul({"ad": "Ayrılan levent", "sinif": "asker", "stat": 8})
	k.moral = 30
	k.sadakat = 20
	_kontrol(y.muhafiz_ata(k.id) and SavunmaKonuslanmasi.ata(y, k.id, "kapi"), "Gerçek levent/kapı görevi")
	var sadik := y.kabul({"ad": "Sadık levent", "sinif": "asker", "stat": 8})
	sadik.moral = 100
	sadik.sadakat = 60
	_kontrol(y.muhafiz_ata(sadik.id), "Sadık levent nöbeti")
	KuyuKirliligi.kirlet(y)
	ana._koye_git()
	await get_tree().process_frame
	var e: Node = ana._ekran
	var h: Node = e.sahne3b.halk_hareketi
	_kontrol(h.modeller.has(k.id), "Ayrılıştan önce gerçek model")
	_kontrol(ana.kayit.yaz(o.kaydet()), "Firar öncesi güvenli kayıt")
	var geri := Oturum.kayittan(ana.katalog, ana.kayit.oku())
	var beklenen := geri.gece_sonu()
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol(y.koylu(k.id) == null and y.koylu(sadik.id) != null and FIRAR.durum(y).firar_edildi, "Gerçek gece yalnız riskli levent ayrılır")
	_kontrol(_metin(e._ust_kart).contains("Levent firarı") and _metin(e._ust_kart).contains("Ayrılan levent") and _metin(e._ust_kart).contains("Güvenlik"), "Gerçek raporda firar ve Güvenlik kaybı")
	_kontrol(beklenen.rapor.olenler.is_empty() and JSON.stringify(o.kaydet()) == JSON.stringify(geri.kaydet()), "Gerçek UI/gece restore eşit; ölüm değil")
	_kontrol(o.gosterge(3) == int(KervanKorumasi.guvenlik(y) / 10) and o.muhafiz_akce == 77, "Tek Güvenlik ve kişisel kese korunur")
	_kontrol(not h.modeller.has(k.id), "Mevcut model yenilemesi ayrılanı kaldırır")
	_kontrol(ana.kayit.yaz(o.kaydet()), "Firar sonrası güvenli kayıt")
	geri = Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(geri.yonetim.koylu(k.id) == null and FIRAR.durum(geri.yonetim) == FIRAR.durum(y), "Ayrılış ve dönem kilidi kalıcı")
	await _sabah(ana, e)
	e = ana._ekran
	sadik.moral = 30
	sadik.sadakat = 20
	var bordro: Dictionary = y.maas_durumu[str(k.id)].duplicate(true)
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	_kontrol(y.koylu(sadik.id) != null and not _metin(e._ust_kart).contains("Levent firarı"), "Aynı kriz ikinci dalga yaratmaz")
	_kontrol(y.maas_durumu[str(k.id)] == bordro, "Ayrılan nöbetçiye yeni maaş/borç yok")
	await _sabah(ana, e)
	e = ana._ekran
	_kontrol(e.sahne3b.halk_hareketi.modeller.size() == y.nufus(), "Sabah model ve nüfus uyumu")
	_kontrol(e.hud._asayis.text == tr("arayuz.hud.asayis") % y.asayis_riski, "Mevcut HUD gerçek asayiş riskini okur")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	print("LEVENT FİRARI UI: GEÇTİ" if hata == 0 else "LEVENT FİRARI UI: KALDI")
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
