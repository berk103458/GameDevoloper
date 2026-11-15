# gdlint: disable=max-line-length
class_name SevilenYuz
extends RefCounted

## SEV-01 … SEV-07: Sevilen Yüz — Köyde Tekrar Görme.
## Boş gün köy günüdür; tanıdık yüz ateşe gelir; kişisel iz kalır; tek istek; köylü bağları;
## isim ancak sorulunca kartta durur; veda o kişiyi götürür.

var taninan_isimler: Dictionary = {} # chr_id -> bool
var kisisel_izler: Dictionary = {} # chr_id -> iz_turu
var koylu_baglari: Array[Dictionary] = [] # [{chr1, chr2, tur}]
var ayrilanlar: Array[String] = []

func bos_gun_mu(ziyaretciler: Array) -> bool:
	# SEV-01: Kapıya kimse gelmemişse boş gündür
	return ziyaretciler.is_empty()

func ates_ziyaretcisi_sec(koy_kayitlari: Array) -> Dictionary:
	# Oyun adaptörü yalnız gerçek köylü ve kadro hafızası ile aday gönderir.
	for k in koy_kayitlari:
		if not k is Dictionary: continue
		if String(k.get("durum", "")) != "koyde" or ayrilanlar.has(k.get("id")): continue
		var karar := String(k.get("son_karar", ""))
		if karar.is_empty() or String(k.get("id", "")).is_empty(): continue
		var anahtar := "anlati.ates_selam." + karar
		if karar not in ["kabul", "ret", "rusvet", "kisla", "kacti"]: continue
		if karar == "kabul" and String(k.get("yapilan_yardim", "")) == "ekmek": anahtar = "anlati.ates_selam.ekmek"
		return {"chr_id": k.id, "ad": k.get("ad", ""), "ates_sozu": anahtar}
	return {}

func kisisel_iz_birak(chr_id: String, iz_turu: String) -> void:
	# SEV-03: Kişisel iz köyde kalır
	kisisel_izler[chr_id] = iz_turu

func istek_uret(chr_id: String) -> Dictionary:
	# SEV-04: Tek istek
	return {
		"chr_id": chr_id,
		"istek": "bir_cuval_tohum",
		"metin": "Muhafız bey, ekine başlamak için ambardan bir çuval tohumluk arpa dilerim."
	}

func bag_kur(chr1: String, chr2: String, bag_turu: String = "dostluk") -> void:
	# SEV-05: Köylüler birbirine bağlanır
	koylu_baglari.append({
		"chr1": chr1,
		"chr2": chr2,
		"tur": bag_turu
	})

func kart_gorunum_adi(chr_id: String, gercek_ad: String, meslek: String) -> String:
	# SEV-06: İsim ancak sorulunca kartta durur
	if taninan_isimler.get(chr_id, false):
		return gercek_ad
	return meslek

func isim_sor(chr_id: String) -> void:
	taninan_isimler[chr_id] = true

func veda_et(chr_id: String) -> Dictionary:
	kisisel_izler.erase(chr_id)
	# SEV-07: Veda o kişiyi götürür
	if not ayrilanlar.has(chr_id):
		ayrilanlar.append(chr_id)
	return {
		"chr_id": chr_id,
		"ayrildi": true,
		"veda_metni": "Helallik almaya geldim muhafız bey; yolum gayrı dağ ardınadır."
	}

## SEV-01 oyun adaptörü: üretici gece_kuyrugu API'sini tekrar çalıştırmaz.
func bos_gun_isareti(oturum: Oturum) -> bool:
	return OzelOlay.bos_mu(oturum) or (oturum != null and preload("res://src/sistemler/acilis_senaryosu.gd").kapi_kapali(oturum))
