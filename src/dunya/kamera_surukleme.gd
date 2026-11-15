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
	sahne_ayarlari_yukle()
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

# --- SAH-41..SAH-48: Kamera sinirlari, yukseklik/uzaklik ve guvenlik yardimcilari ---

const SAHNE_AYAR_YOLU := "res://data/ayarlar/sahne.json"

static var _uzaklik_sinirlar := Vector2(14.0, 80.0)
static var _ayarlar_yuklendi := false

static func sahne_ayarlari_yukle(ayar_yolu: String = SAHNE_AYAR_YOLU) -> void:
	if FileAccess.file_exists(ayar_yolu):
		var veri: Variant = JSON.parse_string(FileAccess.get_file_as_string(ayar_yolu))
		if veri is Dictionary:
			var ky: Dictionary = {}
			if veri.has("kamera_uzaklik") and veri["kamera_uzaklik"] is Dictionary:
				ky = veri["kamera_uzaklik"]
			elif veri.has("kamera_yukseklik") and veri["kamera_yukseklik"] is Dictionary:
				ky = veri["kamera_yukseklik"]
			if not ky.is_empty():
				_uzaklik_sinirlar = Vector2(float(ky.get("min", 14.0)), float(ky.get("max", 80.0)))
				_ayarlar_yuklendi = true

static func uzaklik_sinirlari_al(ayar_yolu: String = SAHNE_AYAR_YOLU) -> Vector2:
	if not _ayarlar_yuklendi or ayar_yolu != SAHNE_AYAR_YOLU:
		sahne_ayarlari_yukle(ayar_yolu)
	return _uzaklik_sinirlar

static func yukseklik_sinirlari_al(ayar_yolu: String = SAHNE_AYAR_YOLU) -> Vector2:
	return uzaklik_sinirlari_al(ayar_yolu)


## SAH-42: Kamera uzaklığı sahne.json alt ve üst sınırları arasında tutulur.
static func uzaklik_sinirla(u: float, min_u: float = -1.0, max_u: float = -1.0) -> float:
	if min_u < 0.0 or max_u < 0.0:
		var s := uzaklik_sinirlari_al()
		return clampf(u, s.x, s.y)
	return clampf(u, min_u, max_u)

static func yukseklik_sinirla(y: float, min_y: float = -1.0, max_y: float = -1.0) -> float:
	return uzaklik_sinirla(y, min_y, max_y)


## SAH-45: En yakin yukseklikte kamera modele girmez.
static func model_mesafesi_guvenli_mi(kamera_pos: Vector3, model_pos: Vector3, min_mesafe: float = 1.2) -> bool:
	return kamera_pos.distance_to(model_pos) >= min_mesafe


## SAH-46: Kapi kamerasi FOV'u koy kamerasindan bagimsizdir.
static func kapi_fov_koru(kapi_kamera: Camera3D, varsayilan_fov: float = 32.0) -> float:
	if kapi_kamera != null:
		return kapi_kamera.fov
	return varsayilan_fov


## SAH-47: Kamera sarsintisi yalniz kapi olayindadir. Kare kare ornek konumlardan
## sarsinti suresini olcer: ilk ornekten `esik`'ten fazla sapan her kare `dt` sayilir.
## Koyde (girdi yokken) bu sure 0'dir; kapi kavgasinda (CAT-02) sifirdan buyuktur.
static func sarsinti_suresi(ornekler: Array, dt: float, esik: float = 0.001) -> float:
	if ornekler.size() < 2:
		return 0.0
	var sure := 0.0
	for i in range(1, ornekler.size()):
		if (ornekler[i] - ornekler[0]).length() > esik:
			sure += dt
	return sure


## SAH-47: Koy kamerasinin ornekleri verilirse olculen sarsinti suresi; ornek yoksa 0.
static func koyde_sarsinti_suresi(ornekler: Array = [], dt: float = 0.0) -> float:
	return sarsinti_suresi(ornekler, dt)



## SAH-48: Kamera ayarlari kayit dosyasina yazilmaz.
static func kayit_kamera_alani_icermez(kayit: Dictionary) -> bool:
	return not kayit.has("kamera_uzaklik") and not kayit.has("kamera_yukseklik") and not kayit.has("kamera_hedef")

