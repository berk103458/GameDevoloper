extends SceneTree

var hata := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var adapt := preload("res://src/kapi/karar_replik_adaptoru.gd")
	_kontrol(adapt.ilgilendirir("rusvet") and adapt.ilgilendirir("ret"), "Yalnız rüşvet ve ret")
	_kontrol(not adapt.ilgilendirir("kabul") and not adapt.ilgilendirir("kisla") and not adapt.ilgilendirir("elkoy"), "Diğer kararlar bu adaptöre girmez")
	_kontrol(adapt.yerlestir("Kese el değiştirdi. %s içeri girdi.", "Hamza") == "Kese el değiştirdi. Hamza içeri girdi.", "CSV yer tutucusu adı alır")
	_kontrol(adapt.yerlestir("anlati.sonuc.rusvet", "Hamza") == "anlati.sonuc.rusvet", "Yer tutucusuz kalıp boşalmaz")
	var json := Gelen.new()
	json.ad_anahtari = "karakter.chr_001.ad"
	json.yanitlar = {
		"rusvet": "Şu darının yarısını vereyim sana, yeter ki aç o kapıyı.",
		"ret": "Geri dönersem yollarda tükenirim, yapma.",
	}
	var rusvet: Dictionary = adapt.uygula(json, "rusvet")
	var rusvet_metin := String(rusvet["metin"])
	_kontrol(rusvet_metin.contains("anlati.sonuc.rusvet") or rusvet_metin.contains("Kese el değiştirdi"), "Rüşvet CSV satırı kutuya düşer")
	_kontrol(rusvet_metin.contains("darının"), "Rüşvet yanıtı çevrilerek kutuya düşer")
	_kontrol(rusvet["sfx"] == &"sfx_chr_sikke" and rusvet["dosya"], "Rüşvet mevcut sikke sesini seçer")
	var ret: Dictionary = adapt.uygula(json, "ret")
	var ret_metin := String(ret["metin"])
	_kontrol(ret_metin.contains("anlati.sonuc.ret") or ret_metin.contains("Kapı kapalı kaldı"), "Ret CSV satırı kutuya düşer")
	_kontrol(ret_metin.contains("tükenirim"), "Ret yanıtı kutuya düşer")
	_kontrol(ret["sfx"] == &"sfx_chr_deri" and ret["dosya"], "Ret mevcut deri sesini seçer")
	json.yanitlar = {"ret": "anlati.sonuc.ret"}
	var anahtar_metin := String(adapt.uygula(json, "ret")["metin"])
	_kontrol(anahtar_metin.contains("anlati.sonuc.ret") or anahtar_metin.contains("Kapı kapalı kaldı"), "CSV anahtarı ham basılmaz")
	var chr := Gelen.new()
	chr.id = &"chr_001"
	chr.adli = true
	chr.ad_anahtari = "karakter.chr_001.ad"
	var chr_rusvet: Dictionary = adapt.uygula(chr, "rusvet")
	var chr_ret: Dictionary = adapt.uygula(chr, "ret")
	_kontrol(not String(chr_rusvet["metin"]).is_empty() and not String(chr_ret["metin"]).is_empty(), "CHR kararında boş replik yok")
	_kontrol(chr_rusvet["sfx"] == &"sfx_chr_sikke" and chr_rusvet["dosya"], "CHR rüşveti mevcut sikke dosyası")
	_kontrol(chr_ret["sfx"] == &"sfx_chr_deri" and chr_ret["dosya"], "CHR reti mevcut deri dosyası")
	_kontrol(adapt.ses_adi("Hançer kabzasına sarılır", "ret") == &"sfx_chr_kabza" and adapt.dosya_var(&"sfx_chr_kabza"), "Metindeki kabza mevcut dosyaya gider")
	for ses in ["sfx_chr_sikke", "sfx_chr_deri", "sfx_chr_kabza", "sfx_chr_metal", "sfx_chr_kagit", "sfx_chr_bebek", "sfx_kese", "sfx_onay", "sfx_kapi_acilir", "sfx_kapi_kapanir"]:
		_kontrol(ResourceLoader.exists("res://assets/ses/%s.wav" % ses), "Mevcut ses duruyor: " + ses)
	var oynatici := root.get_node_or_null("Ses")
	if oynatici != null and oynatici.has_method("sustur"):
		await oynatici.sustur()
	print("KARAR REPLIK: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
