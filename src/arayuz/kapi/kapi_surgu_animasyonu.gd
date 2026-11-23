## Karar sonrası kapı sürgüsü: kabulde açılır, rette kapanır.
class_name KapiSurguAnimasyonu
extends KareAnimasyonKabuk

const KOK := "res://assets/ui/kapi/surgu/"
const KARE_SAYISI := 8


static func kare_kok(kaldi: bool) -> String:
	return "%s%s/" % [KOK, "kabul" if kaldi else "ret"]


static func olustur(kaldi: bool) -> KapiSurguAnimasyonu:
	var kareler := KareAnimasyonKabuk.yukle_kareler(kare_kok(kaldi), KARE_SAYISI)
	if kareler.size() < 2:
		return null
	var n := KapiSurguAnimasyonu.new()
	n.kur(kareler)
	return n


static func oynat(ebeveyn: Control, kaldi: bool) -> void:
	await KareAnimasyonKabuk.oynat_uzerinde(ebeveyn, olustur(kaldi))
