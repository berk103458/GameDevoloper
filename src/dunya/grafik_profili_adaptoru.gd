## Canlı grafik ayarları: yalnız 3B ölçek ve dekoratif efektler.
class_name GrafikProfiliAdaptoru
extends Node

const EFEKT := &"grafik_efekti"
const GOLGE := &"grafik_asli_golge"
const ASIL_MSAA := &"grafik_asli_msaa"
var ayarlar: Ayarlar
var hedef: Node

func _ready() -> void:
	ayarlar.degisti.connect(_degisti)
	get_tree().node_added.connect(_eklendi)
	_bellek()
	uygula()

func _degisti(anahtar: StringName) -> void:
	if anahtar in [&"", &"grafik_profili", &"cozunurluk_3d"]:
		if anahtar != &"cozunurluk_3d":
			_bellek()
		uygula()

func _bellek() -> void:
	if ayarlar.al(&"grafik_profili") == &"dusuk":
		DusukBellekProfili.memory_free()

func uygula() -> void:
	if is_instance_valid(hedef):
		get_viewport().scaling_3d_scale = float(ayarlar.al(&"cozunurluk_3d")) / 100.0
		_tara(hedef)

func _tara(n: Node) -> void:
	_dugum(n)
	for cocuk in n.get_children():
		_tara(cocuk)

func _eklendi(n: Node) -> void:
	# _ready sırasında kurulan düğümün gerçek başlangıç değerlerini bekle.
	_gec_uygula.call_deferred(weakref(n))

func _gec_uygula(referans: WeakRef) -> void:
	var n: Node = referans.get_ref()
	if is_instance_valid(n) and is_instance_valid(hedef) and hedef.is_ancestor_of(n):
		_dugum(n)

func _dugum(n: Node) -> void:
	var dusuk: bool = ayarlar.al(&"grafik_profili") == &"dusuk"
	if n is SubViewport:
		n.scaling_3d_scale = float(ayarlar.al(&"cozunurluk_3d")) / 100.0
		_kenar_yumusatma(n, dusuk)
	if n is Light3D:
		if dusuk:
			if not n.has_meta(GOLGE):
				n.set_meta(GOLGE, n.shadow_enabled)
			n.shadow_enabled = false
		elif n.has_meta(GOLGE):
			n.shadow_enabled = bool(n.get_meta(GOLGE))
			n.remove_meta(GOLGE)
	var parcacik := n is CPUParticles3D or n is GPUParticles3D
	if not parcacik and not (n is VisualInstance3D and n.get_meta(EFEKT, false)):
		return
	if not n.has_meta(&"grafik_asli_katman"):
		n.set_meta(&"grafik_asli_katman", n.layers)
		if parcacik:
			n.set_meta(&"grafik_asli_emisyon", n.emitting)
	n.layers = 0 if dusuk else int(n.get_meta(&"grafik_asli_katman"))
	if parcacik:
		n.emitting = false if dusuk else bool(n.get_meta(&"grafik_asli_emisyon"))

## Düşük profilde SMAA açıkken ek MSAA örneklemesini kaldır.
func _kenar_yumusatma(vp: SubViewport, dusuk: bool) -> void:
	if dusuk and vp.screen_space_aa == Viewport.SCREEN_SPACE_AA_SMAA:
		if not vp.has_meta(ASIL_MSAA):
			vp.set_meta(ASIL_MSAA, vp.msaa_3d)
		vp.msaa_3d = Viewport.MSAA_DISABLED
	elif vp.has_meta(ASIL_MSAA):
		vp.msaa_3d = vp.get_meta(ASIL_MSAA)
		vp.remove_meta(ASIL_MSAA)


func _exit_tree() -> void:
	if is_instance_valid(ayarlar) and ayarlar.degisti.is_connected(_degisti):
		ayarlar.degisti.disconnect(_degisti)
	if get_tree().node_added.is_connected(_eklendi):
		get_tree().node_added.disconnect(_eklendi)
