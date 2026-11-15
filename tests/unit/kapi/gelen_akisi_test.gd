## KAP-16: değişken gelen sayısı, boş gün, canlı bar spawn eşiği ve kuyruk bütünlüğü.
extends SceneTree

var _hata := 0


func dene(kosul: bool, mesaj: String) -> void:
	if kosul:
		return
	_hata += 1
	push_error("KAP-16 HATA: " + mesaj)


func _gd_atama_say(dizin: String) -> int:
	var toplam := 0
	var da := DirAccess.open(dizin)
	if da == null:
		return 0
	da.list_dir_begin()
	var ad := da.get_next()
	while ad != "":
		var yol := dizin.path_join(ad)
		if da.current_is_dir():
			if not ad.begins_with("."):
				toplam += _gd_atama_say(yol)
		elif ad.ends_with(".gd"):
			var metin := FileAccess.get_file_as_string(yol)
			if metin.contains("gece_basina_gelen = 3") or metin.contains("gece_basina_gelen=3"):
				toplam += 1
		ad = da.get_next()
	da.list_dir_end()
	return toplam


func _kimlik_dizisi(kat: Katalog, tohum: int, gece_sayisi: int) -> Array:
	var o := Oturum.new(kat, tohum)
	o.yonetim.a = o.yonetim.a.duplicate(true)
	o.yonetim.kaynaklar = Kaynaklar.new(10000, {"gida": 5000, "odun": 5000})
	var imzalar: Array = []
	for g_no in gece_sayisi:
		o.gun = g_no
		o.kadro.gece_bitti()
		var gun_listesi: Array = []
		for g in o.gece_kuyrugu():
			gun_listesi.append("%s:%s:%s" % [String(g.id), String(g.sinif), g.ad_anahtari])
		imzalar.append(gun_listesi)
	return imzalar


func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var cfg := GelenAkisi.ayar()
	var min_g := int(cfg.get("min_gelen", 0))
	var tavan := GelenAkisi.tavan()
	dene(tavan == 3, "data/gelen_akisi.json tavan 3 olmali")
	dene(_gd_atama_say("res://src") == 0, ".gd icinde gece_basina_gelen = 3 atamasi 0 olmalidir")

	# 1. 100 tohumlu 28 gun kosusu: bos gun >= 4 ve tablo araligi [min_gelen, tavan].
	var min_bos := 999
	for tohum in range(1001, 1101):
		var o := Oturum.new(kat, tohum)
		var bos_say := 0
		for gun_no in 28:
			o.gun = gun_no
			var s := GelenAkisi.gunluk_sayi(o)
			dene(s >= min_g and s <= tavan, "Gelen sayisi tablo araliginda olmali (tohum=%d, gun=%d, s=%d)" % [tohum, gun_no, s])
			if s == 0:
				bos_say += 1
		min_bos = mini(min_bos, bos_say)
		dene(bos_say >= 4, "Tohum %d icin 28 gunde en az 4 bos gun olmali (bulunan=%d)" % [tohum, bos_say])
	print("KAP-16 100 tohum en az bos gun: %d/28" % min_bos)

	# 2. Mevsim (kis dusurur), cekicilik ve dunya olayi etkisi.
	var om := Oturum.new(kat, 4242)
	for i in 4:
		var k := om.yonetim.kabul({"ad": "Koylu %d" % i, "sinif": "ciftci"})
		k.refah = 45
	om.gun = 0 # Ilkbahar
	var ilkbahar_sayi := GelenAkisi.gunluk_sayi(om)
	IklimDeneyi.degistir(om, 3, "normal") # Kis
	var kis_sayi := GelenAkisi.gunluk_sayi(om)
	dene(kis_sayi < ilkbahar_sayi or kis_sayi <= 1, "Kis mevsiminde gelen sayisi duser (ilkbahar=%d, kis=%d)" % [ilkbahar_sayi, kis_sayi])
	IklimDeneyi.degistir(om, 0, "normal")
	om.yonetim.asayis_riski = 85
	for k in om.yonetim.koylular:
		k.refah = 5
	var kotu_cekicilik := GelenAkisi.cekicilik_sayisi(om)
	om.yonetim.asayis_riski = 0
	for k in om.yonetim.koylular:
		k.refah = 95
	var iyi_cekicilik := GelenAkisi.cekicilik_sayisi(om)
	dene(iyi_cekicilik > kotu_cekicilik, "Yuksek refah ve guvenlik cekiciligi artirir")
	var baz_carpan := GelenAkisi.dunya_olayi_carpani(om)
	om.dunya_zamani = {"isaretler": ["selcuklu_taht_kavgasi.etki"]}
	dene(GelenAkisi.dunya_olayi_carpani(om) > baz_carpan, "selcuklu_taht_kavgasi dunya olayi gelen_akisi carpanini artirir")

	# 3. Perde 2 perde 1 formulunu kullanmaz; perde2_gece_basina_gelen okur.
	var op2 := Oturum.new(kat, 777)
	op2.yonetim.agalik = true
	op2.ayarlar = op2.ayarlar.duplicate(true)
	op2.ayarlar.perde2_gece_basina_gelen = 5
	dene(GelenAkisi.gunluk_sayi(op2) == 5, "Perde 2 perde2_gece_basina_gelen degerini okur")

	# 4. Fadime (CHR_017) canli Moral < 6 kosulu + Gozcu bos gun raporu.
	var ofad := Oturum.new(kat, 515)
	ofad.gun = 10 # Tur > 3 saglanir
	for i in 2:
		var fk := ofad.yonetim.kabul({"ad": "Sadik %d" % i, "sinif": "ciftci"})
		fk.moral = 70 # huzur = 7.0 (>= 6)
	dene(not (&"chr_017" in GelenAkisi.uygun_adaylar(ofad, ofad.gun)), "Moral >= 6 iken Fadime (CHR_017) aday olamaz")
	for fk in ofad.yonetim.koylular:
		fk.moral = 40 # huzur = 4.0 (< 6)
	dene(&"chr_017" in GelenAkisi.uygun_adaylar(ofad, ofad.gun), "Moral < 6 ve Tur > 3 iken Fadime aday olur")

	# Bos gun Gozcu ozeti (kapisi acik ama bos gun = 0 ziyaret)
	var ogz := Oturum.new(kat, 1001)
	var bos_gun_no := -1
	for d in 28:
		ogz.gun = d
		if GelenAkisi.gunluk_sayi(ogz) == 0:
			bos_gun_no = d
			break
	dene(bos_gun_no > 0, "1001 tohumunda en az 1 bos gun bulunur")
	ogz.gun = bos_gun_no
	var bos_k := ogz.gece_kuyrugu()
	dene(bos_k.is_empty() and OzelOlay.bos_mu(ogz), "Bos gunde kapi acik, kuyruk bos ve bos_gun=true")
	dene(preload("res://src/sistemler/gozcu_kafile_ozeti.gd").metin({"toplam": 0, "yolcu": 0, "tuccar": 0, "heyetler": []}).contains("beklenen kapı ziyareti yok"), "Gozcu bos gunu bildirir")

	# 5. Ek sartlar: tekrar yok, ayrilmis/olu kimlik yok, tavan 3 ve ertesi gune tasirma yok, ayni gece cikan donmez.
	var ot := Oturum.new(kat, 333)
	ot.gun = 8
	ot.kadro.durumlar[&"chr_001"]["durum"] = &"kalici_ayrildi"
	ot.sonraki_gelen_ek = 7
	var tavan_k := ot.gece_kuyrugu()
	dene(tavan_k.size() <= 3, "Tavan 3 iken kuyruk 3'u gecmez (bulunan=%d)" % tavan_k.size())
	dene(ot.sonraki_gelen_ek == 0, "Tavan fazlasi sonraki_gelen_ek'e birakilmaz")
	var seen_ids := {}
	for g in tavan_k:
		dene(g.id != &"chr_001", "kalici_ayrildi kimlik kuyruga girmez")
		if g.id != &"":
			dene(not seen_ids.has(g.id), "Ayni gecede kadro kimligi tekrarlamaz")
			seen_ids[g.id] = true
	ot.gun = 9
	dene(ot.gece_kuyrugu().size() <= 3, "Ertesi gece tavan fazlasi tasinmaz")

	# Ayni gece karar verilip cikan kisi o gece tekrar kuyruga donmez.
	var oc := Oturum.new(kat, 444)
	oc.gun = 6
	var ilk_g := oc._adli_gelen(&"chr_006")
	oc.karar_ver(ilk_g, &"ret")
	var duble_deneme: Array[Gelen] = [ilk_g, oc._adli_gelen(&"chr_006")]
	var suzulen := GelenAkisi.kuyrugu_temizle_ve_sinirla(oc, duble_deneme)
	dene(suzulen.is_empty(), "Ayni gece kapidan cikan kimlik kuyruga geri yazilmaz")

	# 6. Determinizm: ayni tohum iki kosunun ilk 6 gecesi aynidir.
	var sira_a := _kimlik_dizisi(kat, 2026, 6)
	var sira_b := _kimlik_dizisi(kat, 2026, 6)
	dene(sira_a == sira_b, "Ayni tohumla iki kosunun ilk 6 gecesinin kimlik sirasi aynidir")

	# 7. Durgun bar kosul parseri & tur siniri kontrolu (chr_runtime).
	dene(GelenAkisi.bar_kosulu_uygun(ofad, "Tur > 3 ve Moral < 6"), "Moral < 6 iken bar_kosulu_uygun dogru")
	for fk in ofad.yonetim.koylular:
		fk.moral = 65
	dene(not GelenAkisi.bar_kosulu_uygun(ofad, "Tur > 3 ve Moral < 6"), "Moral >= 6 iken bar_kosulu_uygun yanlis")

	print("GELEN AKISI: %s" % ("GEÇTİ" if _hata == 0 else "KALDI (%d hata)" % _hata))
	quit(0 if _hata == 0 else 1)
