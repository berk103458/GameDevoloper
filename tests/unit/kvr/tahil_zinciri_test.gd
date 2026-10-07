extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 22)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	y.akce = 1000
	for t in ["odun", "tas", "gida", "alet"]: y.kaynaklar.ekle(t, 100)
	var tarla := _kur(y, "tarla")
	var degirmen := _kur(y, "degirmen")
	var firin := _kur(y, "firin")
	var turler := ["ciftci", "degirmenci", "firinci"]
	var i := 0
	for b in [tarla, degirmen, firin]:
		var k := y.kabul({"ad": "Zincir çalışanı", "sinif": turler[i], "stat": 5})
		k.moral = 50
		y.ata(k.id, b.id)
		i += 1
	_kontrol(y.recete_sec(tarla.id, "bugday") and y.recete_sec(degirmen.id, "un"), "Gerçek yapı tarifleri seçilir")
	var r := y.gece()
	_kontrol(r.uretim.get("bugday", 0) >= 3 and r.uretim.get("un", 0) >= 2 and r.uretim.get("gida", 0) >= 4, "Gerçek gece üç üretim aşaması çalışır")
	_kontrol(y.kaynaklar.miktar("bugday") >= 1 and y.kaynaklar.miktar("un") == 0, "Un fırında tüketilir; buğday ayrı stoktur")
	y.bosalt(y.calisanlar(tarla.id)[0].id)
	y.bosalt(y.calisanlar(degirmen.id)[0].id)
	var once := y.kaynaklar.kaydet()
	var u := {}
	var olaylar: Array[Dictionary] = []
	y._uret(u, olaylar)
	_kontrol(u.is_empty() and y.kaynaklar.kaydet() == once and firin.bekliyor == "girdi", "Unsuz fırın mevcut gıdayı atlatmaz; odun da tüketmez")
	y.kaynaklar.ekle("un", 5)
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	_kontrol(geri.yonetim.kaynaklar.miktar("un") == 5 and geri.yonetim.bina(firin.id).recete == "ekmek", "Yeni stok ve tarif JSON dönüşümünde korunur")
	_kontrol(y.katalog.receteler("tarla").has("gida") and y.katalog.receteler("degirmen").has("ogutme"), "Eski tarif kimlikleri ve sebze/erzak yolu korunur")
	_kontrol(y.katalog.receteler("bostan").has("bugday"), "Bostan da buğday yetiştirebilir")
	var eski := Kaynaklar.kayittan({"stok": {"gida": 12}, "kapasite": 150})
	_kontrol(eski.miktar("bugday") == 0 and eski.miktar("un") == 0 and eski.miktar("gida") == 12, "Eski gıda stokları değişmez")
	print("TAHIL ZİNCİRİ: GEÇTİ" if hata == 0 else "TAHIL ZİNCİRİ: KALDI")
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
