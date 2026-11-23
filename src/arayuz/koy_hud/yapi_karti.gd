## Katalogdan ad, maliyet ve inşa süresi gösteren klavye ile seçilebilir yapı kartı.
class_name YapiKarti
extends Button

const IKONLAR := {"cadir": "cadir", "kulube": "kulube", "tarla": "gida", "hizarhane": "odun", "odunluk": "tomruk", "tas_ocagi": "tas", "kirec_kuyusu": "kirec", "tas_ev": "kulube", "avci": "avci", "atolye": "alet", "ambar": "ambar"}
const KOY_PNG_KOK := "res://assets/ui/koy/gece_kapisi/"
const YAPI_PNG := {
	"agil": "agil",
	"ahir": "ahir",
	"degirmen": "degirmen",
	"demirhane": "demirhane",
	"firin": "firin",
	"muhafiz_kislasi": "kislasi",
	"sifahane": "sifahane",
	"kulube": "kulube",
	"cadir": "cadir",
	"tas_ev": "tas_ev",
	"tarla": "tarla",
	"bostan": "bostan",
	"odunluk": "odunluk",
	"hizarhane": "hizarhane",
	"tas_ocagi": "tas_ocagi",
	"kirec_kuyusu": "kirec_kuyusu",
	"avci": "avci",
	"ambar": "ambar",
	"atolye": "atolye",
	"cozumleme_odasi": "cozumleme_odasi",
}

## Kartı güncel simülasyon verisiyle kurar; satın alma kuralı oyunun kaynaklarına dayanır.
func kur(tur: String, y: KoyYonetimi, ayarlar: Ayarlar) -> void:
	set_meta("yapi_turu", tur)
	custom_minimum_size = Vector2(220, 136)
	focus_mode = Control.FOCUS_ALL
	var m := y.katalog.maliyet(tur)
	disabled = not y.kaynaklar.yeterli(_malzeme(m)) or y.akce < int(m.get("akce", 0))
	var kilit := YapiKilidi.durum(y, tur)
	disabled = disabled or not kilit.acik
	tooltip_text = MeslekYapilari.aciklama(tur)
	var v := VBoxContainer.new()
	v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	v.offset_left = 22
	v.offset_right = -22
	v.offset_top = 12
	v.offset_bottom = -12
	v.add_theme_constant_override("separation", 6)
	add_child(v)
	var baslik := HBoxContainer.new()
	baslik.add_theme_constant_override("separation", 10)
	v.add_child(baslik)
	baslik.add_child(_yapi_ikonu(tur, 38))
	var ad := _etiket(MeslekYapilari.ad(tur), ayarlar.boyut(Kabuk.KUCUK))
	ad.add_theme_font_override("font", Tema.koy_baslik_fontu())
	baslik.add_child(ad)
	var maliyet := HBoxContainer.new()
	maliyet.add_theme_constant_override("separation", 8)
	v.add_child(maliyet)
	for kaynak in m:
		maliyet.add_child(KaynakGostergesi.ikon(kaynak, 22))
		var adet := _etiket(str(int(m[kaynak])), ayarlar.boyut(Kabuk.KUCUK))
		var elde: int = y.akce if kaynak == "akce" else y.kaynaklar.miktar(kaynak)
		if elde < int(m[kaynak]):
			adet.add_theme_color_override("font_color", Hud.UYARI)
		maliyet.add_child(adet)
	var veri := y.katalog.veri(tur)
	var bilgi := _etiket(tr("koy.kart.sure") % int(veri.get("insa_gun", 1)), ayarlar.boyut(Kabuk.KUCUK))
	bilgi.add_theme_color_override("font_color", Kabuk.SOLUK)
	v.add_child(bilgi)
	if disabled:
		bilgi.text = tr("koy.kart.eksik")
		bilgi.add_theme_color_override("font_color", Hud.UYARI)
	if not kilit.acik:
		bilgi.text = YapiKilidi.metin(y, tur)
		bilgi.add_theme_color_override("font_color", Kabuk.SOLUK)
		tooltip_text += "\n" + bilgi.text
	bilgi.name = "YapiKademeBilgisi"
	bilgi.text = "K%d · %s" % [y.katalog.kademe(tur), bilgi.text]
	_girdiyi_gecir(v)
	# Çocuk içerik font ölçeğiyle büyür; yatay liste taşanı kaydırır.
	custom_minimum_size = v.get_combined_minimum_size() + Vector2(44, 24)

func _etiket(yazi: String, punto: int) -> Label:
	var l := Label.new()
	l.text = yazi
	l.add_theme_font_size_override("font_size", punto)
	return l

func _girdiyi_gecir(n: Control) -> void:
	n.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for c in n.get_children():
		if c is Control:
			_girdiyi_gecir(c)

func _malzeme(m: Dictionary) -> Dictionary:
	var sonuc := m.duplicate()
	sonuc.erase("akce")
	return sonuc


static func _yapi_ikonu(tur: String, boy: int) -> Control:
	if tur == GozcuKulesi.TUR:
		return GozcuKulesiGorseli.ikon(boy)
	if YAPI_PNG.has(tur):
		var png_yol := KOY_PNG_KOK + String(YAPI_PNG[tur]) + ".png"
		if ResourceLoader.exists(png_yol):
			var r := TextureRect.new()
			r.texture = load(png_yol)
			r.custom_minimum_size = Vector2(boy, boy)
			r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			r.mouse_filter = Control.MOUSE_FILTER_IGNORE
			return r
	return KaynakGostergesi.ikon(IKONLAR.get(tur, "kulube"), boy)
