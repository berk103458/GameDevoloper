## AYR-22: Pencere odak kaybedince `arka_planda_sustur` aciksa `ses_ana` gecici olarak 0 olur
## ve Master bus -80 dB'ye cekilir; odak donunce eski deger geri yuklenir.
class_name OdakSesi
extends Node

const KISIK_DB := -80.0

var ayarlar: Ayarlar
var _onceki_ses_ana: int = -1
var _susturuldu: bool = false


func _init(ayarlar_: Ayarlar = null) -> void:
	ayarlar = ayarlar_


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		odak_kayboldu()
	elif what == NOTIFICATION_APPLICATION_FOCUS_IN or what == NOTIFICATION_WM_WINDOW_FOCUS_IN:
		odak_geldi()


func odak_kayboldu() -> void:
	if ayarlar == null or _susturuldu:
		return
	if not bool(ayarlar.degerler.get(&"arka_planda_sustur", true)):
		return
	_onceki_ses_ana = int(ayarlar.al(&"ses_ana"))
	_susturuldu = true
	ayarlar.degerler[&"ses_ana"] = 0
	var bus := AudioServer.get_bus_index("Master")
	if bus >= 0:
		AudioServer.set_bus_volume_db(bus, KISIK_DB)
		AudioServer.set_bus_mute(bus, true)


func odak_geldi() -> void:
	if ayarlar == null or not _susturuldu:
		return
	_susturuldu = false
	if _onceki_ses_ana >= 0:
		ayarlar.degerler[&"ses_ana"] = _onceki_ses_ana
	_onceki_ses_ana = -1
	ayarlar.uygula()
	var bus := AudioServer.get_bus_index("Master")
	if bus >= 0 and int(ayarlar.al(&"ses_ana")) > 0:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(bus, linear_to_db(float(ayarlar.al(&"ses_ana")) / 10.0))
