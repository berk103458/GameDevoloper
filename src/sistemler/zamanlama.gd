## Köy mini oyunlarının zamanlama kuralları (okçuluk, harman). Arayüzden bağımsız, saf hesap.
## Kurallar: design/gdd/koy-mini-oyunlari.md
class_name Zamanlama
extends RefCounted


## Okçuluk nişangâhının konumu (−1..1 kare içinde): yatayda sinüs, dikeyde farklı hızda sinüs.
## `t` saniye, `hiz` salınım/s.
static func nisangah(t: float, hiz: float) -> Vector2:
	return Vector2(sin(t * hiz * TAU), 0.6 * sin(t * hiz * TAU * 1.37 + 0.6))


## Bir okun puanı: merkezden uzaklık `merkez` içindeyse 2, `halka` içindeyse 1, yoksa 0.
static func ok_puani(konum: Vector2, merkez: float, halka: float) -> int:
	var d := konum.length()
	if d <= merkez:
		return 2
	if d <= halka:
		return 1
	return 0


## Harman vuruşlarının zamanları: `bas` saniyeden başlayıp `aralik` arayla `adet` vuruş.
static func vuruslar(bas: float, aralik: float, adet: int) -> PackedFloat32Array:
	var v := PackedFloat32Array()
	for i in adet:
		v.append(bas + i * aralik)
	return v


## Basış anına en yakın, henüz vurulmamış vuruşun indeksi; `tolerans` dışında ya da hepsi vurulmuşsa −1.
static func vurus_isabeti(an: float, vurus: PackedFloat32Array, vuruldu: Array[bool], tolerans: float) -> int:
	var en := -1
	var fark := tolerans
	for i in vurus.size():
		if vuruldu[i]:
			continue
		var f := absf(an - vurus[i])
		if f <= fark:
			fark = f
			en = i
	return en
