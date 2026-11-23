## Kapı sorgusu ve kavga zarı: mevcut d6 / d12 kareleri (assets/art/anim).
class_name ZarAtisiAnimasyonu
extends KareAnimasyonKabuk

const KOK := "res://assets/art/anim/"
const KARE_SAYISI := 4


static func kare_on_eki(tur: StringName) -> String:
	return "zar_d12_roll_" if tur == &"d12" else "zar_d6_roll_"


static func olustur(tur: StringName = &"d6") -> ZarAtisiAnimasyonu:
	var kareler := KareAnimasyonKabuk.yukle_kareler_on_ekli(KOK, kare_on_eki(tur), KARE_SAYISI)
	if kareler.size() < 2:
		return null
	var n := ZarAtisiAnimasyonu.new()
	n.kur(kareler)
	return n


static func oynat(ebeveyn: Control, tur: StringName = &"d6", ayarlar: Ayarlar = null) -> void:
	var n := olustur(tur)
	if n == null:
		return
	var aninda := false
	if ayarlar != null:
		aninda = ayarlar.al(&"belirme_hizi") == &"aninda"
	await KareAnimasyonKabuk.oynat_uzerinde(ebeveyn, n, aninda)
