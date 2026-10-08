## EKO-06: gerçek cevher → işlenmiş demir → mevcut alet reçetesi; alet aşınması.
class_name DemirZinciri
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/demir_zinciri.json"))
## Dış yapı verilerini ekler; mevcut demir/alet kimlikleri korunur.
static func ekle(turler: Dictionary) -> void:
	turler.merge(AYAR.yapilar.duplicate(true), false)
## Alet gerektiren işte stok sıfırsa verim %70 düşer; rastgele sayı tüketmez.
static func carpan(y: KoyYonetimi, tur: String) -> float:
	return float(AYAR.aletsiz_carpan) if tur in AYAR.alet_gereken and y.kaynaklar.miktar("alet") == 0 else 1.0
## Yalnız fiili çalışan ve ambarı açık üretimin aşınmasını toplar.
static func calisildi(y: KoyYonetimi, tur: String) -> void:
	if tur not in AYAR.alet_gereken or y.kaynaklar.miktar("alet") == 0: return
	y.alet_asinma += float(AYAR.asinma_calisma)
	if y.alet_asinma + 0.000001 >= 1.0:
		var tuketilen := y.kaynaklar.azalt("alet", int(floor(y.alet_asinma + 0.000001)))
		y.alet_asinma = maxf(0.0, y.alet_asinma - tuketilen)
## Optional eski kayıt alanı; bozuk veya sınır dışı veri sıfıra döner.
static func asinma_oku(v: Variant) -> float:
	return float(v) if (v is int or v is float) and is_finite(float(v)) and float(v) >= 0.0 and float(v) < 1.0 else 0.0
## CSV koruması boyunca yeni oyuncu etiketlerini verir.
static func ad(anahtar: String) -> String:
	return {"koy.kaynak.su": "Su", "koy.kaynak.cevher": "Demir cevheri", "koy.yapi.demir_madeni": "Demir Madeni", "koy.yapi.demir_ocagi": "Demir Ocağı", "koy.yapi.demir_madeni_aciklama": "Ham demir cevheri çıkarır; aletsiz verimi %70 azalır.", "koy.yapi.demir_ocagi_aciklama": "İki cevher ve bir yakacak odunundan işlenmiş demir üretir.", "koy.recete.cevher": "Ham demir cevheri", "koy.recete.demir": "Demir · 2 cevher + 1 odun"}.get(anahtar, GezginTuccarStogu.ad(anahtar))
