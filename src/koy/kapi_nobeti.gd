## NBT-01: kapıda tek nöbet yuvası. Yuva, devir, görülenler, fırtına, uyku ve boş
## direk tek kayıt sözlüğünde durur. Yuva kimliği köy kaydındaki kişidir; düz ad
## saklanmaz. ANI-02 rotası değişmez; kapı noktası yuvayı buradan tek okumada okur.
class_name KapiNobeti
extends RefCounted

const META := &"kapi_nobeti"
const YUVA_YOK := -1

## Oyun açılışında yuva boştur; oyuncu kendiliğinden nöbetçi yazılmaz.
static func bos_kayit() -> Dictionary:
	return {
		"yuva": YUVA_YOK, "eski_is": -1, "eslik": YUVA_YOK,
		"devir": {"brakan": "", "alan": "", "brakan_id": YUVA_YOK, "alan_id": YUVA_YOK},
		"gorulenler": 0, "gorulen_kimlikler": [], "gorulmedi": [], "oyuncu_gordu": [],
		"firtina": false, "uyku": false, "bos_direk": true, "model": "idle",
		"kenarda": false, "oyuncu_nobet": false, "devir_gece": -1, "sahne": "koy",
		"gelen_sayisi": 0, "tutan_kalmadi": false,
	}

static func _tam(v: Variant, alt: int = -1, ust: int = 1000000000) -> bool:
	return (v is int or v is float) and is_finite(float(v)) and float(v) == floor(float(v)) and float(v) >= alt and float(v) <= ust

## Bozuk, eski ya da gelecek kayıt çökmeden güvenli boş kayda iner.
static func oku(v: Variant) -> Dictionary:
	var d := bos_kayit()
	if not v is Dictionary: return d
	if not v.has("devir"): return d
	if not _tam(v.get("yuva"), -1) or not _tam(v.get("eski_is"), -1): return d
	d.yuva = int(v.yuva)
	d.eski_is = int(v.eski_is)
	if _tam(v.get("eslik"), -1): d.eslik = int(v.eslik)
	if _tam(v.get("gorulenler"), 0): d.gorulenler = int(v.gorulenler)
	if v.get("firtina") is bool: d.firtina = v.firtina
	if v.get("uyku") is bool: d.uyku = v.uyku
	var dev: Variant = v.get("devir")
	if dev is Dictionary and dev.get("brakan") is String and dev.get("alan") is String:
		d.devir = {"brakan": String(dev.brakan), "alan": String(dev.alan), "brakan_id": int(dev.get("brakan_id", YUVA_YOK)), "alan_id": int(dev.get("alan_id", YUVA_YOK))}
	if v.get("gorulen_kimlikler") is Array:
		d.gorulen_kimlikler = v.gorulen_kimlikler.duplicate()
	if v.get("gorulmedi") is Array:
		d.gorulmedi = v.gorulmedi.duplicate(true)
	if v.get("oyuncu_gordu") is Array:
		d.oyuncu_gordu = v.oyuncu_gordu.duplicate()
	if v.get("model") is String:
		d.model = String(v.model)
	if v.get("kenarda") is bool:
		d.kenarda = v.kenarda
	if v.get("oyuncu_nobet") is bool:
		d.oyuncu_nobet = v.oyuncu_nobet
	if _tam(v.get("devir_gece"), -1):
		d.devir_gece = int(v.devir_gece)
	if v.get("sahne") is String:
		d.sahne = String(v.sahne)
	if _tam(v.get("gelen_sayisi"), 0):
		d.gelen_sayisi = int(v.gelen_sayisi)
	if v.get("tutan_kalmadi") is bool:
		d.tutan_kalmadi = v.tutan_kalmadi
	d.bos_direk = d.yuva == YUVA_YOK
	if d.yuva == YUVA_YOK: d.eski_is = -1
	return d

static func durum(y: KoyYonetimi) -> Dictionary:
	return oku(y.get_meta(META, {}))

static func yukle(y: KoyYonetimi, v: Variant) -> void:
	y.set_meta(META, oku(v))

static func _yaz(y: KoyYonetimi, d: Dictionary) -> void:
	y.set_meta(META, d)

## Yuva yalnız köyde yaşayan kişiye yazılır; eş/çocuk yasağı NBT-02'nin işidir.
static func aday(y: KoyYonetimi, id: int) -> bool:
	var k := y.koylu(id)
	return k != null and k.saglik > 0

static func yuva(y: KoyYonetimi) -> int:
	return int(durum(y).yuva)

## Kapıda ikinci yuva yoktur.
static func ikinci_yuva(_y: KoyYonetimi) -> int:
	return 0

static func bos_mu(y: KoyYonetimi) -> bool:
	return yuva(y) == YUVA_YOK

## Direkte görünen ad, yuvaya yazılmış köylünün kayıtlı adının aynısıdır.
static func direk_ad(y: KoyYonetimi) -> String:
	var k := y.koylu(yuva(y))
	return k.ad if k != null else ""

## Nöbetten düşen kişi ölmediyse eski işine döner; iş yeri boş değilse dokunulmaz.
static func _ise_don(y: KoyYonetimi, id: int, eski_is: int) -> void:
	if id == YUVA_YOK or eski_is < 0: return
	var k := y.koylu(id)
	if k != null and k.saglik > 0 and k.is_yeri == KoyYonetimi.BOSTA:
		k.is_yeri = eski_is

## Yuvaya köylü yazılır. Kişi o gece kendi işinde üretim yazmasın diye işinden
## alınır; sabah dönebilmesi için eski iş yeri tek kayıtta saklanır. Ayrı maaş yok.
static func _yasak(k: Koylu) -> bool:
	return k == null or k.yas_grubu == &"cocuk" or k.bayrak_var("acl01_es") or k.usta_mi()


static func yanlis_mi(y: KoyYonetimi, id: int) -> bool:
	var k := y.koylu(id)
	if k == null:
		return true
	if k.sinif != &"asker":
		return true
	return NobetYorgunlugu.aktif(k, y)


static func yaz(y: KoyYonetimi, id: int) -> bool:
	if not aday(y, id) or _yasak(y.koylu(id)): return false
	var d := durum(y)
	if int(d.yuva) == id: return true
	_ise_don(y, int(d.yuva), int(d.eski_is))
	var k := y.koylu(id)
	GeciciIsler.birak(y,k)
	d.eski_is = k.is_yeri
	d.yuva = id
	preload("res://src/koy/bosta_kalma.gd").sifirla(y, id)
	d.bos_direk = false
	if k.is_yeri >= 0: k.is_yeri = KoyYonetimi.BOSTA
	_yaz(y, d)
	return true

## Eşlik eden ikinci kişi ayrı alanda durur; yuvayı tek başına doldurmaz.
static func eslik_isaretle(y: KoyYonetimi, id: int) -> bool:
	if not aday(y, id) or yuva(y) == id: return false
	var d := durum(y)
	GeciciIsler.birak(y,y.koylu(id))
	d.eslik = id
	preload("res://src/koy/bosta_kalma.gd").sifirla(y, id)
	_yaz(y, d)
	return true

## Sabah: ölmediyse eski işine döner; ölen kişinin kimliği yuvada kalamaz, düşer.
static func sabah(y: KoyYonetimi) -> void:
	var d := durum(y)
	var id := int(d.yuva)
	if id != YUVA_YOK:
		var k := y.koylu(id)
		if k == null:
			d.tutan_kalmadi = true
			d.yuva = YUVA_YOK
			d.eski_is = -1
			d.bos_direk = true
		else:
			_ise_don(y, id, int(d.eski_is))
			d.eski_is = -1
	d.eslik = YUVA_YOK
	_yaz(y, d)


static func guvenlik(y: KoyYonetimi) -> int:
	return KervanKorumasi.guvenlik(y)


static func devir_yaz(y: KoyYonetimi) -> Dictionary:
	var d := durum(y)
	var simdi := int(d.yuva)
	if int(d.devir_gece) == y.gun and int(d.devir.get("alan_id", YUVA_YOK)) == simdi:
		return d.devir
	var once := int(d.devir.get("alan_id", YUVA_YOK))
	var alan := ""
	var brakan := ""
	if simdi != YUVA_YOK:
		var k := y.koylu(simdi)
		alan = k.ad if k != null else ""
		if once == YUVA_YOK or once == simdi:
			brakan = alan
		else:
			var b := y.koylu(once)
			brakan = b.ad if b != null else String(d.devir.get("alan", ""))
	d.devir = {"brakan": brakan, "alan": alan, "brakan_id": once if simdi != YUVA_YOK else YUVA_YOK, "alan_id": simdi}
	d.devir_gece = y.gun
	if simdi != YUVA_YOK:
		var kisi := y.koylu(simdi)
		if kisi != null and int(kisi.yorgunluk.get("son_gece", -1)) != y.gun:
			kisi.yorgunluk = {"son_gece": y.gun}
	_yaz(y, d)
	return d.devir


static func _firtina(y: KoyYonetimi, baglam: Dictionary) -> bool:
	if baglam.has("firtina"):
		return bool(baglam.firtina)
	return IklimDeneyi.hava(y) == "kar_firtinasi"


static func _uyku(y: KoyYonetimi, baglam: Dictionary) -> bool:
	if baglam.has("uyku"):
		return bool(baglam.uyku)
	var k := y.koylu(yuva(y))
	return k != null and IsKazalari.uyuyor(k)


static func gece(y: KoyYonetimi, gelenler: Array, baglam: Dictionary = {}) -> Dictionary:
	var d := durum(y)
	var kapi_acik := bool(baglam.get("kapi_acik", true))
	var sahne := String(baglam.get("sahne", d.sahne))
	var firtina := _firtina(y, baglam)
	var uyku := _uyku(y, baglam)
	var ambara := bool(baglam.get("ambara", false))
	var oyuncu := bool(baglam.get("oyuncu_nobet", d.oyuncu_nobet))
	d.gelen_sayisi = gelenler.size()
	d.firtina = firtina and kapi_acik
	d.uyku = uyku and kapi_acik and not oyuncu
	d.model = "uyku" if d.uyku else "idle"
	var gorulen: Array = []
	var gorulmedi: Array = []
	if not kapi_acik:
		d.gorulen_kimlikler = []
		d.gorulmedi = []
		d.gorulenler = 0
		d.firtina = false
		d.uyku = false
		d.model = "idle"
		_yaz(y, d)
		return d
	var yuva_bos := int(d.yuva) == YUVA_YOK or ambara
	if oyuncu:
		yuva_bos = false
	if sahne != "kapi" and yuva_bos and not oyuncu:
		for g in gelenler:
			gorulmedi.append({"id": String(g.get("id", "")), "neden": "bos_direk"})
		d.bos_direk = true
	else:
		var nedenler: Array[String] = []
		if int(d.yuva) != YUVA_YOK and yanlis_mi(y, int(d.yuva)):
			nedenler.append("yanlis")
		if firtina:
			nedenler.append("tipi" if not gelenler.is_empty() else "tipi_bos")
		if uyku:
			nedenler.append("uyudu")
		var sira := 0
		for g in gelenler:
			var gid := String(g.get("id", ""))
			if sira < nedenler.size() and nedenler[sira] != "tipi_bos":
				gorulmedi.append({"id": gid, "neden": nedenler[sira]})
			else:
				gorulen.append(gid)
			sira += 1
		if firtina and gelenler.is_empty():
			d.bos_direk = int(d.yuva) == YUVA_YOK
		elif nedenler.size() > gelenler.size():
			var son := "" if gelenler.is_empty() else String(gelenler[gelenler.size() - 1].get("id", ""))
			for i in range(gelenler.size(), nedenler.size()):
				if nedenler[i] != "tipi_bos":
					gorulmedi.append({"id": son, "neden": nedenler[i]})
	d.gorulen_kimlikler = gorulen
	d.gorulmedi = gorulmedi
	d.gorulenler = gorulen.size()
	_yaz(y, d)
	return d


static func rapor_satirlari(y: KoyYonetimi, kapi_acik: bool = true) -> Array:
	if not kapi_acik:
		return []
	var d := durum(y)
	var ilk := "nobet.rapor.devir"
	if bool(d.tutan_kalmadi):
		ilk = "nobet.rapor.sabaha_kalmadi"
	elif String(d.devir.get("alan", "")).is_empty() and int(d.gelen_sayisi) == 0 and int(d.yuva) == YUVA_YOK:
		ilk = "nobet.rapor.bos"
	var ikinci := "nobet.rapor.sayim"
	if d.firtina and int(d.gelen_sayisi) == 0:
		ikinci = "nobet.rapor.tipi_bos"
	elif d.firtina:
		ikinci = "nobet.rapor.tipi"
	elif d.uyku:
		ikinci = "nobet.rapor.uyudu"
	return [
		{"anahtar": ilk, "brakan_id": int(d.devir.get("brakan_id", YUVA_YOK)), "alan_id": int(d.devir.get("alan_id", YUVA_YOK))},
		{"anahtar": ikinci, "gorulen": int(d.gorulenler), "gorulmedi": d.gorulmedi.size()},
	]


static func kapiya_gir(y: KoyYonetimi) -> Dictionary:
	var d := durum(y)
	d.sahne = "kapi"
	d.kenarda = int(d.yuva) != YUVA_YOK
	if d.kenarda and d.uyku:
		d.uyku = false
		d.model = "idle"
	_yaz(y, d)
	return d


static func koye_don(y: KoyYonetimi) -> int:
	var d := durum(y)
	d.sahne = "koy"
	d.kenarda = false
	_yaz(y, d)
	return int(d.yuva)


static func oyuncu_gordu(y: KoyYonetimi, kisi_id: String) -> void:
	var d := durum(y)
	if kisi_id not in d.oyuncu_gordu:
		d.oyuncu_gordu.append(kisi_id)
	if kisi_id not in d.gorulen_kimlikler:
		d.gorulen_kimlikler.append(kisi_id)
		d.gorulenler = d.gorulen_kimlikler.size()
	_yaz(y, d)


static func replik_soyleyen(_y: KoyYonetimi) -> int:
	return 0


static func sorgu_acilir(y: KoyYonetimi) -> bool:
	return not bool(durum(y).oyuncu_nobet)


static func oyuncu_nobet_yaz(y: KoyYonetimi) -> void:
	var d := durum(y)
	d.oyuncu_nobet = true
	d.bos_direk = false
	_yaz(y, d)