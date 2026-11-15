# gdlint: disable=max-line-length
class_name Hane
extends RefCounted

## BÖLÜM 36: HAN-01 … HAN-48 / HAN-52
## Muhafızın kişisel hayatı, hane içi diyalog, eşin sabah satırları,
## sofra döngüsü, hane misafirleri ve duyum-ipucu akışı.

const SABAH_SATIRLARI_YOLU := "res://data/soz/hane_sabah_satirlari.json"

var kasa_akce: int = 0
var ev_id: int = -1
var uyeler: Array[int] = []
var ocak_durumu: String = "sicak"
var son_sofra_gunu: int = -1
var es_meslegi: String = "dokumaci"
var es_hayatta: bool = true
var es_moral: int = 50
var misafirler: Array[Dictionary] = []
var yetimler: Array[Dictionary] = []
var acik_duyumlar: Array[Dictionary] = []
var sofra_kuruldu: bool = false
var yas_donemi: bool = false

var _sabah_verisi: Dictionary = {}

func _init(p_es_meslegi: String = "dokumaci") -> void:
	es_meslegi = p_es_meslegi
	es_hayatta = true
	es_moral = 50
	kasa_akce = 10
	_veriyi_yukle()

func _veriyi_yukle() -> void:
	var dosya := FileAccess.open(SABAH_SATIRLARI_YOLU, FileAccess.READ)
	if dosya:
		var parsed = JSON.parse_string(dosya.get_as_text())
		if parsed is Dictionary:
			_sabah_verisi = parsed

## HAN-03 & HAN-04: Sabah satırı (akşamı tekrarlamaz, eş ölünce susar).
func sabah_satiri_al(gun: int) -> String:
	if not es_hayatta or yas_donemi:
		return ""

	var satirlar: Array = _sabah_verisi.get(es_meslegi, [])
	if satirlar.is_empty():
		return "Hayırlı sabahlar muhafız bey, kapı seni bekler."
	var idx := (gun - 1) % satirlar.size()
	return str(satirlar[idx])

## HAN-05: Haftalık sofra günü.
func sofra_kur(gun: int) -> Dictionary:
	if not es_hayatta or yas_donemi:
		return { "sofra_acildi": false }
	sofra_kuruldu = true
	son_sofra_gunu = gun
	es_moral = mini(es_moral + 5, 100)
	return {
		"sofra_acildi": true,
		"gun": gun,
		"es_moral": es_moral,
		"metin": "Akşam ocağın başında sıcak çorba içildi, günün yorgunluğu unutuldu."
	}

## HAN-07: Eşin işi ve üretimi.
func is_ciktisi_al() -> Dictionary:
	if not es_hayatta:
		return {}
	match es_meslegi:
		"ebe":
			return { "meslek": "ebe", "cikti": "sifahane_triyaj", "miktar": 1 }
		"firinci":
			return { "meslek": "firinci", "cikti": "ekmek", "miktar": 1 }
		"dokumaci":
			return { "meslek": "dokumaci", "cikti": "kumas", "miktar": 1 }
		"bostanci":
			return { "meslek": "bostanci", "cikti": "gida", "miktar": 1 }
		"sutcu":
			return { "meslek": "sutcu", "cikti": "gida", "miktar": 1 }
		"yun_egirici":
			return { "meslek": "yun_egirici", "cikti": "kumas_girdisi", "miktar": 1 }
		_:
			return { "meslek": es_meslegi, "cikti": "gida", "miktar": 1 }

## HAN-09: Muhafız maaşı haneye girer.
func maas_al(miktar: int) -> void:
	kasa_akce += miktar

## HAN-31: Rüşvet eve girmez.
func rusvet_engelle(_miktar: int) -> bool:
	return false

## HAN-12 … HAN-15: Misafir ağırlama.
func misafir_al(chr_id: String, tur: String = "normal") -> Dictionary:
	var sonuc := { "chr_id": chr_id, "kabul": true, "olay": tur }
	misafirler.append(sonuc)
	match tur:
		"hediye":
			kasa_akce += 2
			sonuc["metin"] = "Misafir hane sahibine teşekkür mahiyetinde 2 akçe bıraktı."
		"hirsizlik":
			kasa_akce = maxi(kasa_akce - 3, 0)
			sonuc["metin"] = "Gece sığınan misafir şafak sökmeden sandıktan 3 akçe aşırdı!"
		_:
			sonuc["metin"] = "Misafir ocağın kenarında sabahladı, dualarla ayrıldı."
	return sonuc

## HAN-16: Yetim alma (en çok 2).
func yetim_al(chr_id: String) -> bool:
	if yetimler.size() >= 2:
		return false
	yetimler.append({ "chr_id": chr_id, "rol": "cocuk" })
	return true

## HAN-18 … HAN-21: Eşin duyumu ertesi gün sorgusunda ipucu olur.
func duyum_dinle(gun: int, duyum_id: String, dogru: bool = true) -> Dictionary:
	if not es_hayatta or yas_donemi:
		return {}
	var duyum := {
		"gun": gun,
		"duyum_id": duyum_id,
		"dogru": dogru,
		"ipucu_anahtari": "clue_es_" + duyum_id,
		"metin": "Eş: 'Dün çeşme başında duydum, gelen kervanda Moğol casusu varmış derler.'"
	}
	acik_duyumlar.append(duyum)
	return duyum

## HAN-28: Eve dönüş satırı.
func eve_donus_satiri(en_agir_karar: String) -> String:
	if en_agir_karar.is_empty():
		return ""
	return "Kapı kapandı, adımlarım ağır. Zihnimde günün kararı: " + en_agir_karar

## Dört kancadan dördüncüsü: Akşam sohbeti uygunluğu (ACL-03 / HAN-38).
func aksam_sohbeti_uygun_mu() -> bool:
	return es_hayatta and not yas_donemi

## HAN-38 & HAN-52: Eşin ölümü sonrası 4 kanca sıfırlanır (sabah, sofra, duyum, akşam).
func es_olumu() -> void:
	es_hayatta = false
	yas_donemi = true
	es_moral = 0
	acik_duyumlar.clear()
	misafirler.clear()

## HAN-01 & HAN-52: KAY zinciri uyumlu kayıt alma ve yükleme.
func kayit_verisi_al() -> Dictionary:
	return {
		"ev_id": ev_id,
		"uyeler": uyeler.duplicate(),
		"ocak_durumu": ocak_durumu,
		"son_sofra_gunu": son_sofra_gunu,
		"kasa_akce": kasa_akce,
		"es_meslegi": es_meslegi,
		"es_hayatta": es_hayatta,
		"es_moral": es_moral,
		"misafirler": misafirler.duplicate(true),
		"yetimler": yetimler.duplicate(true),
		"acik_duyumlar": acik_duyumlar.duplicate(true),
		"sofra_kuruldu": sofra_kuruldu,
		"yas_donemi": yas_donemi
	}

func kayit_verisi_yukle(veri: Dictionary) -> void:
	ev_id = int(veri.get("ev_id", -1))
	uyeler.clear()
	for u in veri.get("uyeler", []):
		uyeler.append(int(u))
	ocak_durumu = str(veri.get("ocak_durumu", "sicak"))
	son_sofra_gunu = int(veri.get("son_sofra_gunu", -1))
	kasa_akce = int(veri.get("kasa_akce", 10))
	es_meslegi = str(veri.get("es_meslegi", "dokumaci"))
	es_hayatta = bool(veri.get("es_hayatta", true))
	es_moral = int(veri.get("es_moral", 50))
	misafirler.assign(veri.get("misafirler", []))
	yetimler.assign(veri.get("yetimler", []))
	acik_duyumlar.assign(veri.get("acik_duyumlar", []))
	sofra_kuruldu = bool(veri.get("sofra_kuruldu", false))
	yas_donemi = bool(veri.get("yas_donemi", false))


## HAN-01: Eski kayıtlarda 'hane' yoksa ACL-01 kuruluşundan türetir.
static func acilis_hanesinden_turet(y: KoyYonetimi, mevcut: Hane = null, acilis_hanesi: Dictionary = {}) -> Hane:
	var h := mevcut if mevcut != null else Hane.new()
	if y == null:
		return h
	if acilis_hanesi.has("ev_id"):
		h.ev_id = int(acilis_hanesi.get("ev_id", h.ev_id))
	var bulunan_uyeler: Array[int] = []
	var es_bulundu := false
	for k in y.koylular:
		var kurulus_uyesi := k.bayrak_var("acl01_muhafiz") or k.bayrak_var("acl01_es")
		if kurulus_uyesi or (h.ev_id >= 0 and k.ev == h.ev_id):
			if not (k.id in bulunan_uyeler):
				bulunan_uyeler.append(k.id)
			if h.ev_id < 0 and k.ev >= 0:
				h.ev_id = k.ev
			if k.bayrak_var("acl01_es") or int(acilis_hanesi.get("es_id", -1)) == k.id:
				es_bulundu = true
				h.es_hayatta = k.saglik > 0
				h.es_moral = k.moral
				var s := String(k.sinif).to_lower()
				if s in ["dokumaci", "firinci", "ebe", "bostanci", "sutcu", "yun_egirici"]:
					h.es_meslegi = s
	if not bulunan_uyeler.is_empty():
		h.uyeler = bulunan_uyeler
	elif acilis_hanesi.get("kuruldu", false):
		for alan in ["muhafiz_id", "es_id"]:
			var id := int(acilis_hanesi.get(alan, -1))
			if id >= 0 and not (id in h.uyeler):
				h.uyeler.append(id)
	if acilis_hanesi.has("es_id") and not es_bulundu:
		h.es_hayatta = false
		h.yas_donemi = true
		h.ocak_durumu = "soguk"
	return h

func hane_durumu() -> Dictionary:
	return {
		"es_hayatta": es_hayatta,
		"es_meslegi": es_meslegi,
		"es_moral": es_moral,
		"kasa_akce": kasa_akce,
		"misafir_sayisi": misafirler.size(),
		"duyum_sayisi": acik_duyumlar.size(),
		"yetim_sayisi": yetimler.size()
	}
