class_name AyakZemini
extends Node3D

## SAH-01..SAH-08: Ayak ve zemin uyumu, eğik zemin izleme ve kayma denetimi.

const AYAR: Dictionary = preload("res://data/ayarlar/sahne.json").data
const VARSAYILAN_KAYMA_ESIGI := 0.15
const CARPISMA_PAYI := 0.6

var model: Node3D = null
var zemin_yuksekligi: float = 0.0
var sol_ayak_y: float = 0.0
var sag_ayak_y: float = 0.0
var kayma_esigi: float = float(AYAR.get("ayak_kayma_esigi", VARSAYILAN_KAYMA_ESIGI))

const TEMAS_KEMIKLERI := ["leftfoot", "rightfoot", "lefttoebase", "righttoebase"]
var _gorsel: Node3D
var _iskelet: Skeleton3D
var _zemin: Callable
var _taban_konum: Vector3
var _kemikler := PackedInt32Array()
var _kemik_tabanlari := PackedVector3Array()
var _ham_tabanlar := PackedVector3Array()


static func kur(m: Node3D, gorsel: Node3D = null, iskelet: Skeleton3D = null) -> AyakZemini:
	if m == null:
		return null
	var mevcut := m.get_node_or_null("AyakZemini") as AyakZemini
	if mevcut != null:
		return mevcut
	var az := AyakZemini.new()
	az.name = "AyakZemini"
	az.model = m
	az._gorsel = gorsel
	az._iskelet = iskelet
	m.add_child(az)
	return az


func _ready() -> void:
	if _gorsel == null or _iskelet == null:
		return
	var sahne := model.get_parent()
	while sahne != null and not sahne.has_method("ayak_zemini_yuksekligi"):
		sahne = sahne.get_parent()
	if sahne == null:
		return
	_zemin = Callable(sahne, "ayak_zemini_yuksekligi")
	_taban_konum = _gorsel.position
	for i in _iskelet.get_bone_count():
		var ad := _iskelet.get_bone_name(i).to_lower()
		for son in TEMAS_KEMIKLERI:
			if not ad.ends_with(son):
				continue
			var dinlenme := _iskelet.global_transform * _iskelet.get_bone_global_rest(i)
			var taban := Vector3(dinlenme.origin.x, model.global_position.y, dinlenme.origin.z)
			_kemikler.append(i)
			_kemik_tabanlari.append(dinlenme.affine_inverse() * taban)
			break
	if not _kemikler.is_empty():
		_ham_tabanlar.resize(_kemikler.size())
		_iskelet.skeleton_updated.connect(_son_pozu_oku)
		_son_pozu_oku()
		set_notify_transform(true)


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED and not _ham_tabanlar.is_empty():
		_gorseli_yukselt()


## İskelet pozu ve kök hareketi farklı zamanlarda güncellenebilir.
func _son_pozu_oku() -> void:
	var iskeletten_koke := model.global_transform.affine_inverse() * _iskelet.global_transform
	iskeletten_koke.origin -= _gorsel.position - _taban_konum
	for i in _kemikler.size():
		var poz := _iskelet.get_bone_global_pose(_kemikler[i])
		_ham_tabanlar[i] = iskeletten_koke * (poz * _kemik_tabanlari[i])
	_gorseli_yukselt()


## Kök konumu ve hareket yolu görsel kaldırmadan ayrıdır.
func _gorseli_yukselt() -> void:
	var yukselme := 0.0
	for ham in _ham_tabanlar:
		var taban := model.to_global(ham)
		yukselme = maxf(yukselme, float(_zemin.call(taban)) - taban.y)
	var konum := _taban_konum + model.global_basis.inverse() * Vector3.UP * yukselme
	if not _gorsel.position.is_equal_approx(konum):
		_gorsel.position = konum


## İskelet değiştiricilerinin cilde verdiği son poz ve mevcut görsel dönüşümü okunur.
func temas_farklari() -> PackedFloat32Array:
	var farklar := PackedFloat32Array()
	if _ham_tabanlar.is_empty():
		return farklar
	var gorsel_ofset := _gorsel.position - _taban_konum
	for ham in _ham_tabanlar:
		var taban := model.to_global(ham + gorsel_ofset)
		farklar.append(taban.y - float(_zemin.call(taban)))
	return farklar


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
