## Köy mini oyunlarının ortak çerçevesi: karartılmış arka plan, altın çerçeveli pano, başlık, ipucu ve puan.
## Alt sınıflar `_baslat`, `_ilerle`, `_bas` ve `_alan_ciz` yazar; oyun bitince `bitti(puan, azami)` yayılır.
## Girdi: Boşluk/Enter (ui_accept) ya da sol tık; GUI'den önce yakalanır (arkadaki düğmeler tetiklenmez).
## Kurallar: design/gdd/koy-mini-oyunlari.md
class_name MiniOyun
extends Control

signal bitti(puan: int, azami: int)

const PANO := Rect2(400, 90, 1120, 820)
## Oyun bittikten sonra sonucun ekranda kalma süresi (s).
const KAPANIS := 1.3

var ayarlar: Ayarlar
var oyun: OyunAyarlari
var puan := 0
var azami := 0

var _t := 0.0
var _bitti := false
var _durum: Label
var _geri_bildirim: Label
var _gb_sure := 0.0
var _alan: Control


## Türüne göre mini oyunu kurar (&"okculuk" / &"harman"); bilinmeyen tür null.
static func olustur(tur: StringName, ayarlar_: Ayarlar, oyun_: OyunAyarlari) -> MiniOyun:
	var m: MiniOyun
	match tur:
		&"okculuk":
			m = OkculukOyunu.new()
		&"harman":
			m = HarmanOyunu.new()
		_:
			return null
	m.ayarlar = ayarlar_
	m.oyun = oyun_
	return m


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var karart := ColorRect.new()
	karart.color = Color(0, 0, 0, 0.55)
	karart.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	karart.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(karart)
	var pano := CerceveKutu.new()
	pano.position = PANO.position
	pano.size = PANO.size
	add_child(pano)
	var baslik := Label.new()
	baslik.text = tr("arayuz.oyun.%s.baslik" % _tur())
	baslik.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.BASLIK_PX))
	baslik.add_theme_color_override("font_color", MenuSatiri.ALTIN)
	baslik.position = PANO.position + Vector2(40, 26)
	add_child(baslik)
	var ipucu := Label.new()
	ipucu.text = tr("arayuz.oyun.%s.ipucu" % _tur())
	ipucu.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ipucu.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.KUCUK_PX))
	ipucu.add_theme_color_override("font_color", Renkler.KUL)
	ipucu.position = PANO.position + Vector2(40, 84)
	ipucu.size = Vector2(PANO.size.x - 80, 60)
	add_child(ipucu)
	_alan = Control.new()
	_alan.position = PANO.position + Vector2(40, 150)
	_alan.size = PANO.size - Vector2(80, 230)
	_alan.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_alan.draw.connect(func() -> void: _alan_ciz(_alan, _alan.size / 2.0))
	add_child(_alan)
	_durum = Label.new()
	_durum.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.GOVDE_PX))
	_durum.position = PANO.position + Vector2(40, PANO.size.y - 70)
	add_child(_durum)
	_geri_bildirim = Label.new()
	_geri_bildirim.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.BASLIK_PX))
	_geri_bildirim.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_geri_bildirim.position = PANO.position + Vector2(PANO.size.x - 540, PANO.size.y - 76)
	_geri_bildirim.size = Vector2(500, 50)
	add_child(_geri_bildirim)
	get_viewport().gui_release_focus()
	_baslat()
	_durum_yaz()


func _process(delta: float) -> void:
	_t += delta
	if _gb_sure > 0.0:
		_gb_sure -= delta
		_geri_bildirim.modulate.a = clampf(_gb_sure / 0.4, 0.0, 1.0)
	if not _bitti:
		_ilerle(delta)
	_alan.queue_redraw()


func _input(event: InputEvent) -> void:
	var basis := event.is_action_pressed("ui_accept") or (event is InputEventMouseButton
			and (event as InputEventMouseButton).pressed and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT)
	if basis:
		get_viewport().set_input_as_handled()
		bas()


## Oyuncunun tek eylemi (ok at / düveni vur). Otomatik oyuncu da bunu çağırır.
func bas() -> void:
	if not _bitti:
		_bas()


## Kısa geri bildirim yazısı (isabet, ıska).
func _bildir(metin: String, renk: Color) -> void:
	_geri_bildirim.text = metin
	_geri_bildirim.add_theme_color_override("font_color", renk)
	_gb_sure = 1.0


## Oyunu bitirir; sonuç kısa bir süre görünür, sonra `bitti` yayılır.
func _bitir() -> void:
	if _bitti:
		return
	_bitti = true
	_durum.text = tr("arayuz.oyun.puan") % [puan, azami]
	Ses.cal(&"sfx_onay")
	await get_tree().create_timer(KAPANIS).timeout
	bitti.emit(puan, azami)


func _tur() -> String:
	return ""


func _baslat() -> void:
	pass


func _ilerle(_delta: float) -> void:
	pass


func _bas() -> void:
	pass


func _durum_yaz() -> void:
	pass


func _alan_ciz(_c: Control, _merkez: Vector2) -> void:
	pass
