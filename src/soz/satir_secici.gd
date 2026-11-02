## DIY-09: Kural tablosu ile baglamsal satir secimi.
## Bir satirin birden cok varyanti varsa tum kosullari tutanlar arasindan en cok kosulu tutan secilir.
## Kismi tutma sayilmaz (6 kosulun 5'i tutan varyant elenir, 3'te 3 tutan kazanir).
## Esit sayida kosul tutan iki varyantta `oncelik` kazanir; oncelik de esitse dogrulayici 1 hata verir.
## Hicbiri tutmazsa bos kosullu varsayilan varyant gelir; varsayilan da yoksa satir susar (bos doner, cokmez).
class_name SatirSecici
extends RefCounted


const DUNYA_ONEKI := "dunya."
const ACLIK_ANAHTARI := "aclik"

## BaglamSorgusu (DIY-08) disinda konusma aninda baglama eklenebilen gecici soz anahtarlari.
const EK_BAGLAM_ANAHTARLARI := [
	"tansiyon",
	"hafiza",
	"son_karar",
	"guven",
	"sabir",
	"aclik",
	"grup_itibari",
	"soylenen",
]

var _son_hatalar: Array[String] = []


## Son yukleme veya secim sirasinda kaydedilen dogrulama hatalari.
func hatalar() -> Array[String]:
	return _son_hatalar.duplicate()


## Varyant tablosunu yukler ve dogrular.
## Cakisan (kosul sayisi ve onceligi esit, ayni anda tutabilen) varyant varsa hatalar listesinde 1 hata doner.
func yukle(varyantlar: Array, baglam: Dictionary = {}) -> Dictionary:
	_son_hatalar = dogrula(varyantlar, baglam)
	return {
		"olur": _son_hatalar.is_empty(),
		"hata_sayisi": _son_hatalar.size(),
		"hatalar": _son_hatalar.duplicate(),
		"varyantlar": varyantlar.duplicate(true),
	}


## Varyant listesini dogrular:
## 1) Kosul sayisi ve onceligi esit olup birbiriyle celismeyen varyant cifti varsa 1 hata uretir.
## 2) Baglam verilmisse, baglamda bulunmayan tanimsiz kosul alanlarini hata olarak bildirir.
static func dogrula(varyantlar: Array, baglam: Dictionary = {}) -> Array[String]:
	var hata_listesi: Array[String] = []
	var norm_baglam := baglam_hazirla(baglam) if not baglam.is_empty() else {}
	var izinli_alanlar := BaglamSorgusu.alanlar()

	# 1. Alan kontrolu (baglam verilmisse veya sabit listeden kontrol)
	if not norm_baglam.is_empty():
		for i in range(varyantlar.size()):
			var v: Variant = varyantlar[i]
			if not (v is Dictionary):
				hata_listesi.append("varyant_%d_sozluk_degil" % i)
				continue
			var kosullar := _kosul_sozlugu_cikar(v)
			for anahtar in kosullar.keys():
				if not _alan_gecerli_mi(String(anahtar), norm_baglam, izinli_alanlar):
					hata_listesi.append("tanimsiz_kosul_alani:%s" % String(anahtar))

	# 2. Onceliksiz esitlik kontrolu: dosya sirasi hakem olamaz.
	var esitlik_hatasi_eklendi := false
	for i in range(varyantlar.size()):
		if esitlik_hatasi_eklendi:
			break
		var v1: Variant = varyantlar[i]
		if not (v1 is Dictionary):
			continue
		var k1 := _kosul_sozlugu_cikar(v1)
		var o1 := _oncelik_oku(v1)
		for j in range(i + 1, varyantlar.size()):
			var v2: Variant = varyantlar[j]
			if not (v2 is Dictionary):
				continue
			var k2 := _kosul_sozlugu_cikar(v2)
			var o2 := _oncelik_oku(v2)
			if k1.size() == k2.size() and o1 == o2:
				if _ayni_anda_tutabilir_mi(k1, k2):
					hata_listesi.append("onceliksiz_esitlik:kosul_sayisi=%d,oncelik=%d" % [k1.size(), o1])
					esitlik_hatasi_eklendi = true
					break
	return hata_listesi


## DIY-08 sozlugunu konusma secimi icin hazirlar (salt-okunur kopya uzerinde).
## - `dunya_olaylari.gorulenler` icindeki her kimligi `dunya.<id> = true` olarak ust anahtara acar.
## - Motor yeni/ikinci cumle uretmez; yalniz baglam anahtarlarini hazirlar.
static func baglam_hazirla(baglam: Dictionary, ek: Dictionary = {}) -> Dictionary:
	var kopya := baglam.duplicate(true)
	# Dunya olaylarindaki gorulen kimlikleri dunya.<id> anahtarina yansit
	var dunya_olaylari: Variant = kopya.get("dunya_olaylari", {})
	if dunya_olaylari is Dictionary:
		var gorulenler: Variant = dunya_olaylari.get("gorulenler", [])
		if gorulenler is Array:
			for olay_id in gorulenler:
				var kimlik := String(olay_id).strip_edges()
				if not kimlik.is_empty():
					kopya[DUNYA_ONEKI + kimlik] = true
		var isaretler: Variant = dunya_olaylari.get("isaretler", {})
		if isaretler is Dictionary:
			for olay_id in isaretler.keys():
				var kimlik := String(olay_id).strip_edges()
				if not kimlik.is_empty():
					kopya[DUNYA_ONEKI + kimlik] = isaretler[olay_id]

	# Ek baglam verilerini uygula
	for k in ek.keys():
		var anahtar := String(k)
		if anahtar == "ac_kisi" or anahtar == ACLIK_ANAHTARI:
			kopya[ACLIK_ANAHTARI] = bool(ek[k])
		elif anahtar == "dunya_isareti" and ek[k] is String:
			var kimlik := String(ek[k]).strip_edges()
			if not kimlik.is_empty():
				kopya[DUNYA_ONEKI + kimlik] = true
		elif anahtar == "dunya_isaretleri":
			if ek[k] is Array:
				for olay_id in ek[k]:
					var kimlik := String(olay_id).strip_edges()
					if not kimlik.is_empty():
						kopya[DUNYA_ONEKI + kimlik] = true
			elif ek[k] is Dictionary:
				for olay_id in (ek[k] as Dictionary).keys():
					var kimlik := String(olay_id).strip_edges()
					if not kimlik.is_empty():
						kopya[DUNYA_ONEKI + kimlik] = ek[k][olay_id]
		else:
			kopya[anahtar] = ek[k]
	return kopya


## Ek sart (YSM-60): Ac kisinin soz baglamina `aclik` anahtari yazilir; motor ikinci cumle uretmez.
static func baglama_aclik_yaz(baglam: Dictionary, ac_mi: bool) -> Dictionary:
	var kopya := baglam.duplicate(true)
	kopya[ACLIK_ANAHTARI] = bool(ac_mi)
	return kopya


## Ek sart (DNY-32): Dunya isareti soz baglamina `dunya` oneki ve olay kimligi (`dunya.<id>`) olarak girer;
## motor yeni cumle uretmez.
static func baglama_dunya_isareti_yaz(baglam: Dictionary, olay_id: String, deger: Variant = true) -> Dictionary:
	var kopya := baglam.duplicate(true)
	var temiz := olay_id.strip_edges()
	if temiz.begins_with(DUNYA_ONEKI):
		kopya[temiz] = deger
	elif not temiz.is_empty():
		kopya[DUNYA_ONEKI + temiz] = deger
	return kopya


## Verilen varyant listesinden baglama en uygun ТЕK varyanti secer.
## - Tum kosullari tutan varyantlar arasindan kosul sayisi en yuksek olani secer.
## - Kosul sayisi esitse `oncelik` degeri buyuk olani secer.
## - Kosul sayisi ve `oncelik` esitse dosya sirasi hakem olmaz; hata kaydeder ve bos doner.
## - Hicbir kosullu varyant tutmazsa bos kosullu varsayilan varyanti doner.
## - Varsayilan da yoksa `{}` doner (satir susar, motor cokmez).
func sec(varyantlar: Array, baglam: Dictionary) -> Dictionary:
	_son_hatalar.clear()
	if varyantlar.is_empty():
		return {}

	var hazir_baglam := baglam_hazirla(baglam)
	var en_iyi_kosullu: Array[Dictionary] = []
	var en_cok_kosul := -1
	var en_yuksek_oncelik := -2147483648
	var varsayilanlar: Array[Dictionary] = []
	var varsayilan_en_yuksek_oncelik := -2147483648

	for ham in varyantlar:
		if not (ham is Dictionary):
			continue
		var v: Dictionary = ham
		var kosullar := _kosul_sozlugu_cikar(v)
		var kosul_sayisi := kosullar.size()
		var oncelik := _oncelik_oku(v)

		if kosul_sayisi == 0:
			if oncelik > varsayilan_en_yuksek_oncelik:
				varsayilan_en_yuksek_oncelik = oncelik
				varsayilanlar = [v]
			elif oncelik == varsayilan_en_yuksek_oncelik:
				varsayilanlar.append(v)
			continue

		# Kural 5: Kismi tutma sayilmaz; tum kosullar tam eslesmelidir.
		if not tum_kosullar_tutar_mi(kosullar, hazir_baglam):
			continue

		if kosul_sayisi > en_cok_kosul:
			en_cok_kosul = kosul_sayisi
			en_yuksek_oncelik = oncelik
			en_iyi_kosullu = [v]
		elif kosul_sayisi == en_cok_kosul:
			if oncelik > en_yuksek_oncelik:
				en_yuksek_oncelik = oncelik
				en_iyi_kosullu = [v]
			elif oncelik == en_yuksek_oncelik:
				en_iyi_kosullu.append(v)

	if en_iyi_kosullu.size() == 1:
		return en_iyi_kosullu[0].duplicate(true)
	elif en_iyi_kosullu.size() > 1:
		_son_hatalar.append("onceliksiz_esitlik:kosul_sayisi=%d,oncelik=%d" % [en_cok_kosul, en_yuksek_oncelik])
		return {}

	# Hicbir kosullu varyant tutmadiysa varsayilan (bos kosullu) varyanta dus
	if varsayilanlar.size() == 1:
		return varsayilanlar[0].duplicate(true)
	elif varsayilanlar.size() > 1:
		_son_hatalar.append("onceliksiz_esitlik:kosul_sayisi=0,oncelik=%d" % varsayilan_en_yuksek_oncelik)
		return {}

	# Varsayilan da yoksa satir susar, motor cokmez.
	return {}


## Secilen varyantin metnini doner. Motor asla ikinci cumle uretmez; tek varyantin metnini doner.
## Hicbiri secilmezse `""` doner (satir susar).
func sec_metin(varyantlar: Array, baglam: Dictionary) -> String:
	var secilen := sec(varyantlar, baglam)
	if secilen.is_empty():
		return ""
	if secilen.has("metin"):
		return String(secilen.get("metin", ""))
	if secilen.has("satir"):
		return String(secilen.get("satir", ""))
	if secilen.has("id"):
		return String(secilen.get("id", ""))
	return ""


## Bir varyantin kosul sozlugundeki TUM kosullarin baglamda tutup tutmadigini denetler.
## Tek bir kosul bile tutmazsa false doner (kismi tutma = false).
static func tum_kosullar_tutar_mi(kosullar: Dictionary, baglam: Dictionary) -> bool:
	for anahtar in kosullar.keys():
		if not tek_kosul_tutar_mi(String(anahtar), kosullar[anahtar], baglam):
			return false
	return true


## Tek bir kosul anahtarinin beklenen degerle baglamda eslesip eslesmedigini denetler.
static func tek_kosul_tutar_mi(anahtar: String, beklenen: Variant, baglam: Dictionary) -> bool:
	# 1. Dogrudan anahtar baglamda var mi?
	if baglam.has(anahtar):
		return _deger_eslesir_mi(baglam[anahtar], beklenen)

	# 2. Noktali alt alan erisimi (orn. "bina.sifahane", "dunya.mogol_elcisi", "grup_itibari.turkmen")
	var nokta := anahtar.find(".")
	if nokta > 0:
		var ust := anahtar.substr(0, nokta)
		var alt := anahtar.substr(nokta + 1)
		if ust == "dunya":
			if baglam.has(anahtar):
				return _deger_eslesir_mi(baglam[anahtar], beklenen)
			var do_sozluk: Variant = baglam.get("dunya_olaylari", {})
			if do_sozluk is Dictionary:
				var gorulenler: Variant = do_sozluk.get("gorulenler", [])
				if gorulenler is Array:
					var var_mi: bool = (alt in (gorulenler as Array))
					return _deger_eslesir_mi(var_mi, beklenen)
			return false
		if baglam.has(ust) and baglam[ust] is Dictionary:
			var alt_sozluk: Dictionary = baglam[ust]
			if alt_sozluk.has(alt):
				return _deger_eslesir_mi(alt_sozluk[alt], beklenen)
			# DIY-08 Kural 3: olmayan bina false doner
			if ust == "bina":
				return _deger_eslesir_mi(false, beklenen)
			return false
		return false

	# 3. "kriz" tekil kisayolu -> baglam["krizler"] dizisinde arama
	if anahtar == "kriz" and baglam.has("krizler") and baglam["krizler"] is Array:
		var kriz_listesi: Array = baglam["krizler"]
		if beklenen is String:
			return String(beklenen) in kriz_listesi
		return _deger_eslesir_mi(kriz_listesi, beklenen)

	# 4. Sayisal alt/ust sinir sonekleri (_min / _max), orn. guven_min, guven_max, terazi_min, terazi_max
	if anahtar.ends_with("_min"):
		var taban := anahtar.substr(0, anahtar.length() - 4)
		var canli: Variant = _baglamdan_deger_oku(taban, baglam)
		if (canli is int or canli is float) and (beklenen is int or beklenen is float):
			return float(canli) >= float(beklenen)
		return false
	if anahtar.ends_with("_max"):
		var taban := anahtar.substr(0, anahtar.length() - 4)
		var canli: Variant = _baglamdan_deger_oku(taban, baglam)
		if (canli is int or canli is float) and (beklenen is int or beklenen is float):
			return float(canli) <= float(beklenen)
		return false

	# DIY-08 Kural 4: Kosul alani sozlukte yoksa satir secilmez.
	return false


static func _baglamdan_deger_oku(anahtar: String, baglam: Dictionary) -> Variant:
	if baglam.has(anahtar):
		return baglam[anahtar]
	var nokta := anahtar.find(".")
	if nokta > 0:
		var ust := anahtar.substr(0, nokta)
		var alt := anahtar.substr(nokta + 1)
		if baglam.has(ust) and baglam[ust] is Dictionary:
			return (baglam[ust] as Dictionary).get(alt, null)
	return null


static func _deger_eslesir_mi(canli: Variant, beklenen: Variant) -> bool:
	# Dizi icinde arama: canli bir Array ise (orn. krizler) ve beklenen tekil String ise
	if canli is Array and not (beklenen is Array):
		for oge in canli:
			if _skaler_esit_mi(oge, beklenen):
				return true
		return false

	# Her ikisi de Array ise: beklenen dizideki her oge canli dizide bulunmali
	if canli is Array and beklenen is Array:
		for aranan in beklenen:
			var bulundu := false
			for mevcut in canli:
				if _skaler_esit_mi(mevcut, aranan):
					bulundu = true
					break
			if not bulundu:
				return false
		return true

	# Karsilastirma sozlugu destegi: {"min": 3, "max": 8} veya {"op": ">=", "deger": 5}
	if beklenen is Dictionary and not (canli is Dictionary):
		if (canli is int or canli is float):
			var sayi := float(canli)
			var b_sozluk: Dictionary = beklenen
			if b_sozluk.has("min") and sayi < float(b_sozluk["min"]):
				return false
			if b_sozluk.has("max") and sayi > float(b_sozluk["max"]):
				return false
			if b_sozluk.has("op") and b_sozluk.has("deger"):
				var hedef := float(b_sozluk["deger"])
				match String(b_sozluk["op"]):
					"==", "=":
						return is_equal_approx(sayi, hedef)
					"!=":
						return not is_equal_approx(sayi, hedef)
					">=":
						return sayi >= hedef
					"<=":
						return sayi <= hedef
					">":
						return sayi > hedef
					"<":
						return sayi < hedef
					_:
						return false
			return b_sozluk.has("min") or b_sozluk.has("max")
		return false

	return _skaler_esit_mi(canli, beklenen)


static func _skaler_esit_mi(a: Variant, b: Variant) -> bool:
	if typeof(a) == TYPE_BOOL or typeof(b) == TYPE_BOOL:
		return typeof(a) == TYPE_BOOL and typeof(b) == TYPE_BOOL and bool(a) == bool(b)
	if (a is int or a is float) and (b is int or b is float):
		return is_equal_approx(float(a), float(b))
	if (a is String or a is StringName) and (b is String or b is StringName):
		return String(a) == String(b)
	return a == b


static func _kosul_sozlugu_cikar(varyant: Dictionary) -> Dictionary:
	var ham: Variant = varyant.get("kosullar", varyant.get("kosul", {}))
	if ham is Dictionary:
		return (ham as Dictionary).duplicate(true)
	if ham is Array:
		var sonuc: Dictionary = {}
		for oge in ham:
			if oge is Dictionary:
				var d: Dictionary = oge
				if d.has("alan") and d.has("deger"):
					sonuc[String(d["alan"])] = d["deger"]
				else:
					for k in d.keys():
						sonuc[String(k)] = d[k]
			elif oge is String:
				var metin := String(oge).strip_edges()
				var esit := metin.find("=")
				if esit > 0:
					var k := metin.substr(0, esit).strip_edges()
					var v := metin.substr(esit + 1).strip_edges()
					sonuc[k] = _metin_degeri_coz(v)
				elif not metin.is_empty():
					sonuc[metin] = true
		return sonuc
	return {}


static func _metin_degeri_coz(v: String) -> Variant:
	if v == "true":
		return true
	if v == "false":
		return false
	if v.is_valid_int():
		return v.to_int()
	if v.is_valid_float():
		return v.to_float()
	return v


static func _oncelik_oku(varyant: Dictionary) -> int:
	var v: Variant = varyant.get("oncelik", 0)
	if v is int or v is float:
		return int(v)
	return 0


static func _alan_gecerli_mi(anahtar: String, baglam: Dictionary, izinli_alanlar: Array[String]) -> bool:
	if baglam.has(anahtar) or (anahtar in izinli_alanlar) or (anahtar in EK_BAGLAM_ANAHTARLARI):
		return true
	if anahtar == "kriz":
		return true
	if anahtar.begins_with(DUNYA_ONEKI) or anahtar.begins_with("bina.") or anahtar.begins_with("grup_itibari.") or anahtar.begins_with("olay.") or anahtar.begins_with("sira."):
		return true
	if anahtar.ends_with("_min") or anahtar.ends_with("_max"):
		var taban := anahtar.substr(0, anahtar.length() - 4)
		return baglam.has(taban) or (taban in izinli_alanlar) or (taban in EK_BAGLAM_ANAHTARLARI)
	return false


## Iki kosul sozlugunun ayni baglamda ayni anda tutup tutamayacagini denetler.
## Ayni anahtarda farkli skaler deger istiyorlarsa (orn. mevsim=0 ve mevsim=2) ayni anda tutamazlar.
static func _ayni_anda_tutabilir_mi(k1: Dictionary, k2: Dictionary) -> bool:
	for anahtar in k1.keys():
		if k2.has(anahtar):
			var d1: Variant = k1[anahtar]
			var d2: Variant = k2[anahtar]
			if not (d1 is Array or d2 is Array or d1 is Dictionary or d2 is Dictionary):
				if not _skaler_esit_mi(d1, d2):
					return false
	return true
