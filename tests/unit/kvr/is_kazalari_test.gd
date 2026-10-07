extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 85)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	for tur in ["gida", "odun", "tas", "kereste"]: y.kaynaklar.ekle(tur, 100)
	y.kaynaklar.stok["alet"] = 0
	var b := _kur(y)
	var asker := y.kabul({"sinif": "asker", "stat": 5})
	asker.moral = 80
	_kontrol(y.ata(asker.id, b.id) and IsKazalari.risk(asker, y) == 0.08, "Askerin gerçek tarlada uyumsuz kaza riski")
	y._rng.seed = _tohum(0.08)
	var ilk := y.gece()
	_kontrol(asker.saglik == 80 and asker.bayrak_var("agir_yarali") and asker.is_kazasi.get("kalan") == 3, "Gerçek gecede sakatlanma sağlık ve bayrağa işler")
	_kontrol(ilk["olaylar"].any(func(e: Dictionary) -> bool: return e["anahtar"].contains("yaralandı")), "Kaza gerçek gece raporunda")
	_kontrol(is_equal_approx(Uretim.koylu_carpani(asker, "ciftci", y.a, "tarla"), 0.35), "Yaralı bayrağı mevcut verim formülünü azaltır")
	kat.koy_ayarlari = y.a.duplicate(true)
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	geri.yonetim.a = y.a.duplicate(true)
	geri.yonetim._ambar_kapasitesi()
	_kontrol(geri.yonetim.koylu(asker.id).is_kazasi == asker.is_kazasi and geri.yonetim._rng.state == y._rng.state, "Kaza ve RNG tam JSON roundtrip")
	for n in 3:
		y.gece()
		geri.yonetim.gece()
		_kontrol(asker.is_kazasi == geri.yonetim.koylu(asker.id).is_kazasi and y._rng.state == geri.yonetim._rng.state, "Yükleme aynı kaza süresini/RNG sonucunu sürdürür")
	_kontrol(asker.is_kazasi.is_empty() and not asker.bayrak_var("agir_yarali") and asker.saglik == 80, "Üç sonraki gece sonunda verim bayrağı kalkar, sağlık uydurulmaz")
	y.bosalt(asker.id)
	var c := y.kabul({"sinif": "ciftci", "stat": 5})
	var uygun := y.kabul({"sinif": "asker", "stat": 5})
	c.moral = 80
	uygun.moral = 80
	_kontrol(y.muhafiz_ata(c.id) and y.muhafiz_ata(uygun.id), "Gerçek nöbet atamaları")
	var savunma := y.savunma_gucu()
	var akce := 100
	y.akce = akce
	y.asayis_riski = 10
	y._rng.seed = _tohum(0.10)
	var rapor := y.gece()
	_kontrol(IsKazalari.uyuyor(c) and not IsKazalari.uyuyor(uygun) and y.muhafiz_sayisi() == 2 and y.etkin_muhafiz_sayisi() == 1, "Çiftçi nöbette uyur, asker bağışık; görev yuvası korunur")
	_kontrol(y.savunma_gucu() == savunma - 1 and y.asayis_riski == maxi(0, 15 - y.a.asayis_sonum - y.a.muhafiz_asayis), "Uyuklama o gecenin gerçek savunma/asayişini düşürür")
	_kontrol(rapor["olaylar"].any(func(e: Dictionary) -> bool: return e["anahtar"].contains("uyuyakaldı")), "Nöbet kazası gerçek raporda")
	_kontrol(rapor["akce_once"] - y.akce == 2 * y.a.muhafiz_maas, "Uyuklama maaşı veya yuva sınırını gizlice değiştirmez")
	y.gece()
	_kontrol(not IsKazalari.uyuyor(c) and y.etkin_muhafiz_sayisi() == 2, "Uyuklama sonraki gece sona erer")
	y.bosalt(c.id)
	var rng := y._rng.state
	IsKazalari.gece(y, {}, [])
	_kontrol(y._rng.state == rng, "Boşta ve uyumlu işte kaza zarı atılmaz")
	y.ata(c.id, b.id)
	_kontrol(IsKazalari.risk(c, y) == 0.0, "Çiftçi tarlada uyumlu")
	y.ata(asker.id, b.id)
	IsKazalari.gece(y, {}, [])
	_kontrol(y._rng.state == rng, "Fiilî üretim yokken sakatlanma zarı yok")
	y._rng.seed = _tohum(0.08)
	rng = y._rng.state
	y.isyan_kalan = 1
	y.gece()
	_kontrol(asker.is_kazasi.is_empty() and y._rng.state == rng, "Gerçek isyan gecesinde üretim yok; kaza zarı yok")
	asker.bayraklar.append("agir_yarali")
	IsKazalari.gece(y, {asker.id: b.id}, [])
	_kontrol(asker.bayrak_var("agir_yarali") and asker.is_kazasi.is_empty() and y._rng.state == rng, "Kaynak ağır yaralı bayrağı sahiplenilmez veya temizlenmez")
	_kontrol(Koylu.kayittan({"id": 1}).is_kazasi.is_empty(), "Eski kayıt kazasız yüklenir")
	for bozuk in [null, {}, {"tur": "yaralanma", "kalan": 1.5, "bayrak_eklendi": true}, {"tur": "uyuklama", "kalan": 3, "bayrak_eklendi": false}, {"tur": "sil", "kalan": 1, "bayrak_eklendi": false}]:
		_kontrol(IsKazalari.oku(bozuk).is_empty(), "Bozuk kaza kaydı reddedilir")
	print("İŞ KAZALARI: GEÇTİ" if hata == 0 else "İŞ KAZALARI: KALDI")
	quit(hata)
func _tohum(risk: float) -> int:
	var zar := RandomNumberGenerator.new()
	var n := 1
	while true:
		zar.seed = n
		if zar.randf() < risk: return n
		n += 1
	return n
func _kur(y: KoyYonetimi) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("tarla", h)["olur"]:
				var b := y.bina(y.bina_kur("tarla", h)["id"])
				b.insa_kalan = 0
				return b
	return null
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
