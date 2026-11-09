extends SceneTree

var _hata := 0

func _initialize() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var o := Oturum.new(katalog, 19)
	var g := Gelen.new()
	g.ad_anahtari = "test"
	g.tehlikeli = true
	g.heybe = Heybe.new()
	g.heybe.ekle("akce", "akce", 1, 3, false)
	g.heybe.ekle("gida", "gida", 2, 2, false)
	g.heybe.teklif = 3
	g.heybe.al(g.heybe.esyalar[1], 2)
	g.heybe.al(g.heybe.esyalar[0], 3)
	g.etkiler[&"rusvet"] = PackedInt32Array([0, 0, 2, 0])
	var kamu := o.koy_akce
	var ambar := o.ambar
	o.karar_ver(g, &"rusvet")
	_dene(o.koy_akce == kamu and o.akce == kamu and o.ambar == ambar, "cift_kasa_test.gd:20")
	_dene(o.muhafiz_akce == 3 and o.muhafiz_esyalari[0]["adet"] == 2, "cift_kasa_test.gd:21")
	o.akce += 10
	_dene(o.koy_akce == kamu + 10 and o.muhafiz_akce == 3, "cift_kasa_test.gd:23")
	var geri := Oturum.kayittan(katalog, JSON.parse_string(JSON.stringify(o.kaydet())))
	_dene(geri.koy_akce == o.koy_akce and geri.muhafiz_akce == 3 and geri.muhafiz_esyalari == o.muhafiz_esyalari, "cift_kasa_test.gd:25")
	var chr := Gelen.new()
	chr.adli = true
	chr.id = &"chr_001"
	var kazanc := preload("res://src/sistemler/cift_kasa_dagitimi.gd").kisisel_rusvet(chr, 999)
	_dene(kazanc["akce"] == 4, "cift_kasa_test.gd:30")
	var usta := o._adli_gelen(&"chr_003")
	usta.chr_sorgusu().bayraklar["Flag_Sir_Tamamen_Cozuldu"] = true
	var sonuc := o.karar_ver(usta, &"kabul")
	_dene(o.yonetim.koylu(sonuc["koylu_id"]).bayrak_var("usta_demirci"), "cift_kasa_test.gd:34")
	_dene(o.muhafiz_tecrubesi == 2, "cift_kasa_test.gd:35")
	print("ÇİFT KASA: GEÇTİ" if _hata == 0 else "ÇİFT KASA: KALDI (%d hata)" % _hata)
	quit(1 if _hata > 0 else 0)


func _dene(kosul: bool, ad: String) -> void:
	if not kosul:
		_hata += 1
		push_error(ad)
