extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func grup() -> Gelen:
	var g := Gelen.new()
	g.ad_anahtari = "Ali"
	g.secenekler = PackedStringArray(["kabul", "ret"])
	g.aile.assign([{"ad":"Ali","yas_grubu":"yetiskin"},{"ad":"Fatma","yas_grubu":"yetiskin"},{"ad":"Ayşe","yas_grubu":"cocuk"},{"ad":"Hasan","yas_grubu":"yasli"}])
	return g
func _initialize() -> void:
	if not FileAccess.file_exists("res://src/kapi/aile_kafilesi.gd"):
		dene(false, "Aile kafilesi henüz uygulanmadı")
		quit(hata)
		return
	var a = load("res://src/kapi/aile_kafilesi.gd")
	var kat := Katalog.new()
	kat.yukle()
	for karar in [&"kabul", &"ret", &"cocuklari_al"]:
		var o := Oturum.new(kat, 1517)
		var g := grup()
		dene(a.kisi_sayisi(g) == 4 and a.bolunur(g), "Dört kişilik ailede bölme var")
		var r := o.karar_ver(g, karar)
		dene(not r.get("engellendi", false), "Aile kararı işlenir")
		var beklenen := 4 if karar == &"kabul" else (1 if karar == &"cocuklari_al" else 0)
		dene(o.yonetim.nufus() == beklenen, "Kabul dört, bölme bir, ret sıfır köylü")
		dene(a.dedikodular(o).size() == (1 if karar == &"cocuklari_al" else 0), "Bölme tek dedikodu kaydı")
		var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
		dene(a.dedikodular(geri) == a.dedikodular(o), "Dedikodu kaydı kalıcı")
		if beklenen > 0:
			var haneler := {}
			for k in geri.yonetim.koylular: haneler[k.hane_id] = true
			dene(haneler.size() == 1 and not haneler.has(-1), "Kabul edilenler tek kalıcı hanedir")
		var once := o.kaydet()
		dene(o.karar_ver(g, karar).get("engellendi", false), "Kafile kararı tekrarlanmaz")
		dene(once == o.kaydet(), "İkinci çağrı etkisiz")
	var yatak := Oturum.new(kat, 1717)
	preload("res://src/sistemler/acilis_senaryosu.gd").kur(yatak)
	var aile := grup()
	dene(not preload("res://src/kapi/barinak_uyarisi.gd").yeter_mi(yatak.yonetim, a.kisi_sayisi(aile)), "İki boş yatak dört kişiye yetmez")
	aile.aile_id = "test_kafile"
	var geri_gelen := KapiAnlikGoruntusu.gelen_yukle(JSON.parse_string(JSON.stringify(KapiAnlikGoruntusu.gelen_kaydet(aile))), kat)
	dene(geri_gelen != null and a.kisi_sayisi(geri_gelen) == 4 and geri_gelen.aile_id == aile.aile_id, "Snapshot tek kafileyi korur")
	var tek := Oturum.new(kat, 17)
	tek.karar_ver(aile, &"kabul")
	var tek_geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(tek.kaydet())))
	dene(tek_geri.karar_ver(geri_gelen, &"kabul").get("engellendi", false) and tek_geri.yonetim.nufus() == 4, "Reis kimliği boşken de snapshot sonrası karar tekrarlanmaz")
	var kuyruk: Array[Gelen] = [Gelen.new(), Gelen.new()]
	var akis := Oturum.new(kat, 17)
	akis.gun = 1
	a.ekle(akis, kuyruk)
	dene(kuyruk.size() == 2 and a.kisi_sayisi(kuyruk[0]) == 4, "Aile üyeleri kuyruğa saçılmaz")
	var g := grup()
	g.aile.remove_at(2)
	dene(not a.bolunur(g), "Çocuksuz kafile bölünmez")
	g.aile.resize(1)
	dene(a.kisi_sayisi(g) == 1 and not a.bolunur(g), "Tek kişi sıradan gelendir")
	print("AİLE KAFİLESİ: GEÇTİ" if hata == 0 else "AİLE KAFİLESİ: KALDI")
	quit(hata)
