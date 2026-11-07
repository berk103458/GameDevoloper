## Üst kaynak şeridi (design/gdd/koy-yonetimi.md, 17.1 ve 17.5): akçe ve ambar stokları (günlük net değişimle),
## mevsim takvimi, nüfus / yatak, köy huzuru barı, adalet ve asayiş; erzak 2 günden azsa ya da asayiş kritikse
## ilgili gösterge yanıp söner. Renk paleti sanat kitabındaki gibi: uyarı kızıl değil, meşale rengidir.
class_name Hud
extends PanelContainer

const STOKLAR: Array[String] = ["gida", "odun", "tas", "kereste", "alet", "tomruk", "bugday", "un", "kirec", "harc", "cevher", "demir", "civi", "tirpan", "balta", "afyon", "sargi", "kece", "kumas", "zirh", "yay", "kalkan", "su", "saman"]
const UYARI := Color("#C4843A")
## Asayiş riski bu değerin üstündeyse kritik sayılır.
const ASAYIS_KRITIK := 60

var _oturum: Oturum
var _akce: KaynakGostergesi
var _kese: KeseGostergesi
var _stok_etiketleri: Dictionary = {}
var _gun: Label
var _mevsim: Label
var _nufus: Label
var _huzur_bar: ProgressBar
var _adalet_bar: ProgressBar
var _ambar_bar: ProgressBar
var _huzur_etiket: Label
var _adalet: Label
var _asayis: Label
## Bir önceki güncellemedeki stoklar ve gün (net değişim için).
var _onceki: Dictionary = {}
var _onceki_gun := -1
var _net: Dictionary = {}
var _zaman := 0.0
var _katman = preload("res://src/arayuz/koy_hud/hud_katmani.gd").new()

func katmanlari_kur(oturum: Oturum, ayarlar: Ayarlar) -> void:
	_katman.kur(oturum, ayarlar)
	if ayarlar != null and not ayarlar.degisti.is_connected(_katman_ayari_degisti):
		ayarlar.degisti.connect(_katman_ayari_degisti)

func _katman_ayari_degisti(anahtar: StringName) -> void:
	if anahtar == &"kademeli_hud": guncelle()

func _notification(ne: int) -> void:
	if ne == NOTIFICATION_PREDELETE: _katman.temizle()


## HUD'u bir oturuma bağlar.
func bagla(oturum: Oturum) -> void:
	_oturum = oturum
	oturum.koy.degisti.connect(guncelle)
	guncelle()


func _ready() -> void:
	custom_minimum_size = Vector2(0, 108)
	add_theme_stylebox_override("panel", Tema.koy_paneli())
	var kutu := HBoxContainer.new()
	kutu.add_theme_constant_override("separation", 14)
	var kaynak_kaydir := ScrollContainer.new()
	kaynak_kaydir.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	kaynak_kaydir.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	kaynak_kaydir.follow_focus = true
	kutu.add_child(kaynak_kaydir)
	_kese = KeseGostergesi.new()
	kutu.add_child(_kese)
	_katman.izle(_kese, "kese_gostergesi.gd")
	var kaynaklar := HBoxContainer.new()
	kaynaklar.add_theme_constant_override("separation", 8)
	kaynak_kaydir.add_child(kaynaklar)
	_akce = _kaynak(kaynaklar, "akce")
	for t in STOKLAR:
		_stok_etiketleri[t] = _kaynak(kaynaklar, t)
	var orta := Control.new()
	orta.custom_minimum_size.x = 4
	kutu.add_child(orta)
	var huzur := VBoxContainer.new()
	huzur.add_theme_constant_override("separation", 4)
	_huzur_etiket = _etiket(huzur, Tema.KUCUK_PX)
	_huzur_bar = _bar(huzur)
	kutu.add_child(huzur)
	_katman.izle(huzur, "hud.gd", "huzur")
	var gosterge := VBoxContainer.new()
	_adalet = _etiket(gosterge, Tema.KUCUK_PX)
	_adalet_bar = _bar(gosterge)
	_asayis = _etiket(gosterge, Tema.KUCUK_PX)
	kutu.add_child(gosterge)
	_katman.izle(gosterge, "hud.gd", "adalet_asayis")
	var sag := VBoxContainer.new()
	_gun = _etiket(sag, Tema.BASLIK_PX)
	_gun.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_mevsim = _etiket(sag, Tema.KUCUK_PX)
	_mevsim.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_nufus = _etiket(sag, Tema.KUCUK_PX)
	_nufus.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_ambar_bar = _bar(sag)
	kutu.add_child(sag)
	_katman.izle(sag, "hud.gd", "takvim")
	_katman.guncelle()
	add_child(kutu)
	set_process(false)
	visibility_changed.connect(_islem_ayarla)

func _islem_ayarla() -> void:
	preload("res://src/arayuz/hud_islem_kapisi.gd").uygula(self)


func _etiket(ust: Control, punto: int) -> Label:
	var l := Label.new()
	l.add_theme_font_size_override("font_size", roundi(punto * float(get_theme_default_font_size()) / Tema.GOVDE_PX))
	l.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	ust.add_child(l)
	return l


func _process(delta: float) -> void:
	_zaman += delta
	if _oturum == null:
		return
	# Uyarılar yanıp söner (zamanlayıcıyla değil, kare başı tek bir alfa: bellek tahsisi yok).
	var yanip := 0.55 + 0.45 * sin(_zaman * 6.0)
	var y := _oturum.yonetim
	(_stok_etiketleri["gida"] as KaynakGostergesi).modulate.a = yanip if y.gida_gunu() < 2.0 and y.nufus() > 0 else 1.0
	_asayis.modulate.a = yanip if y.asayis_riski >= ASAYIS_KRITIK else 1.0
	_huzur_etiket.modulate.a = yanip if y.isyan_kalan >= 0 else 1.0


## Tüm göstergeleri oturumdan yeniden çizer.
func guncelle() -> void:
	if _oturum == null:
		return
	_islem_ayarla()
	var y := _oturum.yonetim
	var meclis_gerekli: bool = not CinarAltiMeclisi._krizler(y).is_empty() or not CinarAltiMeclisi.durum(y).oylama.is_empty()
	var histeri_gerekli := preload("res://src/koy/batil_inanc_histerisi.gd").bekliyor(y)
	var zorunlular := PackedStringArray()
	if meclis_gerekli or histeri_gerekli or y.isyan_kalan >= 0: zorunlular.append("hud.gd:huzur")
	if y.asayis_riski >= ASAYIS_KRITIK: zorunlular.append("hud.gd:adalet_asayis")
	_katman.guncelle(zorunlular)
	var k := y.kaynaklar
	if y.gun != _onceki_gun:
		_net.clear()
		if _onceki_gun >= 0:
			for t in STOKLAR:
				_net[t] = k.miktar(t) - int(_onceki.get(t, 0))
			_net["akce"] = y.akce - int(_onceki.get("akce", y.akce))
		_onceki["akce"] = y.akce
		_onceki_gun = y.gun
		for t in STOKLAR:
			_onceki[t] = k.miktar(t)
	_akce.guncelle(y.akce, int(_net.get("akce", 0)), y.akce < 0)
	_akce.tooltip_text = IflasYoneticisi.tip(y)
	if _kese.is_inside_tree(): _kese.guncelle(_oturum)
	for t in STOKLAR:
		var l: KaynakGostergesi = _stok_etiketleri[t]
		l.guncelle(k.miktar(t), int(_net.get(t, 0)), t == "gida" and y.gida_gunu() < 2.0 and y.nufus() > 0)
		if t in ["gida", "odun"]: l.tooltip_text = TuketimDengesi.tip(y, t)
		if t == "su": l.tooltip_text = SuDengesi.tip(y)
		if t == "saman": l.tooltip_text = SamanBakimi.tip(y)
		if t == "alet": l.tooltip_text = AletAsinmaBilgisi.tip(y)
	_huzur_etiket.text = (tr("arayuz.hud.isyan") % y.isyan_kalan) if y.isyan_kalan >= 0 else tr("arayuz.hud.huzur") % y.huzur()
	_huzur_bar.value = y.huzur()
	_huzur_bar.tooltip_text = _huzur_etiket.text
	_adalet_bar.value = y.adalet
	_ambar_bar.max_value = maxi(1, k.kapasite)
	_ambar_bar.value = k.toplam()
	_ambar_bar.tooltip_text = (tr("koy.hud.ambar") % [k.toplam(), k.kapasite]) + "\n" + AmbarBakimi.tip()
	if _katman.acik("ambar_kapisi_paneli.gd", "ana", KitlikIsyani.durum(y).kapi_kirik):
		AmbarKapisiPaneli.hud(self, y)
	else:
		_katman.gecici_kaldir(_ambar_bar.get_parent(), "ambar_kapisi_onar")
	CinarMeclisPaneli.hud(self, y, _katman.acik("cinar_meclis_paneli.gd", "ana", meclis_gerekli))
	if _katman.acik("histeri_paneli.gd", "ana", histeri_gerekli):
		preload("res://src/arayuz/koy_hud/histeri_paneli.gd").hud(self, y)
	else:
		_katman.gecici_kaldir(_huzur_bar.get_parent(), "histeri_karari")
	_adalet.text = tr("arayuz.hud.adalet") % y.adalet
	_asayis.text = tr("arayuz.hud.asayis") % y.asayis_riski
	_asayis.add_theme_color_override("font_color", UYARI if y.asayis_riski >= ASAYIS_KRITIK else Renkler.KUL)
	_gun.text = tr("arayuz.hud.gun") % (y.gun + 1)
	MevsimTakvim.guncelle(_mevsim, y)
	if _katman.acik("bosta_gostergesi.gd"):
		preload("res://src/arayuz/koy_hud/bosta_gostergesi.gd").guncelle(self, y)
	else:
		_katman.gecici_kaldir(_nufus.get_parent(), "BostaSayisi")
	if _katman.koy_hudu(): KarantinaPaneli.hud_guncelle(self, y, _katman)
	_nufus.text = tr("arayuz.hud.nufus") % [y.nufus(), y.yatak_kapasitesi(), k.toplam(), k.kapasite]
	preload("res://src/arayuz/kapi/bar_bicimi.gd").isaretle(self)
	if _katman.acik("acilis_kapi_bilgisi.gd"):
		preload("res://src/arayuz/koy_hud/acilis_kapi_bilgisi.gd").guncelle(self, _oturum)


func _bar(ust: Control) -> ProgressBar:
	var bar := ProgressBar.new()
	bar.custom_minimum_size = Vector2(150, 8)
	bar.show_percentage = false
	bar.mouse_filter = Control.MOUSE_FILTER_PASS
	var arka := StyleBoxFlat.new()
	arka.bg_color = Color("36362e")
	var dolu := StyleBoxFlat.new()
	dolu.bg_color = KaynakGostergesi.BRONZ
	bar.add_theme_stylebox_override("background", arka)
	bar.add_theme_stylebox_override("fill", dolu)
	ust.add_child(bar)
	return bar


func _kaynak(ust: Control, tur: String) -> KaynakGostergesi:
	var kart := KaynakGostergesi.new()
	ust.add_child(kart)
	var olcek := float(get_theme_default_font_size()) / Tema.GOVDE_PX
	kart.kur(tur, roundi(18 * olcek))
	_katman.izle(kart, "kaynak_gostergesi.gd", tur)
	return kart
