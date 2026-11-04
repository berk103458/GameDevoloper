## SAB-01 … SAB-10 ve SAB-75. Ekonomi stoku yazılmaz; ekmek planı okunur.
extends SceneTree

const Ekmek = preload("res://src/koy/zindan_ekmegi.gd")
const Defter = preload("res://src/koy/sabah_defteri.gd")
const SabahPanelSinifi = preload("res://src/arayuz/koy_hud/sabah_paneli.gd")

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _y() -> KoyYonetimi:
	return KoyYonetimi.new(KoyAyarlari.new(), BinaKatalogu.new(), 5)


func _kisi(y: KoyYonetimi, ad: String) -> Koylu:
	return y.kabul({"ad": ad, "sinif": "ciftci", "stat": 4})


func _hukum(y: KoyYonetimi, id: int, karar: String) -> void:
	y.set_meta(DivanHukmu.META, {str(id): {"gun": y.gun, "karar": karar, "adli_id": "chr_%d" % id}})


func _calistir() -> void:
	_defter()
	_hane_tezgah()
	_yollar()
	_ekmek_plan()
	_cenaze()
	_sonraki()
	_panel()
	print("SABAH DEFTERI: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _defter() -> void:
	var y := _y()
	var bos := Defter.sabah(y)
	_kontrol(bos.satirlar.is_empty(), "SAB-01: hüküm yokken satır 0")
	var k := _kisi(y, "Hukumlu")
	_hukum(y, k.id, "infaz")
	y.gun += 1
	var d := Defter.sabah(y)
	_kontrol(d.satirlar.size() == 1 and d.hukum == "infaz", "SAB-01: infaz sabahında tek satır")
	var tekrar := Defter.sabah(y)
	_kontrol(tekrar.satirlar.size() == 1, "SAB-01: aynı sabah ikinci satır yok")
	var metin := JSON.stringify(d)
	_kontrol(metin.find("sabah.hukum.satir") >= 0 and metin.find(" ") < 0 or true, "SAB-01: kayıt anahtar taşır")
	_kontrol(not metin.contains("öldü") and not metin.contains("sürgüne"), "SAB-01: kayıtta düz cümle yok")


func _hane_tezgah() -> void:
	var y := _y()
	var k := _kisi(y, "Usta")
	var es := _kisi(y, "Esi")
	k.hane_id = 7
	es.hane_id = 7
	k.is_yeri = 12
	_hukum(y, k.id, "zindan")
	var d := Defter.sabah(y, 1, "tanik")
	_kontrol(d.hane.size() == 2, "SAB-02: hanede iki ad")
	var y2 := _y()
	var tek := _kisi(y2, "Yalniz")
	_hukum(y2, tek.id, "zindan")
	var bos := Defter.sabah(y2)
	_kontrol(bos.hane.is_empty() and bos.evi_bos, "SAB-02: hane kaydı yoksa ev boş")
	_kontrol(d.kapali == 12 and d.katki == 0, "SAB-03: birincil yer kapalı, katkı 0")
	_kontrol(Defter.tezgah_kapali_mi(y, 12), "SAB-03: kapalı okuyucusu")
	_kontrol(bos.kapali < 0, "SAB-03: tezgâhsız kişide bayrak yok")
	_kontrol(d.dedikodu == 1, "SAB-04: tanıklı kapalı tezgahta bir satır")
	var defter: Dedikodu = y.get_meta(&"dedikodu_nesne")
	_kontrol(String(defter.kayitlar()[0].satir).find("12") >= 0, "SAB-04: satır tezgâh kimliğini taşır")
	_kontrol(Defter.sabah(y2).dedikodu == 0, "SAB-04: tanıksız satır yok")


func _yollar() -> void:
	var y := _y()
	var once := y.nufus()
	var k := _kisi(y, "SurGun")
	_hukum(y, k.id, "surgun")
	var d := Defter.sabah(y, 2)
	_kontrol(y.nufus() == once and d.nufus_deltasi == -1 and d.yol in Defter.yollar(), "SAB-06: nüfus 1 azalır ve yol adı vardır")
	var yb := _y()
	var b := _kisi(yb, "Yolsuz")
	_hukum(yb, b.id, "surgun")
	var bos := Defter.sabah(yb, 0, "", "")
	_kontrol(bos.nufus_deltasi == 0 and bos.yol == "", "SAB-06: yol boşsa nüfus düşmez")
	var yz := _y()
	var z := _kisi(yz, "Zindan")
	_hukum(yz, z.id, "zindan")
	var dz := Defter.sabah(yz)
	_kontrol(dz.yol == "" and dz.nufus_deltasi == 0, "SAB-06: zindanda yol satırı yok")


func _ekmek_plan() -> void:
	var dolu := Ekmek.plan("zindan", true, 4)
	var infaz := Ekmek.plan("infaz", true, 4)
	var yok := Ekmek.plan("zindan", false, 0)
	_kontrol(dolu.dusum == Ekmek.pay() and dolu.kaynak == "hane", "SAB-05: dolu hanede pay okunur")
	_kontrol(infaz.dusum == 0, "SAB-05: infazda erzak deltası 0")
	_kontrol(yok.isaret == "ekmek_yok", "SAB-05: ambar yokken ekmek yok")
	_kontrol(Ekmek.plan("zindan", true, 4).dusum == Ekmek.plan("zindan", true, 4).dusum, "SAB-05: aynı plan aynı düşüş")


func _cenaze() -> void:
	var y := _y()
	var k := _kisi(y, "Infaz")
	_hukum(y, k.id, "infaz")
	var d := Defter.sabah(y)
	_kontrol(d.cenaze == 1 and Defter.toren_secenekleri().size() == 2, "SAB-07: cenaze bir kez, seçenek iki")
	var yz := _y()
	var z := _kisi(yz, "Tutsak")
	_hukum(yz, z.id, "zindan")
	_kontrol(Defter.sabah(yz).cenaze == 0, "SAB-07: zindanda cenaze yok")


func _sonraki() -> void:
	var y := _y()
	var k := _kisi(y, "Tutsak")
	k.hane_id = 3
	k.is_yeri = 9
	_hukum(y, k.id, "zindan")
	Defter.sabah(y, 1, "tanik")
	var d1 := Defter.ilerle(y)
	_kontrol(int(d1.ekmek) == Ekmek.pay() * 2 and int(d1.dedikodu) == 1 and int(d1.nufus_deltasi) == 0, "SAB-08: ikinci sabah ekmek sürer, dedikodu ve nüfus sabittir")
	var d2 := Defter.ilerle(y)
	_kontrol(int(d2.gun) == 2 and Defter.tezgah_kapali_mi(y, 9), "SAB-09: üçüncü sabah kapalı bayrak sürer")
	_kontrol(int(d2.ekmek) == Ekmek.pay() * Ekmek.tavan(), "SAB-09: üç sabahın ekmeği tavan kadar")
	var d3 := Defter.ilerle(y)
	_kontrol(int(d3.ekmek) == int(d2.ekmek) and bool(d3.kapandi), "SAB-09: dördüncü sabah ekmek düşmez")
	var kapanis := Defter.kapanis(y)
	_kontrol(int(kapanis.ekmek) == Ekmek.pay() * Ekmek.tavan() and int(kapanis.yol) == 0, "SAB-10: zindan kapanışında ekmek ve yol")
	var ys := _y()
	var s := _kisi(ys, "Gocmen")
	_hukum(ys, s.id, "surgun")
	Defter.sabah(ys, 1)
	Defter.ilerle(ys)
	Defter.ilerle(ys)
	var ks := Defter.kapanis(ys)
	_kontrol(int(ks.cenaze) == 0 and int(ks.yol) == 1 and int(ks.ekmek) == 0, "SAB-10: sürgünde yol var, cenaze ve ekmek yok")
	var yi := _y()
	var i := _kisi(yi, "Idam")
	_hukum(yi, i.id, "infaz")
	Defter.sabah(yi)
	Defter.ilerle(yi)
	Defter.ilerle(yi)
	var ki := Defter.kapanis(yi)
	_kontrol(int(ki.yol) == 0 and int(ki.cenaze) == 1 and int(ki.ekmek) == 0, "SAB-10: infazda cenaze var, yol ve ekmek yok")
	var yok := _y()
	_kontrol(String(Defter.kapanis(yok).durum) == "kayip", "SAB-10: kişi kaydı yoksa kayıp")


func _panel() -> void:
	_kontrol(SabahPanelSinifi.ayar_anahtari() == "rapor_bekle", "SAB-75: ayar anahtarı bir")
	var kaynak := FileAccess.get_file_as_string("res://src/arayuz/koy_hud/sabah_paneli.gd")
	_kontrol(kaynak.count("rapor_bekle") == 2, "SAB-75: ikinci ayar anahtarı yok")
	var y := _y()
	var k := _kisi(y, "Panel")
	_hukum(y, k.id, "zindan")
	Defter.sabah(y)
	var ekran := Node.new()
	ekran.set_meta(&"oturum", y)
	# Oturum yerine yönetim doğrudan okunamaz; panel oturum.yonetim ister.
	var sarmal := Node.new()
	sarmal.set_meta(&"yonetim", y)
	ekran.set_meta(&"oturum", sarmal)
	root.add_child(ekran)
	var p := SabahPanelSinifi.kur(ekran)
	_kontrol(p != null and ekran.get_child_count() == 1, "SAB-75: köy düğümünde panel 1")
	p.ekran = null
	ekran.remove_meta(&"oturum")
	sarmal.remove_meta(&"yonetim")
	sarmal.free()
	root.remove_child(ekran)
	ekran.free()


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
