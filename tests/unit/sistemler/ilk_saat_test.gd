extends SceneTree

const IlkSaatSinifi = preload("res://src/sistemler/ilk_saat.gd")
const ZarIpucuSinifi = preload("res://src/kapi/zar_ipucu.gd")
const SonKilidiSinifi = preload("res://src/sistemler/son_kilidi.gd")
const NihaiSonSinifi = preload("res://src/sistemler/nihai_son.gd")
const IpucuKaydiSinifi = preload("res://src/sistemler/ipucu_kaydi.gd")

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

	# OGR-33: Gece < 6 iken son 0 (en kotu degerlerle gece 5 anlik goruntusu)
	_kontrol(ilk.son_kilidi_gece() == 6 and SonKilidiSinifi.kilitli_mi(5) and not SonKilidiSinifi.kilitli_mi(6), "OGR-33: son_kilidi_gece 6 olmali ve gece 5 kilitli olmali")
	var oturum := Oturum.new(Ayarlar.new())
	oturum.yeni_oyun()
	oturum.gun = 5
	oturum.yonetim.gun = 5
	oturum.yonetim.adalet = 0
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

	# Ilk alti gecede (gece 0..5) tum kavramlar tetiklendiginde gosterilen ipucu sayisi kavram sayisiyla esittir
	ilk.sifirla()
	var gosterilen := 0
	for gece in range(0, 6):
		for k in kavramlar:
			var sonuc := ilk.tetikle(String(k.get("tetik", "")), gece)
			if bool(sonuc.get("gosterildi", false)):
				gosterilen += 1
	_kontrol(gosterilen == ilk.kavram_sayisi(), "Dosyadaki kavram sayisi ile ilk alti gecede gosterilen ipucu sayisi esit olmali")

	if _hata == 0:
		print("ILK SAAT: GEÇTİ (0 hata)")
	else:
		print("ILK SAAT: KALDI (%d hata)" % _hata)
	quit(_hata)
