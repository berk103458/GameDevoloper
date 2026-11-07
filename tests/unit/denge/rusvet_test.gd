extends SceneTree

func _initialize() -> void:
	var kat := Katalog.new()
	if kat.yukle() != Katalog.Durum.HAZIR:
		push_error("Katalog yüklenemedi")
		quit(1)
		return
	var o := Oturum.new(kat, 4343)
	var bina := KoyBinasi.new()
	bina.id = 90
	bina.tur = "bez_evi"
	o.yonetim.binalar.append(bina)
	var esnaf := o.yonetim.kabul({"ad": "Çalışan esnaf", "sinif": "esnaf"})
	esnaf.is_yeri = bina.id
	var harac_once := JSON.stringify(o.kaydet())
	for tekrar in 20:
		var harac := MuhafizYetenekleri.harac(o)
		if int(harac.akce) != 0 or int(harac.kisi) != 0:
			push_error("DEN-46: yetenek kapalıyken haraç sıfır olmalı")
			quit(1)
			return
	if JSON.stringify(o.kaydet()) != harac_once:
		push_error("DEN-46: kapalı haraç kasa, moral veya gece makbuzu yazmamalı")
		quit(1)
		return
	var once := MuhafizTerazisi.durum(o)
	var g := Gelen.new()
	g.id = &"den43_rusvet"
	o.karar_ver(g, &"rusvet")
	var sonra := MuhafizTerazisi.durum(o)
	var agirlik := float(MuhafizTerazisi.AYAR.rusvet_agirlik)
	if int(sonra.rusvet) != int(once.rusvet) + 1 or int(sonra.yozlasma) != int(once.yozlasma) + int(agirlik):
		push_error("DEN-43: tek rüşvet mevcut skoru tek kez artırmalı")
		quit(1)
		return
	var kayit := JSON.stringify(o.kaydet())
	for tekrar in 20:
		MuhafizTerazisi.durum(o)
		DengeOlcumu.olustur(o, {})
	if JSON.stringify(o.kaydet()) != kayit:
		push_error("DEN-43: skor gözlemi ikinci kez yazmamalı")
		quit(1)
		return

	# DEN-41: Rüşvet kişisel kasaya gider (20 kararda köy akçesi sabit, kişisel kasa artar).
	# DEN-42: Matris 3 ise kişisel kasa +3 artar (KVR -4..+4 kıskacı stat içindir, akçe tavanı matriste kalır).
	var o_rusvet := Oturum.new(kat, 4141)
	var baslangic_koy_akce := o_rusvet.akce
	var baslangic_kisisel_akce := o_rusvet.muhafiz_akce
	var beklenen_kisisel_artis := 0
	for i in range(20):
		var chr_no := (i % 30) + 1
		var gelen_r := o_rusvet._adli_gelen(StringName("chr_%03d" % chr_no))
		gelen_r.heybe = o_rusvet.heybe_uret(gelen_r.sinif)
		var sorgu_r := gelen_r.chr_sorgusu()
		if i == 0:
			sorgu_r.karakter = sorgu_r.karakter.duplicate(true)
			sorgu_r.karakter.karar_matrisi["rusvet"]["muhafiz_akce"] = 3
		var matris_akce := int(sorgu_r.karakter.karar_verisi(&"rusvet").get("muhafiz_akce", 0))
		beklenen_kisisel_artis += matris_akce
		var kasa_once_i := o_rusvet.muhafiz_akce
		o_rusvet.karar_ver(gelen_r, &"rusvet")
		if i == 0 and (o_rusvet.muhafiz_akce - kasa_once_i) != 3:
			push_error("DEN-42: matris 3 ise kişisel kasa +3 olmalı")
			quit(1)
			return
		if o_rusvet.akce != baslangic_koy_akce:
			push_error("DEN-41: %d. rüşvet kararında köy akçesi değişmemeli (%d != %d)" % [i + 1, o_rusvet.akce, baslangic_koy_akce])
			quit(1)
			return
	if (o_rusvet.muhafiz_akce - baslangic_kisisel_akce) != beklenen_kisisel_artis or beklenen_kisisel_artis <= 0:
		push_error("DEN-41: 20 rüşvet kararında kişisel kasa matris toplamı kadar artmalı (%d != %d)" % [o_rusvet.muhafiz_akce - baslangic_kisisel_akce, beklenen_kisisel_artis])
		quit(1)
		return

	# DEN-45: Adil uçta rüşvet reddi kasayı büyütmez (20 rette kişisel kasa deltası 0).
	var o_ret := Oturum.new(kat, 4545)
	var ret_once_kisisel := o_ret.muhafiz_akce
	var ret_once_koy := o_ret.akce
	for i in range(20):
		var chr_no := (i % 30) + 1
		var gelen_ret := o_ret._adli_gelen(StringName("chr_%03d" % chr_no))
		o_ret.karar_ver(gelen_ret, &"gonullu_ret" if i % 2 == 0 else &"zorunlu_ret")
	if (o_ret.muhafiz_akce - ret_once_kisisel) != 0 or (o_ret.akce - ret_once_koy) != 0:
		push_error("DEN-45: 20 ret kararında kasa deltası 0 olmalı (kişisel=%d, kamu=%d)" % [o_ret.muhafiz_akce - ret_once_kisisel, o_ret.akce - ret_once_koy])
		quit(1)
		return

	print("RÜŞVET ÖLÇÜMÜ: GEÇTİ")
	quit()
