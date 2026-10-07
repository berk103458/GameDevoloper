## Oyuncu ayarları (design/gdd/ayarlar-ve-erisilebilirlik.md). Ayrı dosya, anında uygulanır,
## ekrandan çıkınca yazılır. MVP ayarları: ses düzeyleri, ekran modu, metin ölçeği, belirme hızı.
class_name Ayarlar
extends RefCounted

signal degisti(anahtar: StringName)

const VARSAYILAN := {
	&"ses_ana": 8, &"ses_muzik": 7, &"ses_efekt": 8,
	&"ekran_modu": &"tam_ekran", &"metin_olcegi": 100, &"belirme_hizi": &"normal",
	&"grafik_profili": &"normal", &"cozunurluk_3d": 100,
}
const GECERLI := {
	&"ekran_modu": [&"pencere", &"tam_ekran"],
	&"metin_olcegi": [100, 125, 150],
	&"belirme_hizi": [&"normal", &"hizli", &"aninda"],
	&"grafik_profili": [&"normal", &"dusuk"],
	&"cozunurluk_3d": [50, 67, 75, 85, 100],
}
const CARPAN := {&"normal": 1.0, &"hizli": 0.5, &"aninda": 0.0}
const BUSLAR := {&"ses_ana": "Master", &"ses_muzik": "Muzik", &"ses_efekt": "Efekt"}

var degerler: Dictionary = VARSAYILAN.duplicate()
var yol: String
var _pasif: Dictionary = {}


func _init(yol_: String = "user://ayarlar.cfg") -> void:
	yol = yol_


## Dosyayı okur; geçersiz değer o anahtarın varsayılanına döner.
func yukle() -> void:
	degerler = VARSAYILAN.duplicate()
	var cfg := ConfigFile.new()
	if not FileAccess.file_exists(yol):
		return
	if cfg.load(yol) != OK:
		push_error("Ayar dosyası okunamadı; varsayılanlar kullanılıyor")
		return
	for anahtar in cfg.get_section_keys("ayarlar"):
		var a := StringName(anahtar)
		var v: Variant = cfg.get_value("ayarlar", anahtar)
		if not VARSAYILAN.has(a):
			continue
		if _gecerli(a, v):
			degerler[a] = StringName(v) if v is String else v
		else:
			push_error("Geçersiz ayar %s=%s; varsayılan kullanılıyor" % [a, v])


func yaz() -> void:
	var cfg := ConfigFile.new()
	for a in degerler:
		var v: Variant = degerler[a]
		cfg.set_value("ayarlar", String(a), String(v) if v is StringName else v)
	if cfg.save(yol) != OK:
		push_error("Ayar dosyası yazılamadı")


func al(anahtar: StringName) -> Variant:
	return degerler[anahtar]


## Değeri değiştirir ve hemen uygular.
func ayarla(anahtar: StringName, deger: Variant) -> void:
	if not _gecerli(anahtar, deger):
		return
	degerler[anahtar] = deger
	if anahtar == &"grafik_profili":
		degerler[&"cozunurluk_3d"] = 75 if deger == &"dusuk" else 100
	uygula()
	degisti.emit(anahtar)


func varsayilana_don() -> void:
	degerler = VARSAYILAN.duplicate()
	uygula()
	degisti.emit(&"")


## Belirme gecikmesi (ms) — F3.
func belirme_ms(taban: float) -> float:
	return taban * float(CARPAN[degerler[&"belirme_hizi"]])


## Metin boyutu — F2.
func boyut(taban_px: int) -> int:
	return roundi(taban_px * int(degerler[&"metin_olcegi"]) / 100.0)


## Ses ve pencere ayarlarını motora uygular.
func uygula() -> void:
	for a in BUSLAR:
		var bus := AudioServer.get_bus_index(BUSLAR[a])
		if bus < 0:
			continue
		var seviye: int = degerler[a]
		AudioServer.set_bus_mute(bus, seviye == 0)
		if seviye > 0:
			AudioServer.set_bus_volume_db(bus, linear_to_db(seviye / 10.0))
	if DisplayServer.get_name() != "headless":
		var mod := DisplayServer.WINDOW_MODE_FULLSCREEN if degerler[&"ekran_modu"] == &"tam_ekran" else DisplayServer.WINDOW_MODE_WINDOWED
		if DisplayServer.window_get_mode() != mod:
			DisplayServer.window_set_mode(mod)


func _gecerli(a: StringName, v: Variant) -> bool:
	if a in [&"ses_ana", &"ses_muzik", &"ses_efekt"]:
		return (v is int or v is float) and v == floorf(v) and v >= 0 and v <= 10
	if GECERLI.has(a):
		var liste: Array = GECERLI[a]
		if v is String:
			v = StringName(v)
		return v in liste
	return false
