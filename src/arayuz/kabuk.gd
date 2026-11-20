## Tema seçilmeden duran ortak kabuk. Renk, boşluk ve punto burada toplanır.
## Hazır paketlerden biri burada seçilmez.
## Sabah seçilen tema Kabuk.panel() ve zemin renkleriyle bütün çağrıları değiştirir.
class_name Kabuk
extends RefCounted

const GOVDE := 26
const KUCUK := 22
const BASLIK := 34
const KENAR := 20
const AYIRIM := 12
const DUGME_Y := 48
const IPUCU_GENISLIK := 720
const IPUCU_ALT := 28
const IPUCU_YUKSEKLIK := 56

const PANEL_DOLGU := Color("201f1bed")
const PANEL_KENAR := Color("64543a")
const SOLUK := Color("aaa18e")
const YORGUNLUK := Color("6E7BA8")
const MORAL := Color("7FA86E")
const STOK_SU := Color("678fa7")
const STOK_KUMAS := Color("857c65")
const LEVHA := Color(0.06, 0.05, 0.04, 0.95)
const BAR_ARKA := Color("36362e")
const BAR_DOLU := Color("c6a56b")


static func zemin() -> Color:
	return Renkler.GECE


static func yazi() -> Color:
	return Renkler.KUL


static func vurgu() -> Color:
	return MenuSatiri.ALTIN


static func panel() -> StyleBox:
	var doku := GeceKapisiCerceve.panel()
	if doku != null:
		return doku
	return _duz_panel()


static func _duz_panel() -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = PANEL_DOLGU
	s.border_color = PANEL_KENAR
	s.set_border_width_all(1)
	s.set_corner_radius_all(0)
	s.shadow_size = 0
	s.content_margin_left = 12
	s.content_margin_right = 12
	s.content_margin_top = 6
	s.content_margin_bottom = 6
	return s


static func bar_stili(renk: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = renk
	return s


static func renkten(hex: String) -> Color:
	return Color.from_string(hex, SOLUK)


## Eksik asset için tek renkli yer tutucu kutu. Renk veri dosyasından gelir;
## paneller ColorRect'i kendisi kurmaz, gerçek asset gelince yalnız burası değişir.
static func yer_tutucu(ad: String, renk_hex: String, boy: Vector2) -> ColorRect:
	var kutu := ColorRect.new()
	kutu.name = ad
	kutu.color = Color.from_string(renk_hex, SOLUK)
	kutu.custom_minimum_size = boy
	kutu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	kutu.set_meta("kabuk_yer_tutucu", true)
	return kutu


## Sağ alt menü ipucu kutusu. Ölçek büyüyünce kutu uzar, ekranın içinde kalır.
static func ipucu_kutusu(ekran: Vector2, olcek: int) -> Rect2:
	var yuk := maxi(KUCUK, roundi(IPUCU_YUKSEKLIK * olcek / 100.0))
	var gen := float(mini(IPUCU_GENISLIK, int(ekran.x) - KENAR * 2))
	var x := ekran.x - KENAR - gen
	var y := ekran.y - IPUCU_ALT - yuk
	return Rect2(Vector2(x, y), Vector2(gen, yuk))
