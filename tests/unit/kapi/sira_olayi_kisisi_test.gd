extends SceneTree
var hata := 0
func _initialize() -> void:
	call_deferred("_kos")
func _kos() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var s := KapiSahnesi.new()
	var modeller: Array[KarakterModel] = []
	for bilgi in [["e", "yetiskin", "adam"], ["k", "yetiskin", "kadin"], ["e", "cocuk", "cocuk"], ["k", "cocuk", "cocuk"], ["e", "yasli", "yasli_adam"], ["k", "yasli", "yasli_kadin"]]:
		var k := KarakterModel.new()
		k.set_meta("cinsiyet", bilgi[0])
		k.set_meta("yas_grubu", bilgi[1])
		modeller.append(k)
		dene(SiraOlayiKisisi.anahtar(k) == "olay.sira.kisi." + bilgi[2], "Yaş/cinsiyet ayrı çeviri anahtarı")
	var sayac := 0
	for o in kat.sira_olaylari():
		var a := String(o.kosullar.canlandirma)
		var sablon := GuvenliMetin.metin(o.metin_anahtari)
		dene(sablon.contains("{kisi}"), "%s gerçek kişi şablonu" % o.id)
		for deneme in 100:
			s._kuyruktakiler.clear()
			for i in 4: s._kuyruktakiler.append(modeller[(deneme + i) % modeller.size()])
			var beklenen_i := 0 if a == "kavga" else (2 if a == "bayilma" else 3)
			var beklenen := s._kuyruktakiler[beklenen_i]
			var secilen := SiraOlayiKisisi.sec(s, a)
			dene(secilen == beklenen, "%s metin/animasyon aynı gerçek model" % o.id)
			var kisi := GuvenliMetin.metin(SiraOlayiKisisi.anahtar(secilen))
			var metin := SiraOlayiKisisi.metin(o.metin_anahtari, kisi)
			dene(metin == sablon.replace("{kisi}", kisi) and not metin.contains("{kisi}"), "Çevrilmiş gerçek kişi")
			if secilen.get_meta("yas_grubu") == "cocuk": dene(metin.contains("bir çocuk") and not metin.contains("yaşlı"), "Çocuk yaşlı anlatılmaz")
			for i in 2:
				var sonuc := "olay.%s.sonuc%d" % [o.id, i + 1]
				dene(not SiraOlayiKisisi.metin(sonuc, kisi).contains("{kisi}"), "Sonuçta şablon kalmaz")
			sayac += 1
	var bilinmeyen := KarakterModel.new()
	bilinmeyen.set_meta("yas_grubu", "yasli")
	dene(SiraOlayiKisisi.anahtar(bilinmeyen) == "olay.sira.kisi.biri", "Eksik cinsiyet biri")
	bilinmeyen.set_meta("cinsiyet", "?")
	dene(SiraOlayiKisisi.anahtar(bilinmeyen) == "olay.sira.kisi.biri", "Bilinmeyen cinsiyet biri")
	var o := Oturum.new(kat, 1919)
	var rng := o._rng.state
	s._kuyruktakiler.clear()
	dene(KapiFirtinaKuyrugu.sira_olayi(o, s, 4) == null, "Mantıksal liste dolu fiziksel kuyruk boş: olay yok")
	dene(o.sira_olayi_sec(0) == null and o._rng.state == rng, "Boş kuyruk RNG çekmez")
	s._kuyruktakiler.append(modeller[0])
	dene(KapiFirtinaKuyrugu.sira_olayi(o, s, 1) == null and o._rng.state == rng, "Tek model canlandırma/RNG yok")
	s._kuyruktakiler.append(modeller[1])
	dene(o.yonetim.nufus() == 0, "Binasız/nüfussuz kurulum")
	var uretilen := false
	for i in 100:
		if KapiFirtinaKuyrugu.sira_olayi(o, s, 2) != null: uretilen = true
	dene(uretilen, "Köy nüfusu sıfır olsa da gerçek kuyrukta olay var")
	# Gerçek yüklenmiş model bilgisi: yaş aynı YasRolleri kaynağından, kimlik yerine model adı.
	for ad in SiraOlayiKisisi.BILGI:
		var k := KarakterModel.new()
		SiraOlayiKisisi.model_kur(k, ad)
		dene(k.get_meta("cinsiyet") == SiraOlayiKisisi.BILGI[ad] and k.get_meta("yas_grubu") == YasRolleri.kaynak(StringName(ad)), "Model verisi/yaş kaynağı")
		k.free()
	var kapsul := Dunya3B.karakter("bug19_olmayan_model")
	dene(SiraOlayiKisisi.anahtar(kapsul) == "olay.sira.kisi.biri", "Gerçek kapsül bilinmeyen kişi")
	kapsul.free()
	s._kuyruktakiler.clear()
	s.free()
	bilinmeyen.free()
	for k in modeller: k.free()
	print("SIRA KİŞİ: %d deneme, GEÇTİ" % sayac if hata == 0 else "SIRA KİŞİ: KALDI")
	quit(hata)
func dene(ok: bool, ad: String) -> void:
	if not ok:
		hata += 1
		push_error(ad)
