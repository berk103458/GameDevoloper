## Bölüm 31 söz alanlarının tek paketleyicisi. Oturum'a ince adaptördür.
class_name SozKaydi
extends RefCounted

var beyanlar := BeyanDefteri.new()
var sozler := VerilenSoz.new()
var yalanlar := YalanDenetimi.new()
var cekirdek := CekirdekSecici.new()
var motor := SozMotoru.new()


static func acik(ayarlar: Object) -> bool:
	if ayarlar == null:
		return true
	var bayrak: Variant = ayarlar.get("soz_alanlari_acik")
	if bayrak == null:
		return true
	return bool(bayrak)


func paket(kadro: KarakterKadrosu) -> Dictionary:
	var cekirdek_kaydi := cekirdek.kaydet()
	var veri := {
		"hafiza": KisiHafizasi.hafiza_paketi(kadro),
		"beyanlar": beyanlar.kaydet(),
		"sozler": sozler.kaydet(),
		"yalanlar": yalanlar.kaydet(),
		"ziyaret": motor.kaydet(),
	}
	if not cekirdek_kaydi.is_empty():
		veri["cekirdek"] = cekirdek_kaydi
	return veri


func uygula(kadro: KarakterKadrosu, veri: Variant) -> void:
	if not veri is Dictionary:
		return
	var blok: Dictionary = veri
	if blok.get("hafiza") is Array:
		KisiHafizasi.hafiza_uygula(kadro, blok["hafiza"])
	beyanlar.yukle(blok.get("beyanlar", []))
	sozler.yukle(blok.get("sozler", []))
	yalanlar.yukle(blok.get("yalanlar", []))
	cekirdek.yukle(blok.get("cekirdek", {}))
	motor.yukle(blok.get("ziyaret", {}))
