## Yalnız görsel oynatıcı; temel KarakterModel'in rota/tween/duygu sözleşmesi korunur.
class_name HazirKarakterModeli
extends KarakterModel

const YETISKIN_BOYU := 1.8

var boy := YETISKIN_BOYU

func kur(model: Node3D, ad: String = "") -> void:
	super.kur(model, ad)
	_anim = "yuru"
	_klipler["bekle"] = "bekle"
	_klipler["konus"] = "konus"
	_duzeltici_hedef = 0.0
	if _duzeltici != null:
		_duzeltici.influence = 0.0
	dur()

# UAL yürüyüş döngüsünde temas eden ayağın geriye doğru taban hızı (m/s).
func _yuruyus_taban_hizi() -> float:
	return 0.405 * boy / YETISKIN_BOYU

func dur() -> void:
	_hareket_bandi = "dur"
	_bekleme_hedef = 1.0
	_duzeltici_hedef = 0.0
	if is_instance_valid(_oynatici):
		_oynatici.speed_scale = 1.0
		var bekle := HareketGecisi.tablo_klibi("dur")
		if _oynatici.has_animation(bekle):
			_oynatici.play(bekle, GECIS)
		else:
			preload("res://src/dunya/guvenli_karakter_animasyonu.gd").dur(_oynatici, _anim, GECIS)

func calis(ad: StringName) -> void:
	super.calis(ad)
	_duzeltici_hedef = 0.0
	if not is_instance_valid(_oynatici):
		return
	if ad == &"":
		dur()
	elif _oynatici.has_animation(String(ad)):
		_oynatici.play(String(ad), GECIS)

func _klip_oynat(ad: String) -> int:
	var sira := super._klip_oynat(ad)
	_duzeltici_hedef = 0.0
	return sira

func _process(delta: float) -> void:
	# Temel yuru() prosedürel düzelticiyi açar; retarget edilmiş LOWPO'da ikinci kez uygulanmaz.
	_duzeltici_hedef = 0.0
	super._process(delta)
