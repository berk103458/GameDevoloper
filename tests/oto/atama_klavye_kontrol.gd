## ISG-35: gerçek odak ve ui_accept girdisi; fare olayı gönderilmez.
extends Node
const F = preload("res://tests/oto/atama_duraklat_kontrol.gd")
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _ready() -> void:
	call_deferred("_calistir")

func _tus(eylem: StringName) -> void:
	for bas in [true, false]:
		var olay := InputEventAction.new()
		olay.action = eylem
		olay.pressed = bas
		Input.parse_input_event(olay)
		await get_tree().process_frame
	await get_tree().process_frame

func _dugme(kart: Node, alan: String, deger: Variant) -> Button:
	for n in kart.find_children("*", "Button", true, false):
		if n.has_meta(alan) and n.get_meta(alan) == deger: return n as Button
	return null

func _bas(b: Button) -> void:
	dene(b != null and b.is_visible_in_tree() and not b.disabled, "Atama düğmesi görünür ve kullanılabilir")
	if b == null: return
	var sayac := {"n": 0}
	b.pressed.connect(func() -> void: sayac.n += 1)
	b.grab_focus()
	dene(b.has_focus(), "Atama düğmesi klavye odağı alır")
	await _tus(&"ui_accept")
	dene(sayac.n == 1, "Tek klavye kabulü tek düğme sinyali üretir")

func _calistir() -> void:
	get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := F.TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	var b := KoyBinasi.new()
	b.id = 77
	b.tur = "odunluk"
	b.hucre = Vector2i(2, 2)
	y.binalar.append(b)
	var k := y.kabul({"ad": "Klavye işçisi"})
	ana._koye_git()
	await get_tree().process_frame
	var ekran := ana._ekran as KoyEkrani
	KoyluKarti.ac(ekran, k.id)
	await get_tree().process_frame
	await _bas(_dugme(ekran._ust_kart, "hedef", b.id))
	dene(k.is_yeri == b.id, "Fare olmadan bina ataması bir kez uygulanır")
	await _bas(_dugme(ekran._ust_kart, "hedef", KoyYonetimi.BOSTA))
	dene(k.is_yeri == KoyYonetimi.BOSTA, "Fare olmadan görevden çıkarılır")
	var sekmeler := ekran._ust_kart.find_children("*", "TabContainer", true, false)[0] as TabContainer
	sekmeler.get_tab_bar().grab_focus()
	await _tus(&"ui_right")
	dene(sekmeler.current_tab == 1, "Geçici iş sekmesine klavyeyle geçilir")
	await _bas(_dugme(ekran._ust_kart, "gecici_is", "dal_toplama"))
	dene(GeciciIsler.secili(k) == "dal_toplama", "Fare olmadan geçici işe atanır")
	ana.queue_free()
	await get_tree().process_frame
	print("ATAMA KLAVYE: GEÇTİ" if hata == 0 else "ATAMA KLAVYE: KALDI")
	await Ses.cik(hata)
