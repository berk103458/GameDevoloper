class_name NpcCagirmaPaneli
extends HBoxContainer

signal sonuc_alindi(sonuc: Dictionary)
var baglam: Node
var secim: OptionButton
var cagir: Button
var _oturum: WeakRef
var _kimlikler: Array[StringName] = []
var _calisiyor := false

func _ready() -> void:
	secim = OptionButton.new()
	secim.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(secim)
	cagir = Button.new()
	cagir.text = "Sıradaki kişi olarak çağır"
	cagir.pressed.connect(_cagir)
	add_child(cagir)
	yenile()

func yenile() -> void:
	var o: Oturum = baglam.get("oturum") if is_instance_valid(baglam) else null
	if o != (_oturum.get_ref() if _oturum != null else null):
		_oturum = weakref(o) if o != null else null
		_kimlikler = NpcCagirma.kimlikler(o)
		secim.clear()
		for id in _kimlikler:
			var k := o.katalog.karakter(id)
			secim.add_item("%s · %s" % [String(id).to_upper(), k.ad if not k.ad.is_empty() else tr(k.ad_anahtari)])
		secim.add_item("Gezgin tüccar — TUC-01 bekliyor")
		secim.set_item_disabled(secim.item_count - 1, true)
	cagir.disabled = _calisiyor or _kimlikler.is_empty() or not NpcCagirma.uygun(baglam)

func _cagir() -> void:
	if _calisiyor or secim.selected < 0 or secim.selected >= _kimlikler.size():
		return
	_calisiyor = true
	yenile()
	var sonuc := await NpcCagirma.cagir(baglam, _kimlikler[secim.selected])
	if not is_instance_valid(self):
		return
	_calisiyor = false
	yenile()
	sonuc_alindi.emit(sonuc)
