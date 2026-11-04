## DIY-11: Kisi hafizasi — donen karakter hatirlar.
## Tek kaynak `KarakterKadrosu.durumlar[id]` alanlaridir; ikinci hafiza deposu yoktur.
## Kayit yuklemek ziyaret sayacini artirmaz. Sayac 9'dan sonra yeni selam anahtari acmaz.
class_name KisiHafizasi
extends RefCounted


const AZAMI_SELAM_ZIYARETI := 9
const GECERLI_KARARLAR := ["kabul", "ret", "rusvet", "kisla", "kacti"]
const HABER_KANALI_OLUM := "DYL-08"
const GUVEN_TAVANI := 10
const BEYAN_TAVANI := 40
const ITIRAF_GUVENI := 8


## Karakterin kadrodaki durum kaydindan hafiza gorunumunu okur.
## Eski kayitta opsiyonel alanlar yoksa bos degerlerle doner, oyun cokmez.
static func oku(kadro: KarakterKadrosu, id: StringName, guncel_gece: int = -1, baslangic_tansiyonu: int = 0) -> Dictionary:
	var bos := {
		"durum": "",
		"ziyaret": 0,
		"etkin_ziyaret": 0,
		"son_gece": -1,
		"son_karar": "",
		"verilen_soz": "",
		"yapilan_yardim": "",
		"yuzlesilen_yalan": "",
		"akce_farki": 0,
		"odenen_akce": 0,
		"alinan_akce": 0,
		"karar_gecmisi": [],
		"es": {},
		"oldu": false,
		"guven": 0,
		"korku": baslangic_tansiyonu,
		"itiraf": false,
	}
	if kadro == null or not kadro.durumlar.has(id):
		return bos
	var d: Variant = kadro.durumlar.get(id, {})
	if not (d is Dictionary):
		return bos
	var kayit: Dictionary = d
	var durum_str := String(kayit.get("durum", ""))
	var oldu_mu := (durum_str == "oldu" or durum_str == "öldü")
	var ziyaret_sayisi := maxi(int(kayit.get("ziyaret", 0)), 0)
	var son_gece := int(kayit.get("son_gece", -1))

	# Uç durum: Ayni gun ikinci ziyaret yoksa bu gece yazilan hafiza ertesi kapida okunur.
	var ayni_gun_bekliyor := (guncel_gece >= 0 and son_gece == guncel_gece and not bool(kayit.get("ayni_gun_ikinci_ziyaret", false)))
	var son_karar_str := "" if ayni_gun_bekliyor else _norm_karar(String(kayit.get("son_karar", "")))

	var gecmis: Array = []
	if kayit.get("karar_gecmisi") is Array:
		gecmis = (kayit["karar_gecmisi"] as Array).duplicate(true)
	var es_sozluk: Dictionary = {}
	if kayit.get("es") is Dictionary:
		es_sozluk = (kayit["es"] as Dictionary).duplicate(true)

	var guven := _kisitli_sayi(kayit, "guven", 0)
	var korku := baslangic_tansiyonu
	if _sayi_var(kayit, "korku"):
		korku = _kisitli_sayi(kayit, "korku", baslangic_tansiyonu)
	return {
		"durum": durum_str,
		"ziyaret": ziyaret_sayisi,
		"etkin_ziyaret": mini(ziyaret_sayisi, AZAMI_SELAM_ZIYARETI),
		"son_gece": son_gece,
		"son_karar": son_karar_str,
		"verilen_soz": "" if ayni_gun_bekliyor else String(kayit.get("verilen_soz", "")),
		"yapilan_yardim": "" if ayni_gun_bekliyor else String(kayit.get("yapilan_yardim", "")),
		"yuzlesilen_yalan": "" if ayni_gun_bekliyor else String(kayit.get("yuzlesilen_yalan", "")),
		"akce_farki": 0 if ayni_gun_bekliyor else int(kayit.get("akce_farki", 0)),
		"odenen_akce": 0 if ayni_gun_bekliyor else int(kayit.get("odenen_akce", 0)),
		"alinan_akce": 0 if ayni_gun_bekliyor else int(kayit.get("alinan_akce", 0)),
		"karar_gecmisi": gecmis,
		"es": es_sozluk,
		"oldu": oldu_mu,
		"guven": guven,
		"korku": korku,
		"itiraf": itiraf_acik(kadro, id),
	}


## Kisi basina hafizayi dogrudan `KarakterKadrosu.durumlar[id]` icine yazar.
## Ikinci bir sozluk/depo olusturmaz.
## Ret sonrasi kabul `son_karar` alanini ezer; ancak `karar_gecmisi` icindeki eski ret satiri silinmez.
static func kaydet_olay(
	kadro: KarakterKadrosu,
	id: StringName,
	veri: Dictionary,
	gece: int = -1
) -> bool:
	if kadro == null or not kadro.durumlar.has(id):
		return false
	var kayit: Dictionary = kadro.durumlar[id]
	if String(kayit.get("durum", "")) == "oldu":
		return false

	if veri.has("karar") or veri.has("son_karar"):
		var ham_karar := String(veri.get("karar", veri.get("son_karar", "")))
		var norm := _norm_karar(ham_karar)
		if not norm.is_empty():
			kayit["son_karar"] = StringName(norm)
			var gecmis: Array = []
			if kayit.get("karar_gecmisi") is Array:
				gecmis = kayit["karar_gecmisi"]
			gecmis.append({
				"karar": norm,
				"gece": gece if gece >= 0 else int(kayit.get("son_gece", -1)),
				"satir": String(veri.get("karar_satiri", "karar_" + norm)),
			})
			kayit["karar_gecmisi"] = gecmis

	if veri.has("verilen_soz"):
		kayit["verilen_soz"] = String(veri["verilen_soz"])
	if veri.has("yapilan_yardim"):
		kayit["yapilan_yardim"] = String(veri["yapilan_yardim"])
	if veri.has("yuzlesilen_yalan"):
		kayit["yuzlesilen_yalan"] = String(veri["yuzlesilen_yalan"])
	if veri.has("odenen_akce"):
		var odenen := maxi(int(veri["odenen_akce"]), 0)
		kayit["odenen_akce"] = int(kayit.get("odenen_akce", 0)) + odenen
		kayit["akce_farki"] = int(kayit.get("alinan_akce", 0)) - int(kayit["odenen_akce"])
	if veri.has("alinan_akce"):
		var alinan := maxi(int(veri["alinan_akce"]), 0)
		kayit["alinan_akce"] = int(kayit.get("alinan_akce", 0)) + alinan
		kayit["akce_farki"] = int(kayit["alinan_akce"]) - int(kayit.get("odenen_akce", 0))
	if veri.has("akce_farki") and not veri.has("odenen_akce") and not veri.has("alinan_akce"):
		kayit["akce_farki"] = int(veri["akce_farki"])
	if gece >= 0:
		kayit["son_gece"] = gece
	return true


## Kural 5: Esin aksam hafizasi ayni kaydin `es` altidir (DYL-07). Ayri es deposu yoktur.
static func es_hafizasi_yaz(kadro: KarakterKadrosu, id: StringName, es_verisi: Dictionary) -> bool:
	if kadro == null or not kadro.durumlar.has(id):
		return false
	var kayit: Dictionary = kadro.durumlar[id]
	var mevcut: Dictionary = {}
	if kayit.get("es") is Dictionary:
		mevcut = (kayit["es"] as Dictionary).duplicate(true)
	for k in es_verisi.keys():
		mevcut[String(k)] = es_verisi[k]
	kayit["es"] = mevcut
	return true


static func es_hafizasi_oku(kadro: KarakterKadrosu, id: StringName) -> Dictionary:
	var h := oku(kadro, id)
	var es: Variant = h.get("es", {})
	return (es as Dictionary).duplicate(true) if es is Dictionary else {}


## Uç durum: Kisi olurse hafiza "oldu" diye kapanir ve selam varyanti secilmez; haber DYL-08 kanalina gider.
static func oldu_isaretle(kadro: KarakterKadrosu, id: StringName, gece: int = -1) -> Dictionary:
	if kadro == null or not kadro.durumlar.has(id):
		return {}
	var kayit: Dictionary = kadro.durumlar[id]
	kayit["durum"] = &"oldu"
	if gece >= 0:
		kayit["son_gece"] = gece
	return {
		"kanal": HABER_KANALI_OLUM,
		"id": String(id),
		"durum": "oldu",
		"gece": gece,
	}


## Donen karakterin selam kimligini hesaplar:
## - Kisi olduyse `""` doner (selam secilmez).
## - `son_karar` varsa `"selam_" + son_karar` doner (orn. `son_karar="ret"` -> `"selam_ret"`).
## - Hafiza yoksa ilk ziyaret selami (`"selam_ilk"`) doner.
static func selam_kimligi(kadro: KarakterKadrosu, id: StringName, guncel_gece: int = -1) -> String:
	var h := oku(kadro, id, guncel_gece)
	if bool(h.get("oldu", false)):
		return ""
	var son_karar := String(h.get("son_karar", ""))
	if not son_karar.is_empty():
		return "selam_" + son_karar
	var ziyaret := int(h.get("ziyaret", 0))
	if ziyaret <= 1:
		return "selam_ilk"
	return ziyaret_selam_anahtari(ziyaret)


## Ziyaret sayacina gore selam anahtari. Sayac 9'dan sonra yeni selam anahtari acmaz;
## 10. ve sonraki ziyaretler 9. ziyaretin selam anahtarini (`"selam_9"`) kullanir.
static func ziyaret_selam_anahtari(ziyaret: int) -> String:
	if ziyaret <= 1:
		return "selam_ilk"
	var etkin := mini(ziyaret, AZAMI_SELAM_ZIYARETI)
	return "selam_%d" % etkin


## DIY-09 satir secicisi icin soz baglamina kisi hafizasi alanlarini yazar.
static func baglama_yaz(baglam: Dictionary, kadro: KarakterKadrosu, id: StringName, guncel_gece: int = -1) -> Dictionary:
	var h := oku(kadro, id, guncel_gece)
	var kopya := baglam.duplicate(true)
	kopya["onceki_ziyaret"] = int(h.get("etkin_ziyaret", 0))
	kopya["son_karar"] = String(h.get("son_karar", ""))
	kopya["selam_kimligi"] = selam_kimligi(kadro, id, guncel_gece)
	kopya["ziyaret_selam_anahtari"] = ziyaret_selam_anahtari(int(h.get("ziyaret", 0)))
	kopya["verilen_soz"] = String(h.get("verilen_soz", ""))
	kopya["yapilan_yardim"] = String(h.get("yapilan_yardim", ""))
	kopya["yuzlesilen_yalan"] = String(h.get("yuzlesilen_yalan", ""))
	kopya["akce_farki"] = int(h.get("akce_farki", 0))
	kopya["hafiza"] = h
	return kopya


## DIY-09 (SatirSecici) uzerinden selam varyanti secer.
## Kisi olduyse `{}` doner (selam varyanti secilmez).
static func selam_sec(
	varyantlar: Array,
	baglam: Dictionary,
	kadro: KarakterKadrosu,
	id: StringName,
	guncel_gece: int = -1
) -> Dictionary:
	var h := oku(kadro, id, guncel_gece)
	if bool(h.get("oldu", false)):
		return {}
	var zengin_baglam := baglama_yaz(baglam, kadro, id, guncel_gece)
	var secici := SatirSecici.new()
	var secilen := secici.sec(varyantlar, zengin_baglam)
	if not secilen.is_empty():
		return secilen
	var kimlik := selam_kimligi(kadro, id, guncel_gece)
	if kimlik.is_empty():
		return {}
	return {"id": kimlik, "selam_anahtari": ziyaret_selam_anahtari(int(h.get("ziyaret", 0)))}


## DIY-09 (SatirSecici) uzerinden hafizaya duyarli konu varyanti secer.
static func konu_sec(
	varyantlar: Array,
	baglam: Dictionary,
	kadro: KarakterKadrosu,
	id: StringName,
	guncel_gece: int = -1
) -> Dictionary:
	var h := oku(kadro, id, guncel_gece)
	if bool(h.get("oldu", false)):
		return {}
	var zengin_baglam := baglama_yaz(baglam, kadro, id, guncel_gece)
	var secici := SatirSecici.new()
	return secici.sec(varyantlar, zengin_baglam)


## KAY-07: güven ve korku kişi kaydında 0–10. Eksik güven 0'dır.
static func guven_yaz(kadro: KarakterKadrosu, id: StringName, deger: int) -> int:
	return _olcu_yaz(kadro, id, "guven", deger)


static func korku_yaz(kadro: KarakterKadrosu, id: StringName, deger: int) -> int:
	return _olcu_yaz(kadro, id, "korku", deger)


## KAY-13 / KAY-63: itiraf yalnız sayısal güven eşiği ve bool sır bayrağıyla açılır.
static func itiraf_acik(kadro: KarakterKadrosu, id: StringName) -> bool:
	if kadro == null or not kadro.durumlar.has(id):
		return false
	var kayit: Dictionary = kadro.durumlar[id]
	if not _sayi_var(kayit, "guven") or _kisitli_sayi(kayit, "guven", 0) < ITIRAF_GUVENI:
		return false
	return kayit.get("Flag_Sir_Tamamen_Cozuldu", false) is bool and bool(kayit["Flag_Sir_Tamamen_Cozuldu"])


## KAY-50: kişi başı beyan tavanı. Aşan satır yazılmaz.
static func beyan_tavanina_sigdir(satirlar: Array) -> Array:
	if satirlar.size() <= BEYAN_TAVANI:
		return satirlar
	push_warning("KAY50_BEYAN_TAVANI")
	return satirlar.slice(0, BEYAN_TAVANI)


static func hafiza_paketi(kadro: KarakterKadrosu) -> Array:
	var sonuc: Array = []
	if kadro == null:
		return sonuc
	for id in kadro.durumlar.keys():
		var kayit: Dictionary = kadro.durumlar[id]
		if not kayit.has("guven") and not kayit.has("korku") and not kayit.has("Flag_Sir_Tamamen_Cozuldu"):
			continue
		var satir := {"id": String(id), "ziyaret": int(kayit.get("ziyaret", 0))}
		if kayit.has("guven"):
			satir["guven"] = kayit["guven"]
		if kayit.has("korku"):
			satir["korku"] = kayit["korku"]
		if kayit.has("Flag_Sir_Tamamen_Cozuldu"):
			satir["Flag_Sir_Tamamen_Cozuldu"] = kayit["Flag_Sir_Tamamen_Cozuldu"]
		sonuc.append(satir)
	return sonuc


static func hafiza_uygula(kadro: KarakterKadrosu, satirlar: Array) -> void:
	if kadro == null:
		return
	for satir in satirlar:
		if not satir is Dictionary:
			continue
		var id := StringName(String(satir.get("id", "")).strip_edges())
		if id == StringName() or not kadro.durumlar.has(id):
			push_warning("KAY15_%s" % String(id))
			continue
		var kayit: Dictionary = kadro.durumlar[id]
		if satir.has("ziyaret"):
			kayit["ziyaret"] = maxi(int(kayit.get("ziyaret", 0)), int(satir.get("ziyaret", 0)))
		if _sayi_var(satir, "guven"):
			kayit["guven"] = clampi(int(satir["guven"]), 0, GUVEN_TAVANI)
		if _sayi_var(satir, "korku"):
			kayit["korku"] = clampi(int(satir["korku"]), 0, GUVEN_TAVANI)
		if satir.has("Flag_Sir_Tamamen_Cozuldu") and satir["Flag_Sir_Tamamen_Cozuldu"] is bool:
			kayit["Flag_Sir_Tamamen_Cozuldu"] = bool(satir["Flag_Sir_Tamamen_Cozuldu"])


static func _olcu_yaz(kadro: KarakterKadrosu, id: StringName, alan: String, deger: int) -> int:
	if kadro == null or not kadro.durumlar.has(id):
		return 0
	var n := clampi(deger, 0, GUVEN_TAVANI)
	if n != deger:
		push_warning("KAY14_%s" % alan)
	kadro.durumlar[id][alan] = n
	return n


static func _sayi_var(kayit: Dictionary, alan: String) -> bool:
	if not kayit.has(alan):
		return false
	var v: Variant = kayit[alan]
	return (v is int or v is float) and is_finite(float(v))


static func _kisitli_sayi(kayit: Dictionary, alan: String, varsayilan: int) -> int:
	if not _sayi_var(kayit, alan):
		return varsayilan
	return clampi(int(kayit[alan]), 0, GUVEN_TAVANI)


static func _norm_karar(karar: String) -> String:
	var k := karar.strip_edges().to_lower()
	k = k.replace("ü", "u").replace("ş", "s").replace("ı", "i").replace("ç", "c").replace("ğ", "g").replace("ö", "o")
	if k in GECERLI_KARARLAR:
		return k
	return k
