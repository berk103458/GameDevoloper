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
	print("YIL IZI OYUN: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(1 if hata > 0 else 0)
