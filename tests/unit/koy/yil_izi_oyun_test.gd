## YIL-01/02/05/10 oyun zinciri: KoyYonetimi.gece -> YilIziGecesi.gece -> gece raporu satırı; kayıt yüklemesi.
extends SceneTree

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _kontrol(kosul: bool, ad: String) -> void:
	if kosul:
		print("  ok  ", ad)
	else:
		hata += 1
		print("  HATA  ", ad)


func _satirlar(rapor: Dictionary, ad: String) -> int:
	var n := 0
	for o in rapor.get("olaylar", []):
		if o is Dictionary and String(o.get("anahtar", "")) == "%s: %s" and o.get("deger", []).size() > 0 and String(o.deger[0]) == ad:
			n += 1
	return n


func _metin(rapor: Dictionary, anahtar: String) -> bool:
	for o in rapor.get("olaylar", []):
		if o is Dictionary and String(o.get("anahtar", "")) == "%s: %s" and o.deger.size() == 2 and String(o.deger[1]) == TranslationServer.translate(anahtar):
			return true
	return false


func _kapanis(rapor: Dictionary) -> Array:
	for o in rapor.get("olaylar", []):
		if o is Dictionary and String(o.get("anahtar", "")) == YilIziGecesi.KAPANIS:
			return o.get("deger", [])
	return []


func _calistir() -> void:
	var y := KoyYonetimi.new(KoyAyarlari.new(), BinaKatalogu.new(), 3)
	var k := y.kabul({"ad": "Fadime", "sinif": "ciftci", "stat": 4})
	k.adli_id = &"CHR_017"
	var toplam := 0
	var mevsimler := {}
	var kapanis: Array = []
	var kis_tarla := 0
	var sofra := false
	for gece in 28:
		k.saglik = 100
		k.moral = 100
		k.sadakat = 100
		k.bosta_kalma = {}
		y.kaynaklar.ekle("gida", 20)
		var ad := String(MevsimYoneticisi.durum(y).ad)
		if gece == 0:
			_kontrol(String(YilIzi.durum(y).kisi) == "", "YIL-01: gece öncesi iz boş")
		if gece == 14:
			y.kaynaklar.ekle("gida", y.kaynaklar.kapasite * 2)
		if gece == 20:
			var tarla := KoyBinasi.new()
			tarla.id = 9901
			tarla.tur = "tarla"
			y.binalar.append(tarla)
			k.kis_oncesi_is = tarla.id
		var r := y.gece()
		if gece == 0:
			_kontrol(String(YilIzi.durum(y).kisi) == "CHR_017", "YIL-01: oyun gecesi adlı kişiyi yılın yüzü yapar")
		var n := _satirlar(r, "Fadime")
		toplam += n
		if n > 0:
			mevsimler[ad] = true
		if ad == "kis":
			kis_tarla += n
		if gece == 14:
			sofra = _metin(r, "yil.guz_sofra")
		if not _kapanis(r).is_empty():
			kapanis = _kapanis(r)
		if gece == 10:
			var kayit := y.kaydet()
			var y2 := KoyYonetimi.kayittan(KoyAyarlari.new(), BinaKatalogu.new(), kayit)
			_kontrol(String(YilIzi.durum(y2).kisi) == "CHR_017" and YilIzi.durum(y2).duyulan == YilIzi.durum(y).duyulan, "YIL-10: kayıt yüklemesi izi ve duyulanları korur")
	_kontrol(toplam >= 3, "YIL-02: ilkbahar, yaz ve güzde gece raporunda kişinin adıyla satır (%d)" % toplam)
	_kontrol(mevsimler.size() >= 3, "YIL: satır birden çok mevsimde duyulur (%s)" % str(mevsimler.keys()))
	_kontrol(sofra and HasatSenligi.son_yil(y) == 1, "YIL-02: dolu ambarlı şenlik gecesinde güz sofrası satırı")
	_kontrol(YilIziGecesi.tarlada(y, k) and kis_tarla == 0, "YIL-05: kışın tarla işçisinde yıl satırı yok")
	_kontrol(kapanis.size() == 2 and String(kapanis[0]) == "Fadime" and int(kapanis[1]) >= 1 and int(kapanis[1]) <= 5, "YIL-10: 28. gece kapanış satırı sayar (%s)" % str(kapanis))
	_kontrol(String(YilIzi.durum(y).kisi) == "" or MevsimYoneticisi.durum(y).yil_gunu == 1, "YIL-10: kapanıştan sonra iz temizlenir")
	_test_sev06_maske_ve_yil_izi()
	print("YIL IZI OYUN: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(1 if hata > 0 else 0)


func _test_sev06_maske_ve_yil_izi() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 19)
	o.yonetim.gun = 14
	var g := o._adli_gelen(&"chr_017")
	var s := o.karar_ver(g, &"kabul")
	var kid := int(s.get("koylu_id", -1))
	var k := o.yonetim.koylu(kid)
	_kontrol(k != null and SevilenYuz.gorunen_kart_adi(k) == "çoban", "YIL-09/SEV-06: bayraksız CHR_017 kart adı çoban kalır")
	var r_guz := o.yonetim.gece()
	_kontrol(_satirlar(r_guz, "çoban") == 1 and _satirlar(r_guz, "Fadime") == 0, "YIL-09: bayrak yokken güz cümlesinde çoban geçer, Fadime 0")
	SevilenYuz.kimlik_ac(k)
	_kontrol(SevilenYuz.gorunen_kart_adi(k) == "Fadime", "SEV-06: kimlik açılınca kart adı Fadime olur")
	_kontrol(String(YilIzi.durum(o.yonetim).slotlar.get("sonbahar_satir", {}).get("ad", "")) == "çoban", "YIL-09: yazılmış güz satırı değişmez")
	o.yonetim.gun = 21
	var r_kis := o.yonetim.gece()
	_kontrol(_satirlar(r_kis, "Fadime") == 1, "YIL-09: kimlik açıldıktan sonraki slot Fadime söyler")
	var veri: Resource = ResourceLoader.load("res://data/chr_runtime/CHR_017.tres")
	_kontrol(TranslationServer.translate(kat.karakter(&"chr_017").ad_anahtari) == "Fadime" and veri != null and String(veri.ad) == "Fadime", "YIL-09: karakter verisi yazısı değişmez")
