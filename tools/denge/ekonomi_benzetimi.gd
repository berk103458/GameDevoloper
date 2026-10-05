## Ekonomi benzetimi: oturumu arayüzsüz, QA botlarının stratejileriyle gece gece oynatır ve akçe/ambar izini basar.
## Gözlem verir, hüküm vermez. Çalıştırma:
##   godot --headless --path . -s tools/denge/ekonomi_benzetimi.gd      (ortam: TOHUMLAR="42,43,44", GECE=10)
extends SceneTree

const YAPI_SIRASI: Array[StringName] = [&"sur", &"pazar", &"kervansaray", &"konak"]


func _init() -> void:
	var k := Katalog.new()
	if k.yukle() != Katalog.Durum.HAZIR:
		print("katalog yüklenemedi: ", k.hatalar)
		quit(1)
		return
	var tohumlar := (OS.get_environment("TOHUMLAR") if OS.get_environment("TOHUMLAR") != "" else "42,43,44").split(",")
	var gece := int(OS.get_environment("GECE")) if OS.get_environment("GECE") != "" else 10
	for strateji in ["kaos", "ekonomist"]:
		for t in tohumlar:
			_oyna(k, int(t), strateji, gece)
	quit(0)


func _oyna(k: Katalog, tohum: int, strateji: String, azami: int) -> void:
	var o := Oturum.new(k, tohum)
	var rng := RandomNumberGenerator.new()
	rng.seed = tohum
	var iz: PackedStringArray = []
	var son := "GECE_SINIRI"
	var en_az := 999
	var donuk := 0
	for n in azami:
		for g in o.gece_kuyrugu():
			o.ziyaret_basladi(g)
			var sec := g.secenekler if not g.secenekler.is_empty() else PackedStringArray(["kabul", "ret"])
			var karar := sec[rng.randi_range(0, sec.size() - 1)]
			if strateji == "ekonomist" and rng.randf() < 0.75 and "kabul" in sec:
				karar = "kabul"
			var s := o.karar_ver(g, StringName(karar))
			if int(s["kirilan"]) >= 0:
				son = "kırıldı(%d)" % s["kirilan"]
				break
		if son != "GECE_SINIRI":
			break
		var r := o.gece_sonu()
		if int(r["kirilan"]) >= 0:
			son = "kırıldı(%d)" % r["kirilan"]
			break
		var olay: OlayVerisi = r.get("olay")
		if olay != null:
			var uygun: Array[int] = []
			for i in olay.secenek_anahtarlari.size():
				if o.secenek_olur(olay, i):
					uygun.append(i)
			if not uygun.is_empty():
				o.olay_uygula(olay, uygun[rng.randi_range(0, uygun.size() - 1)], 1)
		# Bot gibi: sıradaki ilk alınabilir yapıyı alır (en çok 4 deneme).
		for d in 4:
			for y in YAPI_SIRASI:
				if o.yapi_kur(y):
					break
		en_az = mini(en_az, o.akce)
		donuk += 1 if o.akce <= 1 else 0
		iz.append("%d:%d/%d" % [o.gun, o.akce, o.ambar])
		if n == azami - 1 or son != "GECE_SINIRI":
			print("   sınıflar ç/e/a=%d/%d/%d" % [o.koy.sayi(&"ciftci"), o.koy.sayi(&"esnaf"), o.koy.sayi(&"asker")])
	print("%-9s t=%d son=%s köy=%d yapı=%s akçe≤1 gece=%d | %s" % [strateji, tohum, son, o.koy.toplam(),
		[o.yapilar[&"sur"], o.yapilar[&"pazar"], o.yapilar[&"kervansaray"], o.yapilar[&"konak"]], donuk, " ".join(iz)])
