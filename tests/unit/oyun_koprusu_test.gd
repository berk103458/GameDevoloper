extends SceneTree

func _initialize() -> void:
	call_deferred("_test")

func _test() -> void:
	var kopru = load("res://src/debug/oyun_koprusu.gd")
	assert(kopru.port_oku([], "") == 0)
	assert(kopru.port_oku([], "9311") == 9311)
	assert(kopru.port_oku(["--bridge-port", "9312"], "9311") == 9312)
	for hatali in ["", "abc", "0", "65536", "-1", "1.5"]:
		assert(kopru.port_oku(["--bridge-port", hatali], "9311") == 0)
	assert(kopru.port_oku(["--bridge-port"], "9311") == 0)
	var k = kopru.new()
	root.add_child(k)
	assert((await k.run_command("ping"))["pong"])
	assert((await k.run_command("get_state"))["hazir"] == false)
	assert((await k.run_command("set_value", {"akce": 999})).has("error"))
	var ana = load("res://src/arayuz/ana.gd").new()
	k.ana = ana
	ana._ekran = load("res://src/arayuz/menu_ekrani.gd").new()
	assert((await k.run_command("kapi_karar", {"karar": "kabul"})).has("error"))
	assert((await k.run_command("soru_sor", {"indeks": -1})).has("error"))
	assert((await k.run_command("koy_eylem", {"tur": "insa"})).has("error"))
	assert((await k.run_command("gece_bitir")).has("error"))
	assert((await k.run_command("devam", {"indeks": "0"})).has("error"))
	assert((await k.run_command("yeni_oyun", {"tohum": {}})).has("error"))
	assert((await k.run_command("screenshot", {"yol": "x.png"})).has("error"))
	ana._ekran.free()
	ana.free()
	k.queue_free()
	print("OYUN KÖPRÜSÜ BİRİM: GEÇTİ")
	quit(0)
