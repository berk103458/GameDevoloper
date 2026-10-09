## HAR-15: temel gece nöbet payını tekrar eklemeyen canlı hazırlık katkısı.
class_name SavunmaGuvenligi
extends RefCounted

const AZAMI_KATKI := 20
const ROL_PAYI := {"devriye": 1, "kapi": 3, "sur": 4}

## HAR-10 uygunluğu + bayrak eksik olsa bile gerçek yaralanma/yanık kaydı.
static func uygun(y: KoyYonetimi, id: int) -> bool:
	if not SavunmaKonuslanmasi.uygun(y, id): return false
	var k := y.koylu(id)
	var bayraklar := k.bayraklar + k.gizli_bayraklar
	for bayrak in ["yarali", "agir_yarali", "zindanda"]:
		if bayrak in bayraklar: return false
	if k.is_kazasi.get("tur") == "yaralanma" and int(k.is_kazasi.get("kalan", 0)) > 0: return false
	if k.zanaat_kazasi.get("tur") == "yanik" and (k.zanaat_kazasi.get("tedavi", false) or int(k.zanaat_kazasi.get("kalan", 0)) > 0): return false
	return true

## Her gerçek kişi bir kez: etkin taktik rolü veya mevcut devriye fallback'ı.
## Kontenjan/işlevli sur/ID sırası HAR-10'dan; kayıt dışı bonus veya NPC yok.
static func kisiler(y: KoyYonetimi) -> Dictionary:
	var roller := {}
	if not y.agalik or y.son != &"": return roller
	var taktik := {}
	for rol in ["kapi", "sur"]:
		for id in SavunmaKonuslanmasi.kisiler(y, rol): taktik[id] = rol
	for k in y.koylular:
		if uygun(y, k.id): roller[k.id] = taktik.get(k.id, "devriye")
	return roller

## floor((stat[1..10] + rol payı) * sağlık[0..100] / 100) − mevcut nöbet payı.
## Negatif kişi katkısı sıfır; toplam 20/100. Gece asayişi ve savunma_gucu değişmez.
static func katkisi(y: KoyYonetimi) -> int:
	var toplam := 0
	var roller := kisiler(y)
	for id in roller:
		var k := y.koylu(id)
		var hazirlik := (clampi(k.stat, 1, 10) + int(ROL_PAYI[roller[id]])) * clampi(k.saglik, 0, 100) / 100
		toplam += maxi(0, hazirlik - maxi(0, y.a.muhafiz_asayis))
	return mini(AZAMI_KATKI, toplam)

## Tek mevcut Güvenlik kaynağına bağlı köylü kartı bilgisi; gizli bayrak ifşa etmez.
static func metin(y: KoyYonetimi) -> String:
	return "Güvenlik %d/100 · savunma hazırlığı +%d (en çok %d).\nBeceri, sağlık ve görev katkıyı belirler; dış görev, zindan ve yaralılar katkı vermez." % [KervanKorumasi.guvenlik(y), katkisi(y), AZAMI_KATKI]
