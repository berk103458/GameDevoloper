## Adsız sınıf figürlerinin şablonu (karakter-kadrosu.md, Core Rules 5–7).
class_name SinifSablonu
extends Resource

## Sınıf adıyla aynı: `asker`, `esnaf`, `ciftci`.
@export var id: StringName
@export var sinif: StringName
## Figür adlarının çeviri anahtarları (≥ 3).
@export var ad_havuzu: PackedStringArray
## Çeşit başına giriş anlatısı anahtarı; çeşit sayısı = bu dizinin boyu.
@export var giris_anahtarlari: PackedStringArray
## Çeşit başına açılış sözü (gelenin kendini anlattığı söz).
@export var acilis_anahtarlari: PackedStringArray
## Çeşit başına portre kökü.
@export var portreler: PackedStringArray
## Sorular: anahtar, cevap anahtarı ve ait olduğu çeşit (0'dan).
@export var soru_anahtarlari: PackedStringArray
@export var cevap_anahtarlari: PackedStringArray
@export var soru_cesidi: PackedInt32Array
## Takip sorusunun üst sorusu (-1 = kök).
@export var soru_ust: PackedInt32Array
@export var karar_secenekleri: PackedStringArray
@export var etki_kabul: PackedInt32Array
@export var etki_ret: PackedInt32Array
@export var etki_rusvet: PackedInt32Array
@export var etki_kisla: PackedInt32Array


## Verilen kararın bar etkisini döner.
func etki(karar: StringName) -> PackedInt32Array:
	match karar:
		&"kabul":
			return etki_kabul
		&"ret":
			return etki_ret
		&"rusvet":
			return etki_rusvet
		&"kisla":
			return etki_kisla
	return PackedInt32Array()
