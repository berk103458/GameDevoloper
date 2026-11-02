## OGR-01: Ilk saat haritasi tek dosyada durur (`data/ogretici/ilk_saat.json`).
## Oyuncunun ilk alti gecede karsilasacagi kavramlarin `gece_min` ve `tetik` bilgisini okur.
## Listede olmayan ipucu cikmaz; gosterilen ipucu ikinci kez uretilmez.
class_name IlkSaat
extends RefCounted

const VERI_YOLU := "res://data/ogretici/ilk_saat.json"
const TEHDIT_YOLU := "res://data/tehdit_takvimi.json"

var _veri: Dictionary = {}
var _kavramlar: Array[Dictionary] = []
var _gorulen: Dictionary = {}


func _init(yol: String = VERI_YOLU) -> void:
	yukle_dosya(yol)


func yukle_dosya(yol: String = VERI_YOLU) -> bool:
	_veri.clear()
	_kavramlar.clear()
	if not FileAccess.file_exists(yol):
		return false
	var metin := FileAccess.get_file_as_string(yol)
	var parsed: Variant = JSON.parse_string(metin)
	if not (parsed is Dictionary):
		return false
	_veri = parsed
	var ham_liste: Variant = _veri.get("kavramlar", [])
	if ham_liste is Array:
		for oge in ham_liste:
			if oge is Dictionary:
				var d: Dictionary = (oge as Dictionary).duplicate(true)
				if d.has("id") and d.has("gece_min") and d.has("tetik"):
					_kavramlar.append(d)
	return not _kavramlar.is_empty()


func sifirla() -> void:
	_gorulen.clear()


func kavram_sayisi() -> int:
	return _kavramlar.size()


func kavramlar() -> Array[Dictionary]:
	return _kavramlar.duplicate(true)


## OGR-06: tehdit_baslangic BUG-18 sabitini (tehdit_takvimi.json) tek yerden okur; iki ayri sayi yoktur.
static func tehdit_baslangic_gunu(ozel_ayar: Dictionary = {}) -> int:
	if not ozel_ayar.is_empty() and ozel_ayar.has("tehdit_baslangic_gunu"):
		return maxi(0, int(ozel_ayar["tehdit_baslangic_gunu"]))
	return maxi(0, int(TehditTakvimi.AYAR.get("tehdit_baslangic_gunu", 14)))


## Verilen kavram kimliginin listede yer alip almadigini ve bu gecede acik olup olmadigini denetler.
func kavram_acik_mi(kavram_id: String, guncel_gece: int) -> bool:
	var temiz := kavram_id.strip_edges()
	for k in _kavramlar:
		if String(k.get("id", "")) == temiz:
			return guncel_gece >= int(k.get("gece_min", 0))
	return false


## Tetik veya kavram kimligiyle ipucu gostermeyi dener.
## Listede olmayan ipucu cikmaz; `gece_min` gelmemisse veya daha once gorulduyse cikmaz.
func tetikle(anahtar: String, guncel_gece: int) -> Dictionary:
	var temiz := anahtar.strip_edges()
	if temiz.is_empty():
		return {"gosterildi": false, "sebep": "bos_anahtar"}
	for k in _kavramlar:
		var id_str := String(k.get("id", ""))
		var tetik_str := String(k.get("tetik", ""))
		if temiz == id_str or temiz == tetik_str:
			if _gorulen.has(id_str):
				return {"gosterildi": false, "sebep": "zaten_goruldu", "id": id_str}
			if guncel_gece < int(k.get("gece_min", 0)):
				return {"gosterildi": false, "sebep": "gece_min_gelmedi", "id": id_str}
			_gorulen[id_str] = true
			return {
				"gosterildi": true,
				"id": id_str,
				"tetik": tetik_str,
				"gece_min": int(k.get("gece_min", 0)),
			}
	return {"gosterildi": false, "sebep": "listede_yok"}


func gorulen_ipuclari() -> Array[String]:
	var sonuc: Array[String] = []
	for k in _gorulen.keys():
		sonuc.append(String(k))
	return sonuc


## OGR-04: Ilk kabul edilen kisi koye girmeden once koy ekrani dugmesi pasiftir.
static func koy_acik(kabul_sayisi: int) -> bool:
	return kabul_sayisi > 0


func kaydet() -> Dictionary:
	return {"gorulen": gorulen_ipuclari()}


func yukle(veri: Dictionary) -> bool:
	_gorulen.clear()
	if veri.get("gorulen") is Array:
		for id in veri["gorulen"]:
			var s := String(id).strip_edges()
			if not s.is_empty():
				_gorulen[s] = true
	return true
