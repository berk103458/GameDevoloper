# gdlint: disable=max-line-length
class_name CeliskiYuzlesme
extends RefCounted

## DIY-07 / DYL-01: Çelişki ve yüzleşme — iki kaydı oyuncu kendisi eşleştirir.
## Yalan, kanıtla ortaya çıkar; doğru eşleştirme yüzleşme düğümünü açar, yanlış eşleştirme güveni düşürür.

static func eslestir(kayit_1: Dictionary, kayit_2: Dictionary, soz_motoru: SozMotoru = null) -> Dictionary:
	if kayit_1.is_empty() or kayit_2.is_empty():
		return {"basarili": false, "sebep": "bos_kayit"}

	var celiski_var: bool = false

	# 1. Beyan ile Kanıt eşleşmesi (Örn: "Yalnızım" beyanı ile "çocuk çarığı" ipucu)
	var kanit_id_1 = str(kayit_1.get("kanit_id", ""))
	var kanit_id_2 = str(kayit_2.get("kanit_id", ""))
	var ipucu_id_1 = str(kayit_1.get("ipucu_id", kayit_1.get("id", "")))
	var ipucu_id_2 = str(kayit_2.get("ipucu_id", kayit_2.get("id", "")))

	if (not kanit_id_1.is_empty() and kanit_id_1 == ipucu_id_2) or (not kanit_id_2.is_empty() and kanit_id_2 == ipucu_id_1):
		celiski_var = true

	# 2. İki zıt beyan eşleşmesi (Biri doğru: false diğeri doğru: true veya tersi)
	if kayit_1.has("dogru") and kayit_2.has("dogru"):
		if kayit_1.get("dogru") != kayit_2.get("dogru"):
			celiski_var = true

	if celiski_var:
		if soz_motoru:
			# Yüzleşme düğümünü tetikle
			if soz_motoru.dugumler.has("yuzlesme"):
				soz_motoru.aktif_dugum = soz_motoru.dugumler["yuzlesme"]
				soz_motoru._satiri_isle(soz_motoru.aktif_dugum, {})
				return {
					"basarili": true,
					"yuzlesme_acildi": true,
					"satir": soz_motoru.son_satir
				}
		return {"basarili": true, "yuzlesme_acildi": true}
	else:
		if soz_motoru:
			soz_motoru.guven = clampi(soz_motoru.guven - 1, 0, 10)
		return {"basarili": false, "sebep": "celiski_yok"}
