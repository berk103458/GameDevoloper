## OGR-01: Ilk saat haritasi tek dosyada durur (`data/ogretici/ilk_saat.json`).
## Oyuncunun ilk alti gecede karsilasacagi kavramlarin `gece_min` ve `tetik` bilgisini okur.
## Listede olmayan ipucu cikmaz; gosterilen ipucu ikinci kez uretilmez.
class_name IlkSaat
extends RefCounted

const VERI_YOLU := "res://data/ogretici/ilk_saat.json"
const TEHDIT_YOLU := "res://data/tehdit_takvimi.json"
const AZAMI_IPUCU := 20

var _veri: Dictionary = {}
var _kavramlar: Array[Dictionary] = []
var _gorulen: Dictionary = {}
var zar_gosterildi: bool = false


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
	var ust_sinir := mini(AZAMI_IPUCU, maxi(1, int(_veri.get("azami_ipucu", AZAMI_IPUCU))))
	var ham_liste: Variant = _veri.get("kavramlar", [])
	if ham_liste is Array:
		for oge in ham_liste:
			if _kavramlar.size() >= ust_sinir:
				break
			if oge is Dictionary:
				var d: Dictionary = (oge as Dictionary).duplicate(true)
				if d.has("id") and d.has("gece_min") and d.has("tetik"):
					if not (d.get("atla_gecmis", null) is Array):
						d["atla_gecmis"] = []
					_kavramlar.append(d)
	return not _kavramlar.is_empty()


func sifirla() -> void:
	_gorulen.clear()
	zar_gosterildi = false


func kavram_sayisi() -> int:
	return _kavramlar.size()


func kavramlar() -> Array[Dictionary]:
	return _kavramlar.duplicate(true)


## OGR-37: Verilen muhafiz gecmisi icin atlanmayan kavram kimliklerini doner.
func gecmis_icin_ipuclari(gecmis_id: String) -> Array[String]:
	var temiz := gecmis_id.strip_edges()
	var sonuc: Array[String] = []
	for k in _kavramlar:
		var atla: Variant = k.get("atla_gecmis", [])
		var atlanir := false
		if not temiz.is_empty() and atla is Array:
			for g in atla:
				if String(g) == temiz:
					atlanir = true
					break
		if not atlanir:
			sonuc.append(String(k.get("id", "")))
	return sonuc


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
func tetikle(anahtar: String, guncel_gece: int, gecmis_id: String = "") -> Dictionary:
	var temiz := anahtar.strip_edges()
	if temiz.is_empty():
		return {"gosterildi": false, "sebep": "bos_anahtar"}
	var temiz_gecmis := gecmis_id.strip_edges()
	for k in _kavramlar:
		var id_str := String(k.get("id", ""))
		var tetik_str := String(k.get("tetik", ""))
		if temiz == id_str or temiz == tetik_str:
			if not temiz_gecmis.is_empty():
				var atla: Variant = k.get("atla_gecmis", [])
				if atla is Array:
					for g in atla:
						if String(g) == temiz_gecmis:
							return {"gosterildi": false, "sebep": "gecmis_atlandi", "id": id_str}
			if _gorulen.has(id_str):
				return {"gosterildi": false, "sebep": "zaten_goruldu", "id": id_str}
			if guncel_gece < int(k.get("gece_min", 0)):
				return {"gosterildi": false, "sebep": "gece_min_gelmedi", "id": id_str}
			_gorulen[id_str] = true
			if id_str == "zar":
				zar_gosterildi = true
			return {
				"gosterildi": true,
				"id": id_str,
				"tetik": tetik_str,
				"gece_min": int(k.get("gece_min", 0)),
			}
	return {"gosterildi": false, "sebep": "listede_yok"}


## OGR-03: Ikinci gece (gece >= 1) ilk zar atisinda ipucu bir kez doner ve `zar_gosterildi = true` yazilir.
func zar_ipucu_kontrol(guncel_gece: int) -> Dictionary:
	if guncel_gece < 1 or zar_gosterildi:
		return {"ipucu_sayisi": 0, "metin": "", "zar_gosterildi": zar_gosterildi}
	var sonuc := tetikle("ilk_zar_atisi", guncel_gece)
	if not bool(sonuc.get("gosterildi", false)):
		return {"ipucu_sayisi": 0, "metin": "", "zar_gosterildi": zar_gosterildi}
	zar_gosterildi = true
	return {
		"ipucu_sayisi": 1,
		"metin": "gerekli = değer + 1 + tansiyon eki",
		"zar_gosterildi": true,
	}


## OGR-21: Ilk insa denemesinde kaynak yetmezse kaynagin nereden geldigini (tas yatagi, oduncu) bir kez soyler.
## Yeterli kaynakla 0 doner; yetersiz kaynakla ilk denemede 1, sonraki denemelerde 0 doner.
func insa_kaynak_uyarisi(kaynak_yeterli: bool, eksik_kaynak: String = "tas") -> Dictionary:
	if kaynak_yeterli or _gorulen.has("insa_kaynak_uyarisi"):
		return {"ipucu_sayisi": 0, "metin": ""}
	_gorulen["insa_kaynak_uyarisi"] = true
	var norm := eksik_kaynak.strip_edges().to_lower()
	var kaynak_yeri := "taş yatağı ve oduncu"
	if norm == "tas":
		kaynak_yeri = "taş yatağı"
	elif norm == "odun":
		kaynak_yeri = "oduncu"
	return {
		"ipucu_sayisi": 1,
		"metin": "Kaynak yetmiyor; %s üzerinden temin edilir." % kaynak_yeri,
		"kaynak_yeri": kaynak_yeri,
	}


func gorulen_ipuclari() -> Array[String]:
	var sonuc: Array[String] = []
	for k in _gorulen.keys():
		sonuc.append(String(k))
	return sonuc


## OGR-04: Ilk kabul edilen kisi koye girmeden once koy ekrani dugmesi pasiftir.
static func koy_acik(kabul_sayisi: int) -> bool:
	return kabul_sayisi > 0


func kaydet() -> Dictionary:
	return {
		"gorulen": gorulen_ipuclari(),
		"zar_gosterildi": zar_gosterildi,
	}


func yukle(veri: Dictionary) -> bool:
	_gorulen.clear()
	zar_gosterildi = bool(veri.get("zar_gosterildi", false))
	var ham_gorulen: Variant = veri.get("gorulen", [])
	if ham_gorulen is Array:
		for g in ham_gorulen:
			var s := String(g).strip_edges()
			if not s.is_empty():
				_gorulen[s] = true
	return true
