## Heybe astarında yalan çıkınca mum mührün basılması (mevcut muhur_bas kareleri).
class_name YalanMuhurAnimasyonu
extends KareAnimasyonKabuk

const KOK := "res://assets/art/anim/"
const KARE_SAYISI := 4


static func olustur() -> YalanMuhurAnimasyonu:
	var kareler := KareAnimasyonKabuk.yukle_kareler_on_ekli(KOK, "muhur_bas_", KARE_SAYISI)
	if kareler.size() < 2:
		return null
	var n := YalanMuhurAnimasyonu.new()
	n.kur(kareler)
	return n


static func oynat(ebeveyn: Control) -> void:
	await KareAnimasyonKabuk.oynat_uzerinde(ebeveyn, olustur())
