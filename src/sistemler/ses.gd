## Ses yöneticisi (autoload `Ses`): müzik ve ortam döngüleri, efektler.
## Dosyalar `res://assets/ses/<ad>.wav`; yoksa sessizce geçilir. Bus'lar: Master → Muzik, Efekt (Ayarlar GDD).
extends Node

const KOK := "res://assets/ses/"
const ES_ZAMANLI := 6

var _muzik: AudioStreamPlayer
var _ortam: AudioStreamPlayer
var _efektler: Array[AudioStreamPlayer] = []
var _sira := 0
var _onbellek: Dictionary = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for bus in ["Muzik", "Efekt"]:
		if AudioServer.get_bus_index(bus) < 0:
			AudioServer.add_bus()
			var i := AudioServer.bus_count - 1
			AudioServer.set_bus_name(i, bus)
			AudioServer.set_bus_send(i, "Master")
	_muzik = _oynatici("Muzik")
	_ortam = _oynatici("Efekt")
	for i in ES_ZAMANLI:
		_efektler.append(_oynatici("Efekt"))


## Arka plan müziğini ve meşale ortamını başlatır (zaten çalıyorsa dokunmaz).
func dongu_baslat() -> void:
	_dongu(_muzik, "muzik_gece_dongu")
	_dongu(_ortam, "ortam_mesale_dongu", -6.0)


## Bir efekt çalar.
func cal(ad: StringName, db: float = 0.0) -> void:
	var akis := _akis(String(ad))
	if akis == null:
		return
	var o := _efektler[_sira]
	_sira = (_sira + 1) % _efektler.size()
	o.stream = akis
	o.volume_db = db
	o.play()


func _dongu(o: AudioStreamPlayer, ad: String, db: float = 0.0) -> void:
	if o.playing:
		return
	var akis := _akis(ad)
	if akis is AudioStreamWAV:
		var w := (akis as AudioStreamWAV).duplicate() as AudioStreamWAV
		w.loop_mode = AudioStreamWAV.LOOP_FORWARD
		w.loop_begin = 0
		w.loop_end = int(w.get_length() * w.mix_rate)
		akis = w
	if akis == null:
		return
	o.stream = akis
	o.volume_db = db
	o.play()


func _akis(ad: String) -> AudioStream:
	if _onbellek.has(ad):
		return _onbellek[ad]
	var yol := KOK + ad + ".wav"
	var a: AudioStream = load(yol) if ResourceLoader.exists(yol) else null
	_onbellek[ad] = a
	return a


func _oynatici(bus: String) -> AudioStreamPlayer:
	var o := AudioStreamPlayer.new()
	o.bus = bus
	add_child(o)
	return o
