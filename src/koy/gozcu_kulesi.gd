## HAR-06: var olan CHR hedef türüne tek gerçek kule katalog adaptörü.
class_name GozcuKulesi
extends RefCounted
const TUR := "nobetci_kulesi"
static var AYAR: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/gozcu_kulesi.json"))
## Ana yapı verilerini ezmeden mevcut placeholder türünün gerçek inşa verisini ekler.
static func ekle(turler: Dictionary) -> void:
	turler.merge({TUR:AYAR.yapi.duplicate(true)},false)
## Hazır tek gözcü yuvasında gerçek sağlıklı, uygun yaştaki çalışan aranır.
static func aktif(y: KoyYonetimi) -> bool:
	if y.son!="": return false
	for b in y.binalar:
		if b.tur!=TUR or not b.hazir(): continue
		for k in y.calisanlar(b.id):
			if k.yas_grubu==&"yetiskin" and k.saglik>=int(AYAR.saglik_min) and CirakEgitimi.saglam(k) and not DivanHukmu.zindanda(k) and not KervanKorumasi.disarida(y,k.id) and not IsKazalari.uyuyor(k) and not IsMemnuniyeti.isyanci(k,y): return true
	return false
