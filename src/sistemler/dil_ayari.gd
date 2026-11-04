## YER-01, YER-03, YER-08: dil ayarı `ayarlar.cfg` anahtarı `dil`. Çekirdek listeye eklenmez.
class_name DilAyari
extends RefCounted

const ANAHTAR := &"dil"
const VARSAYILAN := "tr"
const DOSYA_EN := "res://data/metin/metinler.en.translation"

static var uyari_sayisi := 0


static func diller() -> PackedStringArray:
	var liste := PackedStringArray([VARSAYILAN])
	if FileAccess.file_exists(DOSYA_EN):
		liste.append("en")
	return liste


## Dosyadaki değeri okur. Bilinmeyen kod `tr` olur ve bir uyarı yazar.
static func bagla(a: Ayarlar) -> void:
	uyari_sayisi = 0
	var kod := VARSAYILAN
	if a != null and FileAccess.file_exists(a.yol):
		var cfg := ConfigFile.new()
		var onceki := Engine.print_error_messages
		Engine.print_error_messages = false
		var sonuc := cfg.load(a.yol)
		Engine.print_error_messages = onceki
		if sonuc == OK and cfg.has_section("ayarlar"):
			kod = str(cfg.get_value("ayarlar", "dil", VARSAYILAN))
	kod = _gecerli(kod)
	if a != null:
		a.degerler[ANAHTAR] = kod
		if not a.degisti.is_connected(_degisti):
			a.degisti.connect(_degisti.bind(a))


static func sec(a: Ayarlar, kod: String) -> bool:
	if a == null or not diller().has(kod):
		return false
	a.degerler[ANAHTAR] = kod
	a.degisti.emit(ANAHTAR)
	return true


static func uygula(a: Ayarlar) -> void:
	var kod := VARSAYILAN
	if a != null:
		kod = _gecerli(str(a.degerler.get(ANAHTAR, VARSAYILAN)))
		a.degerler[ANAHTAR] = kod
	if FileAccess.file_exists(DOSYA_EN) and TranslationServer.get_translation_object("en") == null and ResourceLoader.exists(DOSYA_EN):
		var tr_en := load(DOSYA_EN) as Translation
		if tr_en != null:
			TranslationServer.add_translation(tr_en)
	TranslationServer.set_locale(kod)
	GuvenliMetin.kur()


## Menü ve ayarlar hemen yenilenir. Açık sorgu satırı olduğu gibi kalır.
static func gorunen(ekran: String, eski: String, anahtar: String) -> String:
	if ekran == "sorgu":
		return eski
	if anahtar.is_empty():
		return eski
	return TranslationServer.translate(anahtar)


static func _gecerli(kod: String) -> String:
	var temiz := kod.strip_edges()
	if diller().has(temiz):
		return temiz
	uyari_sayisi += 1
	push_warning("Geçersiz dil ayarı; tr kullanılıyor")
	return VARSAYILAN


static func _degisti(anahtar: StringName, a: Ayarlar) -> void:
	if anahtar == &"":
		a.degerler[ANAHTAR] = VARSAYILAN
	if anahtar != ANAHTAR and anahtar != &"":
		return
	uygula(a)
