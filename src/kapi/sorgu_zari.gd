## ZAR-01: Görünür zar — d6 ve d12. Başarı kuralı `zar >= gerekli`.
## gerekli = karakter değeri + 1 + tansiyon eki + değiştiriciler. Formül eşikleri
## `data/chr_runtime/sorgu_kurallari.tres` içindedir; burada sayı sabiti yoktur.
## Yeni ses yok. Hüküm sabahı zar atışı yazmaz (çağıran taraf bunu atmaz).
class_name SorguZari
extends RefCounted

const TUR_D6 := &"d6"
const TUR_D12 := &"d12"
## Başarı ve başarısızlık yalnız renkle değil sözcükle de yazılır; metin çeviri anahtarıdır.
const SOZCUK_BASARILI := &"ZAR_BASARILI"
const SOZCUK_BASARISIZ := &"ZAR_BASARISIZ"
const SOZCUK_KILITLI := &"ZAR_KILITLI"

## d20 gibi tanımsız türler reddedilir.
static func gecerli_tur(tur: StringName) -> bool:
	return tur == TUR_D6 or tur == TUR_D12

static func tavan(tur: StringName) -> int:
	return 12 if tur == TUR_D12 else 6

## Tansiyon eki üç kademe: sakin, gergin, panik. Aralıklar ve ekler kural kaynağındadır.
static func tansiyon_eki(tansiyon: int, kurallar: Resource) -> int:
	if tansiyon >= kurallar.zar_panik_alt:
		return kurallar.zar_ek_panik
	if tansiyon >= kurallar.zar_gergin_alt:
		return kurallar.zar_ek_gergin
	return kurallar.zar_ek_sakin

static func gerekli(deger: int, tansiyon: int, degistirici: int, kurallar: Resource) -> int:
	return deger + 1 + tansiyon_eki(tansiyon, kurallar) + degistirici

## Gerekli değer zarın tavanından büyükse düğme kilitlenir, zar atılmaz.
static func kilitli(gerekli_deger: int, tur: StringName) -> bool:
	return gerekli_deger > tavan(tur)

## Tavan değer her zaman başarı, 1 her zaman başarısızdır. Değiştirici 1'i başarıya çevirmez.
static func basarili(zar: int, gerekli_deger: int, tur: StringName) -> bool:
	if zar >= tavan(tur):
		return true
	if zar <= 1:
		return false
	return zar >= gerekli_deger

static func at(rng: RandomNumberGenerator, tur: StringName) -> int:
	return rng.randi_range(1, tavan(tur))

## Teorik başarı oranı (KAP-09 `basari_olasiligi` buraya döner; ikinci hesap yolu yoktur).
static func olasilik(gerekli_deger: int, tur: StringName) -> float:
	if kilitli(gerekli_deger, tur):
		return 0.0
	var say := 0
	for yuz in range(1, tavan(tur) + 1):
		if basarili(yuz, gerekli_deger, tur):
			say += 1
	return float(say) / float(tavan(tur))

## Tek atış: zar sayısı, gerekli değer, başarı ve sözcük anahtarı. Kilitliyse zar atılmaz (rng ilerlemez).
static func sonuc(rng: RandomNumberGenerator, tur: StringName, deger: int, tansiyon: int, degistirici: int, kurallar: Resource) -> Dictionary:
	var gerek := gerekli(deger, tansiyon, degistirici, kurallar)
	if not gecerli_tur(tur) or kilitli(gerek, tur):
		return {"tur": tur, "gerekli": gerek, "zar": 0, "atildi": false, "basarili": false, "sozcuk": SOZCUK_KILITLI}
	var zar := at(rng, tur)
	var iyi := basarili(zar, gerek, tur)
	return {"tur": tur, "gerekli": gerek, "zar": zar, "atildi": true, "basarili": iyi,
		"sozcuk": SOZCUK_BASARILI if iyi else SOZCUK_BASARISIZ}
