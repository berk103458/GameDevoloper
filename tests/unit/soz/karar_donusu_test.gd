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
		g.kapi_sozu().kapi_karar(&"kabul", func() -> Dictionary: return o.karar_ver(g, &"kabul"), o.yonetim, "")
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
			var spawn_kaydi: Dictionary = yuklenen.gecikmeli_kuyruk[0]
			var vade := int(spawn_kaydi.hedef_gun)
			var ilk_tehdit := int(TehditTakvimi.AYAR.tehdit_baslangic_gunu)
			var eski_adli_olasiligi := yuklenen.ayarlar.adli_olasiligi
			yuklenen.ayarlar.adli_olasiligi = 0.0
			if vade < ilk_tehdit:
				yuklenen.gun = vade
				var erken_kuyruk := yuklenen.gece_kuyrugu()
				if erken_kuyruk.any(func(kisi: Gelen) -> bool: return kisi.id == &"chr_004") or bool(spawn_kaydi.spawned):
					hatalar.append("Vade tehdit takviminden önceyse kayıt sonraki geceye kalmalı!")
			yuklenen.gun = maxi(vade, ilk_tehdit)
			yuklenen.sonraki_gelen_ek = GelenAkisi.tavan()
			var beklenen_kuyruk := yuklenen.gece_kuyrugu()
			yuklenen.ayarlar.adli_olasiligi = eski_adli_olasiligi
			var geldi := false
			for gelen_kisi in beklenen_kuyruk:
				if String(gelen_kisi.id).to_lower() == "chr_004":
					geldi = true
					break
			if not geldi:
				hatalar.append("Vadesi gelen tek spawn kuyruğu gece_kuyrugu içinde görünmeli!")
			var dolu_oturum := Oturum.kayittan(kat, paket)
			dolu_oturum.gun = maxi(vade, ilk_tehdit)
			var dolu_kuyruk: Array[Gelen] = []
			for i in GelenAkisi.tavan():
				var ozel := Gelen.new()
				ozel.set_meta(&"har05_goc", true)
				dolu_kuyruk.append(ozel)
			KararDonusu.spawn_ekle(dolu_oturum, dolu_kuyruk)
			var sinirli := GelenAkisi.kuyrugu_temizle_ve_sinirla(dolu_oturum, dolu_kuyruk)
			if sinirli.any(func(kisi: Gelen) -> bool: return kisi.id == &"chr_004") or bool(dolu_oturum.gecikmeli_kuyruk[0].spawned):
				hatalar.append("Özel ziyaretler kuyruğu doldurduğunda gecikmeli ziyaret kaybolmamalı!")

		# 9. DYL-08 gerçek gece_sonu: 2/gün sınırı (3. aynı kuyrukta kalır), ölen -> haberci, tanıklı/tanıksız dedikodu, tek sefer bar, SAB-01'e yazmaz
		var o2 := Oturum.new(kat, 77)
		o2.yonetim.koylular.clear()
		o2.gecikmeli_kuyruk = [
			{"chr_id": "chr_001", "karar": "ret", "hedef_sistem": "bar", "alan": "Adalet", "deger": -2, "tur_offset": 2, "eklenme_gunu": 0, "hedef_gun": 2, "uygulandi": false, "tanikli": false, "kanal": "sabah", "olay_id": "d1_bar", "metin": "Bar değişti"},
			{"chr_id": "chr_002", "karar": "ret", "hedef_sistem": "dedikodu", "alan": "Etki", "deger": 1, "tur_offset": 2, "eklenme_gunu": 0, "hedef_gun": 2, "uygulandi": false, "tanikli": true, "kanal": "koylu", "olay_id": "d2_ded", "metin": "Tanıklı dönüş haberi"},
			{"chr_id": "chr_003", "karar": "ret", "hedef_sistem": "dedikodu", "alan": "Etki", "deger": 1, "tur_offset": 2, "eklenme_gunu": 0, "hedef_gun": 2, "uygulandi": false, "tanikli": false, "kanal": "koylu", "olay_id": "d3_taniksiz", "metin": "Tanıksız satır"},
		]
		o2.kadro.durumlar[&"chr_002"]["durum"] = &"oldu"
		o2.yonetim.gun = 2
		var sabah_once: Dictionary = SabahDefteri.durum(o2.yonetim).duplicate(true)
		var adalet_once := o2.yonetim.adalet
		var rapor2 := o2.gece_sonu()
		var donen2: Array = rapor2.get("rapor", {}).get("karar_donusleri", [])
		if donen2.size() != 2:
			hatalar.append("Günde en çok 2 dönüş işlenmeli, işlenen: %d" % donen2.size())
		if String(donen2[1].get("kanal", "")) != "haberci" or not bool(donen2[1].get("gitti", false)):
			hatalar.append("Ölen karakter dönüşü yalnız haberci kanalına yönlenmeli!")
		if bool(o2.gecikmeli_kuyruk[2].get("uygulandi", false)):
			hatalar.append("3. dönüş ertesi güne aynı kuyrukta beklemeli!")
		if o2.yonetim.adalet == adalet_once:
			hatalar.append("DYL-08 bar etkisi bir kez uygulanmalıydı!")
		var adalet_iki := o2.yonetim.adalet
		if o2.dedikodu.kaydet().get("kayitlar", []).size() != 1:
			hatalar.append("Tanıklı dönüş mevcut dedikodu kaydına tam 1 satır düşmeli!")
		if JSON.stringify(SabahDefteri.durum(o2.yonetim)) != JSON.stringify(sabah_once):
			hatalar.append("DYL-08 SAB-01 sabah defterine yazmamalı!")
		# Ertesi gece 3. dönüş tanıksız olduğundan 0 dedikodu ekler ve önceki bar tekrar uygulanmaz
		o2.yonetim.gun = 3
		o2.gece_sonu()
		if o2.yonetim.adalet != adalet_iki:
			hatalar.append("Aynı dönüş ertesi gecede barı ikinci kez değiştirmemeli!")
		if o2.dedikodu.kaydet().get("kayitlar", []).size() != 1:
			hatalar.append("Tanıksız dönüş dedikoduya 0 satır düşmeli!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("GEÇTİ: karar_donusu_test.gd")
	quit(0)
