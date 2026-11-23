## Rüşvet veya elkoyma anında kesenin açılıp akçenin dökülmesi.
class_name RusvetKesesiAnimasyonu
extends KareAnimasyonKabuk

const KOK := "res://assets/ui/kapi/rusvet_kesesi/"
const KARE_SAYISI := 8


static func olustur() -> RusvetKesesiAnimasyonu:
	var kareler := KareAnimasyonKabuk.yukle_kareler(KOK, KARE_SAYISI)
	if kareler.size() < 2:
		return null
	var n := RusvetKesesiAnimasyonu.new()
	n.kur(kareler)
	return n


static func oynat(ebeveyn: Control) -> void:
	await KareAnimasyonKabuk.oynat_uzerinde(ebeveyn, olustur())
