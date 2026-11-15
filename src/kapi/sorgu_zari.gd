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


## ZAR-04: Yaklaşım değiştiricilerini zar atılmadan önce hesaplayıp SorguZari.sonuc eşiğine uygular.
static func degistiricili_sonuc(rng: RandomNumberGenerator, tur: StringName, deger: int, tansiyon: int, yaklasim: String, baglam: Dictionary = {}, kurallar: Resource = null, tablo_override: Dictionary = {}) -> Dictionary:
	var deg: Dictionary = preload("res://src/kapi/zar_degistiricileri.gd").hesapla(yaklasim, baglam, tablo_override)
	if not bool(deg.get("gecerli", false)):
		return {"tur": tur, "gerekli": deger + 1, "zar": 0, "atildi": false, "basarili": false, "sozcuk": SOZCUK_KILITLI,
			"hata": String(deg.get("hata", "gecersiz_yaklasim")), "satirlar": [], "toplam": 0, "kesildi": false}
	var res := sonuc(rng, tur, deger, tansiyon, int(deg.get("toplam", 0)), kurallar)
	res["yaklasim"] = yaklasim
	res["toplam"] = int(deg.get("toplam", 0))
	res["ham_toplam"] = int(deg.get("ham_toplam", 0))
	res["kesildi"] = bool(deg.get("kesildi", false))
	res["satirlar"] = deg.get("satirlar", [])
	return res

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


## ZAR-05: Tekrar edilebilir ("tekrar", beyaz) ve tek şanslık ("tek_sans", kırmızı) kontroller.
const KONTROL_TEKRAR := "tekrar"
const KONTROL_TEK_SANS := "tek_sans"

## Kural 1, 3, 5: Kontrol türünü ve düğüm uygunluğunu doğrular.
## Tür boşsa hata döner (sessizce "tekrar" sayılmaz). "tek_sans" yalnız sır ve ikilem düğümünde durur.
static func kontrol_dogrula(kontrol_turu: Variant, dugum_id: String = "", dugum_veri: Dictionary = {}) -> Array[String]:
	var hatalar: Array[String] = []
	var tur_str := String(kontrol_turu).strip_edges() if kontrol_turu != null else ""
	if tur_str.is_empty():
		hatalar.append("zar_kontrol_turu_bos")
		return hatalar
	if tur_str != KONTROL_TEKRAR and tur_str != KONTROL_TEK_SANS:
		hatalar.append("gecersiz_zar_kontrol_turu_%s" % tur_str)
		return hatalar
	if tur_str == KONTROL_TEK_SANS and not _sir_veya_ikilem_mi(dugum_id, dugum_veri):
		hatalar.append("sir_disinda_tek_sans")
	return hatalar

static func _sir_veya_ikilem_mi(dugum_id: String, dugum_veri: Dictionary) -> bool:
	var id_kucuk := dugum_id.to_lower()
	if id_kucuk.find("sir") >= 0 or id_kucuk.find("ikilem") >= 0 or id_kucuk.find("yuzles") >= 0 or id_kucuk.find("neden") >= 0:
		return true
	var d_tur := String(dugum_veri.get("dugum_turu", dugum_veri.get("tur", ""))).to_lower()
	if d_tur in ["sir", "ikilem", "yuzlesme", "neden"]:
		return true
	if bool(dugum_veri.get("sir_dugumu", false)) or bool(dugum_veri.get("ikilem_dugumu", false)):
		return true
	return false

## Kural 2: "tekrar" kontrolü için koşul imzası (kanıt kümesi, tansiyon bandı, güven eşiği).
## Menü açılıp kapanması veya odak değişimi bu imzayı değiştirmez.
static func kosul_imzasi(baglam: Dictionary, kurallar: Resource = null) -> String:
	var kanitlar_ham: Variant = baglam.get("kanitlar", baglam.get("ipuclari", []))
	var kanit_listesi: Array[String] = []
	if kanitlar_ham is Array:
		for k in kanitlar_ham:
			var ks := String(k).strip_edges()
			if not ks.is_empty() and not kanit_listesi.has(ks):
				kanit_listesi.append(ks)
	elif kanitlar_ham is Dictionary:
		for k in kanitlar_ham.keys():
			if bool(kanitlar_ham[k]):
				var ks := String(k).strip_edges()
				if not ks.is_empty() and not kanit_listesi.has(ks):
					kanit_listesi.append(ks)
	kanit_listesi.sort()

	var tansiyon_bandi := String(baglam.get("tansiyon_bandi", "")).strip_edges()
	if tansiyon_bandi.is_empty():
		var t_deger := int(baglam.get("tansiyon", 0))
		if kurallar != null:
			var ek := tansiyon_eki(t_deger, kurallar)
			tansiyon_bandi = "band_%d" % ek
		else:
			if t_deger >= 8:
				tansiyon_bandi = "panik"
			elif t_deger >= 4:
				tansiyon_bandi = "gergin"
			else:
				tansiyon_bandi = "sakin"

	var guven_esigi := String(baglam.get("guven_esigi", "")).strip_edges()
	if guven_esigi.is_empty() and baglam.has("guven"):
		guven_esigi = "g_%d" % int(baglam.get("guven", 0))

	return "kanit:%s|tansiyon:%s|guven:%s" % [",".join(kanit_listesi), tansiyon_bandi, guven_esigi]

## Kural 2, 3, 4: Zar kontrolünün şu anki bağlam ve hafızayla atılıp atılamayacağını döner.
static func kontrol_acik_mi(hafiza: Dictionary, kontrol_id: String, kontrol_turu: Variant, baglam: Dictionary, dugum_id: String = "", dugum_veri: Dictionary = {}, kurallar: Resource = null) -> bool:
	var dogrulama := kontrol_dogrula(kontrol_turu, dugum_id, dugum_veri)
	if not dogrulama.is_empty():
		return false
	var tur_str := String(kontrol_turu).strip_edges()
	var kontroller: Dictionary = hafiza.get("zar_kontrolleri", {}) if hafiza.get("zar_kontrolleri") is Dictionary else {}
	if not kontroller.has(kontrol_id):
		return true
	var kayit: Dictionary = kontroller[kontrol_id] if kontroller[kontrol_id] is Dictionary else {}
	if tur_str == KONTROL_TEK_SANS:
		return not bool(kayit.get("kapandi", true))
	if bool(kayit.get("basarili", false)):
		return false
	var mevcut_imza := kosul_imzasi(baglam, kurallar)
	var son_imza := String(kayit.get("son_imza", ""))
	return mevcut_imza != son_imza

## Zar kontrolü atışı yapar ve hafızaya yazar. Kod kontrol_turu değerini asla kendiliğinden değiştirmez.
static func kontrol_at(rng: RandomNumberGenerator, hafiza: Dictionary, kontrol_id: String, kontrol_turu: Variant, zar_turu: StringName, deger: int, tansiyon: int, degistirici: int, kurallar: Resource, baglam: Dictionary = {}, dugum_id: String = "", dugum_veri: Dictionary = {}) -> Dictionary:
	var hatalar := kontrol_dogrula(kontrol_turu, dugum_id, dugum_veri)
	if not hatalar.is_empty():
		return {"atildi": false, "basarili": false, "zar": 0, "hatalar": hatalar, "kontrol_turu": String(kontrol_turu)}
	var tur_str := String(kontrol_turu).strip_edges()
	if not kontrol_acik_mi(hafiza, kontrol_id, tur_str, baglam, dugum_id, dugum_veri, kurallar):
		return {"atildi": false, "basarili": false, "zar": 0, "hatalar": PackedStringArray(), "kontrol_turu": tur_str, "kilitli_sebep": "kosul_degismedi_veya_kapali"}

	var atis := sonuc(rng, zar_turu, deger, tansiyon, degistirici, kurallar)
	if not bool(atis.get("atildi", false)):
		atis["kontrol_turu"] = tur_str
		atis["hatalar"] = PackedStringArray()
		return atis

	if not hafiza.has("zar_kontrolleri") or not (hafiza["zar_kontrolleri"] is Dictionary):
		hafiza["zar_kontrolleri"] = {}
	var kontroller: Dictionary = hafiza["zar_kontrolleri"]
	var imza := kosul_imzasi(baglam, kurallar)
	var basari := bool(atis.get("basarili", false))
	kontroller[kontrol_id] = {
		"kontrol_turu": tur_str,
		"son_imza": imza,
		"son_zar": int(atis.get("zar", 0)),
		"basarili": basari,
		"kapandi": true if tur_str == KONTROL_TEK_SANS else basari,
		"kenar": "kirmizi" if tur_str == KONTROL_TEK_SANS else "beyaz"
	}
	atis["kontrol_turu"] = tur_str
	atis["kenar"] = "kirmizi" if tur_str == KONTROL_TEK_SANS else "beyaz"
	atis["dal_kapandi"] = true if tur_str == KONTROL_TEK_SANS else basari
	atis["hatalar"] = PackedStringArray()
	return atis

## Menü açılıp kapanması veya odak değişimi zarı yeniden atmaz ve tekrar hakkını düşürmez.
static func menu_veya_odak_degisti(_hafiza: Dictionary) -> void:
	pass
