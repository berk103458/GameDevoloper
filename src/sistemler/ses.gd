## Ses yöneticisi (autoload `Ses`): müzik ve ortam döngüleri, efektler.
## Dosyalar `res://assets/ses/<ad>.wav`; yoksa sessizce geçilir. Bus'lar: Master → Muzik, Efekt (Ayarlar GDD).
extends Node

const KOK := "res://assets/ses/"
const ES_ZAMANLI := 6
const VARSAYILAN_MUZIK := &"muzik_gece_dongu"
const VARSAYILAN_ORTAM := &"ortam_mesale_dongu"
## Döngüler arası geçiş süresi (s) ve sessiz kabul edilen düzey.
const GECIS := 1.5
const SESSIZ_DB := -40.0

var _muzik: AudioStreamPlayer
var _ortam: AudioStreamPlayer
## Geçiş için ikinci oynatıcılar: yeni döngü bunda açılır, eskisi söner, sonra yer değiştirirler.
var _muzik_yedek: AudioStreamPlayer
var _ortam_yedek: AudioStreamPlayer
var _muzik_ad: StringName = &""
var _ortam_ad: StringName = &""
var _efektler: Array[AudioStreamPlayer] = []
var _sira := 0
var _onbellek: Dictionary = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().auto_accept_quit = false
	for bus in ["Muzik", "Efekt"]:
		if AudioServer.get_bus_index(bus) < 0:
			AudioServer.add_bus()
			var i := AudioServer.bus_count - 1
			AudioServer.set_bus_name(i, bus)
			AudioServer.set_bus_send(i, "Master")
	_muzik = _oynatici("Muzik")
	_muzik_yedek = _oynatici("Muzik")
	_ortam = _oynatici("Efekt")
	_ortam_yedek = _oynatici("Efekt")
	for i in ES_ZAMANLI:
		var o := _oynatici("Efekt")
		o.finished.connect(EfektHavuzuTemizligi.biteni_birak.bind(o))
		_efektler.append(o)


## Oyundan çıkış: önce sesleri susturur, ses sunucusunun çalanları bırakmasını bekler, sonra çıkar.
## Doğrudan `get_tree().quit()` çalan döngüleri ses sunucusunda bırakır; motor kapanırken AudioStreamWAV /
## AudioStreamPlaybackWAV sızıntısı bildirir (QA A-002, A-003). Pencere kapatma da buradan geçer.
func cik(kod: int = 0) -> void:
	await sustur()
	# Uçuştaki varlık yüklemeleri (load_threaded_request) kapanış anında sızıntı verir; bitmesini bekle.
	await VarlikAkisDenetimi.bosalana_kadar(get_tree())
	_onbellekleri_bosalt()
	get_tree().quit(kod)


## Statik önbellekler (doku, malzeme, model, klip) ve imleç dokusu motor kapanırken görüntü sunucusundan sonra bırakılır ve
## "Texture ... leaked" bildirir; çıkıştan önce boşaltılır. Sahneler kendi kopyalarını tutar, etkilenmez.
func _onbellekleri_bosalt() -> void:
	Sanat._onbellek.clear()
	Pbr._onbellek.clear()
	Dunya3B._onbellek.clear()
	Dunya3B._el_esyalari.clear()
	KarakterModel._klip_onbellek.clear()
	HazirKarakterler._kitaplar.clear()
	DurusDuzeltici._sekil_onbellek.clear()
	KapiManzarasi._gurultu = null
	# Özel fare imleci (ana.gd) Input'ta kalır; Input görüntü sunucusundan sonra kapanır.
	Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(null, Input.CURSOR_POINTING_HAND)


## Çalan her şeyi durdurur ve akışları bırakır; ses sunucusu birkaç karede çalanları siler.
func sustur() -> void:
	get_tree().call_group("chr_tansiyon_muzigi", "durdur")
	for o: AudioStreamPlayer in [_muzik, _muzik_yedek, _ortam, _ortam_yedek] + _efektler:
		if is_instance_valid(o):
			o.stop()
			o.stream = null
	_muzik_ad = &""
	_ortam_ad = &""
	_onbellek.clear()
	for i in 3:
		await get_tree().process_frame
	await get_tree().create_timer(0.1, true, false, true).timeout


func _notification(ne: int) -> void:
	if ne == NOTIFICATION_WM_CLOSE_REQUEST:
		cik()


## Arka plan müziğini ve meşale ortamını başlatır (zaten çalıyorsa dokunmaz).
func dongu_baslat() -> void:
	if _muzik_ad == &"":
		_muzik_ad = VARSAYILAN_MUZIK
		_dongu(_muzik, String(VARSAYILAN_MUZIK))
	if _ortam_ad == &"":
		_ortam_ad = VARSAYILAN_ORTAM
		_dongu(_ortam, String(VARSAYILAN_ORTAM), -6.0)


## Müziği yumuşak geçişle başka bir döngüye çevirir (düğün gibi olaylar). &"" = varsayılan.
func muzik_cal(ad: StringName, db: float = 0.0) -> void:
	if ad == &"":
		ad = VARSAYILAN_MUZIK
	if ad == _muzik_ad:
		return
	if _gecis(_muzik, _muzik_yedek, ad, db):
		_muzik_ad = ad
		var t := _muzik
		_muzik = _muzik_yedek
		_muzik_yedek = t


## Ortam döngüsünü değiştirir (kapıda meşale, köyde gece). &"" = varsayılan.
func ortam_cal(ad: StringName, db: float = -6.0) -> void:
	if ad == &"":
		ad = VARSAYILAN_ORTAM
	if ad == _ortam_ad:
		return
	if _gecis(_ortam, _ortam_yedek, ad, db):
		_ortam_ad = ad
		var t := _ortam
		_ortam = _ortam_yedek
		_ortam_yedek = t


## Çalan müzik döngüsünün adı.
func muzik_adi() -> StringName:
	return _muzik_ad

## Sorgu müziği adaptörü; oyuncunun Muzik bus ayarına dokunmaz.
func muzik_sesi() -> float:
	return _muzik.volume_db if is_instance_valid(_muzik) else 0.0

func muzik_sesini_ayarla(db: float) -> void:
	for o in [_muzik, _muzik_yedek]:
		if is_instance_valid(o):
			o.volume_db = db


## Çalan ortam döngüsünün adı.
func ortam_adi() -> StringName:
	return _ortam_ad

func ortam_busu_adi() -> StringName:
	return _ortam.bus if is_instance_valid(_ortam) else &"Efekt"

func ortam_busunu_ayarla(ad: StringName) -> void:
	for o in [_ortam, _ortam_yedek]:
		if is_instance_valid(o):
			o.bus = ad


func _gecis(eski: AudioStreamPlayer, yeni: AudioStreamPlayer, ad: StringName, db: float) -> bool:
	if not is_instance_valid(eski) or not is_instance_valid(yeni):
		return false
	yeni.stop()
	_dongu(yeni, String(ad), SESSIZ_DB)
	if not yeni.playing:
		return false
	var t := create_tween().set_parallel()
	t.tween_property(yeni, "volume_db", db, GECIS)
	t.tween_property(eski, "volume_db", SESSIZ_DB, GECIS)
	t.chain().tween_callback(eski.stop)
	return true


## Bir efekt çalar.
func cal(ad: StringName, db: float = 0.0) -> void:
	oynat(ad, db)


## Sahneye ait kısa sesleri durdurur; sabit havuz ve arka plan döngüleri korunur.
func efektleri_temizle() -> void:
	EfektHavuzuTemizligi.temizle(_efektler, _onbellek)
	_sira = 0

## Başlamayan ses false döner; eski cal API'si bu güvenli yolu kullanır.
func oynat(ad: StringName, db: float = 0.0) -> bool:
	if _efektler.is_empty() or ad == &"" or not is_finite(db):
		return false
	var akis := _akis(String(ad))
	if akis == null:
		return false
	_sira = posmod(_sira, _efektler.size())
	var o := _efektler[_sira]
	_sira = (_sira + 1) % _efektler.size()
	if not is_instance_valid(o):
		return false
	o.stream = akis
	o.volume_db = db
	o.play()
	return true


func _dongu(o: AudioStreamPlayer, ad: String, db: float = 0.0) -> void:
	if not is_instance_valid(o):
		return
	if o.playing:
		return
	var akis := _akis(ad)
	if akis is AudioStreamWAV:
		var w := (akis as AudioStreamWAV).duplicate() as AudioStreamWAV
		w.loop_mode = AudioStreamWAV.LOOP_FORWARD
		w.loop_begin = 0
		w.loop_end = int(w.get_length() * w.mix_rate)
		akis = w
	elif akis is AudioStreamOggVorbis:
		akis = akis.duplicate()
		(akis as AudioStreamOggVorbis).loop = true
	if akis == null:
		return
	o.stream = akis
	o.volume_db = db
	o.play()


func _akis(ad: String) -> AudioStream:
	if _onbellek.has(ad):
		return _onbellek[ad]
	var yol := HazirSesKaynaklari.yol(ad)
	var a: AudioStream = load(yol) if ResourceLoader.exists(yol) else null
	_onbellek[ad] = a
	return a


func _oynatici(bus: String) -> AudioStreamPlayer:
	var o := AudioStreamPlayer.new()
	o.bus = bus
	add_child(o)
	return o
