extends SceneTree

var _hata := 0

func _initialize() -> void:
	call_deferred("_test")

func _test() -> void:
	var kopru = load("res://src/debug/oyun_koprusu.gd")
	_dene(kopru.port_oku([], "") == 0, "oyun_koprusu_test.gd:8")
	_dene(kopru.port_oku([], "9311") == 9311, "oyun_koprusu_test.gd:9")
	_dene(kopru.port_oku(["--bridge-port", "9312"], "9311") == 9312, "oyun_koprusu_test.gd:10")
	for hatali in ["", "abc", "0", "65536", "-1", "1.5"]:
		_dene(kopru.port_oku(["--bridge-port", hatali], "9311") == 0, "oyun_koprusu_test.gd:12")
	_dene(kopru.port_oku(["--bridge-port"], "9311") == 0, "oyun_koprusu_test.gd:13")
	var k = kopru.new()
	root.add_child(k)
	_dene((await k.run_command("ping"))["pong"], "oyun_koprusu_test.gd:16")
	_dene((await k.run_command("get_state"))["hazir"] == false, "oyun_koprusu_test.gd:17")
	_dene((await k.run_command("set_value", {"akce": 999})).has("error"), "oyun_koprusu_test.gd:18")
	var ana = load("res://src/arayuz/ana.gd").new()
	k.ana = ana
	ana._ekran = load("res://src/arayuz/menu_ekrani.gd").new()
	_dene((await k.run_command("kapi_karar", {"karar": "kabul"})).has("error"), "oyun_koprusu_test.gd:22")
	_dene((await k.run_command("soru_sor", {"indeks": -1})).has("error"), "oyun_koprusu_test.gd:23")
	_dene((await k.run_command("koy_eylem", {"tur": "insa"})).has("error"), "oyun_koprusu_test.gd:24")
	_dene((await k.run_command("gece_bitir")).has("error"), "oyun_koprusu_test.gd:25")
	_dene((await k.run_command("devam", {"indeks": "0"})).has("error"), "oyun_koprusu_test.gd:26")
	_dene((await k.run_command("yeni_oyun", {"tohum": {}})).has("error"), "oyun_koprusu_test.gd:27")
	_dene((await k.run_command("screenshot", {"yol": "x.png"})).has("error"), "oyun_koprusu_test.gd:28")
	ana._ekran.free()
	ana.free()
	k.queue_free()
	print("OYUN KÖPRÜSÜ BİRİM: GEÇTİ" if _hata == 0 else "OYUN KÖPRÜSÜ BİRİM: KALDI (%d hata)" % _hata)
	quit(1 if _hata > 0 else 0)


func _dene(kosul: bool, ad: String) -> void:
	if not kosul:
		_hata += 1
		push_error(ad)
