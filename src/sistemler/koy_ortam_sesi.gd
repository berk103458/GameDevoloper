## Gündüz/gece ses fazı; Ambiance Efekt bus'ına bağlıdır, kullanıcı ayarı korunur.
extends Node

var faz_adi: StringName = &""
var _ses: Node
var _onceki_bus: StringName = &"Efekt"

func _ready() -> void:
	for bus in ["Efekt", "Ambiance"]:
		if AudioServer.get_bus_index(bus) < 0:
			AudioServer.add_bus()
			var indeks := AudioServer.bus_count - 1
			AudioServer.set_bus_name(indeks, bus)
			AudioServer.set_bus_send(indeks, "Efekt" if bus == "Ambiance" else "Master")
	if _ses == null:
		_ses = get_tree().root.get_node_or_null("Ses")
	if _ses != null:
		_onceki_bus = StringName(_ses.call("ortam_busu_adi"))
		_ses.set_meta("koy_ortam_sahibi", get_instance_id())
		_ses.call("ortam_busunu_ayarla", &"Ambiance")

func faz(ad: StringName) -> void:
	var yeni := &"gece" if ad == &"gece" else &"gunduz"
	if yeni == faz_adi:
		return
	faz_adi = yeni
	if _ses != null:
		_ses.call("ortam_cal", &"ortam_koy_gece" if yeni == &"gece" else &"ortam_koy_gunduz", -8.0)

func _exit_tree() -> void:
	if is_instance_valid(_ses) and _ses.get_meta("koy_ortam_sahibi", 0) == get_instance_id():
		_ses.call("ortam_busunu_ayarla", _onceki_bus)
		_ses.remove_meta("koy_ortam_sahibi")
