class_name HareketGecisi
extends Node

## SAH-17..SAH-32: Yürüme, koşma, durma hız bantları ve animasyon karıştırma denetleyicisi.

const AYAR_YOLU := "res://data/ayarlar/sahne.json"

var hiz_bantlari := {
	"dur": [0.0, 0.1],
	"yuru": [0.1, 2.5],
	"kos": [2.5, 6.0]
}
var klipler := {
	"dur": "bekle",
	"yuru": "yuru",
	"kos": "kos"
}
var gecis_suresi_tablo := 0.25


func _init() -> void:
	_ayarlari_yukle()


func _ayarlari_yukle() -> void:
	if not FileAccess.file_exists(AYAR_YOLU):
		return
	var metin := FileAccess.get_file_as_string(AYAR_YOLU)
	var veri: Variant = JSON.parse_string(metin)
	if veri is Dictionary:
		if veri.has("hiz_bantlari") and veri["hiz_bantlari"] is Dictionary:
			hiz_bantlari = veri["hiz_bantlari"]
		if veri.has("klipler") and veri["klipler"] is Dictionary:
			klipler = veri["klipler"]
		if veri.has("gecis_suresi"):
			gecis_suresi_tablo = float(veri["gecis_suresi"])


## SAH-17: Hız üç bandadır: dur, yürü, koş.
func hiz_bandi_bul(hiz: float) -> String:
	var h := absf(hiz)
	if h < hiz_bantlari["dur"][1]:
		return "dur"
	elif h < hiz_bantlari["yuru"][1]:
		return "yuru"
	else:
		return "kos"


func klip_adi_al(band: String) -> String:
	return klipler.get(band, "bekle")


## SAH-18: Durmadan yürümeye geçiş karışıktır, ilk karede dur pozuna daha yakındır.
func karisim_hesapla(t: float, toplam_sure: float = -1.0) -> float:
	var sure := gecis_suresi_tablo if toplam_sure <= 0.0 else toplam_sure
	if sure <= 0.0:
		return 1.0
	var oran := clampf(t / sure, 0.0, 1.0)
	return oran


## SAH-19: Koşu yalnız kovalama ve kaçışta açılır; devriyede koşu 0'dır.
func kosu_acik_mi(durum: String) -> bool:
	return durum in ["kovalama", "kacis"]


## SAH-20: Durunca ayak cilası aynı karede devreye girer.
func durus_cila_etkin_mi(band: String) -> bool:
	return band == "dur"


## SAH-21: Yokuşta bant değişmez ("yuru"), adım ve kök hız kısalır.
func yokusta_hiz_uyarla(kok_hiz: float, egim: float) -> Dictionary:
	var dusus := clampf(absf(egim) * 0.02, 0.0, 0.4)
	var yeni_hiz := maxf(kok_hiz * (1.0 - dusus), 0.15)
	var band := hiz_bandi_bul(yeni_hiz)
	return {
		"band": "yuru" if band in ["dur", "yuru"] else band,
		"hiz": yeni_hiz,
		"klip": klip_adi_al("yuru")
	}


## SAH-22: Yorgun yürüyüş ayrı bir klip istemez; hız düşer, klip aynı kalır.
func yorgun_hiz(hiz: float, yorgun: bool) -> Dictionary:
	var son_hiz := hiz * 0.7 if yorgun else hiz
	return {
		"hiz": son_hiz,
		"klip": klip_adi_al("yuru")
	}


## SAH-23: Kapıdaki sorgu sırasında kök hız 0'dır, konuşma yürüyüşle karışmaz.
func sorgu_hareketi(sorguda: bool) -> Dictionary:
	if sorguda:
		return {
			"hiz": 0.0,
			"band": "dur",
			"klip": klip_adi_al("dur")
		}
	return {
		"hiz": 1.2,
		"band": "yuru",
		"klip": klip_adi_al("yuru")
	}


## SAH-24: Geçiş süresi zorluk seviyesine göre değişmez.
func gecis_suresi(_zorluk: String = "olagan") -> float:
	return gecis_suresi_tablo


## SAH-25: İki klip birden tam ağırlıkta oynamaz; karışım ağırlıkları toplamı 1'dir.
func karisim_agirliklari(t: float, toplam_sure: float = -1.0) -> Dictionary:
	var oran := karisim_hesapla(t, toplam_sure)
	return {
		"kaynak_agirlik": 1.0 - oran,
		"hedef_agirlik": oran,
		"toplam": 1.0
	}


func agirlik_gecerli_mi(agirliklar: Array) -> bool:
	var toplam := 0.0
	for a in agirliklar:
		toplam += float(a)
	return is_equal_approx(toplam, 1.0)


## SAH-26: Üst gövde konuşur, alt gövde yürür (yalnız köyde yürürken; kapı sorgusunda alt gövde durur).
func ust_konus_alt_yuru(konusuyor: bool, kapi_sorgusunda: bool = false, koyde_yuruyor: bool = true) -> Dictionary:
	if kapi_sorgusunda:
		return {
			"ust_klip": "konus" if konusuyor else "bekle",
			"alt_klip": "bekle",
			"yuruyus_agirlik": 0.0
		}
	if konusuyor and koyde_yuruyor:
		return {
			"ust_klip": "konus",
			"alt_klip": "yuru",
			"yuruyus_agirlik": 1.0
		}
	var klip := "yuru" if koyde_yuruyor else "bekle"
	return {
		"ust_klip": klip,
		"alt_klip": klip,
		"yuruyus_agirlik": 1.0 if koyde_yuruyor else 0.0
	}


func ust_konusma_alt_dur(konusuyor: bool) -> Dictionary:
	return ust_konus_alt_yuru(konusuyor, true, false)


func ust_konus_alt_dur(konusuyor: bool) -> Dictionary:
	return ust_konus_alt_yuru(konusuyor, true, false)


func kismi_karisim_agirliklari() -> Dictionary:
	return {
		"bacak": 1.0,
		"kol": 0.6,
		"bas": 0.4
	}


## SAH-27: Eksik klip karışımı bozmaz; BUG-09 idle'a (bekle) düşer, olmayan klip ağırlığa katılmaz.
func eksik_klip_coz(klip_adi: String, mevcut_klipler: Array = []) -> Dictionary:
	var klip_var := (klip_adi in mevcut_klipler) if not mevcut_klipler.is_empty() else (klip_adi in klipler.values())
	if not klip_var or klip_adi.is_empty():
		return {
			"klip": "bekle",
			"agirlik": 1.0,
			"eksik_dususu": true
		}
	return {
		"klip": klip_adi,
		"agirlik": 1.0,
		"eksik_dususu": false
	}


func bosta_kemik_klibi(_aktif: String) -> String:
	return klip_adi_al("dur")


## SAH-28: Bekleme çeşitliliği karışımı kesmez; ANI-12 ofseti geçiş sırasında korunur, sıfırlanmaz.
func geciste_ofset_koru(karakter_ofset: float, gecis_orani: float) -> Dictionary:
	return {
		"ofset": karakter_ofset,
		"sifirlandi": false,
		"gecis_orani": clampf(gecis_orani, 0.0, 1.0)
	}


## SAH-29: Tezgâh başında kök hız 0'dır, üst gövde iş klibi oynar, yürüyüş ağırlığı 0'dır.
func tezgah_klibi_agirlik(is_noktasinda: bool) -> Dictionary:
	if is_noktasinda:
		return {
			"kok_hiz": 0.0,
			"ust": "is",
			"alt": "bekle",
			"yuruyus_agirlik": 0.0
		}
	return {
		"kok_hiz": 1.2,
		"ust": "yuru",
		"alt": "yuru",
		"yuruyus_agirlik": 1.0
	}


## SAH-30: Hava tepkisi ayrı bir katmandır; yürüyüş klipine omuz katmanı biner.
func hava_katmani_ekle(temel_klip: String, soguk: bool) -> Dictionary:
	return {
		"temel_klip": temel_klip,
		"omuz_katmani": "usume" if soguk else "",
		"ayri_katman": true
	}


## SAH-31: Kayıt göçü klip ağırlığı tutmaz; yüklemede hızdan kurulur.
func kayit_klip_agirligi_icermez(kayit: Dictionary) -> bool:
	return not kayit.has("klip_agirligi") and not kayit.has("karisim_katmani")


## SAH-32: Aynı karede 3 geçiş olursa ortadaki atlanır, titreme önlenir.
func gecis_filtrele(gecisler: Array) -> Array:
	if gecisler.size() >= 3:
		return [gecisler[0], gecisler[-1]]
	return gecisler
