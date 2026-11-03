## KAY-26 / KAY-27 / KAY-36 / KAY-51: söz ziyaretinin kayıt adaptörü.
## Diyalog metni burada yazılmaz; düğüm kimliği, konu ve dosya sayısı tutulur.
class_name SozMotoru
extends RefCounted

const GECIS_YOLU := "res://data/soz/gecis.json"
const SELAM := "selam"

var dugum_id: String = ""
var konular: Array = []
var selam_okundu: bool = false
var zar: int = -1
var _zar_kayitli: bool = false
var _acilan: PackedStringArray = PackedStringArray()


func sorguyu_ac() -> void:
	GuvenliKayit.sorgu_kaydi_kapali = true


func sorguyu_kapat() -> void:
	GuvenliKayit.sorgu_kaydi_kapali = false


func kaydet() -> Dictionary:
	var veri := {
		"dugum_id": dugum_id,
		"konular": konular.duplicate(true),
		"selam_okundu": selam_okundu,
	}
	if _zar_kayitli:
		veri["zar"] = zar
	return veri


func yukle(veri: Variant, sema_dugumleri: Array = []) -> Dictionary:
	if not veri is Dictionary or veri.is_empty():
		dugum_id = ""
		konular = []
		selam_okundu = false
		return {"kisi_silindi": false, "dugum_id": dugum_id, "selam_yeniden": false}
	var gelen := String(veri.get("dugum_id", "")).strip_edges()
	if not gelen.is_empty() and not sema_dugumleri.is_empty() and not sema_dugumleri.has(gelen):
		push_warning("KAY36_KOPUK_DUGUM:%s" % gelen)
		dugum_id = SELAM
		konular = veri.get("konular", []) if veri.get("konular") is Array else []
		selam_okundu = false
		_zar_oku(veri)
		return {"kisi_silindi": false, "dugum_id": SELAM, "selam_yeniden": true}
	dugum_id = gelen
	konular = veri.get("konular", []).duplicate(true) if veri.get("konular") is Array else []
	selam_okundu = bool(veri.get("selam_okundu", false))
	_zar_oku(veri)
	return {"kisi_silindi": false, "dugum_id": dugum_id, "selam_yeniden": not selam_okundu and not dugum_id.is_empty()}


func selam_yeniden_okunur() -> bool:
	return not selam_okundu


func zar_kaydet(deger: int) -> void:
	zar = deger
	_zar_kayitli = true


## Kayıtlı zar varsa yeni atış yoktur.
func zar_at(rng: RandomNumberGenerator) -> int:
	if _zar_kayitli:
		return zar
	zar = rng.randi_range(1, 6)
	_zar_kayitli = true
	return zar


## Kuyruktaki kişilerin dosyaları açılır. Katalogun geri kalanı bu yüklemede açılmaz.
func gece_dosyalarini_ac(kuyruk: Array, katalog_yollari: Dictionary) -> int:
	_acilan = PackedStringArray()
	for kisi in kuyruk:
		if _acilan.size() >= kuyruk.size():
			break
		var yol := String(katalog_yollari.get(String(kisi), "")).strip_edges()
		if yol.is_empty():
			continue
		_acilan.append(yol)
	return _acilan.size()


func acilan_dosyalar() -> PackedStringArray:
	return _acilan.duplicate()


static func gecis_kisileri(yol: String = GECIS_YOLU) -> Array:
	if not FileAccess.file_exists(yol):
		return []
	var okunan: Variant = JSON.parse_string(FileAccess.get_file_as_string(yol))
	if okunan is Dictionary and okunan.get("yeni_motor") is Array:
		return (okunan["yeni_motor"] as Array).duplicate()
	return []


## Geçiş tablosundaki kişi için eski sıra yok sayılır. Tabloda olmayan kişi eski sırasından devam eder.
static func sira_etkin(kisi: String, sira: int, tablo: Array) -> int:
	if tablo.has(kisi):
		return -1
	return sira


## Kayıtlı bağlamın satır kimliklerini yeniden oynatır. Metin üretmez.
static func oynat(kayit: Dictionary) -> PackedStringArray:
	var sonuc := PackedStringArray()
	var satirlar: Variant = kayit.get("satirlar", [])
	if satirlar is Array:
		for satir in satirlar:
			sonuc.append(String(satir))
	return sonuc


static func etkiler_ayni(beklenen: Dictionary, gelen: Dictionary) -> bool:
	return beklenen == gelen


func _zar_oku(veri: Dictionary) -> void:
	if veri.has("zar") and (veri["zar"] is int or veri["zar"] is float) and is_finite(float(veri["zar"])):
		zar = int(veri["zar"])
		_zar_kayitli = true
	else:
		_zar_kayitli = false
		zar = -1
