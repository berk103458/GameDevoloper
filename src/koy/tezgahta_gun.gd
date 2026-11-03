## TEZ-01: dört tezgâhın yeri. Ağıl, değirmen, demirhane ve bez tezgâhı ayrı iş
## yerleridir; yer kaydı düğüm kimliğidir, düz ad yazılmaz. Düğümü olmayan ya da
## ızgara hücresinin dışındaki yer iş almaz. ANI-08 düğüm hareketi tek okumadan
## gelir; yeni sahne, yeni meslek ve YAP kademesi açılmaz.
class_name TezgahtaGun
extends RefCounted

## Sabit sıra; yer kimliği → karşılık gelen yapı türü (dördüncü yer bez tezgâhı).
const YERLER := {"agil": "agil", "degirmen": "degirmen", "demirhane": "demirhane", "bez": "bez_evi"}
const SIRA: Array[String] = ["agil", "degirmen", "demirhane", "bez"]
const YOK := Vector2i(-1, -1)

static func yer_mi(yer: String) -> bool:
	return SIRA.has(yer)

## Yerin ANI-08 düğümü: hazır yapının ızgara hücresi. Düğüm yoksa (-1, -1).
static func dugum(y: KoyYonetimi, yer: String) -> Vector2i:
	if not yer_mi(yer): return YOK
	var tur: String = YERLER[yer]
	for b in y.binalar:
		if b.tur == tur and b.hazir(): return b.hucre
	return YOK

static func dugum_var_mi(y: KoyYonetimi, yer: String) -> bool:
	return dugum(y, yer).x >= 0

## Açık iş: düğümü olan ve hücresi ızgara içinde olan yer 1; düğümü olmayan ya da
## ızgara hücresinin dışındaki yer 0.
static func acik_is(y: KoyYonetimi, yer: String) -> int:
	if not dugum_var_mi(y, yer): return 0
	return 1 if y.izgara.icinde(dugum(y, yer)) else 0

static func acik_isler(y: KoyYonetimi) -> Dictionary:
	var d := {}
	for yer in SIRA: d[yer] = acik_is(y, yer)
	return d

## ANI-08 düğüm hareketi: yapı türü → dov/pisir; yoksa boş. Tek okuma, yazma yok.
static func ani08_hareket(tur: String) -> String:
	return String(ZanaatTezgahi.AYAR.turler.get(tur, ""))

## MEV-01 mevsimi; dört yer sabittir, kış için beşinci yer açılmaz.
static func mevsim(y: KoyYonetimi) -> int:
	return y.mevsim()


const META := &"tezgahta_is"
const HAL := ["", "ham", "iz", "bicim", "agiz", "tam"]


static func _bos_is() -> Dictionary:
	return {
		"yer": "", "yuz": "", "yuz_tur": "", "koyde": true, "acik": false,
		"gun": 0, "hal": "", "titreme": 0, "stok_dusum": 0, "boya_dusum": 0,
		"boyasiz": false, "teslim": 0, "cumle": "", "ev_parca": 0, "ucret": 0,
		"son_sabah": -1, "hata": 0, "faz_acik": true, "rutbe_delta": 0,
		"un_delta": 0, "kademe_delta": 0,
	}


static func yuz_ayar() -> Dictionary:
	var veri = JSON.parse_string(FileAccess.get_file_as_string("res://data/tez/siparis_yuzu.json"))
	return veri if veri is Dictionary else {}


static func isler(y: KoyYonetimi) -> Dictionary:
	var ham: Variant = y.get_meta(META, {})
	return ham.duplicate(true) if ham is Dictionary else {}


static func _kaydet(y: KoyYonetimi, d: Dictionary) -> void:
	y.set_meta(META, d)


static func _sab_kapali(y: KoyYonetimi, bina_id: int) -> bool:
	if not y.has_meta(&"sabah_defteri"):
		return false
	var d: Variant = y.get_meta(&"sabah_defteri")
	return d is Dictionary and int(d.get("kapali", -1)) == bina_id and bina_id >= 0


static func yuz_bagla(y: KoyYonetimi, yer: String, yuz: String, tur: String, koyde: bool) -> int:
	if not yer_mi(yer) or not dugum_var_mi(y, yer):
		return 1
	if yuz.is_empty() or not koyde or tur not in ["hane", "usta", "tuccar"]:
		var d := isler(y)
		d["yuzsuz"] = _bos_is()
		d["yuzsuz"]["hata"] = 1
		_kaydet(y, d)
		return 1
	var d := isler(y)
	for anahtar in d:
		var eski: Dictionary = d[anahtar]
		if String(eski.get("yuz", "")) == yuz and bool(eski.get("acik", false)):
			eski["hata"] = int(eski.get("hata", 0)) + 1
			d[anahtar] = eski
			_kaydet(y, d)
			return int(eski.hata)
	var is_kaydi := _bos_is()
	is_kaydi.yer = yer
	is_kaydi.yuz = yuz
	is_kaydi.yuz_tur = tur
	is_kaydi.koyde = true
	is_kaydi.acik = true
	d[yer] = is_kaydi
	_kaydet(y, d)
	return 0


static func stok_okur(stok: int, dusum: int) -> int:
	return maxi(0, stok - dusum)


static func sabah(y: KoyYonetimi, yer: String, baglam: Dictionary) -> Dictionary:
	var d := isler(y)
	if not d.has(yer):
		return _bos_is()
	var is_kaydi: Dictionary = d[yer]
	if int(is_kaydi.get("son_sabah", -1)) == y.gun:
		return is_kaydi
	var usta := int(baglam.get("usta", -1))
	var cirak := int(baglam.get("cirak", -1))
	var bina := int(baglam.get("bina", -1))
	var kapali := _sab_kapali(y, bina) or bool(baglam.get("kapali", false))
	var usta_var := usta >= 0 and y.koylu(usta) != null and y.koylu(usta).saglik > 0 and not kapali
	if usta_var and (KapiNobeti.yuva(y) == usta or DivanHukmu.zindanda(y.koylu(usta)) or int(y.koylu(usta).yorgunluk.get("miktar", 0)) >= 2):
		usta_var = false
	var cirak_var := cirak >= 0 and y.koylu(cirak) != null
	if not usta_var:
		if cirak_var and not kapali:
			is_kaydi.titreme = int(is_kaydi.titreme) + 1
		is_kaydi.son_sabah = y.gun
		is_kaydi.rutbe_delta = 0
		d[yer] = is_kaydi
		_kaydet(y, d)
		return is_kaydi
	var gun := int(is_kaydi.gun)
	var stok := int(baglam.get("stok", 0))
	if gun == 0:
		if stok < 1:
			is_kaydi.son_sabah = y.gun
			d[yer] = is_kaydi
			_kaydet(y, d)
			return is_kaydi
		is_kaydi.gun = 1
		is_kaydi.hal = "ham"
		is_kaydi.stok_dusum = int(is_kaydi.stok_dusum) + 1
	elif gun == 1:
		is_kaydi.gun = 2
		is_kaydi.hal = "iz"
	elif gun == 2:
		var uyar := bool(baglam.get("uyar", true))
		var alet := int(baglam.get("alet", 1))
		if not uyar or alet < 1:
			is_kaydi.titreme = int(is_kaydi.titreme) + 1
		else:
			is_kaydi.gun = 3
			is_kaydi.hal = "bicim"
	elif gun == 3:
		is_kaydi.gun = 4
		is_kaydi.hal = "agiz"
		if bool(baglam.get("boya_ister", false)):
			if int(baglam.get("boya", 0)) > 0:
				is_kaydi.boya_dusum = int(is_kaydi.boya_dusum) + 1
			else:
				is_kaydi.boyasiz = true
	elif gun == 4 and int(is_kaydi.teslim) == 0:
		var ucret := int(baglam.get("ucret", -1))
		var koyde := bool(baglam.get("koyde", is_kaydi.koyde))
		var anahtarlar: Dictionary = {} if bool(baglam.get("cumle_yok", false)) else yuz_ayar().get("cumle", {})
		var hangi := "tam" if int(is_kaydi.titreme) == 0 else "egri"
		var anahtar := String(anahtarlar.get(hangi, ""))
		if not koyde or ucret < 0 or anahtar.is_empty():
			is_kaydi.faz_acik = true
		else:
			is_kaydi.gun = 5
			is_kaydi.hal = "tam"
			is_kaydi.teslim = 1
			is_kaydi.ev_parca = 1
			is_kaydi.ucret = ucret
			is_kaydi.cumle = anahtar
			is_kaydi.acik = false
			is_kaydi.faz_acik = true
	is_kaydi.son_sabah = y.gun
	is_kaydi.rutbe_delta = 0
	is_kaydi.un_delta = 0
	is_kaydi.kademe_delta = 0
	d[yer] = is_kaydi
	_kaydet(y, d)
	return is_kaydi


static func sayim(y: KoyYonetimi, yer: String) -> Dictionary:
	var is_kaydi: Dictionary = isler(y).get(yer, _bos_is())
	return {
		"gun": int(is_kaydi.get("gun", 0)),
		"titreme": int(is_kaydi.get("titreme", 0)),
		"teslim": int(is_kaydi.get("teslim", 0)),
		"cumle": String(is_kaydi.get("cumle", "")),
		"rutbe_delta": 0,
		"un_delta": 0,
		"kademe_delta": 0,
		"stok_dusum": int(is_kaydi.get("stok_dusum", 0)),
		"boya_dusum": int(is_kaydi.get("boya_dusum", 0)),
	}