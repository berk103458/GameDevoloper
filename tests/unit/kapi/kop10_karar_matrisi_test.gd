## KOP-10: Kapıdaki sayı, kişinin karar matrisinden gelir.
## Test: CHR_017 kabul ve sır çözülmüşken Erzak +2 ve Moral +2 köy barına bir kez yazar;
## sınıf şablonu o ziyarette yazmaz. Adsız diyalog_01 kabulü şablondan gelir.
## Dört karar türü (kabul, ret, rusvet, kisla), iki varyant (Flag_Sir_Tamamen_Cozuldu true/false),
## rüşvet akçesi yalnız kişisel kasada (muhafiz_akce) ve matriste olmayan karar düğmesi görünmez.
extends SceneTree

var hata := 0


func _initialize() -> void:
	var kat := Katalog.new()
	if kat.yukle() != Katalog.Durum.HAZIR:
		_hata("Katalog yüklenemedi")
		quit(1)
		return

	# 1. CHR_017 kabul + Flag_Sir_Tamamen_Cozuldu = true -> Erzak +2 ve Moral +2 bir kez yazar; sınıf şablonu yazmaz.
	var o1 := Oturum.new(kat, 1010)
	var k1 := o1.yonetim.kabul({"ad": "Ahmet", "sinif": "ciftci"})
	k1.moral = 50
	var erzak_once := o1.ambar
	var adalet_once := o1.yonetim.adalet
	var akce_once := o1.akce
	var g17 := o1._adli_gelen(&"chr_017")
	_kontrol(g17.etkiler.is_empty(), "Adlı CHR ziyaretinde sınıf şablonu etkileri (g.etkiler) boş kalmalı")
	var s17 := g17.chr_sorgusu()
	_kontrol(s17 != null, "CHR_017 sorgusu açılmalı")
	s17.bayraklar["Flag_Sir_Tamamen_Cozuldu"] = true
	var sonuc1 := o1.karar_ver(g17, &"kabul")
	_kontrol(not sonuc1.get("engellendi", false) and bool(sonuc1.get("kaldi", false)), "CHR_017 kabul edilmeli")
	_kontrol(sonuc1.get("chr_stat_etkisi", {}) == {"Erzak": 2, "Moral": 2}, "Seçilen varyant Erzak +2 ve Moral +2 olmalı")
	_kontrol(o1.ambar == erzak_once + 2, "Erzak +2 köy ambarına tam bir kez yazılmalı (beklenen %d, gerçek %d)" % [erzak_once + 2, o1.ambar])
	# Sınıf şablonu (etki_kabul = [1, 0, 0, 0] -> +5 moral) uygulanmadığı için mevcut köylünün morali yalnız +2 artmalı.
	_kontrol(k1.moral == 52, "Mevcut köylü morali şablon (+5) değil matris (+2) kadar artmalı (gerçek %d)" % k1.moral)
	_kontrol(o1.yonetim.adalet == adalet_once and o1.akce == akce_once, "Şablon dışı barlar (adalet/akçe) değişmemeli")

	# 2. İkinci varyant: CHR_017 kabul + Flag_Sir_Tamamen_Cozuldu = false -> anlık stat etkisi {} (0 değişim).
	var o2 := Oturum.new(kat, 1011)
	var k2 := o2.yonetim.kabul({"ad": "Mehmet", "sinif": "ciftci"})
	k2.moral = 50
	var erzak2_once := o2.ambar
	var g17_gizli := o2._adli_gelen(&"chr_017")
	var s17_gizli := g17_gizli.chr_sorgusu()
	s17_gizli.bayraklar["Flag_Sir_Tamamen_Cozuldu"] = false
	var sonuc2 := o2.karar_ver(g17_gizli, &"kabul")
	_kontrol(sonuc2.get("chr_stat_etkisi", {}).is_empty(), "Sır gizliyken CHR_017 kabul varyantı anlık stat yazmamalı")
	_kontrol(o2.ambar == erzak2_once and k2.moral == 50, "Sır gizliyken ambar ve moral değişmemeli")

	# 3. Dört karar türü: kisla, rusvet, ret (gonullu_ret ve zorunlu_ret)
	# 3a. Kışla: CHR_017 kisla -> Guvenlik +1 (asayis_riski -1), Moral -3
	var o_kisla := Oturum.new(kat, 1012)
	var k_kisla := o_kisla.yonetim.kabul({"ad": "Veli", "sinif": "ciftci"})
	k_kisla.moral = 60
	o_kisla.yonetim.asayis_riski = 20
	var g17_kisla := o_kisla._adli_gelen(&"chr_017")
	var sonuc_kisla := o_kisla.karar_ver(g17_kisla, &"kisla")
	_kontrol(sonuc_kisla.get("chr_stat_etkisi", {}) == {"Guvenlik": 1, "Moral": -3}, "CHR_017 kışla stat etkisi Guvenlik +1, Moral -3 olmalı")
	_kontrol(o_kisla.yonetim.asayis_riski == 19 and k_kisla.moral == 57, "Kışla kararı asayiş riskini 1 düşürüp morali 3 azaltmalı")

	# 3b. Rüşvet: CHR_001 rusvet -> muhafiz_akce +4 yalnız kişisel kasada, kamu kasasına ikinci yazım yok
	var o_rusvet := Oturum.new(kat, 1013)
	var kamu_once := o_rusvet.akce
	var kisisel_once := o_rusvet.muhafiz_akce
	var g01_rusvet := o_rusvet._adli_gelen(&"chr_001")
	g01_rusvet.heybe = o_rusvet.heybe_uret(g01_rusvet.sinif)
	var sonuc_rusvet := o_rusvet.karar_ver(g01_rusvet, &"rusvet")
	_kontrol(o_rusvet.muhafiz_akce == kisisel_once + 4, "CHR_001 rüşvet akçesi (+4) kişisel kasaya yazılmalı")
	_kontrol(o_rusvet.akce == kamu_once, "Rüşvet akçesi kamu kasasına ikinci kez yazılmamalı (beklenen %d, gerçek %d)" % [kamu_once, o_rusvet.akce])
	_kontrol(sonuc_rusvet.get("chr_stat_etkisi", {}).is_empty(), "CHR_001 rüşvet anlık stat etkisi boş olmalı")

	# 3c. Ret (gonullu_ret ve zorunlu_ret): sınıf şablonu etki_ret (-1 halk -> -5 moral) uygulanmaz
	var o_ret := Oturum.new(kat, 1014)
	var k_ret := o_ret.yonetim.kabul({"ad": "Hasan", "sinif": "ciftci"})
	k_ret.moral = 50
	var g17_ret := o_ret._adli_gelen(&"chr_017")
	g17_ret.tehlikeli = true # yonetim.ret haksız ret cezası yazmasın, yalnız karar matrisi vs şablon ölçülsün
	var sonuc_ret := o_ret.karar_ver(g17_ret, &"ret")
	_kontrol(not bool(sonuc_ret.get("kaldi", true)) and k_ret.moral == 50, "Adlı CHR gönüllü rette sınıf şablonu (-5 moral) uygulanmamalı")

	# 4. Adsız diyalog_01 kabulü sınıf şablonundan gelir.
	var o_figur := Oturum.new(kat, 1015)
	var k_figur := o_figur.yonetim.kabul({"ad": "Köylü", "sinif": "ciftci"})
	k_figur.moral = 50
	var adalet_f_once := o_figur.yonetim.adalet
	var akce_f_once := o_figur.akce
	var asayis_f_once := o_figur.yonetim.asayis_riski
	var g_figur := o_figur._figur_gelen()
	_kontrol(g_figur.chr_sorgusu() == null and not g_figur.etkiler.is_empty(), "Adsız diyalog_01 ziyaretçisi şablon etkilerini taşımalı")
	var beklenen_bar: PackedInt32Array = g_figur.etkiler[&"kabul"]
	var sonuc_figur := o_figur.karar_ver(g_figur, &"kabul")
	_kontrol(not sonuc_figur.has("chr_stat_etkisi"), "Adsız ziyarette chr_stat_etkisi alanı olmamalı")
	var degisim_var := (
		k_figur.moral != 50
		or o_figur.yonetim.adalet != adalet_f_once
		or o_figur.akce != akce_f_once
		or o_figur.yonetim.asayis_riski != asayis_f_once
	)
	_kontrol(beklenen_bar.size() == 4 and degisim_var, "Adsız diyalog_01 kabulü sınıf şablonundan bar etkisi uygulamalı")

	# 5. Uç durum: Matriste olmayan bir karar düğmesi kapıda görünmez ve karar_acik false döner.
	var g_eksik := o1._adli_gelen(&"chr_017")
	var s_eksik := g_eksik.chr_sorgusu()
	s_eksik.karakter = s_eksik.karakter.duplicate(true)
	s_eksik.karakter.karar_matrisi.erase("kisla")
	var suzulen := ChrKararMatrisi.gorunen_secenekler(s_eksik, PackedStringArray(["kabul", "ret", "rusvet", "kisla"]))
	_kontrol(not suzulen.has("kisla") and suzulen.has("kabul"), "Matriste olmayan kışla düğmesi görünür seçeneklerden elenmeli")
	_kontrol(not s_eksik.karar_acik(&"kisla"), "Matriste olmayan karar düğmesi karar_acik(kisla) == false dönmeli")

	print("KOP10 KARAR MATRISI: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		_hata(mesaj)


func _hata(mesaj: String) -> void:
	hata += 1
	push_error(mesaj)
