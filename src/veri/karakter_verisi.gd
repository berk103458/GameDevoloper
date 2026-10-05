## Bir adlı karakterin değişmez verisi (design/gdd/karakter-kadrosu.md, Core Rules 14).
class_name KarakterVerisi
extends Resource

## Kimlik; dosya adına eşit, ASCII snake_case.
@export var id: StringName
## Ad metninin çeviri anahtarı (`karakter.<id>.ad`).
@export var ad_anahtari: StringName
## `yabanci` ya da `yerel`.
@export var koken: StringName
## Kabul edilince köye yazılan sınıf: `asker`, `esnaf`, `ciftci`.
@export var sinif: StringName
## Bu karakterin sohbet kaydı (`data/sohbetler/<id>.tres`).
@export var sohbet_id: StringName
## Bu karaktere sunulan karar kimlikleri (Karar 7'nin tanıdıkları).
@export var karar_secenekleri: PackedStringArray
## Karar başına bar etkileri; sıra `OyunAyarlari.bar_anahtarlari` ile aynı.
@export var etki_kabul: PackedInt32Array
@export var etki_ret: PackedInt32Array
@export var etki_rusvet: PackedInt32Array
@export var etki_kisla: PackedInt32Array
## `hic_donmez`, `oranla_doner` ya da `birden_cok_gelir`.
@export var donus_kurali: StringName
@export var p0: float = 0.6
@export var d: float = 0.5
@export var k_azami: int = 4
@export var n_ziyaret: int = 1
@export var g_min: int = 2
@export var g_max: int = 4
## Bu geceden (gun_sayaci) önce gelmez.
@export var en_erken_gece: int = 0
## Portre dosya kökü: `char_<portre>_neutral_card.png`.
@export var portre: StringName
## Bu karaktere sorulabilecek en çok soru; 0 = genel ayar (`OyunAyarlari.azami_soru`).
@export var azami_soru: int = 0
## Kötü niyetli mi (karakter sayfasındaki fraksiyon): retteki tepki öfke olur, masumda yıkılma.
@export var tehlikeli: bool = false


## Verilen kararın bar etkisini döner; tanınmayan karar için boş dizi.
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
