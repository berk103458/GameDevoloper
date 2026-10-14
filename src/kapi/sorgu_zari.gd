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

## ZAR-03: Tansiyon 10'u aşarsa karakter gider.
const KARAR_KACTI := &"kacti"
const KARAR_KACTI_TR := "kaçtı"
const VARSAYILAN_KACIS_ESIGI := 10

## data/ayarlar/denge.json içindeki zar_esigi.tansiyon_kacis_esigi eşiğini okur.
## Dosya yoksa veya kurallar kaynağında varsa oradan döner, en son 10'a düşer.
static func kacis_esigi_oku(denge_yolu: String = "res://data/ayarlar/denge.json", kurallar: Resource = null) -> int:
	if kurallar != null and "tansiyon_kacis_esigi" in kurallar:
		return int(kurallar.tansiyon_kacis_esigi)
	if FileAccess.file_exists(denge_yolu):
		var dosya := FileAccess.open(denge_yolu, FileAccess.READ)
		if dosya != null:
			var j: Variant = JSON.parse_string(dosya.get_as_text())
			if j is Dictionary and j.has("zar_esigi"):
				var z: Variant = j["zar_esigi"]
				if z is Dictionary and z.has("tansiyon_kacis_esigi"):
					return int(z["tansiyon_kacis_esigi"])
	return VARSAYILAN_KACIS_ESIGI

## Kural 1: Başarısız zar tansiyonu seçenekte yazan kadar artırır; yazılmamışsa +1'dir.
static func basarisiz_artis(secenek: Dictionary = {}, kurallar: Resource = null) -> int:
	if secenek.has("tansiyon_delta"):
		return int(secenek["tansiyon_delta"])
	if kurallar != null and "basarisiz_tansiyon_delta" in kurallar:
		return int(kurallar.basarisiz_tansiyon_delta)
	return 1

## Kural 2 & 5 & Uç durumlar:
## - Başarılı zar, tansiyon ondayken karakteri kaçırmaz.
## - Başarısız zar tansiyonu seçenekte yazan (veya 1) kadar artırır.
## - Tansiyon 10'u (eşiği) aşarsa karakter kaçar ve karar "kaçtı" olur.
## - Tansiyon 10'da artış +0 olan başarısızlık kaçırmaz.
static func kacis_kontrol(mevcut_tansiyon: int, artis: int, basarili_zar: bool, esik: int = VARSAYILAN_KACIS_ESIGI) -> Dictionary:
	if basarili_zar:
		return {"kacti": false, "tansiyon": mevcut_tansiyon, "karar": &"", "karar_str": ""}
	var yeni_tansiyon := mevcut_tansiyon + artis
	var kacti := yeni_tansiyon > esik
	return {
		"kacti": kacti,
		"tansiyon": yeni_tansiyon,
		"karar": KARAR_KACTI if kacti else &"",
		"karar_str": KARAR_KACTI_TR if kacti else ""
	}

## Karar akışına adaptör: Kaçış kararı uygulandığında:
## - Karar "kaçtı"dır. Kabul, ret, rüşvet ve kışla yazılmaz.
## - Ek şart: Kaçış ret_sayisi artırmaz.
## - Tehlikeli karakter kaçarsa sonraki tehdit, duran tehdit sayacına (asayis_riski) yazar. Yeni sayaç yok.
## - Kaçış kişi hafızasına / kadrosuna yazılır.
static func karar_uygula(oturum: RefCounted, gelen: RefCounted, karar: Variant = KARAR_KACTI_TR) -> Dictionary:
	var k_str := String(karar)
	if k_str != "kaçtı" and k_str != "kacti":
		return oturum.karar_ver(gelen, StringName(karar))
	var yonetim: KoyYonetimi = oturum.get("yonetim") if oturum != null else null
	var ret_once := yonetim.ret_sayisi if yonetim != null else 0
	if gelen != null and gelen.get("tehlikeli") == true and yonetim != null:
		yonetim.asayis_riski = mini(100, yonetim.asayis_riski + 5)
	if gelen != null and gelen.get("adli") == true and oturum != null and oturum.get("kadro") != null:
		oturum.kadro.sonuc(gelen.id, false, KARAR_KACTI, oturum.gun)
	var ret_sonra := yonetim.ret_sayisi if yonetim != null else 0
	assert(ret_sonra == ret_once, "Kaçış ret_sayisi artırmaz (ZAR-03)")
	return {
		"karar": KARAR_KACTI_TR,
		"karar_kodu": KARAR_KACTI,
		"kaldi": false,
		"koylu_id": -1,
		"engellendi": false,
		"ret_artti": false
	}

