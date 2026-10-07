class_name AnlikGoruntuPaneli
extends HBoxContainer
signal sonuc_alindi(sonuc: Dictionary)
var baglam: Node
var arac := DurumAnlikGoruntusu.new()
var kaydet: Button
var geri: Button
var son_rapor: Dictionary = {}
var _calisiyor := false

func _ready() -> void:
	kaydet = Button.new()
	kaydet.text = "Kayıt noktası al"
	kaydet.tooltip_text = "Köy veya kapı sorgusunu ayrı geçici slota kaydeder. Açık rapor/olay ve geçiş önce tamamlanmalı."
	kaydet.pressed.connect(_al)
	add_child(kaydet)
	geri = Button.new()
	geri.text = "Kayıt noktasına dön"
	geri.tooltip_text = "Kaydedilen köy veya kapı sorgusuna döner; model/heybe/kuyruk korunur, normal kayıt güncellenir. Hız 1x."
	geri.pressed.connect(_don)
	add_child(geri)
	yenile()

func yenile() -> void:
	kaydet.disabled = _calisiyor or not DurumAnlikGoruntusu.alinabilir(baglam)
	geri.disabled = _calisiyor or not arac.slot.var_mi() or not DurumAnlikGoruntusu.donulebilir(baglam)

func _al() -> void:
	if _calisiyor: return
	son_rapor = arac.yakala(baglam)
	son_rapor["islem"] = "kaydedildi"
	yenile()
	sonuc_alindi.emit(son_rapor)

func _don() -> void:
	if _calisiyor: return
	_calisiyor = true
	yenile()
	son_rapor = await arac.geri_don(baglam)
	_calisiyor = false
	son_rapor["islem"] = "geri dönüldü"
	yenile()
	sonuc_alindi.emit(son_rapor)
