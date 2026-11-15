extends SceneTree

const IlkSaatSinifi = preload("res://src/sistemler/ilk_saat.gd")
const ZarIpucuSinifi = preload("res://src/kapi/zar_ipucu.gd")
const SonKilidiSinifi = preload("res://src/sistemler/son_kilidi.gd")
const NihaiSonSinifi = preload("res://src/sistemler/nihai_son.gd")
const IpucuKaydiSinifi = preload("res://src/sistemler/ipucu_kaydi.gd")
const IpucuSeridiSinifi = preload("res://src/arayuz/ipucu_seridi.gd")
const IpucuPaneliSinifi = preload("res://src/debug/ipucu_paneli.gd")
const YeniDugmeIsaretiSinifi = preload("res://src/arayuz/koy_hud/yeni_dugme_isareti.gd")

var _hata: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("ILK SAAT TEST HATASI: " + mesaj)


func _initialize() -> void:
	var ilk := IlkSaatSinifi.new()
	var kavramlar := ilk.kavramlar()
	_kontrol(kavramlar.size() == 9, "ilk_saat.json icinde 9 temel kavram olmali")
	_kontrol(kavramlar.size() <= 20, "OGR-45: ilk_saat.json kavram sayisi <= 20 olmali")
	for k in kavramlar:
		_kontrol(k.has("gece_min") and k.has("tetik"), "Her kavramin gece_min ve tetik alani olmali")
		_kontrol(k.has("atla_gecmis") and k["atla_gecmis"] is Array, "OGR-37: Her kavramda atla_gecmis listesi olmali")

	# OGR-37: Iki gecmisle ipucu kumesi farki >= 1
	var levent_kume := ilk.gecmis_icin_ipuclari("eski_levent")
	var medrese_kume := ilk.gecmis_icin_ipuclari("medrese_talebesi")
	var fark := 0
	for id_a in levent_kume:
		if not medrese_kume.has(id_a):
			fark += 1
	for id_b in medrese_kume:
		if not levent_kume.has(id_b):
			fark += 1
	_kontrol(fark >= 1, "OGR-37: iki gecmisle ipucu kumesi farki >= 1 olmali")

	# OGR-38: Atlanan kavramın yerine tek bir kişisel satır gelir.
	for k in kavramlar:
		for gecmis in k.atla_gecmis:
			var oz := IlkSaatSinifi.new()
			var sonuc := oz.tetikle(k.id, k.gece_min, gecmis)
			var metin := String(sonuc.get("gecmis_metni", ""))
			_kontrol(not sonuc.gosterildi and not metin.is_empty() and metin.length() <= 70 and not metin.begins_with("ogretici."), "OGR-38: " + gecmis)
			_kontrol(not oz.tetikle(k.id, k.gece_min, gecmis).has("gecmis_metni"), "OGR-38: Aynı kavram ikinci kez görünmez")
	_kontrol(not IlkSaatSinifi.new().tetikle("pazar", 0, "ahi_ciragi").has("gecmis_metni"), "OGR-38: Gece eşiğinden önce satır yok")
	# OGR-33: Gece < 6 iken son 0 (en kotu degerlerle gece 5 anlik goruntusu)
	_kontrol(ilk.son_kilidi_gece() == 6 and SonKilidiSinifi.kilitli_mi(5) and not SonKilidiSinifi.kilitli_mi(6), "OGR-33: son_kilidi_gece 6 olmali ve gece 5 kilitli olmali")
	var kat := Katalog.new()
	if kat.yukle() != Katalog.Durum.HAZIR:
		_kontrol(false, "katalog")
		print("ILK SAAT: KALDI")
		quit(1)
		return
	var gecmisli := Oturum.new(kat, 5)
	preload("res://src/sistemler/muhafiz_gecmisi.gd").sec(gecmisli, "medrese_talebesi")
	var kapi_satirlari := IlkSaat.kapi_acilis_satirlari(gecmisli)
	_kontrol(kapi_satirlari.size() == 3 and kapi_satirlari[0] == IlkSaat.ipucu_metni("ogretici.gecmis.medrese_talebesi") and kapi_satirlari[1] == IlkSaat.ipucu_metni("ogretici.kapi.konu"), "OGR-38: Kapıdaki ilk satır geçmişe göre değişir")
	var oturum := Oturum.new(kat, 5)
	var kapi_acilis = preload("res://src/sistemler/kapi_acilis_olayi.gd")
	_kontrol(not IlkSaat.ulak_hatirlatmasi_var(oturum, 1), "OGR-40: Açılış akışı geçilmeden ulak satırı yok")
	oturum.bayraklar[kapi_acilis.ULAK] = true
	oturum.bayraklar[kapi_acilis.BITTI] = true
	_kontrol(not IlkSaat.ulak_hatirlatmasi_var(oturum, 0) and IlkSaat.ulak_hatirlatmasi_var(oturum, 1) and not IlkSaat.ulak_hatirlatmasi_var(oturum, 2), "OGR-40: Ulak yalnız ikinci gece raporunda")
	oturum.gun = 5
	oturum.yonetim.gun = 5
	oturum.yonetim.adalet = 0
	var kanca = preload("res://src/debug/ilk_saat_kancasi.gd")
	kanca.arac(oturum, "koy_atama")
	kanca.ipucu(oturum, "koy_atama")
	kanca.ipucu(oturum, "koy_atama")
	oturum.gun = 6
	kanca.ipucu(oturum, "gec_ipucu")
	_kontrol(kanca.satirlar(oturum) == [{"ipucu": "koy_atama", "gosterim_gecesi": 5, "ilk_kullanim_gecesi": 5}], "OGR-42: Gerçek ilk kullanım zamanı, tek satır ve altı gece sınırı")
	oturum.gun = 5
	_kontrol(NihaiSonSinifi.son(oturum, &"zafer").is_empty(), "OGR-33: gece 5 iken en kotu degerlerle bile nihai son 0 (bos) olmali")

	# OMR-11: Gecis sonrasi (perde 2) alti gece ipucu 0
	ilk.sifirla()
	ilk.perde = 2
	var perde2_ipucu := 0
	for gece in range(0, 6):
		for k in kavramlar:
			if bool(ilk.tetikle(String(k.get("tetik", "")), gece).get("gosterildi", false)):
				perde2_ipucu += 1
	_kontrol(perde2_ipucu == 0, "OMR-11: perde 2 gecisi sonrasi alti gece ipucu 0 olmali")
	ilk.sifirla()

	# Listede olmayan ipucu cikmaz
	var uydurma := ilk.tetikle("uydurma_ipucu", 5)
	_kontrol(not bool(uydurma.get("gosterildi", true)), "Listede olmayan ipucu cikmamali")

	# OGR-03: Gece 1'de ilk zar atisinda ipucu 1 kez gorunur, `zar_gosterildi` yazilir; ayni kayitla ikinci acilista ipucu 0
	var zar_ilk := ZarIpucuSinifi.ilk_atis_ipucu(ilk, 1)
	_kontrol(int(zar_ilk.get("ipucu_sayisi", 0)) == 1 and bool(ilk.zar_gosterildi), "Ilk zar atisinda ipucu 1 kez gorunmeli ve zar_gosterildi yazilmali")
	var kayit := ilk.kaydet()
	var yuklenen := IlkSaatSinifi.new()
	yuklenen.yukle(kayit)
	var zar_ikinci := ZarIpucuSinifi.ilk_atis_ipucu(yuklenen, 1)
	_kontrol(int(zar_ikinci.get("ipucu_sayisi", -1)) == 0, "Ayni kayitla ikinci acilista zar ipucu 0 olmali")

	# OGR-06: tehdit_baslangic BUG-18 sabitini okur; deger degisince ikisi birlikte degisir ve pazar/divan'dan sonradir
	var eski_tehdit := int(TehditTakvimi.AYAR.get("tehdit_baslangic_gunu", 14))
	_kontrol(IlkSaatSinifi.tehdit_baslangic_gunu() == eski_tehdit, "tehdit_baslangic BUG-18 ile ayni degeri okumali")
	TehditTakvimi.AYAR["tehdit_baslangic_gunu"] = 18
	_kontrol(IlkSaatSinifi.tehdit_baslangic_gunu() == 18 and TehditTakvimi.acik(18) and not TehditTakvimi.acik(17), "BUG-18 sabiti degisince IlkSaat ve TehditTakvimi birlikte degismeli")
	TehditTakvimi.AYAR["tehdit_baslangic_gunu"] = eski_tehdit

	# OGR-21: Yeterli kaynakla 0, yetersiz kaynakla ilk denemede 1 kez, ikincisinde 0
	ilk.sifirla()
	_kontrol(int(ilk.insa_kaynak_uyarisi(true, "tas").get("ipucu_sayisi", -1)) == 0, "Yeterli kaynakla insa uyarisi 0 olmali")
	_kontrol(int(ilk.insa_kaynak_uyarisi(false, "tas").get("ipucu_sayisi", 0)) == 1, "Yetersiz kaynakla ilk denemede insa uyarisi 1 olmali")
	_kontrol(int(ilk.insa_kaynak_uyarisi(false, "odun").get("ipucu_sayisi", -1)) == 0, "Yetersiz kaynakla ikinci denemede insa uyarisi 0 olmali")

	# OGR-07: IpucuKaydi kayda yazar, eski/silinmis alanli kayittan cokmeden bos okur, sifirla ile temizlenir
	var ik := IpucuKaydiSinifi.new()
	_kontrol(ik.ipucu_ekle("zar") and not ik.ipucu_ekle("zar"), "OGR-07: ayni ipucu iki kez eklenmemeli")
	var kayit_soz := ik.kayda_yaz({"surum": 4})
	_kontrol(kayit_soz.has("ogretici") and (kayit_soz["ogretici"] as Dictionary).get("gorulen", []) == ["zar"], "OGR-07: ogretici.gorulen dizisi kayda yazilmali")
	var ik_eski := IpucuKaydiSinifi.new()
	_kontrol(ik_eski.kayittan_oku({"surum": 1}) and ik_eski.gorulen_sayisi() == 0, "OGR-07: alan silinmis/eski kayit cokmeden bos acilmali")
	ik.sifirla()
	_kontrol(ik.gorulen_sayisi() == 0, "OGR-07: sifirla ile ipuclari temizlenmeli")

	# OGR-15: Heybe ilk gizli esyada 1 kez, gizli esyasizda 0
	ilk.sifirla()
	_kontrol(int(ilk.heybe_gizli_esya_ipucu(false, 2).get("ipucu_sayisi", -1)) == 0, "OGR-15: gizli esyasiz ziyarette ipucu 0 olmali")
	_kontrol(int(ilk.heybe_gizli_esya_ipucu(true, 2).get("ipucu_sayisi", 0)) == 1, "OGR-15: ilk gizli esya ziyaretinde ipucu 1 olmali")
	_kontrol(int(ilk.heybe_gizli_esya_ipucu(true, 3).get("ipucu_sayisi", -1)) == 0, "OGR-15: ikinci gizli esya ziyaretinde ipucu 0 olmali")

	# OGR-16: Tansiyon ilk "gergin" kademesinde 1 kez, sakin gecede 0
	ilk.sifirla()
	_kontrol(int(ilk.tansiyon_gergin_ipucu("sakin").get("ipucu_sayisi", -1)) == 0, "OGR-16: sakin kalan gecede ipucu 0 olmali")
	_kontrol(int(ilk.tansiyon_gergin_ipucu("gergin").get("ipucu_sayisi", 0)) == 1, "OGR-16: gergin kademeye geciste ipucu 1 olmali")
	_kontrol(int(ilk.tansiyon_gergin_ipucu("gergin").get("ipucu_sayisi", -1)) == 0, "OGR-16: ikinci gergin gecisinde ipucu 0 olmali")

	# OGR-17: Bar etkisi ilk degisimde 1 kez ve bar adi anahtarla yazilir; degismeyende 0
	ilk.sifirla()
	_kontrol(int(ilk.bar_degisim_ipucu("bar.halk", 0).get("ipucu_sayisi", -1)) == 0, "OGR-17: bar degismeyen gecede ipucu 0 olmali")
	var bar_sonuc := ilk.bar_degisim_ipucu("soylular", -1)
	_kontrol(int(bar_sonuc.get("ipucu_sayisi", 0)) == 1 and String(bar_sonuc.get("metin", "")).contains("bar.soylular"), "OGR-17: ilk degisimde ipucu 1 ve bar.soylular anahtari metinde olmali")
	_kontrol(int(ilk.bar_degisim_ipucu("bar.ordu", 1).get("ipucu_sayisi", -1)) == 0, "OGR-17: ikinci bar degisiminde ipucu 0 olmali")

	# OGR-18: Barinak ilk doluda 1 kez, kapasite dolmadan 0, karari engellemez
	ilk.sifirla()
	_kontrol(int(ilk.barinak_dolu_ipucu(2).get("ipucu_sayisi", -1)) == 0, "OGR-18: kapasite dolmadan ipucu 0 olmali")
	var barinak_sonuc := ilk.barinak_dolu_ipucu(0)
	_kontrol(int(barinak_sonuc.get("ipucu_sayisi", 0)) == 1 and not bool(barinak_sonuc.get("engeller", true)), "OGR-18: ilk dolu anda ipucu 1 ve engeller=false olmali")
	_kontrol(int(ilk.barinak_dolu_ipucu(0).get("ipucu_sayisi", -1)) == 0, "OGR-18: ikinci dolu anda ipucu 0 olmali")

	# OGR-20: Kaynak eksilisinde 1 kez, tuketim 0 olan gecede 0
	ilk.sifirla()
	_kontrol(int(ilk.kaynak_eksilis_ipucu(0).get("ipucu_sayisi", -1)) == 0, "OGR-20: tuketim 0 olan gecede ipucu 0 olmali")
	_kontrol(int(ilk.kaynak_eksilis_ipucu(3, "erzak").get("ipucu_sayisi", 0)) == 1, "OGR-20: ilk eksiliste ipucu 1 olmali")
	_kontrol(int(ilk.kaynak_eksilis_ipucu(4, "odun").get("ipucu_sayisi", -1)) == 0, "OGR-20: ikinci eksiliste ipucu 0 olmali")

	# OGR-32: Kitlik esigi ilk yaklasmada 1 kez, bol ambarli kayitta 0
	ilk.sifirla()
	_kontrol(int(ilk.kitlik_esigi_ipucu(3.0, 1.0).get("ipucu_sayisi", -1)) == 0, "OGR-32: bol ambarli kayitta ipucu 0 olmali")
	var kitlik_sonuc := ilk.kitlik_esigi_ipucu(0.5, 1.0)
	_kontrol(int(kitlik_sonuc.get("ipucu_sayisi", 0)) == 1 and bool(kitlik_sonuc.get("renk_uyarisi", false)), "OGR-32: ilk yaklasmada ipucu 1 ve renk_uyarisi=true olmali")
	_kontrol(int(ilk.kitlik_esigi_ipucu(0.2, 1.0).get("ipucu_sayisi", -1)) == 0, "OGR-32: ikinci yaklasmada ipucu 0 olmali")

	# OGR-34: Iflas uyarisi esikten iki gece once (orn. esik 3 iken 1. eksi gecede) 1 kez gelir
	ilk.sifirla()
	_kontrol(int(ilk.iflas_uyarisi_ipucu(0, 3).get("ipucu_sayisi", -1)) == 0, "OGR-34: arti kasada iflas uyarisi 0 olmali")
	var iflas_sonuc := ilk.iflas_uyarisi_ipucu(1, 3)
	_kontrol(int(iflas_sonuc.get("ipucu_sayisi", 0)) == 1 and int(iflas_sonuc.get("kalan_gece", 0)) == 2, "OGR-34: iflastan iki gece once uyari 1 kez gelmeli")
	_kontrol(int(ilk.iflas_uyarisi_ipucu(2, 3).get("ipucu_sayisi", -1)) == 0, "OGR-34: sonraki eksi gecede tekrar uyari gelmemeli")

	# OGR-08 & OGR-11: IpucuSeridi en cok 90 karakter gosterir, 6 sn durur, koy hizina (Engine.time_scale) dokunmaz
	var serit := IpucuSeridiSinifi.new()
	var eski_hiz := Engine.time_scale
	Engine.time_scale = 2.0
	var uzun_metin := "Bu ipucu metni doksan karakter sinirini asmak icin bilerek cok uzun yazilmistir ve kirpilmalidir hemen simdi."
	_kontrol(serit.goster(uzun_metin, "test_ipucu"), "OGR-08: IpucuSeridi goster true donmeli")
	_kontrol(serit.aktif_metin().length() <= 90, "OGR-08: IpucuSeridi metni <= 90 karakter olmali")
	_kontrol(is_equal_approx(Engine.time_scale, 2.0), "OGR-11: Ipucu acildiginda Engine.time_scale 2.0 kalmali")
	serit.kapat()
	_kontrol(not serit.visible and is_equal_approx(Engine.time_scale, 2.0), "OGR-11: Ipucu kapandiginda Engine.time_scale 2.0 kalmali")
	Engine.time_scale = eski_hiz
	serit.free()

	# OGR-12: Debug kapaliyken IpucuPaneli dugme_sayisi 0, acikken 1 ve sifirla calisir
	var panel_kapali := IpucuPaneliSinifi.new(false)
	_kontrol(panel_kapali.dugme_sayisi() == 0, "OGR-12: debug kapaliyken dugme 0 olmali")
	panel_kapali.free()
	var panel_acik := IpucuPaneliSinifi.new(true)
	panel_acik.kayit.ipucu_ekle("zar")
	panel_acik.yenile()
	_kontrol(panel_acik.dugme_sayisi() == 1 and panel_acik.etiket.text.contains("zar"), "OGR-12: debug acikken dugme 1 ve gorulen ipuclari listelenmeli")
	panel_acik.hepsini_sifirla()
	_kontrol(panel_acik.kayit.gorulen_sayisi() == 0, "OGR-12: hepsini_sifirla kaydi temizlemeli")
	panel_acik.free()

	# OGR-24: Pazar ve divan dugmeleri ilk acilista isaretlenir, girince kalkar, iki kez tiklanmista isaret 0
	var isaret := YeniDugmeIsaretiSinifi.new()
	var pazar_ilk := isaret.dugme_etkinlesti("pazar")
	_kontrol(int(pazar_ilk.get("isaret", 0)) == 1 and isaret.isaret_sayisi("pazar") == 1, "OGR-24: ilk acilista pazar isareti 1 olmali")
	isaret.dugmeye_girildi("pazar")
	isaret.dugmeye_girildi("pazar")
	_kontrol(isaret.isaret_sayisi("pazar") == 0 and int(isaret.dugme_etkinlesti("pazar").get("isaret", -1)) == 0, "OGR-24: iki kez tiklanmis dugmede isaret 0 olmali")
	isaret.free()

	# OGR-04: Kabul 0 iken koy ekranina gecis 0; kabul > 0 iken acik
	var bos_oturum := Oturum.new(kat, 9)
	_kontrol(not IlkSaatSinifi.koy_acik(0) and not IlkSaatSinifi.koy_acik(bos_oturum), "OGR-04: kabul 0 iken koy ekrani acik olmamali")
	bos_oturum.yonetim.kabul({"ad": "IlkKoylu", "sinif": "ciftci", "stat": 4})
	_kontrol(IlkSaatSinifi.koy_acik(1) and IlkSaatSinifi.koy_acik(bos_oturum), "OGR-04: ilk kabulden sonra koy ekrani acik olmali")

	# OGR-19: Ilk atama surukle-birakla gosterilir; ilk atama sonrasi vurgu kalkar, ikinci koylude vurgu 0
	var vurgu_sinifi := preload("res://src/arayuz/koy_hud/ilk_atama_vurgusu.gd")
	var kulp1 := Button.new()
	var ilk_koylu: Koylu = bos_oturum.yonetim.koylular[0]
	var v1 := vurgu_sinifi.uygula(kulp1, bos_oturum.yonetim, ilk_koylu)
	_kontrol(int(v1.get("vurgu", 0)) == 1 and kulp1.get_node_or_null("IlkAtamaVurgusu") != null, "OGR-19: ilk suruklenebilir koylude vurgu 1 olmali")
	vurgu_sinifi.atama_kaydet(bos_oturum.yonetim)
	var ikinci_koylu := bos_oturum.yonetim.kabul({"ad": "IkinciKoylu", "sinif": "ciftci", "stat": 4})
	var kulp2 := Button.new()
	var v2 := vurgu_sinifi.uygula(kulp2, bos_oturum.yonetim, ikinci_koylu)
	_kontrol(int(v2.get("vurgu", -1)) == 0 and kulp2.get_node_or_null("IlkAtamaVurgusu") == null, "OGR-19: ilk atama sonrasi ikinci koylude vurgu 0 olmali")
	kulp1.free()
	kulp2.free()

	# Ilk alti gecede (gece 0..5) tum kavramlar tetiklendiginde gosterilen ipucu sayisi kavram sayisiyla esittir
	ilk.sifirla()
	var gosterilen := 0
	for gece in range(0, 6):
		for k in kavramlar:
			var sonuc := ilk.tetikle(String(k.get("tetik", "")), gece)
			if bool(sonuc.get("gosterildi", false)):
				gosterilen += 1
	_kontrol(gosterilen == ilk.kavram_sayisi(), "Dosyadaki kavram sayisi ile ilk alti gecede gosterilen ipucu sayisi esit olmali")

	# OGR-14: Beyan defteri ilk celiskide tanitilir; kademeli HUD kapaliyken dogrudan acik
	var defter_tanitimi := preload("res://src/kapi/defter_tanitimi.gd")
	var defter_oturum := Oturum.new(kat, 1)
	_kontrol(not defter_tanitimi.celiski_goruldu_mu(defter_oturum), "OGR-14: baslangicta celiski gorulmemis olmali")
	_kontrol(not defter_tanitimi.dugme_gorunur_mu(defter_oturum, true), "OGR-14: kademeli hud acikken baslangicta defter dugmesi gorunmemeli")
	_kontrol(defter_tanitimi.dugme_gorunur_mu(defter_oturum, false), "OGR-14: kademeli hud kapaliyken defter dugmesi gorunmeli")
	defter_tanitimi.celiski_kaydet(defter_oturum)
	_kontrol(defter_tanitimi.celiski_goruldu_mu(defter_oturum), "OGR-14: kayit sonrasi celiski goruldu olmali")
	_kontrol(defter_tanitimi.dugme_gorunur_mu(defter_oturum, true), "OGR-14: ilk celiskiden sonra defter dugmesi gorunmeli")
	var ipucu_res: Dictionary = defter_tanitimi.ipucu_ver(defter_oturum)
	_kontrol(bool(ipucu_res.get("ipucu_goster", false)), "OGR-14: ilk celiskide ipucu verilmeli")
	var ipucu_tekrar: Dictionary = defter_tanitimi.ipucu_ver(defter_oturum)
	_kontrol(not bool(ipucu_tekrar.get("ipucu_goster", true)), "OGR-14: ipucu yalniz bir kez verilmeli")
	var dk_kayit := defter_oturum.kaydet()
	var dk_yuk := Oturum.kayittan(kat, dk_kayit)
	_kontrol(defter_tanitimi.dugme_gorunur_mu(dk_yuk, true) and not bool(defter_tanitimi.ipucu_ver(dk_yuk).get("ipucu_goster", true)), "OGR-14: kayit/yukleme sonrasi dugme acik kalmali ve ipucu tekrar cikmamali")
	var dt_ot := Oturum.new(kat, 1)
	var dt_ay := Ayarlar.new()
	var dt_cel := preload("res://src/soz/celiski.gd").new()
	dt_cel.kayit_ekle({"id": "b1", "tur": "beyan", "metin": "Silah yok"})
	dt_cel.celiski_ekle("b1", "ip1", "3.1", "guclu")
	_kontrol(not bool(defter_tanitimi.oturumda_kontrol_et(dt_ot, dt_ay, dt_cel).get("gorunur", true)), "OGR-14: tek kayitta dugme gizli kalmali")
	dt_cel.kayit_ekle({"id": "ip1", "tur": "ipucu", "metin": "Hancer izi"})
	var dt_ac: Dictionary = defter_tanitimi.oturumda_kontrol_et(dt_ot, dt_ay, dt_cel)
	_kontrol(bool(dt_ac.get("gorunur", false)) and bool((dt_ac.get("ipucu", {}) as Dictionary).get("ipucu_goster", false)), "OGR-14: cift yakalaninca dugme ve tek seferlik ipucu acilmali")
	_kontrol(not bool((defter_tanitimi.oturumda_kontrol_et(dt_ot, dt_ay, dt_cel).get("ipucu", {}) as Dictionary).get("ipucu_goster", false)), "OGR-14: ikinci kontrolde ipucu tekrar etmemeli")

	# OGR-03: Gercek Oturum + IlkSaat.zar_ipucu_kontrol + kayit/yukleme ile tek seferlik zar ipucu
	var zar_ilk2 := ilk.zar_ipucu_kontrol(1)
	_kontrol(int(zar_ilk2.get("ipucu_sayisi", -1)) == 0, "IlkSaat.zar_ipucu_kontrol ZarIpucu ile tutarli kalmali")
	var zo := Oturum.new(kat, 1)
	zo.gun = 0
	_kontrol(int(ZarIpucuSinifi.oturumda_goster(zo).get("ipucu_sayisi", -1)) == 0, "OGR-03: gece 0'da zar ipucu cikmamali")
	zo.gun = 1
	var z_res1 := ZarIpucuSinifi.oturumda_goster(zo)
	_kontrol(int(z_res1.get("ipucu_sayisi", 0)) == 1 and zo.ipucu_kaydi.goruldu_mu("zar"), "OGR-03: gece 1'de Oturum uzerinden zar ipucu 1 kez donmeli")
	var z_kayit := zo.kaydet()
	var zo_yuk := Oturum.kayittan(kat, z_kayit)
	var z_res2 := ZarIpucuSinifi.oturumda_goster(zo_yuk)
	_kontrol(int(z_res2.get("ipucu_sayisi", -1)) == 0, "OGR-03: kayit/yukleme sonrasi zar ipucu tekrar cikmamali")

	# OGR-31: Ilk kotu karar bir aciklama satiri alir
	var kotu_oturum := Oturum.new(kat, 1)
	var aciklama_ilk := IlkSaatSinifi.ilk_kotu_karar_satiri(kotu_oturum, {"deger": -5, "tur": "kaybi"}, 3)
	_kontrol(not aciklama_ilk.is_empty() and aciklama_ilk.contains("3 gece önce"), "OGR-31: ilk kotu donus bir aciklama satiri almali")
	var aciklama_tekrar := IlkSaatSinifi.ilk_kotu_karar_satiri(kotu_oturum, {"deger": -10, "tur": "kaybi"}, 2)
	_kontrol(aciklama_tekrar.is_empty(), "OGR-31: kotu karar aciklamasi yalniz ilk sefer verilmeli")

	if _hata == 0:
		print("ILK SAAT: GEÇTİ (0 hata)")
	else:
		print("ILK SAAT: KALDI (%d hata)" % _hata)
	quit(_hata)
