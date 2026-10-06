## Bir adlı karakterin sohbeti: ziyaret başına giriş ve sorular.
class_name SohbetVerisi
extends Resource

@export var id: StringName
## Ziyaret başına giriş anlatısı (1. ziyaret = indeks 0); fazla ziyarette son giriş kullanılır.
@export var giris_anahtarlari: PackedStringArray
## Ziyaret başına açılış sözü: gelen kapıya varınca kendini ve hikâyesini anlatır.
@export var acilis_anahtarlari: PackedStringArray
@export var soru_anahtarlari: PackedStringArray
@export var cevap_anahtarlari: PackedStringArray
## Sorunun sorulabildiği ziyaret (1'den); 0 = her ziyarette.
@export var soru_ziyareti: PackedInt32Array
## Sorunun üst sorusu (takip sorusu ise); -1 = kök. Üst soru sorulunca açılır.
@export var soru_ust: PackedInt32Array
## Soru sorulup cevabı alınınca açılan bayrak (koşullu kilit, design/gdd/koy-yonetimi.md 1.3–1.4); boş = yok.
@export var soru_bayraklari: PackedStringArray


## Verilen ziyarette sorulabilen soruların indeksleri.
func sorular(ziyaret: int) -> PackedInt32Array:
	var sonuc := PackedInt32Array()
	var en_son := 0
	for z in soru_ziyareti:
		en_son = maxi(en_son, z)
	var hedef := mini(ziyaret, en_son)
	for i in soru_anahtarlari.size():
		if soru_ziyareti[i] == 0 or soru_ziyareti[i] == hedef:
			sonuc.append(i)
	return sonuc


## `sorular(ziyaret)` ile aynı sırada soru bayrakları.
func soru_bayraklari_ziyaret(ziyaret: int) -> PackedStringArray:
	var s := PackedStringArray()
	for i in sorular(ziyaret):
		s.append(soru_bayraklari[i] if i < soru_bayraklari.size() else "")
	return s


## Ziyaretin giriş anlatısı anahtarı.
func giris(ziyaret: int) -> String:
	return giris_anahtarlari[clampi(ziyaret - 1, 0, giris_anahtarlari.size() - 1)]


## Ziyaretin açılış sözü anahtarı; yoksa boş.
func acilis(ziyaret: int) -> String:
	if acilis_anahtarlari.is_empty():
		return ""
	return acilis_anahtarlari[clampi(ziyaret - 1, 0, acilis_anahtarlari.size() - 1)]


## Sorunun üst sorusu (-1 = kök).
func ust(i: int) -> int:
	return soru_ust[i] if i < soru_ust.size() else -1
