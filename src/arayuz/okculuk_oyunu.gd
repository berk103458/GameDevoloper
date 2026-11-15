## Okçuluk: salınan nişangâh hedefin ortasından geçerken at. Merkez 2, halka 1 puan; her okta nişangâh hızlanır.
## Kurallar: design/gdd/koy-mini-oyunlari.md · hesap: Zamanlama
class_name OkculukOyunu
extends MiniOyun

const HEDEF_R := 220.0
## Bir ok atıldıktan sonra saplanmış okun görünür kaldığı süre (s).
const DURAKLAMA := 0.8

var _ok := 0
var _t_ok := 0.0
var _durak := 0.0
var _izler: Array[Vector2] = []
var _konum := Vector2.ZERO


func _tur() -> String:
	return "okculuk"


func _baslat() -> void:
	azami = oyun.okculuk_ok * 2


func _hiz() -> float:
	return oyun.okculuk_hiz + _ok * oyun.okculuk_hiz_artis


func _ilerle(delta: float) -> void:
	if _durak > 0.0:
		_durak -= delta
		if _durak <= 0.0:
			if _ok >= oyun.okculuk_ok:
				_bitir()
			else:
				_t_ok = 0.0
		return
	_t_ok += delta
	_konum = Zamanlama.nisangah(_t_ok + _ok * 0.37, _hiz())


func _bas() -> void:
	if _durak > 0.0 or _ok >= oyun.okculuk_ok:
		return
	var p := Zamanlama.ok_puani(_konum, oyun.okculuk_merkez, oyun.okculuk_halka)
	puan += p
	_izler.append(_konum)
	_ok += 1
	_durak = DURAKLAMA
	Ses.cal(&"sfx_ok", -2.0)
	match p:
		2:
			_bildir(tr("arayuz.oyun.tam"), MenuSatiri.ALTIN)
		1:
			_bildir(tr("arayuz.oyun.kenar"), Renkler.KUL)
		_:
			_bildir(tr("arayuz.oyun.iska"), Hud.UYARI)
	_durum_yaz()


func _durum_yaz() -> void:
	_durum.text = "%s    ·    %s" % [tr("arayuz.oyun.ok") % [mini(_ok + 1, oyun.okculuk_ok), oyun.okculuk_ok],
			tr("arayuz.oyun.puan") % [puan, azami]]


func _alan_ciz(c: Control, m: Vector2) -> void:
	# Hedef: saman balyası üstünde boyalı halkalar (dış krem, halka kızıl, merkez altın).
	var balya := Rect2(m - Vector2(HEDEF_R + 40, HEDEF_R + 30), Vector2(HEDEF_R * 2 + 80, HEDEF_R * 2 + 60))
	c.draw_rect(balya, Kabuk.PANEL_KENAR)
	for k in 7:
		var y := balya.position.y + 18 + k * (balya.size.y - 36) / 6.0
		c.draw_line(Vector2(balya.position.x + 8, y), Vector2(balya.end.x - 8, y), Renkler.AHSAP, 3.0)
	c.draw_circle(m, HEDEF_R, Kabuk.yazi())
	c.draw_circle(m, HEDEF_R * oyun.okculuk_halka, Hud.UYARI)
	c.draw_circle(m, HEDEF_R * oyun.okculuk_merkez, MenuSatiri.ALTIN)
	for r in [1.0, oyun.okculuk_halka, oyun.okculuk_merkez]:
		c.draw_arc(m, HEDEF_R * r, 0.0, TAU, 64, Renkler.MUREKKEP, 2.0)
	# Saplanmış oklar: gövde ve tüy.
	for iz in _izler:
		var p := m + iz * HEDEF_R
		c.draw_line(p, p + Vector2(26, 34), Renkler.AHSAP, 4.0)
		c.draw_line(p + Vector2(22, 28), p + Vector2(34, 30), Kabuk.yazi(), 3.0)
		c.draw_line(p + Vector2(22, 28), p + Vector2(24, 42), Kabuk.yazi(), 3.0)
		c.draw_circle(p, 4.0, Renkler.MUREKKEP)
	# Nişangâh.
	if _durak <= 0.0 and not _bitti:
		var n := m + _konum * HEDEF_R
		c.draw_arc(n, 26.0, 0.0, TAU, 32, Renkler.MESALE, 3.0)
		for d in [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]:
			c.draw_line(n + d * 10.0, n + d * 38.0, Renkler.MESALE, 3.0)
	# Kalan oklar (sol alt).
	for k in oyun.okculuk_ok - _ok:
		var x := 20.0 + k * 22.0
		c.draw_line(Vector2(x, c.size.y - 10), Vector2(x, c.size.y - 80), Kabuk.PANEL_KENAR, 4.0)
		c.draw_colored_polygon(PackedVector2Array([Vector2(x - 7, c.size.y - 78), Vector2(x + 7, c.size.y - 78), Vector2(x, c.size.y - 94)]), Renkler.KUL)
