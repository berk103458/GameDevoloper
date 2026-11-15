## DIY-14 notunu bir ekrana bir kez baglar.
## Koy ekraninda bilesen yoksa ayni HatirlanmaNotu sinifindan ornek acar.
## Kapı ekraninin yerlestirmesini kopyalamaz; konum ve katman yalniz buradadir.
class_name HatirlanmaNotuBaglantisi
extends RefCounted

const NOT := preload("res://src/arayuz/kapi/hatirlanma_notu.gd")
const DUGUM_ADI := &"HatirlanmaNotu"
const AYAR := &"hatirlanma_notu"
const KONUM := Vector2(360, 28)
const KATMAN := 40


## Ekranda tek not tutar. Ebeveyn Container degil, serbest Control ekranidir.
static func ornek(ekran: Node) -> HatirlanmaNotu:
	if ekran == null:
		return null
	var mevcut := ekran.get_node_or_null(NodePath(String(DUGUM_ADI))) as HatirlanmaNotu
	if mevcut != null and is_instance_valid(mevcut):
		return mevcut
	var yeni := NOT.new() as HatirlanmaNotu
	yeni.name = DUGUM_ADI
	yeni.z_index = KATMAN
	yeni.position = KONUM
	ekran.add_child(yeni)
	return yeni


## Secimi DIY-14 kuralina bildirir. Ayar her cagrida okunur; kapaliysa not gizlenir.
static func bildir(ekran: Node, olay: Dictionary, kayit_islemi: Callable = Callable()) -> Dictionary:
	var notu := ornek(ekran)
	if notu == null:
		return {"kayit_yazildi": false, "not_gorundu": false, "not_sayisi": 0, "metin": ""}
	_ayar_uygula(notu, ekran)
	var sonuc := notu.secim_bildir(olay, kayit_islemi)
	notu.set_meta(&"son_sonuc", sonuc)
	return sonuc


static func _ayar_uygula(notu: HatirlanmaNotu, ekran: Node) -> void:
	var ayarlar: Variant = ekran.get("ayarlar")
	if ayarlar == null:
		return
	var degerler: Variant = ayarlar.get("degerler")
	if degerler is Dictionary:
		notu.bildirim_acik = bool((degerler as Dictionary).get(AYAR, true))
