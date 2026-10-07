extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 70)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	for tur in ["gida", "odun", "tas", "kereste"]: y.kaynaklar.ekle(tur, 100)
	var b := _kur(y)
	var ilk := o.karar_ver(o._adli_gelen(&"chr_001"), &"kabul")
	var ikinci := o.karar_ver(o._adli_gelen(&"chr_004"), &"kabul")
	var ucuncu := o.karar_ver(o._adli_gelen(&"chr_007"), &"kabul")
	var a := y.koylu(ilk["koylu_id"])
	var c := y.koylu(ikinci["koylu_id"])
	var d := y.koylu(ucuncu["koylu_id"])
	for k in [a, c, d]:
		k.moral = 80
		y.ata(k.id, b.id)
	_kontrol(KanDavasi.dusman(a, d) and KanDavasi.dusman(d, a) and not KanDavasi.dusman(a, c), "Gerçek kapı kabulü kaynak kan davasını taşır; ilişki simetrik, aynı grup düşman değil")
	_kontrol(KanDavasi.ciftler(y, b.id).size() == 2, "Üç çalışanın iki düşman çifti, ters/öz çift yok")
	var u := {}
	var stok := y.kaynaklar.kaydet()
	var rng := y._rng.state
	y._uret(u, [])
	_kontrol(u.is_empty() and y.kaynaklar.kaydet() == stok and y._rng.state == rng and b.bekliyor == "kan_davasi", "Tüm bina üretimi durur; girdi/alet zarı tüketilmez")
	y._rng.seed = _tohum()
	var rapor := y.gece()
	_kontrol(rapor["uretim"].is_empty() and a.saglik == 95 and c.saglik == 95 and d.saglik == 95, "Gerçek gece kavga; iki çifte giren aynı kişi yalnız bir kez yaralanır")
	_kontrol(rapor["olaylar"].any(func(e: Dictionary) -> bool: return e["anahtar"].contains("kan davası kavgasında")), "Kavga gerçek gece raporunda")
	kat.koy_ayarlari = y.a.duplicate(true)
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	geri.yonetim.a = y.a.duplicate(true)
	geri.yonetim._ambar_kapasitesi()
	_kontrol(geri.yonetim.koylu(a.id).toplumsal_bag == a.toplumsal_bag and KanDavasi.engel(geri.yonetim, b.id), "JSON aynı ilişki ve bina çatışmasını korur")
	y.gece()
	geri.yonetim.gece()
	_kontrol(y._rng.state == geri.yonetim._rng.state and a.saglik == geri.yonetim.koylu(a.id).saglik and d.moral == geri.yonetim.koylu(d.id).moral, "Yükleme aynı sonraki kavga/RNG sonucunu üretir")
	y.bosalt(d.id)
	_kontrol(not KanDavasi.engel(y, b.id), "Düşman kişiyi ayırmak duruşu kaldırır")
	u.clear()
	y._uret(u, [])
	_kontrol(int(u.get("gida", 0)) > 0 and b.bekliyor == "", "Kalan aynı grup gerçek üretime döner")
	var x := y.kabul({"sinif": "esnaf", "toplumsal_bag": {"grup": "koy_a", "dusman_gruplar": ["koy_b"]}})
	var z := y.kabul({"sinif": "esnaf", "toplumsal_bag": {"grup": "koy_b", "dusman_gruplar": []}})
	_kontrol(KanDavasi.dusman(x, z), "Açık köy/aşiret ilişkisi CHR listesinden bağımsız çalışır")
	z.toplumsal_bag = {"grup": "koy_c", "dusman_gruplar": []}
	_kontrol(not KanDavasi.dusman(x, z), "Farklı gruplar tek başına düşman sayılmaz")
	z.toplumsal_bag = {"grup": "koy_b", "dusman_gruplar": []}
	y.akce = 100
	y.kaynaklar.ekle("demir", 20)
	var demirhane := _kur(y, "atolye")
	_kontrol(y.ata(x.id, demirhane.id) and y.ata(z.id, demirhane.id), "Düşman köylerden iki kişi gerçek girdili atölyeye atanır")
	var demir := y.kaynaklar.miktar("demir")
	var kereste := y.kaynaklar.miktar("kereste")
	var alet := y.kaynaklar.miktar("alet")
	rng = y._rng.state
	u.clear()
	y._uret(u, [])
	_kontrol(y.kaynaklar.miktar("demir") == demir and y.kaynaklar.miktar("kereste") == kereste and y.kaynaklar.miktar("alet") == alet and demirhane.bekliyor == "kan_davasi" and y._rng.state == rng, "Gerçek girdili üretimde kan davası ham madde/alet/RNG tüketmez")
	var eski := a.kaydet()
	eski.erase("toplumsal_bag")
	_kontrol(Koylu.kayittan(eski).toplumsal_bag == KanDavasi.kaynak(a.adli_id), "Eski kayıt kaynak ilişkisiyle güvenli tamamlanır")
	for bozuk in [null, {}, {"grup": 7, "dusman_gruplar": []}, {"grup": "a", "dusman_gruplar": ["a"]}, {"grup": "a", "dusman_gruplar": [false]}]:
		_kontrol(KanDavasi.oku(bozuk, KanDavasi.kaynak(a.adli_id)) == a.toplumsal_bag, "Hatalı ilişki kaynak varsayılanına döner")
	var anlik := o.kaydet()
	KoyluDenetcisi.satirlar(o)
	_kontrol(o.kaydet() == anlik, "İlişki önizlemesi salt okunur")
	print("KAN DAVASI: GEÇTİ" if hata == 0 else "KAN DAVASI: KALDI")
	quit(hata)
func _tohum() -> int:
	var zar := RandomNumberGenerator.new()
	var n := 1
	while true:
		zar.seed = n
		if zar.randf() < KanDavasi.KAVGA_RISKI: return n
		n += 1
	return n
func _kur(y: KoyYonetimi, tur: String = "tarla") -> KoyBinasi:
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
