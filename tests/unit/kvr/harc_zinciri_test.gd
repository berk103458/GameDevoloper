extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 35)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	y.akce = 1000
	for t in ["odun", "tas", "alet", "gida"]: y.kaynaklar.ekle(t, 100)
	var kuyu := _kur(y, "kirec_kuyusu")
	_kontrol(kuyu != null, "Kireç kuyusu harçsız kurulabilir; başlangıç döngüsü yok")
	if kuyu == null:
		quit(1)
		return
	var k := y.kabul({"ad": "Kireç ustası", "sinif": "tasci", "stat": 5})
	k.moral = 50
	y.ata(k.id, kuyu.id)
	var r := y.gece()
	_kontrol(r.uretim.get("kirec", 0) >= 2, "Ham taş ve yakacak gerçek gecede kirece işlenir")
	_kontrol(y.recete_sec(kuyu.id, "harc"), "Harç tarifi seçilebilir")
	r = y.gece()
	_kontrol(r.uretim.get("harc", 0) >= 4, "Kireç ve ham taş gerçek gecede harca işlenir")
	var harc_once := y.kaynaklar.miktar("harc")
	_kontrol(_kur(y, "tas_ev") == null, "Harç yetersizse taş ev kurulmaz")
	y.kaynaklar.ekle("harc", 20)
	var once := y.kaynaklar.miktar("harc")
	var ev := _kur(y, "tas_ev")
	_kontrol(ev != null and y.kaynaklar.miktar("harc") == once - 6, "Taş ev gerçek altı harç tüketir")
	y.sur_seviye = 1
	y.sur_taksit_odenen = y.a.sur_taksit - 1
	y.kaynaklar.azalt("harc", 10000)
	var kayit := y.kaydet()
	_kontrol(not y.sur_taksit_ode() and y.kaydet() == kayit, "Son taş sur taksiti harçsız kasa ve kısmi ödemeyi korur")
	y.kaynaklar.ekle("harc", 8)
	_kontrol(y.sur_taksit_ode() and y.sur_seviye == 2 and y.kaynaklar.miktar("harc") == 0, "Son taksit malzemeyi bir kez tüketip suru yükseltir")
	y.kaynaklar.azalt("kirec", 10000)
	var stok := y.kaynaklar.kaydet()
	var u := {}
	var olaylar: Array[Dictionary] = []
	y._uret(u, olaylar)
	_kontrol(u.is_empty() and stok == y.kaynaklar.kaydet(), "Kireçsiz harç reçetesi taş harcamaz")
	y.kaynaklar.ekle("harc", harc_once)
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	_kontrol(geri.yonetim.kaynaklar.miktar("harc") == harc_once and geri.yonetim.bina(kuyu.id).recete == "harc", "Tarif ve yeni stoklar gerçek oturum JSON dönüşümünde korunur")
	# Seviye 3 erken taksit malzemeyi tüketmez; son taksit tek kez tüketir.
	y.sur_taksit_odenen = 0
	y.kaynaklar.ekle("harc", 30)
	var malzeme_once := y.kaynaklar.kaydet()
	_kontrol(y.sur_taksit_ode() and y.kaynaklar.kaydet() == malzeme_once, "Erken taksit yalnız kamu kasasından ödenir")
	y.sur_taksit_odenen = y.a.sur_taksit - 1
	var tas_once := y.kaynaklar.miktar("tas")
	var harc_son := y.kaynaklar.miktar("harc")
	_kontrol(y.sur_taksit_ode() and y.sur_seviye == 3 and y.kaynaklar.miktar("tas") == tas_once - 24 and y.kaynaklar.miktar("harc") == harc_son - 12, "Üçüncü taş sur tam bedelle tamamlanır")
	var azami := y.kaydet()
	_kontrol(not y.sur_taksit_ode() and y.kaydet() == azami, "Azami sur tekrarlı ödeme almaz")
	var harc_yikim := y.kaynaklar.miktar("harc")
	_kontrol(y.bina_yik(ev.id) and y.kaynaklar.miktar("harc") == harc_yikim + int(6 * y.a.yikim_iade), "Taş ev yıkımı ödenmiş harcı mevcut iade oranıyla geri verir")
	var eski := Kaynaklar.kayittan({"stok": {"tas": 7}, "kapasite": 150})
	_kontrol(eski.miktar("tas") == 7 and eski.miktar("kirec") == 0 and eski.miktar("harc") == 0, "Eski kayıt ham taşı korur; yeni stoklar sıfır")
	print("HARÇ ZİNCİRİ: GEÇTİ" if hata == 0 else "HARÇ ZİNCİRİ: KALDI")
	quit(hata)
func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h)["olur"]:
				var b := y.bina(y.bina_kur(tur, h)["id"])
				if b == null: return null
				b.insa_kalan = 0
				return b
	return null
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
