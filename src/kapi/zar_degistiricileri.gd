## ZAR-04: Yaklaşım türleri ve değiştiriciler.
## Dört yaklaşım vardır: ikna, blöf, gözdağı ve gönül alma.
## Terazi, grup itibarı, kanıt, asker ve yorgunluk gerekli değerini en çok -3 ile +3 arasında değiştirir.
## Zar öncesi liste tutan her maddeyi ayrı satırda gösterir; gizli değiştirici yoktur.
## Beşinci yaklaşım adı reddedilir. Kalp veya romans eşiği yoktur.
class_name ZarDegistiricileri
extends RefCounted

const YAKLASIM_IKNA := &"ikna"
const YAKLASIM_BLOF := &"blof"
const YAKLASIM_GOZDAGI := &"gozdagi"
const YAKLASIM_GONUL_ALMA := &"gonul_alma"

const GECERLI_YAKLASIMLAR := [
	YAKLASIM_IKNA,
	YAKLASIM_BLOF,
	YAKLASIM_GOZDAGI,
	YAKLASIM_GONUL_ALMA,
]

const TABLO_YOLU := "res://data/zar_degistiricileri.json"
const ASGARI_TOPLAM := -3
const AZAMI_TOPLAM := 3

static func gecerli_yaklasim(yaklasim: Variant) -> bool:
	var y_str := String(yaklasim).to_lower().strip_edges()
	if y_str == "kalp" or y_str == "romans":
		return false
	return StringName(y_str) in GECERLI_YAKLASIMLAR

static func tablo_dogrula(veri: Dictionary) -> Array[String]:
	var hatalar: Array[String] = []
	var metin := JSON.stringify(veri).to_lower()
	if "kalp" in metin or "romans" in metin:
		hatalar.append("Kalp veya romans anahtarı yasaktır (ZAR-04)")
	var yaklasimlar: Array = veri.get("yaklasimlar", [])
	for y in yaklasimlar:
		var y_str := String(y).to_lower()
		if y_str == "kalp" or y_str == "romans":
			hatalar.append("Kalp veya romans anahtarı yasaktır (ZAR-04)")
		elif StringName(y_str) not in GECERLI_YAKLASIMLAR:
			hatalar.append("Geçersiz yaklaşım türü: %s (beşinci tür reddedilir)" % y_str)
	return hatalar

## Yaklaşım ve bağlama göre değiştiricileri hesaplar.
## Döner: {gecerli: bool, yaklasim: StringName, toplam: int, ham_toplam: int, kesildi: bool, satirlar: Array, hata: String}
static func hesapla(yaklasim: Variant, baglam: Dictionary = {}, tablo_override: Dictionary = {}) -> Dictionary:
	var y_str := String(yaklasim).to_lower().strip_edges()
	if y_str == "kalp" or y_str == "romans":
		return {
			"gecerli": false,
			"hata": "Kalp veya romans yaklaşımı yasaktır (ZAR-04)",
			"toplam": 0,
			"ham_toplam": 0,
			"satirlar": [],
			"kesildi": false
		}
	var y := StringName(y_str)
	if y not in GECERLI_YAKLASIMLAR:
		return {
			"gecerli": false,
			"hata": "Geçersiz yaklaşım türü: '%s'. Yalnızca ikna, blöf, gözdağı ve gönül alma geçerlidir." % y_str,
			"toplam": 0,
			"ham_toplam": 0,
			"satirlar": [],
			"kesildi": false
		}

	var satirlar: Array[Dictionary] = []
	var ham_toplam := 0

	# 1. Terazi değiştiricisi:
	# adil iken ikna ve gönül alma -1; yoz iken gözdağı -1.
	var terazi: Variant = baglam.get("terazi", "")
	var terazi_adil := false
	var terazi_yoz := false
	if terazi is String or terazi is StringName:
		var t_str := String(terazi).to_lower()
		terazi_adil = (t_str == "adil" or t_str.contains("adil"))
		terazi_yoz = (t_str == "yoz" or t_str.contains("yoz"))
	elif terazi is Dictionary:
		var unvan: String = terazi.get("unvan", "").to_lower()
		var denge: int = int(terazi.get("denge", 50))
		terazi_adil = unvan.contains("adil") or denge >= 65
		terazi_yoz = unvan.contains("yoz") or denge <= 35
	elif terazi is int or terazi is float:
		terazi_adil = int(terazi) >= 65
		terazi_yoz = int(terazi) <= 35

	if terazi_adil:
		if y == YAKLASIM_IKNA or y == YAKLASIM_GONUL_ALMA:
			satirlar.append({"tur": "terazi_adil", "metin": "Adil terazi", "deger": -1})
			ham_toplam -= 1
	elif terazi_yoz:
		if y == YAKLASIM_GOZDAGI:
			satirlar.append({"tur": "terazi_yoz", "metin": "Yoz terazi", "deger": -1})
			ham_toplam -= 1

	# 2. Grup itibarı: uçta en çok ±1
	var itibar := int(baglam.get("itibar", 0))
	if itibar != 0:
		var itibar_etki := clampi(itibar, -1, 1)
		var mod := -itibar_etki
		satirlar.append({"tur": "grup_itibari", "metin": "Grup itibarı", "deger": mod})
		ham_toplam += mod

	# 3. Bulunmuş kanıt: -1
	# İki kanıt ikinci -1 vermez; "bulundu mu" sayılır.
	var kanit_var: bool = bool(baglam.get("kanit", false) or int(baglam.get("kanit_sayisi", 0)) > 0)
	if kanit_var:
		satirlar.append({"tur": "kanit", "metin": "Bulunmuş kanıt", "deger": -1})
		ham_toplam -= 1

	# 4. Yanındaki asker: yalnız gözdağı -1
	# Asker yokken asker satırı listede hiç yazılmaz. Asker iknaya yazmaz.
	var asker_var: bool = bool(baglam.get("asker", false) or int(baglam.get("asker_sayisi", 0)) > 0)
	if asker_var and y == YAKLASIM_GOZDAGI:
		satirlar.append({"tur": "asker", "metin": "Yanındaki asker", "deger": -1})
		ham_toplam -= 1

	# 5. Yorgunluk: +1
	var yorgunluk: bool = bool(baglam.get("yorgunluk", false) or int(baglam.get("yorgunluk_seviyesi", 0)) > 0)
	if yorgunluk:
		satirlar.append({"tur": "yorgunluk", "metin": "Nöbet yorgunluğu", "deger": 1})
		ham_toplam += 1

	# Toplam -3...+3 dışında kesilir.
	var toplam := clampi(ham_toplam, ASGARI_TOPLAM, AZAMI_TOPLAM)
	var kesildi := (toplam != ham_toplam)
	if kesildi:
		satirlar.append({
			"tur": "kesilme",
			"metin": "Sınır kesintisi (en çok %d)" % (AZAMI_TOPLAM if ham_toplam > 0 else ASGARI_TOPLAM),
			"deger": toplam - ham_toplam
		})

	return {
		"gecerli": true,
		"yaklasim": y,
		"toplam": toplam,
		"ham_toplam": ham_toplam,
		"kesildi": kesildi,
		"satirlar": satirlar
	}
