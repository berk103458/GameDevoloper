## Bir adlı karakterin sohbeti: ziyaret başına giriş ve sorular.
class_name SohbetVerisi
extends Resource

@export var id: StringName
## Ziyaret başına giriş anlatısı (1. ziyaret = indeks 0); fazla ziyarette son giriş kullanılır.
@export var giris_anahtarlari: PackedStringArray
@export var soru_anahtarlari: PackedStringArray
@export var cevap_anahtarlari: PackedStringArray
## Sorunun sorulabildiği ziyaret (1'den); 0 = her ziyarette.
@export var soru_ziyareti: PackedInt32Array


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


## Ziyaretin giriş anlatısı anahtarı.
func giris(ziyaret: int) -> String:
	return giris_anahtarlari[clampi(ziyaret - 1, 0, giris_anahtarlari.size() - 1)]
