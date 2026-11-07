extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 90)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	y.akce = 100
	for tur in ["gida", "odun", "tas", "kereste", "demir"]: y.kaynaklar.ekle(tur, 100)
	var tarla := _kur(y, "tarla")
	var cocuk := y.kabul({"adli_id": "chr_006", "sinif": "ciftci"})
	var yasli := y.kabul({"adli_id": "chr_013", "sinif": "ciftci", "stat": 5})
	var dudu := y.kabul({"adli_id": "chr_008", "sinif": "esnaf"})
	var genc := y.kabul({"adli_id": "chr_014", "sinif": "ciftci"})
	var isci := y.kabul({"adli_id": "chr_030", "sinif": "esnaf", "stat": 5})
	# YAP-01/02: yaş testi gerçek yapı bilgisini taşıyan mevcut kişiyi kullanır.
	preload("res://src/koy/yapi_bilgisi.gd").ekle(isci,PackedStringArray(["ambar","degirmen"]))
	var ambar := _kur(y,"ambar")
	var m := _kur(y, "degirmen")
	_kontrol(ambar != null and m != null,"Yaş testi gerçek K1/K2 ön şartlarıyla kurulur")
	if ambar == null or m == null:
		quit(1)
		return
	for k in y.koylular: k.moral = 50
	_kontrol(cocuk.yas_grubu == &"cocuk" and yasli.yas_grubu == &"yasli" and genc.yas_grubu == &"yetiskin", "Kaynak çocuk/yaşlı; genç etiketi çocuk yapılmaz")
	_kontrol(not y.ata(cocuk.id, tarla.id) and not y.muhafiz_ata(cocuk.id) and not y.muhafiz_ata(yasli.id), "Çocuk ağır tarla, çocuk/yaşlı nöbet ataması reddedilir")
	_kontrol(not y.ata(dudu.id, tarla.id), "Tarla uzmanı olmayan yaşlı ağır işe atanamaz")
	_kontrol(y.ata(yasli.id, tarla.id) and YasRolleri.danisman(yasli, "tarla") and not YasRolleri.fiziksel(yasli, "tarla"), "Osman tarla ustası danışman olur; fiziksel iş yapmaz")
	var u := {}
	y._uret(u, [])
	_kontrol(u.is_empty(), "Yalnız yaşlı danışman ücretsiz tarla üretimi yapmaz")
	cocuk.is_yeri = tarla.id
	y._uret(u, [])
	_kontrol(u.is_empty(), "Eski kayıtta çocuk ağır işe atanmış olsa da fiziksel üretim engellenir")
	y.bosalt(cocuk.id)
	y.bosalt(yasli.id)
	_kontrol(y.ata(isci.id, m.id), "Değirmenci gerçek öğütme yapısına atanır")
	y._artik.clear()
	u.clear()
	var gida := y.kaynaklar.miktar("gida")
	y._uret(u, [])
	_kontrol(is_equal_approx(float(u["gida"]) + float(y._artik["%d:gida" % m.id]), 4.8) and y.kaynaklar.miktar("gida") == gida - 2 + int(u["gida"]), "Gerçek değirmen girdi tüketir; danışmansız brüt 4.8")
	_kontrol(y.ata(yasli.id, m.id) and YasRolleri.carpan(y, m) == 1.15, "Yaşlı danışman %15 çarpan")
	y._artik.clear()
	u.clear()
	gida = y.kaynaklar.miktar("gida")
	y._uret(u, [])
	_kontrol(is_equal_approx(float(u["gida"]) + float(y._artik["%d:gida" % m.id]), 5.52) and y.kaynaklar.miktar("gida") == gida - 2 + int(u["gida"]), "Danışman gerçek öğütme çıktısını 5.52 yapar; kendi girdisi/çıktısı yok")
	y.ata(dudu.id, m.id)
	_kontrol(YasRolleri.carpan(y, m) == 1.15, "İki yaşlı danışman bonusu üst üste eklemez")
	yasli.bayraklar.append("hasta")
	dudu.bayraklar.append("hasta")
	_kontrol(YasRolleri.carpan(y, m) == 1.0, "Hasta danışman bonus sağlamaz")
	yasli.bayraklar.clear()
	dudu.bayraklar.clear()
	y._artik.clear()
	var gece := y.gece()
	_kontrol(int(gece["uretim"]["gida"]) == 5 and is_equal_approx(float(y._artik["%d:gida" % m.id]), 0.52), "Danışman bonusu gerçek gece_sonu üretiminde uygulanır")
	var anlik := o.kaydet()
	var satirlar := KoyluDenetcisi.satirlar(o)
	var ust := satirlar.filter(func(r: Dictionary) -> bool: return r["id"] == yasli.id)[0] as Dictionary
	_kontrol(float(ust["carpan"]) == 0.0 and ust["engel"].contains("Danışman") and o.kaydet() == anlik, "Canlı danışman önizlemesi kendi üretimini sıfır ve salt okunur gösterir")
	kat.koy_ayarlari = y.a.duplicate(true)
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(anlik)))
	_kontrol(geri.yonetim.koylu(yasli.id).yas_grubu == &"yasli" and geri.yonetim.koylu(cocuk.id).yas_grubu == &"cocuk", "Yaş sınıfı tam JSON kayıtla korunur")
	var eski := yasli.kaydet()
	eski.erase("yas_grubu")
	_kontrol(Koylu.kayittan(eski).yas_grubu == &"yasli" and YasRolleri.oku("bozuk", cocuk.adli_id) == &"cocuk", "Eski/hatalı yaş alanı kaynak varsayılanına döner")
	print("YAŞ ROLLERİ: GEÇTİ" if hata == 0 else "YAŞ ROLLERİ: KALDI")
	quit(hata)
func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h)["olur"]:
				var b := y.bina(y.bina_kur(tur, h)["id"])
				b.insa_kalan = 0
				return b
	return null
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
