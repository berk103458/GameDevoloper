# gdlint: disable=max-line-length
class_name BeyinDenetcisi
extends RefCounted

## DYL-09: Beyin denetçisi — sorgulanan muhafız.
## Sancak subaşısı/müfettişi gelir; muhafızın kararlarını, rüşvet ve kasa durumunu sorgular.
## Cevaplar: kanıtla savunma, pişmanlık, inkar.

static func sorgula(muhafiz_sicili: Dictionary) -> Dictionary:
	var rusvet_sayisi: int = int(muhafiz_sicili.get("rusvet_sayisi", 0))
	var tutulmayan_sozler: int = int(muhafiz_sicili.get("tutulmayan_soz_sayisi", 0))
	var adalet_puani: int = int(muhafiz_sicili.get("adalet", 50))

	var suphe_seviyesi: int = rusvet_sayisi * 3 + tutulmayan_sozler * 2
	if adalet_puani < 30:
		suphe_seviyesi += 4

	var baslik := "Sancak Müfettişinin Divanı"
	var soru := ""
	if suphe_seviyesi >= 8:
		soru = "Hakkında rüşvet ve hile söylentileri sancağa kadar ulaştı muhafız! Beyliğin mührünü kirletmeye utanmadın mı?"
	elif suphe_seviyesi >= 4:
		soru = "Kapıda keyfi davrandığın, ahaliye verdiğin sözleri tutmadığın söylenir. Ne dersin?"
	else:
		soru = "Uç kapısının asayişi ve defter kayıtları teftiş edilir. Sicilinde mühim bir leke görünmez."

	return {
		"baslik": baslik,
		"soru": soru,
		"suphe_seviyesi": suphe_seviyesi,
		"azil_riski": (suphe_seviyesi >= 10)
	}
