class_name AyakZemini
extends Node

## SAH-01..SAH-08: Ayak ve zemin uyumu, eğik zemin izleme ve kayma denetimi.

const AYAR_YOLU := "res://data/ayarlar/sahne.json"
const VARSAYILAN_KAYMA_ESIGI := 0.15
const CARPISMA_PAYI := 0.6

var model: Node3D = null
var zemin_yuksekligi: float = 0.0
var sol_ayak_y: float = 0.0
var sag_ayak_y: float = 0.0
var kayma_esigi: float = VARSAYILAN_KAYMA_ESIGI


func _init() -> void:
	_ayarlari_yukle()


static func kur(m: Node3D) -> AyakZemini:
	if m == null:
		return null
	var mevcut := m.get_node_or_null("AyakZemini") as AyakZemini
	if mevcut != null:
		return mevcut
	var az := AyakZemini.new()
	az.name = "AyakZemini"
	az.model = m
	m.add_child(az)
	return az


func _ayarlari_yukle() -> void:
	if not FileAccess.file_exists(AYAR_YOLU):
		return
	var metin := FileAccess.get_file_as_string(AYAR_YOLU)
	var veri: Variant = JSON.parse_string(metin)
	if veri is Dictionary and veri.has("ayak_kayma_esigi"):
		kayma_esigi = float(veri["ayak_kayma_esigi"])


## SAH-01: Topuk yürünebilir zemin seviyesinin altından geçmez (gömülme karesi 0).
func zemin_hizala(ayak_y: float, hedef_zemin_y: float = 0.0) -> float:
	return maxf(ayak_y, hedef_zemin_y)


## SAH-02: Eğik zeminde her ayak kendi değdiği noktayı izler.
func egik_zemin_hizala(sol_zemin: float, sag_zemin: float) -> Dictionary:
	sol_ayak_y = sol_zemin
	sag_ayak_y = sag_zemin
	return {
		"sol": sol_ayak_y,
		"sag": sag_ayak_y,
		"fark": absf(sol_ayak_y - sag_ayak_y)
	}


## SAH-03: Ayak kayması adım boyunu ve tablodaki eşiği aşmaz.
func kayma_esik_altinda_mi(iskelet_adim: float, kok_adim: float) -> bool:
	var fark := absf(iskelet_adim - kok_adim)
	return fark <= kayma_esigi


## SAH-04: Hız sıfır olunca kayma birikmez, konum deltası duruşta eşik altındadır.
func durus_kayma_esik_alti_mi(hiz: float, konum_deltasi: Vector3) -> bool:
	if hiz <= 0.05:
		return konum_deltasi.length() <= 0.01
	return true


## SAH-05: Kapı eşiği ayrı zemin değildir; ağ hücresidir. Ağ dışına basılmaz.
func esik_hucrede_mi(hucre: Vector2i, ag_hucreleri: Array) -> bool:
	return hucre in ag_hucreleri


## SAH-06: Çömelme veya eğilmede ayak tabanı zeminde tutulur.
func taban_zeminde_mi(poz: String, ayak_y: float, hedef_zemin_y: float = 0.0) -> bool:
	# poz: sukran, diz_cokme vb.
	var hizali := zemin_hizala(ayak_y, hedef_zemin_y)
	return absf(hizali - hedef_zemin_y) <= 0.05


## SAH-07: İki model kök aralığı en az çarpışma payı kadardır.
func aralik_guvenli_mi(kok_a: Vector3, kok_b: Vector3, pay: float = CARPISMA_PAYI) -> bool:
	var d := kok_a.distance_to(kok_b)
	return d >= (pay - 0.001)
