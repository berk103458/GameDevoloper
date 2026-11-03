## DIY-13: Dedikodu yayilimi — haber gecikmeli dolasir.
## Rusvet, siddet, aileyi bolme ve haksiz ret tanik varsa 1-3 gece icinde yayilir.
## Tanik yoksa satir olusmaz. Ayni olay kimligi ikinci kayit acmaz.
## Tanik yayilmadan olurse kayit duser; 3. geceden sonra basilmamis satir silinir, birikmez.
class_name Dedikodu
extends RefCounted


const ASGARI_GECIKME := 1
const AZAMI_GECIKME := 3
const AZAMI_SATIR := 80

const AGIR_OLAY_TURLERI := [
	"rusvet",
	"siddet",
	"aileyi_bolme",
	"haksiz_ret",
]

const VARSAYILAN_SATIRLAR := {
	"rusvet": "Kapıda el altından akçe alındığı fısıldanıyor.",
	"siddet": "Kapı önünde yaşanan sert arbede köy içinde konuşuluyor.",
	"aileyi_bolme": "Kapıda bir ailenin birbirinden koparıldığı söylentisi dolaşıyor.",
	"haksiz_ret": "Kapıdan geri çevrilen yolcuya haksızlık edildiği fısıldanıyor.",
}

var _kayitlar: Array[Dictionary] = []
var _gorulen_kimlikler: Dictionary = {}
var _okuma_sayisi: int = 0
var _yazma_sayisi: int = 0


## Tum dedikodu kayitlarini sifirlar.
func sifirla() -> void:
	_kayitlar.clear()
	_gorulen_kimlikler.clear()
	_okuma_sayisi = 0
	_yazma_sayisi = 0


## Okuma ve yazma cagri sayaclarini sifirlar.
func sayaclari_sifirla() -> void:
	_okuma_sayisi = 0
	_yazma_sayisi = 0


func okuma_sayisi() -> int:
	return _okuma_sayisi


func yazma_sayisi() -> int:
	return _yazma_sayisi


## Olay turunun agir olay listesinde olup olmadigini denetler.
## Kamu vergisi ("kamu_vergisi") dedikodu degildir; yalniz sahsi rusvet ve diger 3 agir olay turu gecerlidir.
static func gecerli_tur_mu(tur: String) -> bool:
	var norm := _norm_tur(tur)
	if norm == "kamu_vergisi" or norm == "vergi":
		return false
	return norm in AGIR_OLAY_TURLERI


## Yeni bir dedikodu olayi kaydetmeyi dener.
## - Tur listede yoksa reddeder.
## - Tanik yoksa kayit olusmaz.
## - Ayni `olay_id` ikinci kez kayit acmaz.
## - Gecikme 1..3 gece arasina kesilir; gun araligi `[gece + 1, gece + 3]` olarak kayitta yazar.
func olay_kaydet(
	olay_id: String,
	tur: String,
	gece: int,
	tanik: Variant,
	gecikme_gece: int = 1,
	ek: Dictionary = {}
) -> Dictionary:
	var temiz_id := olay_id.strip_edges()
	if temiz_id.is_empty():
		return {"olur": false, "sebep": "bos_olay_id"}

	# Kamu vergisi dedikodu degildir
	if bool(ek.get("kamu_vergisi", false)):
		return {"olur": false, "sebep": "kamu_vergisi_dedikodu_degil"}

	var norm_tur := _norm_tur(tur)
	if not (norm_tur in AGIR_OLAY_TURLERI):
		return {"olur": false, "sebep": "gecersiz_olay_turu"}

	var tanik_id := _tanik_kimligi_cikar(tanik)
	if tanik_id.is_empty():
		return {"olur": false, "sebep": "tanik_yok"}

	if _gorulen_kimlikler.has(temiz_id):
		return {"olur": false, "sebep": "tekrar_olay_id"}

	var baslangic_gece := maxi(gece, 0)
	var gecikme := clampi(gecikme_gece, ASGARI_GECIKME, AZAMI_GECIKME)
	var yayilim_gecesi := baslangic_gece + gecikme
	var son_gece := baslangic_gece + AZAMI_GECIKME
	var ozel_satir := String(ek.get("satir", "")).strip_edges()
	var satir_metni := ozel_satir if not ozel_satir.is_empty() else String(VARSAYILAN_SATIRLAR.get(norm_tur, ""))

	var kayit := {
		"olay_id": temiz_id,
		"tur": norm_tur,
		"satir": satir_metni,
		"bayrak": "dedikodu_" + norm_tur,
		"kayit_gecesi": baslangic_gece,
		"gecikme": gecikme,
		"yayilim_gecesi": yayilim_gecesi,
		"gun_araligi": [baslangic_gece + ASGARI_GECIKME, son_gece],
		"tanik_id": tanik_id,
		"yayildi": false,
		"basildi": false,
		"grup": String(ek.get("grup", "")),
		"hedef_id": String(ek.get("hedef_id", "")),
		"kisisel_kasa": bool(ek.get("kisisel_kasa", false)),
	}
	_kayitlar.append(kayit)
	_gorulen_kimlikler[temiz_id] = true
	_tavana_sigdir()
	_yazma_sayisi += 1
	return {
		"olur": true,
		"kayit": kayit.duplicate(true),
	}


## Kisisel kasadaki rusvet: tanik varsa tek satir uretir; tanik yoksa akce hareketi pusulaya yazilmaz.
func kisisel_rusvet_kaydet(
	olay_id: String,
	gece: int,
	tanik: Variant,
	gecikme_gece: int = 1,
	ek: Dictionary = {}
) -> Dictionary:
	var kopya := ek.duplicate(true)
	kopya["kisisel_kasa"] = true
	return olay_kaydet(olay_id, "rusvet", gece, tanik, gecikme_gece, kopya)


## Tanik ertesi gece (yayilmadan veya basilmadan once) olurse henuz basilmamis kayit duser.
func tanik_oldu(tanik_id: String, olum_gecesi: int = -1) -> int:
	return _tanik_kaydi_dusur(tanik_id, olum_gecesi)


## Tanik koyu terk ederse henuz basilmamis kayit duser.
func tanik_ayrildi(tanik_id: String, ayrilis_gecesi: int = -1) -> int:
	return _tanik_kaydi_dusur(tanik_id, ayrilis_gecesi)


func _tanik_kaydi_dusur(tanik_id: String, olay_gecesi: int = -1) -> int:
	var temiz := tanik_id.strip_edges()
	if temiz.is_empty():
		return 0
	var silinen := 0
	var kalanlar: Array[Dictionary] = []
	for k in _kayitlar:
		var k_tanik := String(k.get("tanik_id", ""))
		var basildi := bool(k.get("basildi", false))
		var yayildi := bool(k.get("yayildi", false))
		var yayilim_gecesi := int(k.get("yayilim_gecesi", 0))
		var zaman_uygun := (olay_gecesi < 0) or (not yayildi) or (olay_gecesi <= yayilim_gecesi)
		var dusmeli := (k_tanik == temiz) and (not basildi) and zaman_uygun
		if dusmeli:
			silinen += 1
		else:
			kalanlar.append(k)
	_kayitlar = kalanlar
	return silinen


## Gece ilerlediginde:
## - Yayilim gecesi gelmis kayitlari `yayildi = true` yapar.
## - Ucuncu geceden (`kayit_gecesi + 3`) sonra hala basilmamis (`basildi == false`) satirlari siler, biriktirmez.
func gece_ilerlet(guncel_gece: int) -> void:
	if guncel_gece <= 0:
		return
	var kalanlar: Array[Dictionary] = []
	for k in _kayitlar:
		var aralik: Array = k.get("gun_araligi", [1, 3])
		var son_gece := int(aralik[1]) if aralik.size() > 1 else (int(k.get("kayit_gecesi", 0)) + AZAMI_GECIKME)
		var basildi := bool(k.get("basildi", false))
		if guncel_gece > son_gece and not basildi:
			# Ucuncu geceden sonra basilmamis satir silinir, birikmez.
			continue
		if guncel_gece >= int(k.get("yayilim_gecesi", 1)):
			k["yayildi"] = true
		kalanlar.append(k)
	_kayitlar = kalanlar


## KOP-05, FisiltiGazetesi (CAS-09) ve BatilInancHisterisi (KRI-08) icin ortak okuma yuzeyi.
## Gun 0'da veya yayilim gecesinden once 0 satir doner.
## `basildi_isaretle = true` verilirse okunan yayilmis kayitlar `basildi = true` olarak isaretlenir.
func pusula_satirlari(guncel_gece: int, basildi_isaretle: bool = false) -> Array[Dictionary]:
	_okuma_sayisi += 1
	if guncel_gece <= 0:
		return []
	gece_ilerlet(guncel_gece)
	var sonuc: Array[Dictionary] = []
	for k in _kayitlar:
		var kayit_gecesi := int(k.get("kayit_gecesi", 0))
		if guncel_gece <= kayit_gecesi:
			continue
		if bool(k.get("yayildi", false)) and not bool(k.get("basildi", false)):
			sonuc.append(k.duplicate(true))
			if basildi_isaretle:
				k["basildi"] = true
	return sonuc


## Aktif (dusmemis ve suresi gecmemis) tum kayitlarin kopyasini doner.
func kayitlar() -> Array[Dictionary]:
	return _kayitlar.duplicate(true)


func kaydet() -> Dictionary:
	return {
		"kayitlar": _kayitlar.duplicate(true),
		"gorulen_kimlikler": _gorulen_kimlikler.keys(),
	}


func yukle(veri: Dictionary) -> bool:
	sifirla()
	if veri.get("kayitlar") is Array:
		for oge in veri["kayitlar"]:
			if oge is Dictionary:
				var d: Dictionary = (oge as Dictionary).duplicate(true)
				# KAY-12: tanık kimliği olmayan satır yüklemede haber uyduramaz.
				if not d.get("tanik_id") is String or String(d.tanik_id).strip_edges().is_empty(): continue
				_kayitlar.append(d)
				var id := String(d.get("olay_id", ""))
				if not id.is_empty():
					_gorulen_kimlikler[id] = true
	if veri.get("gorulen_kimlikler") is Array:
		for id in veri["gorulen_kimlikler"]:
			var s := String(id).strip_edges()
			if not s.is_empty():
				_gorulen_kimlikler[s] = true
	_tavana_sigdir()
	return true


## KAY-70: en fazla 80 satır. En eski düşer; kimliği görülenlerde kalır, yayılmamış olay geri gelmez.
func _tavana_sigdir() -> void:
	while _kayitlar.size() > AZAMI_SATIR:
		_kayitlar.remove_at(0)
		push_warning("KAY70_DEDIKODU_TAVANI")


static func _norm_tur(tur: String) -> String:
	var s := tur.strip_edges().to_lower()
	s = s.replace("ü", "u").replace("ş", "s").replace("ı", "i").replace("ç", "c").replace("ğ", "g").replace("ö", "o").replace(" ", "_")
	return s


static func _tanik_kimligi_cikar(tanik: Variant) -> String:
	if tanik == null:
		return ""
	if typeof(tanik) == TYPE_BOOL:
		return "kapi_sirasi_tanik" if bool(tanik) else ""
	if tanik is String or tanik is StringName:
		return String(tanik).strip_edges()
	if tanik is Array:
		var dizi: Array = tanik
		for oge in dizi:
			var kimlik := _tanik_kimligi_cikar(oge)
			if not kimlik.is_empty():
				return kimlik
		return ""
	if tanik is Dictionary:
		var d: Dictionary = tanik
		return String(d.get("id", d.get("ad", ""))).strip_edges()
	return ""
