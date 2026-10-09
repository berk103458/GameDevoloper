class_name SenaryoPaneli
extends HBoxContainer
signal sonuc_alindi(sonuc: Dictionary)
var baglam: Node
var secim: OptionButton
var baslat: Button
var son_rapor: Dictionary = {}
var _calisiyor := false

func _ready() -> void:
	secim = OptionButton.new()
	secim.add_item("10 Gün Kıtlık")
	secim.add_item("Gece Haydut Baskını")
	secim.add_item("Veba Salgını — stres deneyi")
	secim.set_item_tooltip(0, "En çok 10 gerçek gece: her üretim sonrası gıda kaybı; açlık/ölüm/isyan normal modelden. Terminal sonuçta durur.")
	secim.set_item_tooltip(1, "1 gerçek gece: Husumet baskını kesin tetiklenir; hasar ve yağma mevcut modelden.")
	secim.set_item_tooltip(2, "Herkese veba enfeksiyonu ve −40 sağlık, ardından 1 gerçek gece: bulaşma, Şifahane tedavisi ve sağlık/ölüm hesabı çalışır.")
	add_child(secim)
	baslat = Button.new()
	baslat.text = "Senaryoyu çalıştır"
	baslat.tooltip_text = "Canlı oturumu değiştirir; sonuç normal köy kaydına yazılır."
	baslat.pressed.connect(_baslat)
	add_child(baslat)
	yenile()

func yenile() -> void:
	baslat.disabled = _calisiyor or not ZamanMakinesi.uygun(baglam)

func _baslat() -> void:
	if _calisiyor:
		return
	_calisiyor = true
	yenile()
	son_rapor = SenaryoKosucusu.uygula(baglam, SenaryoKosucusu.KIMLIKLER[secim.selected])
	_calisiyor = false
	yenile()
	sonuc_alindi.emit(son_rapor)
