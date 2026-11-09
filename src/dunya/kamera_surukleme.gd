## BUG-24: mevcut köy kamerasını zemindeki son iki imleç noktasıyla kaydırır.
## Hız boyutsuz denge çarpanıdır; piksel ölçeği kamera projeksiyonundan gelir.
class_name KameraSurukleme
extends Node

const DENGE_YOLU := "res://data/ayarlar/denge.json"

var sahne: KoyYonetimSahnesi
var ekran: Control
var hiz := 0.0
var _surukleniyor := false
var _son := Vector2.ZERO


## Yalnız köyün mevcut SubViewportContainer yüzeyine bağlanır, kapıda kurulmaz.
static func kur(s: KoyYonetimSahnesi) -> void:
	var kap := s.get_viewport().get_parent() as SubViewportContainer
	if kap == null:
		return
	var e := kap.get_parent() as Control
	if e == null or e.get("sahne3b") != s or s.get_node_or_null("kamera_surukleme") != null:
		return
	var n := KameraSurukleme.new()
	n.name = "kamera_surukleme"
	n.sahne = s
	n.ekran = e
	s.add_child(n)


func _ready() -> void:
	# Duraklama sırasında yalnız iptal kontrolü sürer; kamera oynatılmaz.
	process_mode = Node.PROCESS_MODE_ALWAYS
	denge_yukle()
	ekran._kap.gui_input.connect(_girdi)
	ekran._kap.mouse_exited.connect(_birak)
	get_tree().root.focus_exited.connect(_birak)


func denge_yukle(yol: String = DENGE_YOLU) -> void:
	hiz = 0.0
	var veri: Variant = JSON.parse_string(FileAccess.get_file_as_string(yol))
	if veri is Dictionary and veri.get("kamera_surukleme") is Dictionary:
		var deger: Variant = veri.kamera_surukleme.get("hiz")
		if (deger is float or deger is int) and is_finite(float(deger)) and deger > 0:
			hiz = float(deger)
	if hiz <= 0:
		push_error("Kamera sürükleme hızı denge dosyasında geçersiz: " + yol)


func _process(_delta: float) -> void:
	# Panelde/pencere dışında yutulan bırakma olayını da temizle. Atalet yoktur.
	if _surukleniyor and (not Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE) or not _etkin()):
		_birak()


func _etkin() -> bool:
	return is_instance_valid(ekran) and ekran.is_visible_in_tree() and sahne.can_process() and not get_tree().paused


func _girdi(olay: InputEvent) -> void:
	if olay is InputEventMouseButton and olay.button_index == MOUSE_BUTTON_MIDDLE and not olay.pressed:
		_birak()
		return
	if not (olay is InputEventMouseButton or olay is InputEventMouseMotion):
		return
	# GUI yakalaması sürerken imleç panelin üstüne geçebilir; hover ayrıca denetlenir.
	var ust := ekran.get_viewport().gui_get_hovered_control()
	if not _etkin() or ust != ekran._kap or not Rect2(Vector2.ZERO, ekran._kap.size).has_point(olay.position):
		_birak()
		return
	if olay is InputEventMouseButton:
		if olay.button_index == MOUSE_BUTTON_MIDDLE and olay.pressed:
			_surukleniyor = true
			_son = ekran._vp_konum(olay.position)
			var takip := sahne.get_node_or_null("koylu_takibi") as KoyluTakibi
			if takip != null:
				takip.takip = false
			_kaydir(Vector3.ZERO)
		return
	if not _surukleniyor:
		return
	if not (olay.button_mask & MOUSE_BUTTON_MASK_MIDDLE):
		_birak()
		return
	var simdi: Vector2 = ekran._vp_konum(olay.position)
	var zemin := Plane(Vector3.UP)
	var once: Variant = zemin.intersects_ray(sahne.kamera.project_ray_origin(_son), sahne.kamera.project_ray_normal(_son))
	var sonra: Variant = zemin.intersects_ray(sahne.kamera.project_ray_origin(simdi), sahne.kamera.project_ray_normal(simdi))
	_son = simdi
	if once == null or sonra == null:
		return
	var fark: Vector3 = (once - sonra) * hiz
	if bool(ekran.ayarlar.al(&"kamera_eksen_ters")):
		fark = -fark
	_kaydir(fark)


func _kaydir(fark: Vector3) -> void:
	# Kamera odağını gerçek ızgara sınırına, atama ve yerleştirmeden önce kırp.
	var alt := sahne.hucre_kosesi(Vector2i.ZERO)
	var ust_sinir := sahne.hucre_kosesi(sahne.yonetim.a.izgara_boyut)
	var hedef := sahne.hedef + fark
	hedef.x = clampf(hedef.x, alt.x, ust_sinir.x)
	hedef.z = clampf(hedef.z, alt.z, ust_sinir.z)
	sahne.hedef = hedef
	sahne._kamera_yerlestir()


func _birak() -> void:
	_surukleniyor = false


func _exit_tree() -> void:
	_birak()
	if is_instance_valid(ekran) and is_instance_valid(ekran._kap):
		ekran._kap.gui_input.disconnect(_girdi)
		ekran._kap.mouse_exited.disconnect(_birak)
	get_tree().root.focus_exited.disconnect(_birak)

# --- SAH-41..SAH-48: Kamera sinirlari, yukseklik ve guvenlik yardimcilari ---

const SAHNE_AYAR_YOLU := "res://data/ayarlar/sahne.json"

static func yukseklik_sinirlari_al(ayar_yolu: String = SAHNE_AYAR_YOLU) -> Vector2:
	if FileAccess.file_exists(ayar_yolu):
		var veri: Variant = JSON.parse_string(FileAccess.get_file_as_string(ayar_yolu))
		if veri is Dictionary and veri.has("kamera_yukseklik") and veri["kamera_yukseklik"] is Dictionary:
			var ky: Dictionary = veri["kamera_yukseklik"]
			return Vector2(float(ky.get("min", 14.0)), float(ky.get("max", 80.0)))
	return Vector2(14.0, 80.0)


## SAH-42: Kamera yuksekligi sahne.json alt ve ust sinirlari arasinda tutulur.
static func yukseklik_sinirla(y: float, min_y: float = -1.0, max_y: float = -1.0) -> float:
	if min_y < 0.0 or max_y < 0.0:
		var s := yukseklik_sinirlari_al()
		return clampf(y, s.x, s.y)
	return clampf(y, min_y, max_y)


## SAH-45: En yakin yukseklikte kamera modele girmez.
static func model_mesafesi_guvenli_mi(kamera_pos: Vector3, model_pos: Vector3, min_mesafe: float = 1.2) -> bool:
	return kamera_pos.distance_to(model_pos) >= min_mesafe


## SAH-46: Kapi kamerasi FOV'u koy kamerasindan bagimsizdir.
static func kapi_fov_koru(kapi_kamera: Camera3D, varsayilan_fov: float = 32.0) -> float:
	if kapi_kamera != null:
		return kapi_kamera.fov
	return varsayilan_fov


## SAH-47: Kamera sarsintisi yalniz kapi olayindadir; koyde sarsinti suresi 0'dir.
static func koyde_sarsinti_suresi() -> float:
	return 0.0


## SAH-48: Kamera ayarlari kayit dosyasina yazilmaz.
static func kayit_kamera_alani_icermez(kayit: Dictionary) -> bool:
	return not kayit.has("kamera_yukseklik") and not kayit.has("kamera_hedef")

