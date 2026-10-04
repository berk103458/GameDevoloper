## Barlar: dört toplum desteği. 0'a inen bar kırılır (prototip kararı; Barlar GDD'si yazılınca doğrulanacak).
class_name Barlar
extends RefCounted

signal degisti

var degerler: PackedInt32Array = []
var azami: int = 10


func _init(bar_sayisi: int, baslangic: int, azami_deger: int) -> void:
	azami = azami_deger
	for i in bar_sayisi:
		degerler.append(baslangic)


## Etki dizisini uygular; değerler [0, azami] aralığına sıkıştırılır.
func uygula(etki: PackedInt32Array) -> void:
	for i in mini(etki.size(), degerler.size()):
		degerler[i] = clampi(degerler[i] + etki[i], 0, azami)
	degisti.emit()


## Tek bir barı değiştirir.
func ekle(indeks: int, miktar: int) -> void:
	degerler[indeks] = clampi(degerler[indeks] + miktar, 0, azami)
	degisti.emit()


func ayarla(indeks: int, deger: int) -> void:
	degerler[indeks] = clampi(deger, 0, azami)
	degisti.emit()


## İlk kırılan barın indeksi; yoksa -1.
func kirilan() -> int:
	for i in degerler.size():
		if degerler[i] <= 0:
			return i
	return -1
