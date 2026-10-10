## KRI-15 gerçek akış: köy ekranı → açık salgın gecesi → boştaki vasıfsızlar ot toplar → rapor + ambar → kayıt.
extends Node
class OlaysizOturum extends Oturum:
	func olay_sec() -> OlayVerisi: return null
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_kri15.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = OlaysizOturum.new(katalog, 1515)
		kayit = GuvenliKayit.new("user://test_kri15_ui.json")
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
	y.kaynaklar = Kaynaklar.new(1000, {"gida": 200, "odun": 100, "su": 100})
	y.akce = 200
	var h := y.kabul({"ad": "Ateşli komşu"})
	SaglikYoneticisi.enfekte(y, h, "humma")
	h.enfeksiyon.bitis = y.gun + 4
	h.bayrak_ac("hasta")
	for i in 2: y.kabul({"ad": "Boştaki %d" % i, "stat": 4})
	ana._koye_git()
	await get_tree().process_frame
	var e: Node = ana._ekran
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	var m := _metin(e._ust_kart)
	_kontrol(m.contains("Şifalı ot") and m.contains("Boştaki 0"), "Gerçek gece raporunda şifalı ot satırı")
	_kontrol(y.kaynaklar.miktar("afyon") == 2, "Ambara 2 afyon girdi")
	_kontrol(not m.contains("chr_") and not m.contains("Clue_"), "Sızıntı yok")
	_kontrol(ana.kayit.yaz(o.kaydet()), "GuvenliKayit yazımı")
	var geri := Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(geri != null and geri.yonetim.kaynaklar.miktar("afyon") == 2, "Ot kayıtta")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	print("SIFALI OT UI: GEÇTİ" if hata == 0 else "SIFALI OT UI: KALDI")
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
