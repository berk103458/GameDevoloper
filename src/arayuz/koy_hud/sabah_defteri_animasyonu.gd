## Gece raporu / sabah defteri kapağının açılması. Metin görsele gömülmez.
class_name SabahDefteriAnimasyonu
extends KareAnimasyonKabuk

const KOK := "res://assets/ui/koy/sabah_defteri/"
const KARE_SAYISI := 9


static func olustur() -> SabahDefteriAnimasyonu:
	var kareler := KareAnimasyonKabuk.yukle_kareler(KOK, KARE_SAYISI)
	if kareler.size() < 2:
		return null
	var n := SabahDefteriAnimasyonu.new()
	n.kur(kareler)
	return n


static func oynat(ebeveyn: Control) -> void:
	await KareAnimasyonKabuk.oynat_uzerinde(ebeveyn, olustur())
