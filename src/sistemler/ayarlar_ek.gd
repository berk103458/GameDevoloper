## Bölüm 35 ek ayarları (AYR-02, AYR-44): çekirdek `ayarlar.gd` değişmez.
## Bu bölümün yeni anahtarları `VARSAYILAN` ve `GECERLI` listelerinde durur ve açılışta
## `Ayarlar.degerler` sözlüğüne birleştirilir; `Ayarlar.al()` ek anahtarı da okur.
## Geçersiz değer o anahtarın varsayılanına döner, tek satır günlük yazılır (AYR-44).
class_name AyarlarEk
extends RefCounted

## Bu bölümün yeni anahtarları ve varsayılanları. Kalan bölüm anahtarlarını kendi maddeleri ekler.
## Değerleri ROADMAP_2'de birebir yazılı maddelerden alınmıştır: AYR-08, AYR-13, AYR-24.
const VARSAYILAN := {
	&"satir_araligi": &"normal",
	&"metin_agirligi": 400,
	&"koy_hizi_varsayilan": 1,
}
## Seçenekli ek anahtarların geçerli değerleri.
const GECERLI := {
	&"satir_araligi": [&"normal", &"genis"],
	&"metin_agirligi": [400, 500],
	&"koy_hizi_varsayilan": [1, 2, 3],
}

## AYR-44 günlüğü: reddedilen her değer için bir satır; `_reddet()` doldurur.
static var gecersizler: Array[String] = []


## Açılışta çağrılır (ana.gd tek satır): ek varsayılanları birleştirir, dosyadaki ek değerleri
## doğrulayarak üzerine yazar. Geçersiz değer varsayılanda kalır ve loglanır.
static func bagla(a: Ayarlar) -> void:
	gecersizler.clear()
	for anahtar in VARSAYILAN:
		if not a.degerler.has(anahtar):
			a.degerler[anahtar] = VARSAYILAN[anahtar]
	if not FileAccess.file_exists(a.yol):
		return
	var cfg := ConfigFile.new()
	# `Ayarlar.yukle()` aynı dosyayı az önce okudu; bozuk dosyanın ayrıştırma teşhisi orada bir kez
	# basıldı. Aynı teşhisi ikinci kez yazmamak için yalnız bu okuma boyunca hata basımı kapatılır.
	var onceki := Engine.print_error_messages
	Engine.print_error_messages = false
	var sonuc := cfg.load(a.yol)
	Engine.print_error_messages = onceki
	if sonuc != OK:
		return
	for anahtar in cfg.get_section_keys("ayarlar"):
		var k := StringName(anahtar)
		if not VARSAYILAN.has(k):
			continue
		var v: Variant = cfg.get_value("ayarlar", anahtar)
		if _gecerli(k, v):
			a.degerler[k] = _donustur(v)
		else:
			_reddet(k, v)


## Ek anahtarı değiştirir ve hemen uygular (çekirdek `Ayarlar.ayarla` ek anahtarı bilmez).
## Geçersiz değer reddedilir, değer değişmez; `true` döner yalnız değer kabul edildiğinde.
static func ayarla(a: Ayarlar, anahtar: StringName, deger: Variant) -> bool:
	if not _gecerli(anahtar, deger):
		_reddet(anahtar, deger)
		return false
	a.degerler[anahtar] = _donustur(deger)
	a.uygula()
	a.degisti.emit(anahtar)
	return true


## Ek anahtarın geçerli değerler listesi; bilinmeyen anahtar geçersizdir.
static func _gecerli(anahtar: StringName, deger: Variant) -> bool:
	if not GECERLI.has(anahtar):
		return false
	var liste: Array = GECERLI[anahtar]
	return _donustur(deger) in liste


static func _donustur(deger: Variant) -> Variant:
	return StringName(deger) if deger is String else deger


## Tek satır günlük (AYR-44): satır listeye yazılır ve hata olarak basılır.
static func _reddet(anahtar: StringName, deger: Variant) -> void:
	var satir := "Geçersiz ayar %s=%s; varsayılan kullanılıyor" % [anahtar, deger]
	gecersizler.append(satir)
	push_error(satir)
