## Bölüm 38: boş gün, dış yüz, gece erteleme, kadı ve defter. Kart cümlesi yazılmaz.
class_name OzelOlay
extends RefCounted

const KOY_KARTLARI := ["pazar_gunu", "harman", "dugun", "asik"]
const DIS_YUZ := ["tekfur_elcisi", "bey_daveti", "vergi_tahsildari", "aydogdu_oba", "miraen_cavus"]
const HABER := ["ertugrul_haberi", "nogay_haber", "mogol_duman", "ahi_haber"]
const HABER_KAYNAK := {"mogol_duman": "mogol", "ertugrul_haberi": "tekfur", "nogay_haber": "cete"}
const FAZLAR := ["kapi", "koy"]
const YENI_KARTLAR := ["asik", "kadi"]
const ASIK_NUFUS := 6
const KADI_NUFUS := 10


static func olasiliklar() -> Dictionary:
	var yol := "res://data/ayarlar/denge.json"
	var ham := FileAccess.get_file_as_string(yol) if FileAccess.file_exists(yol) else ""
	var veri: Variant = JSON.parse_string(ham)
	var olay: Dictionary = veri.get("olay", {}) if veri is Dictionary else {}
	return {
		"olay": float(olay.get("olay_olasiligi", 0.0)),
		"sira": float(olay.get("sira_olay_olasiligi", 0.0)),
	}


static func bos_mu(o: Oturum) -> bool:
	return o != null and bool(o.get_meta(&"bos_gun", false))


static func kapi_kuyrugu(o: Oturum) -> int:
	return 0 if bos_mu(o) else -1


static func sira_kapali(o: Oturum) -> bool:
	return bos_mu(o)


static func fazlar() -> PackedStringArray:
	var sonuc: PackedStringArray = []
	for faz in FAZLAR:
		sonuc.append(faz)
	return sonuc


static func nobette(o: Oturum) -> bool:
	return o != null and bool(o.get_meta(&"oyuncu_nobette", false))


static func kapi_yuzu(o: Oturum) -> String:
	return "" if o == null else str(o.get_meta(&"kapi_yuzu", ""))


static func nufus_yeter(o: Oturum, esik: int) -> bool:
	return o != null and o.yonetim.nufus() >= esik


static func koy_karti(id: String) -> bool:
	return id in KOY_KARTLARI


static func bos_gun_karti(o: Oturum, id: String) -> bool:
	if not bos_mu(o):
		return true
	return id in KOY_KARTLARI


static func tehdit_gunu() -> int:
	var yol := "res://data/tehdit_takvimi.json"
	var veri: Variant = JSON.parse_string(FileAccess.get_file_as_string(yol)) if FileAccess.file_exists(yol) else {}
	return int(veri.get("tehdit_baslangic_gunu", 0)) if veri is Dictionary else 0


static func aday(o: Oturum, olay: OlayVerisi) -> bool:
	if o == null or olay == null:
		return false
	var id := String(olay.id)
	if id == "aydogdu_oba": return false # İttifak kararı ikinci kapı ziyaretinde açılır.
	if bos_mu(o) and id not in KOY_KARTLARI:
		return false
	if id in DIS_YUZ and kapi_yuzu(o) == id:
		return false
	if id == "asik" and not nufus_yeter(o, ASIK_NUFUS):
		return false
	if id == "kadi":
		if not nufus_yeter(o, KADI_NUFUS) or o.gun < tehdit_gunu():
			return false
	if id in HABER and _haber_var(o, id):
		return false
	return true


static func bekleyen(o: Oturum, katalog: Katalog) -> OlayVerisi:
	if o == null or nobette(o):
		return null
	var id := str(o.get_meta(&"ertelenen_olay", ""))
	if id.is_empty():
		return null
	o.set_meta(&"ertelenen_olay", "")
	for olay in katalog.olaylar():
		if String(olay.id) == id:
			return olay
	return null


static func sonuc(o: Oturum, olay: OlayVerisi) -> OlayVerisi:
	if olay == null:
		return null
	if nobette(o):
		o.set_meta(&"ertelenen_olay", String(olay.id))
		return null
	return olay


static func secildi(o: Oturum, olay: OlayVerisi, indeks: int) -> void:
	if o == null or olay == null:
		return
	_satir(o, "olay", String(olay.id), indeks)
	if String(olay.id) == "kadi" and indeks == 0:
		_divan_ac(o)
	elif String(olay.id) == "kadi" and indeks == 1:
		o.yonetim.adalet = maxi(0, o.yonetim.adalet - int(o.yonetim.a.harc_adalet))


static func bos_gun_yaz(o: Oturum, kart_id: String = "") -> void:
	if not bos_mu(o):
		return
	for satir in defter(o):
		if satir is Dictionary and str(satir.get("tur", "")) == "bos_gun" and int(satir.get("gece", -1)) == o.gun:
			return
	_satir(o, "bos_gun", kart_id, -1)


static func defter(o: Oturum) -> Array:
	var ham: Variant = o.get_meta(&"olay_defteri", []) if o != null else []
	return ham if ham is Array else []


static func bilinen_idler(katalog: Katalog) -> PackedStringArray:
	var sonuc: PackedStringArray = []
	if katalog == null:
		return sonuc
	for olay in katalog.olaylar():
		sonuc.append(String(olay.id))
	return sonuc


## Eski kayıtta olmayan kart seçilmez. Bilinmeyen id yutulur, oyun açılır.
static func kayit_kartlari(bilinen: PackedStringArray, kayit_idler: Array) -> PackedStringArray:
	var sonuc: PackedStringArray = []
	for id in kayit_idler:
		var ad := str(id)
		if bilinen.has(ad):
			sonuc.append(ad)
	return sonuc


static func _haber_var(o: Oturum, id: String) -> bool:
	var yazilan: Variant = o.get_meta(&"haber_satirlari", [])
	if yazilan is Array and id in yazilan:
		return true
	var kaynak := str(HABER_KAYNAK.get(id, ""))
	if kaynak.is_empty():
		return false
	var defter: Dictionary = HaberciAgi.oku(o.haberci_agi)
	for satir in defter.get("bekleyen", []):
		if satir is Dictionary and str(satir.get("kaynak", "")) == kaynak:
			return true
	return false


static func _divan_ac(o: Oturum) -> int:
	var adaylar := DivanOturumu.adaylar(o.yonetim)
	if not adaylar.is_empty() and DivanOturumu.sec(o.yonetim, adaylar[0]):
		return 1
	o.yonetim.set_meta(DivanOturumu.META, {"kisi": -1, "inceleme_gunu": o.yonetim.gun})
	return 1 if int(DivanOturumu.durum(o.yonetim).inceleme_gunu) == o.yonetim.gun else 0


static func _satir(o: Oturum, tur: String, olay_id: String, indeks: int) -> void:
	var liste: Array = defter(o).duplicate()
	liste.append({"tur": tur, "gece": o.gun, "olay": olay_id, "secenek": indeks})
	o.set_meta(&"olay_defteri", liste)
