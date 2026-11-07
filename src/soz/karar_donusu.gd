# gdlint: disable=max-line-length
class_name KararDonusu
extends RefCounted

## DYL-08: Kararın sonradan dönüşü.
## Karakter kapıdan çevrildiğinde veya kabul edildiğinde,
## ileriki günlerde köye olumlu/olumsuz dönüş haberi veya fiziki gelişi tetiklenir.

static func donus_hesapla(karar_kaydi: Dictionary, gun_farki: int) -> Dictionary:
	var karar: String = str(karar_kaydi.get("karar", "ret"))
	var chr_id: String = str(karar_kaydi.get("chr_id", ""))
	var yalan_yakalandi: bool = bool(karar_kaydi.get("yalan_yakalandi", false))
	var defter_id: String = str(karar_kaydi.get("defter_id", ""))

	if gun_farki < 2:
		return { "donus_var": false }

	if not defter_id.is_empty():
		if karar == "ret":
			return {
				"donus_var": true,
				"tur": "defter_kaybi_haberi",
				"defter_id": defter_id,
				"metin_anahtari": "yap37.donus.defter_ret",
				"metin": "Kapıdan çevrilen yolcunun heybesindeki usta defteri komşu menzilde başkasına satılmış.",
				"moral_etkisi": -1
			}
		return {
			"donus_var": true,
			"tur": "defter_sozu_donusu",
			"defter_id": defter_id,
			"metin_anahtari": "yap37.donus.defter_kabul",
			"metin": "Söz verilen usta defteri ve yapı resmi haberciyle kapıya ulaştırıldı.",
			"defter_teslim": true
		}

	if karar == "ret":
		if yalan_yakalandi:
			# Dağda çeteye katıldı haberi
			return {
				"donus_var": true,
				"tur": "intikam_haberi",
				"metin": "Kapıdan çevrilen şahıs dağ çetesine sığınmış; köye tehdit savurur.",
				"asayis_riski": 2
			}
		else:
			# Masum garibin donma/ölüm haberi
			return {
				"donus_var": true,
				"tur": "vicdan_azabi",
				"metin": "Karaköy yolunda donarak ölen garibin haberi köye ulaştı.",
				"moral_etkisi": -2
			}
	else: # kabul
		return {
			"donus_var": true,
			"tur": "akraba_gelisi",
			"metin": "Kabul edilen köylünün geride kalan ailesi kapıya dayandı.",
			"yeni_ziyaretci_tetikle": true
		}
