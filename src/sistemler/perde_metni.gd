# gdlint: disable=max-line-length
class_name PerdeMetni
extends RefCounted

## OMR-07 & KOP-07: Perde geçiş metin adaptörü.
## Sabit Türkçe cümleleri metinler.csv anahtarına (anlati.perde.basladi) taşır.

const ANAHTAR_BASLADI := "anlati.perde.basladi"
const ANAHTAR_BITTI := "anlati.perde.bitti"


static func metin_al(tur: String, hedef: int = 12, gun: int = 1) -> String:
	if tur == "basladi":
		var sablon := String(TranslationServer.translate(ANAHTAR_BASLADI))
		if sablon == ANAHTAR_BASLADI:
			sablon = "Köy oturdu · 2. perde başladı. Çitler sağlamlaştı, nöbet ciddiye bindi."
		return "%s (Ağa olarak %d gece dayan, %d. günden itibaren)." % [sablon, hedef, gun]
	var bitti := String(TranslationServer.translate(ANAHTAR_BITTI))
	if bitti == ANAHTAR_BITTI:
		bitti = "Uç tutundu · Ağalığın %d gecesi dolduruldu; köy ayakta kaldı." % hedef
	return bitti
