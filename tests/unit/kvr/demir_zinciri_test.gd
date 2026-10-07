extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 76)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	y.akce = 1000
	for t in ["gida", "odun", "tas", "kereste", "alet", "harc"]: y.kaynaklar.ekle(t, 100)
	var maden := _kur(y, "demir_madeni")
	var ocak := _kur(y, "demir_ocagi")
	var demirci := _kur(y, "demirhane")
	for bina in [maden, ocak, demirci]:
		_kontrol(bina != null, "Demir zinciri gerçek katalogdan kurulabilir")
		if bina == null:
			quit(1)
			return
		var k := y.kabul({"ad": "Demir işçisi", "sinif": "esnaf", "stat": 5})
		k.moral = 50
		y.ata(k.id, bina.id)
	var r := y.gece()
	_kontrol(r.uretim.get("cevher", 0) >= 3 and r.uretim.get("demir", 0) >= 2 and r.uretim.get("alet", 0) >= 1, "Gerçek gece cevher→demir→alet zinciri işler")
	var tarla := _kur(y, "tarla")
	var c := y.kabul({"ad": "Çiftçi", "sinif": "ciftci", "stat": 5})
	c.moral = 50
	y.ata(c.id, tarla.id)
	var tam := AtamaOnizlemesi.brut(y, tarla)
	y.kaynaklar.azalt("alet", 10000)
	var dusuk := AtamaOnizlemesi.brut(y, tarla)
	_kontrol(is_equal_approx(float(dusuk.gida), float(tam.gida) * 0.3), "Aletsiz gerçek üretim önizlemesi %70 düşer")
	for bina in [maden, ocak, demirci]: y.bosalt(y.calisanlar(bina.id)[0].id)
	var u := {}
	var olaylar: Array[Dictionary] = []
	y._artik.clear()
	y._uret(u, olaylar)
	_kontrol(is_equal_approx(float(y._artik["%d:gida" % tarla.id]) + float(u.get("gida", 0)), float(dusuk.gida)), "Aletsiz gerçek gece önizleme ile aynı formülü kullanır")
	y.kaynaklar.ekle("alet", 1)
	y.alet_asinma = 0.9
	u.clear()
	y._uret(u, olaylar)
	_kontrol(y.kaynaklar.miktar("alet") == 0 and is_equal_approx(y.alet_asinma, 0.0), "Fiili üretimde aşınma bir aleti tüketir")
	y.alet_asinma = 0.4
	var gozlem := y.kaydet()
	AtamaOnizlemesi.brut(y, tarla)
	KoyluDenetcisi.satirlar(o)
	_kontrol(y.kaydet() == gozlem, "Denetçi ve atama önizlemesi stok/aşınma/RNG değiştirmez")
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	_kontrol(geri.yonetim.kaynaklar.miktar("cevher") == y.kaynaklar.miktar("cevher") and geri.yonetim.alet_asinma == y.alet_asinma, "Cevher/aşınma JSON dönüşümünde korunur")
	# Girdisiz ocak, tam ambar ve boş iş aşınma üretmez.
	y.bosalt(c.id)
	y.ata(c.id, ocak.id)
	y.kaynaklar.ekle("alet", 1)
	y.kaynaklar.azalt("cevher", 10000)
	var yok := y.kaydet()
	u.clear()
	y._uret(u, olaylar)
	_kontrol(y.alet_asinma == 0.4 and y.kaynaklar.kaydet() == yok.kaynaklar, "Eksik cevherde yakacak/alet/aşınma korunur")
	y.bosalt(c.id)
	y.ata(c.id, tarla.id)
	y.kaynaklar.kapasite = y.kaynaklar.toplam()
	y._uret(u, olaylar)
	_kontrol(y.alet_asinma == 0.4 and y.kaynaklar.miktar("alet") == 1, "Dolu ambarda aşınma oluşmaz")
	_kontrol(DemirZinciri.asinma_oku("hata") == 0.0 and DemirZinciri.asinma_oku(-1) == 0.0, "Bozuk aşınma alanı güvenli sıfır")
	print("DEMİR ZİNCİRİ: GEÇTİ" if hata == 0 else "DEMİR ZİNCİRİ: KALDI")
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
