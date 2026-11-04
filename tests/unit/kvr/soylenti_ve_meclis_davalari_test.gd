# SOY-SON-01 ve MECLIS-ARA-01 doğrulama testi
extends SceneTree

func _init() -> void:
	print("--- SOY-SON-01 & MECLIS-ARA-01 TESTI BASLADI ---")

	# 1. SOY-SON-01 Kapanış Olayları kontrolü
	var olay_idler := [
		"soylenti_degirmen_kapanis",
		"soylenti_kuyu_kapanis",
		"soylenti_tekfur_araba_kapanis",
		"soylenti_mogol_casus_kapanis",
		"soylenti_vebali_kumas_kapanis"
	]
	for id in olay_idler:
		var yol := "res://data/olaylar/%s.tres" % id
		assert(FileAccess.file_exists(yol), "%s dosyasi bulunamadi" % yol)
		var res := load(yol) as OlayVerisi
		assert(res != null, "OlayVerisi yuklenemedi: %s" % yol)
		assert(res.id == StringName(id), "Olay id uyusmuyor: %s" % id)
		assert(res.secenek_anahtarlari.size() >= 2, "Secenekler eksik: %s" % id)
		assert(res.secenek_etkileri.size() >= 2, "Etkiler eksik: %s" % id)

	# 2. SoylentiAgi kapanış fonksiyonları kontrolü
	var ag := SoylentiAgi.new()
	assert(ag.soylenti_kapanis_olayi_al("degirmen_un") == "soylenti_degirmen_kapanis", "degirmen_un eslesmesi yanlis")
	assert(ag.soylenti_kapanis_olayi_al("kuyu_zehir") == "soylenti_kuyu_kapanis", "kuyu_zehir eslesmesi yanlis")
	
	ag.soylenti_ekle("degirmen_un", "suc", "yusuf", false)
	assert(ag.ag_kayitlari.has("degirmen_un"), "degirmen_un ag kaydi acilmadi")
	var sonuc := ag.soylenti_kapanisi_uygula("degirmen_un", "adalet")
	assert(sonuc["cozuldu"] == true, "soylenti kapanisi basarisiz")
	assert(ag.ag_kayitlari["degirmen_un"]["cozuldu"] == true, "cozuldu bayragi islenmedi")

	# 3. MECLIS-ARA-01 Parley Dava Dosyası kontrolü
	var meclis_yollar := [
		"res://data/parley/koy/meclis_davalari.ds",
		"res://data/parley/en/koy/meclis_davalari.ds"
	]
	for yol in meclis_yollar:
		assert(FileAccess.file_exists(yol), "%s bulunamadi" % yol)
		var txt := FileAccess.get_file_as_string(yol)
		var j: Variant = JSON.parse_string(txt)
		assert(j is Dictionary and j.has("nodes") and j.has("edges"), "Parley semasi gecersiz: %s" % yol)
		var nodes: Array = j["nodes"]
		var node_idler: Array = []
		for n in nodes:
			node_idler.append(n["id"])
		assert("node:opt_balta" in node_idler, "opt_balta eksik: %s" % yol)
		assert("node:opt_boya" in node_idler, "opt_boya eksik: %s" % yol)
		assert("node:opt_mera" in node_idler, "opt_mera eksik: %s" % yol)
		assert("node:opt_sifahane" in node_idler, "opt_sifahane eksik: %s" % yol)

	print("SOY-SON-01 & MECLIS-ARA-01 TESTI: GECTI (0 hata)")
	quit(0)
