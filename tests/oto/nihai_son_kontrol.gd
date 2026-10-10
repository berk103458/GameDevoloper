## SYS-20 gerçek akış: 2. perde 12 gece → gerçek zafer → Ana son ekranında nihai son başlığı + epilog matrisi.
extends Node
class OlaysizOturum extends Oturum:
	func olay_sec() -> OlayVerisi: return null
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_sys20.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = OlaysizOturum.new(katalog, 2020)
		kayit = GuvenliKayit.new("user://test_sys20_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0

func _ready() -> void:
	get_tree().create_timer(90.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var o := ana.oturum
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 100000
	y.a.isyan_esigi = -1
	y.a.harac_araligi = 100000
	ana.katalog.koy_ayarlari = y.a
	y.kaynaklar = Kaynaklar.new(100000, {"gida": 20000, "odun": 2000, "su": 2000})
	y.akce = 5000
	y.adalet = 75
	for i in 18:
		var k := y.kabul({"ad": "Köylü %d" % i})
		k.moral = 90
		k.refah = 85
	var s := o.gece_sonu()
	_kontrol(o.perde == 2, "Gerçek geçiş")
	var n := 0
	while String(s.son) == "" and n < 30:
		s = o.gece_sonu()
		n += 1
	_kontrol(String(s.son) == "zafer", "Gerçek 2. perde zaferi (%s)" % s.son)
	ana._son_goster(s.son)
	for i in 3: await get_tree().process_frame
	var m := _metin(ana)
	_kontrol(m.contains("Ahi Kasabası") and m.contains("Epilog") and m.contains("Refah 85/100"), "Son ekranında nihai son + epilog matrisi")
	_kontrol(not m.contains("chr_") and not m.contains("Clue_"), "Sızıntı yok")
	ana.queue_free()
	await get_tree().process_frame
	print("NIHAI SON UI: GEÇTİ" if hata == 0 else "NIHAI SON UI: KALDI")
	await Ses.cik(hata)

func _metin(n: Node) -> String:
	var r: String = n.text if n is Label else ""
	for c in n.get_children(): r += " " + _metin(c)
	return r

func _kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
