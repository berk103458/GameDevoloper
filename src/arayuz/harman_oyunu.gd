## Harman: daralan halka düvenin çemberine oturduğu anda bas. Her isabet 1 puan; boşa basış en yakın vuruşu yakar.
## Kurallar: design/gdd/koy-mini-oyunlari.md · hesap: Zamanlama
class_name HarmanOyunu
extends MiniOyun

const CEMBER_R := 110.0
## Halkanın daralma hızı (px/s): vuruştan bu kadar önce görünür.
const DARALMA := 190.0
const ILK_VURUS := 1.6

var _vurus := PackedFloat32Array()
var _vuruldu: Array[bool] = []
var _isabet: Array[bool] = []
var _tik := 0
var _donus := 0.0
var _parilti := 0.0
var _parilti_renk := Color.WHITE


func _tur() -> String:
	return "harman"


func _baslat() -> void:
	azami = oyun.harman_vurus
	_vurus = Zamanlama.vuruslar(ILK_VURUS, oyun.harman_aralik, oyun.harman_vurus)
	for i in _vurus.size():
		_vuruldu.append(false)
		_isabet.append(false)


func _ilerle(delta: float) -> void:
	_donus += delta * (0.6 + puan * 0.25)
	_parilti = maxf(0.0, _parilti - delta * 2.5)
	# Davul vuruşu: oyuncu ritmi duyar.
	if _tik < _vurus.size() and _t >= _vurus[_tik]:
		Ses.cal(&"sfx_onay", -6.0)
		_tik += 1
	# Kaçan vuruşlar.
	for i in _vurus.size():
		if not _vuruldu[i] and _t > _vurus[i] + oyun.harman_tolerans:
			_vuruldu[i] = true
			_bildir(tr("arayuz.oyun.iska"), Color("#B5523B"))
			_durum_yaz()
	if _t > _vurus[_vurus.size() - 1] + oyun.harman_tolerans + 0.4:
		_bitir()


func _bas() -> void:
	var i := Zamanlama.vurus_isabeti(_t, _vurus, _vuruldu, oyun.harman_tolerans)
	if i >= 0:
		_vuruldu[i] = true
		_isabet[i] = true
		puan += 1
		_parilti = 1.0
		_parilti_renk = MenuSatiri.ALTIN
		Ses.cal(&"sfx_hasat", -3.0)
		_bildir(tr("arayuz.oyun.isabet"), MenuSatiri.ALTIN)
	else:
		# Boşa basış: yaklaşan ilk vuruş yanar (rastgele basarak puan toplanmaz).
		var yanan := Zamanlama.vurus_isabeti(_t, _vurus, _vuruldu, oyun.harman_aralik * 0.5)
		if yanan >= 0:
			_vuruldu[yanan] = true
		_parilti = 0.6
		_parilti_renk = Color("#B5523B")
		_bildir(tr("arayuz.oyun.iska"), Color("#B5523B"))
	_durum_yaz()


func _durum_yaz() -> void:
	var gecen := 0
	for v in _vuruldu:
		if v:
			gecen += 1
	_durum.text = "%s    ·    %s" % [tr("arayuz.oyun.vurus") % [mini(gecen + 1, azami), azami], tr("arayuz.oyun.puan") % [puan, azami]]


func _alan_ciz(c: Control, m: Vector2) -> void:
	# Harman yeri: toprak daire, serilmiş demetler.
	c.draw_circle(m, 300.0, Color("#4A3A26"))
	for k in 24:
		var a := TAU * k / 24.0 + 0.1
		var p := m + Vector2(cos(a), sin(a)) * 250.0
		c.draw_line(p, p + Vector2(cos(a + 1.3), sin(a + 1.3)) * 30.0, Color("#C9A957"), 5.0)
	# Düven: dönen ahşap çember ve kollar; isabette parlar.
	var cember := Color("#7A5A36").lerp(_parilti_renk, _parilti * 0.7)
	c.draw_arc(m, CEMBER_R, 0.0, TAU, 64, cember, 14.0)
	for k in 6:
		var a := _donus + TAU * k / 6.0
		c.draw_line(m, m + Vector2(cos(a), sin(a)) * (CEMBER_R - 6.0), Color("#5E4428"), 6.0)
	c.draw_circle(m, 16.0, Color("#3D2E24"))
	# Daralan halkalar.
	for i in _vurus.size():
		if _vuruldu[i]:
			continue
		var r := CEMBER_R + (_vurus[i] - _t) * DARALMA
		if r > 300.0 or r < CEMBER_R - 30.0:
			continue
		var a := clampf((300.0 - r) / 100.0, 0.4, 1.0)
		c.draw_arc(m, r, 0.0, TAU, 64, Color(MenuSatiri.ALTIN, a), 5.0)
	# Tane yığını: isabet sayısı kadar büyür (sağda).
	var taban := Vector2(c.size.x - 110, c.size.y - 20)
	var yuk := 14.0 + puan * 9.0
	c.draw_colored_polygon(PackedVector2Array([taban + Vector2(-70, 0), taban + Vector2(70, 0), taban + Vector2(0, -yuk)]), Color("#C9A957"))
