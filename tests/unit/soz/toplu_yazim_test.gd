# gdlint: disable=max-line-length
## YAZ-06: adsız kapı diyalogları (data/diyalog/diyalog_01_20.json) oyunun okuduğu liste biçimindedir;
## 30 diyalog Oturum._gemini_al sırasıyla, her biri bir kez gelir.
extends SceneTree

func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	var hatalar: Array[String] = []

	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/diyalog/diyalog_01_20.json"))
	if not (parsed is Array):
		push_error("diyalog_01_20.json oyunun beklediği liste (Array) biçiminde değil!")
		quit(1)
		return

	var liste: Array = parsed
	if liste.size() < 30:
		hatalar.append("Toplu yeniden yazımda diyalog sayısı 30'dan az: %d" % liste.size())
	var kimlikler: Array = []
	for d in liste:
		if d is Dictionary:
			kimlikler.append(String(d.get("id", "")))
	for i in range(1, 31):
		var k_id := "diyalog_%02d" % i
		if not k_id in kimlikler:
			hatalar.append("Diyalog '%s' eksik!" % k_id)

	TranslationServer.set_locale("tr")
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 7)
	var gelenler: Array = []
	while true:
		var d: Dictionary = o._gemini_al()
		if d.is_empty():
			break
		gelenler.append(String(d.get("id", "")))
		if gelenler.size() > liste.size():
			break
	if gelenler != kimlikler:
		hatalar.append("Oturum._gemini_al sırası dosyadaki 30 diyalogla aynı değil: %d geldi" % gelenler.size())

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		print("TEST FAIL: toplu_yazim_test.gd (%d hata)" % hatalar.size())
		quit(1)
		return

	print("TEST PASS: toplu_yazim_test.gd")
	quit(0)
