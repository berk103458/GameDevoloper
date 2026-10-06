## Aynı anda dönen üç özgün müzik katmanı; eşikte yumuşak ses geçişi.
extends Node

const PARCALAR := ["sakin", "gergin", "panik"]
const SES_DB := -12.0
var katman: int = -1
var _oynaticilar: Array[AudioStreamPlayer] = []
var _gecis: Tween
var _ses: Node
var _eski_db: float = 0.0
var _bastirildi := false

static func katman_indeksi(tansiyon: int) -> int:
	return 0 if tansiyon < 4 else 1 if tansiyon < 8 else 2

func _ready() -> void:
	add_to_group("chr_tansiyon_muzigi")
	_ses = get_tree().root.get_node_or_null("Ses")
	for parca in PARCALAR:
		var o := AudioStreamPlayer.new()
		o.bus = "Muzik"
		o.volume_db = -80.0
		var akis := load("res://assets/ses/muzik_chr_%s.wav" % parca) as AudioStreamWAV
		if akis != null:
			akis = akis.duplicate()
			akis.loop_mode = AudioStreamWAV.LOOP_FORWARD
			akis.loop_begin = 0
			akis.loop_end = int(akis.get_length() * akis.mix_rate)
			o.stream = akis
		add_child(o)
		_oynaticilar.append(o)

func guncelle(tansiyon: int) -> void:
	var hedef := katman_indeksi(tansiyon)
	if hedef == katman:
		return
	if not _bastirildi and _ses != null:
		_eski_db = _ses.call("muzik_sesi")
		_ses.call("muzik_sesini_ayarla", -80.0)
		_bastirildi = true
	for o in _oynaticilar:
		if not o.playing:
			o.play()
	katman = hedef
	if _gecis != null and _gecis.is_valid():
		_gecis.kill()
	_gecis = create_tween().set_parallel()
	for i in _oynaticilar.size():
		_gecis.tween_property(_oynaticilar[i], "volume_db", SES_DB if i == hedef else -80.0, 0.7)

func durdur() -> void:
	if _gecis != null and _gecis.is_valid():
		_gecis.kill()
	for o in _oynaticilar:
		o.stop()
		o.volume_db = -80.0
	if _bastirildi and is_instance_valid(_ses):
		_ses.call("muzik_sesini_ayarla", _eski_db)
	_bastirildi = false
	katman = -1

func _exit_tree() -> void:
	durdur()
