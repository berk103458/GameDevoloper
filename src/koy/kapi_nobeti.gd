## NBT-01: kapıda tek nöbet yuvası. Yuva, devir, görülenler, fırtına, uyku ve boş
## direk tek kayıt sözlüğünde durur. Yuva kimliği köy kaydındaki kişidir; düz ad
## saklanmaz. ANI-02 rotası değişmez; kapı noktası yuvayı buradan tek okumada okur.
class_name KapiNobeti
extends RefCounted

const META := &"kapi_nobeti"
const YUVA_YOK := -1

## Oyun açılışında yuva boştur; oyuncu kendiliğinden nöbetçi yazılmaz.
static func bos_kayit() -> Dictionary:
	return {"yuva": YUVA_YOK, "eski_is": -1, "eslik": YUVA_YOK, "devir": {"brakan": "", "alan": ""}, "gorulenler": 0, "firtina": false, "uyku": false, "bos_direk": true}

static func _tam(v: Variant, alt: int = -1, ust: int = 1000000000) -> bool:
	return (v is int or v is float) and is_finite(float(v)) and float(v) == floor(float(v)) and float(v) >= alt and float(v) <= ust

## Bozuk, eski ya da gelecek kayıt çökmeden güvenli boş kayda iner.
static func oku(v: Variant) -> Dictionary:
	var d := bos_kayit()
	if not v is Dictionary: return d
	if not _tam(v.get("yuva"), -1) or not _tam(v.get("eski_is"), -1): return d
	d.yuva = int(v.yuva)
	d.eski_is = int(v.eski_is)
	if _tam(v.get("eslik"), -1): d.eslik = int(v.eslik)
	if _tam(v.get("gorulenler"), 0): d.gorulenler = int(v.gorulenler)
	if v.get("firtina") is bool: d.firtina = v.firtina
	if v.get("uyku") is bool: d.uyku = v.uyku
	var dev: Variant = v.get("devir")
	if dev is Dictionary and dev.get("brakan") is String and dev.get("alan") is String:
		d.devir = {"brakan": String(dev.brakan), "alan": String(dev.alan)}
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
static func yaz(y: KoyYonetimi, id: int) -> bool:
	if not aday(y, id): return false
	var d := durum(y)
	if int(d.yuva) == id: return true
	_ise_don(y, int(d.yuva), int(d.eski_is))
	var k := y.koylu(id)
	GeciciIsler.birak(y,k)
	d.eski_is = k.is_yeri
	d.yuva = id
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
	_yaz(y, d)
	return true

## Sabah: ölmediyse eski işine döner; ölen kişinin kimliği yuvada kalamaz, düşer.
static func sabah(y: KoyYonetimi) -> void:
	var d := durum(y)
	var id := int(d.yuva)
	if id != YUVA_YOK:
		var k := y.koylu(id)
		if k == null:
			d.yuva = YUVA_YOK
			d.eski_is = -1
			d.bos_direk = true
		else:
			_ise_don(y, id, int(d.eski_is))
			d.eski_is = -1
	d.eslik = YUVA_YOK
	_yaz(y, d)