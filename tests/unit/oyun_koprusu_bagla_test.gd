extends SceneTree
## TEK-06 (ADM-16 kapanis olcutu): portsuz acilista kopru dugumu ve dinleyen soket yok;
## BRIDGE_PORT (ya da --bridge-port) ile dinleyici acilir ve TCP ping pong doner.
##
## -s kipinde ana otomatik yuklemeleri (autoload) ana betik derlenmeden once hazir
## olmadigi icin Ana ve OyunKoprusu betikleri calisma aninda load() ile alinir; sessiz
## alt sinif GDScript.new() ile uretilir ve _ready'si bos olur (agir sahne kurulumu atlanir).

const ANA_YOLU := "res://src/arayuz/ana.gd"
const KOPRU_YOLU := "res://src/debug/oyun_koprusu.gd"
const DINLEYICI_YOLU := "res://bridge/godot/bridge.gd"

var hata := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _sessiz_ana() -> Node:
	var gd := GDScript.new()
	gd.source_code = "extends \"" + ANA_YOLU + "\"\n\n\nfunc _ready() -> void:\n\tpass\n"
	if gd.reload() != OK:
		return null
	return gd.new()

## Ana agacinda kac adet TCP kopru dinleyicisi (bridge.gd) var; portsuzda 0 olmali.
func _dinleyici_sayisi(kok: Node) -> int:
	var sayi := 0
	for dugum in kok.find_children("*", "", true, false):
		var betik = dugum.get_script()
		if betik != null and String(betik.resource_path) == DINLEYICI_YOLU:
			sayi += 1
	return sayi

func _calistir() -> void:
	var kopru_sinif = load(KOPRU_YOLU)
	var eski_port := OS.get_environment("BRIDGE_PORT")
	var eski_dir := OS.get_environment("BRIDGE_TESTER_DIR")
	OS.set_environment("BRIDGE_TESTER_DIR", "")
	# 1. acilis -- portsuz: bagla() p==0 dali dugum ve dinleyen soket acmaz.
	OS.set_environment("BRIDGE_PORT", "")
	var ana1 := _sessiz_ana()
	_kontrol(ana1 != null, "sessiz Ana alt sinifi derlendi")
	if ana1 != null:
		root.add_child(ana1)
		kopru_sinif.bagla(ana1)
		await process_frame
		_kontrol(ana1.find_children("*", "OyunKoprusu", true, false).is_empty(), "portsuz acilista OyunKoprusu dugumu eklenmez")
		_kontrol(_dinleyici_sayisi(ana1) == 0, "portsuz acilista dinleyen TCP soketi yok")
		ana1.queue_free()
	# 2. acilis -- BRIDGE_PORT dolu: dinleyici acilir, ping pong doner.
	var port := _bos_port()
	OS.set_environment("BRIDGE_PORT", str(port))
	var ana2 := _sessiz_ana()
	_kontrol(ana2 != null, "sessiz Ana alt sinifi ikinci kez derlendi")
	if ana2 != null:
		root.add_child(ana2)
		kopru_sinif.bagla(ana2)
		await process_frame
		_kontrol(ana2.find_children("*", "OyunKoprusu", true, false).size() == 1, "portlu acilista OyunKoprusu dugumu eklenir")
		_kontrol(_dinleyici_sayisi(ana2) == 1, "portlu acilista dinleyen TCP soketi acilir")
		_kontrol(await _ping(port), "portlu acilista TCP ping pong doner")
		ana2.queue_free()
	OS.set_environment("BRIDGE_PORT", eski_port)
	OS.set_environment("BRIDGE_TESTER_DIR", eski_dir)
	await process_frame
	await process_frame
	print("OYUN KOPRUSU ACILIS: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _bos_port() -> int:
	var sunucu := TCPServer.new()
	if sunucu.listen(0, "127.0.0.1") != OK:
		return 19616
	var secilen := sunucu.get_local_port()
	sunucu.stop()
	return secilen

func _ping(port: int) -> bool:
	var istemci := StreamPeerTCP.new()
	if istemci.connect_to_host("127.0.0.1", port) != OK:
		return false
	for _i in 300:
		istemci.poll()
		if istemci.get_status() == StreamPeerTCP.STATUS_CONNECTED:
			break
		if istemci.get_status() == StreamPeerTCP.STATUS_ERROR:
			return false
		await process_frame
	if istemci.get_status() != StreamPeerTCP.STATUS_CONNECTED:
		return false
	istemci.put_data(("{\"id\":1,\"cmd\":\"ping\",\"args\":{}}\n").to_utf8_buffer())
	var tampon := PackedByteArray()
	for _i in 300:
		istemci.poll()
		if istemci.get_available_bytes() > 0:
			var okuma := istemci.get_data(istemci.get_available_bytes())
			if okuma[0] == OK:
				tampon.append_array(okuma[1])
		var son := tampon.find(10)
		if son >= 0:
			var yanit = JSON.parse_string(tampon.slice(0, son).get_string_from_utf8())
			istemci.disconnect_from_host()
			return yanit is Dictionary and yanit.get("ok", false) and yanit.get("result", {}).get("pong", false) == true
		await process_frame
	istemci.disconnect_from_host()
	return false

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error("TEK-06: " + mesaj)