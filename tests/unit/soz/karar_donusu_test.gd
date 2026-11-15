# gdlint: disable=max-line-length
extends SceneTree

const KararDonusu = preload("res://src/soz/karar_donusu.gd")
const ChrSozlesmesi = preload("res://src/veri/chr_sozlesmesi.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	# 1. 2 gün geçmeden dönüş olmaz
	var erken := KararDonusu.donus_hesapla({"karar": "ret"}, 1)
	if erken.get("donus_var", true):
		hatalar.append("2 gün geçmeden erken dönüş tetiklendi!")

	# 2. Ret ve yalan yakalanmışsa çete intikam haberi döner
	var intikam := KararDonusu.donus_hesapla({"karar": "ret", "yalan_yakalandi": true}, 3)
	if not intikam.get("donus_var") or intikam.get("tur") != "intikam_haberi":
		hatalar.append("Yalanı yakalanıp kovulanın intikam haberi dönmedi!")

	# 3. Kabul edilen köylünün akraba gelişi tetiklenir
	var kabul_donus := KararDonusu.donus_hesapla({"karar": "kabul"}, 3)
	if not kabul_donus.get("donus_var") or kabul_donus.get("tur") != "akraba_gelisi":
		hatalar.append("Kabul edilen köylünün akraba gelişi tetiklenmedi!")

	# 4. YAP-37: Defter sözü DYL-08 ile dönebilir (ikinci dönüş motoru yok)
	var defter_kabul := KararDonusu.donus_hesapla({"karar": "kabul", "defter_id": "usta_defteri_marangoz"}, 3)
	if not defter_kabul.get("donus_var") or defter_kabul.get("tur") != "defter_sozu_donusu" or defter_kabul.get("defter_id") != "usta_defteri_marangoz":
		hatalar.append("YAP-37 defter sözü DYL-08 dönüşü tetiklenmedi!")
	var defter_ret := KararDonusu.donus_hesapla({"karar": "ret", "defter_id": "usta_defteri_marangoz"}, 3)
	if not defter_ret.get("donus_var") or defter_ret.get("tur") != "defter_kaybi_haberi":
		hatalar.append("YAP-37 reddedilen defter kaybı haberi DYL-08 ile dönmedi!")

	# 5. KOP-04: hedef_sistem yalnız bar, dedikodu, spawn, kuyu_zehri, ambar_kundak değerlerini alır
	for hs in ["bar", "dedikodu", "spawn", "kuyu_zehri", "ambar_kundak"]:
		if not KararDonusu.gecikmeli_satir_gecerli_mi({"hedef_sistem": hs, "alan": "Erzak", "deger": -2, "tur_offset": 3}):
			hatalar.append("Geçerli hedef_sistem reddedildi: %s" % hs)
	if KararDonusu.gecikmeli_satir_gecerli_mi({"hedef_sistem": "uydurma_sistem", "alan": "Erzak", "deger": -2, "tur_offset": 3}):
		hatalar.append("Geçersiz hedef_sistem doğrulamadan geçti!")
	if ChrSozlesmesi.gecikmeli_hatalari([{"tur_offset": 3, "hedef_bina": "Ambar", "olay_id": "Test", "hedef_sistem": "yanlis", "alan": "Erzak", "deger": -2, "stat_etkisi": {"Erzak": -2}}]).is_empty():
		hatalar.append("ChrSozlesmesi geçersiz hedef_sistem değerini yakalamadı!")

	# 6. KOP-04: Yusuf'un (CHR_003) kabul dönüşü tek kuyrukta tek satırdır; aynı karar iki kez yazılmaz
	var tek_kuyruk: Array = []
	var yusuf_spawns := {"on_accept": {"entity_id": &"CHR_012", "offset": 3}}
	var yusuf_satir_1 := KararDonusu.tek_kuyruga_yaz(tek_kuyruk, yusuf_spawns, {"chr_id": "CHR_003", "karar": "kabul"}, 3)
	var yusuf_satir_2 := KararDonusu.tek_kuyruga_yaz(tek_kuyruk, yusuf_spawns, {"chr_id": "CHR_003", "karar": "kabul"}, 3)
	if tek_kuyruk.size() != 1:
		hatalar.append("Yusuf'un kabul dönüşü kayıtta tek satır olmalı, bulunan: %d" % tek_kuyruk.size())
	if yusuf_satir_1 != yusuf_satir_2 or String(yusuf_satir_1.get("deger", "")) != "CHR_012":
		hatalar.append("Yusuf'un kabul dönüşü sonraki_spawns ile birleşmedi!")

	# 7. KOP-09: Sayfası olmayan spawn hedefi ChrSozlesmesi tarafından reddedilir
	if ChrSozlesmesi.spawn_hatalari({"on_accept": {"entity_id": &"CHR_099", "offset": 3}}).is_empty():
		hatalar.append("KOP-09: Sayfası olmayan CHR_099 spawn doğrulamasından geçti!")

	# 8. KOP-04 gerçek oyun akışı: Oturum.karar_ver -> tek gecikmeli_kuyruk -> kaydet/yukle -> gece_kuyrugu
	var kat := Katalog.new()
	if kat.yukle() != Katalog.Durum.HAZIR:
		hatalar.append("Katalog yüklenemedi!")
	else:
		var o := Oturum.new(kat, 42)
		var g: Gelen = o._adli_gelen(&"chr_001")
		o.karar_ver(g, &"kabul")
		if o.gecikmeli_kuyruk.size() != 1:
			hatalar.append("Oturum.karar_ver tek gecikmeli_kuyruk satırı üretmeli, bulunan: %d" % o.gecikmeli_kuyruk.size())
		o.karar_ver(g, &"kabul")
		if o.gecikmeli_kuyruk.size() != 1:
			hatalar.append("Aynı karar iki kez tek kuyruğa yazılmamalı!")
		if not o.gecikmeli_kuyruk.is_empty():
			var kayit_satir: Dictionary = o.gecikmeli_kuyruk[0]
			if String(kayit_satir.get("hedef_sistem", "")) != "spawn" or String(kayit_satir.get("deger", "")) != "CHR_004":
				hatalar.append("chr_001 kabul sonrası sonraki_spawns CHR_004 tek kuyruğa yazılmalı!")
		var paket := o.kaydet()
		var yuklenen := Oturum.kayittan(kat, paket)
		if yuklenen == null or yuklenen.gecikmeli_kuyruk.size() != 1:
			hatalar.append("Kayıt/yükleme sonrasında gecikmeli_kuyruk korunmalı!")
		elif o.katalog.karakter(&"chr_004") != null:
			yuklenen.yonetim.gun = 10
			var beklenen_kuyruk := yuklenen.gece_kuyrugu()
			var geldi := false
			for gelen_kisi in beklenen_kuyruk:
				if String(gelen_kisi.id).to_lower() == "chr_004":
					geldi = true
					break
			if not geldi:
				hatalar.append("Vadesi gelen tek spawn kuyruğu gece_kuyrugu içinde görünmeli!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: karar_donusu_test.gd")
	quit(0)
