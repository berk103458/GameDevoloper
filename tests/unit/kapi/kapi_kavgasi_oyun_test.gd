## CAT-01: gerçek Oturum.karar_ver yolu, sahte oturum/karar yok.
extends SceneTree
const A = preload("res://src/kapi/kapi_kavgasi_adaptoru.gd")
var hata := 0
var kontrol := 0
var kat: Katalog

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	kat = Katalog.new()
	kat.yukle()
	if _kararlar() != true: hata += 1
	if _veri_ve_kuyruk() != true: hata += 1
	if _ayrilis() != true: hata += 1
	print("KAPI KAVGASI OYUN: %s (%d kontrol, %d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", kontrol, hata])
	quit(1 if hata > 0 else 0)

func _oturum(asker: bool, yatak: bool = false) -> Oturum:
	var o := Oturum.new(kat, 4242)
	if asker:
		var k := o.yonetim.kabul({"ad": "nöbetçi", "sinif": "asker"})
		o.yonetim.muhafiz_ata(k.id)
	if yatak:
		var b := KoyBinasi.new()
		b.id = 99
		b.tur = "kulube"
		b.insa_kalan = 0
		o.yonetim.binalar.append(b)
	return o

func _gelen(tip: String = "genc_erkek") -> Gelen:
	var g := Gelen.new()
	g.kavga_tip = tip
	g.ad_anahtari = "sablon.esnaf.ad1"
	g.secenekler = PackedStringArray(["kabul", "ret"])
	return g

func _kararlar() -> bool:
	for asker in [false, true]:
		for tip in ["", "listede_yok", "genc_erkek", "ac_aile_reisi", "asker_kacagi"]:
			for sert in [false, true]:
				var o := _oturum(asker, sert)
				var g := _gelen(tip)
				g.tehlikeli = sert
				var tanik := _gelen("")
				A.tanik_hazirla(o, [tanik])
				var r := o.karar_ver(g, &"ret")
				var uygun: bool = tip in ["genc_erkek", "ac_aile_reisi", "asker_kacagi"]
				dene(not r.get("engellendi", false) and not r.kaldi, "Gerçek ret işlendi")
				dene(r.get("ret_nedeni") == ("sert_ret" if sert else "yer_yoklugu"), "Neden mevcut yatak/kusurdan")
				dene(r.get("kavga_bayragi", -1) == int(asker and uygun), "Asker/tip/neden matrisi")
				dene(bool(r.get("sahne_acildi", false)) == (asker and uygun), "Sahne matrisi")
				if not asker and uygun:
					dene(r.durum == "tehdit_edip_gitti" and r.dedikodu_yazildi and o.dedikodu.kayitlar().size() == 1, "Tanıklı tehdit gerçek Dedikodu'da")
	var chr_o := _oturum(true, true)
	var chr_g := chr_o._adli_gelen(&"chr_001")
	chr_g.kavga_tip = "genc_erkek"
	chr_g.chr_sorgusu().bayraklar["Flag_Kilitlendi"] = true
	var chr_r := chr_o.karar_ver(chr_g, &"ret")
	dene(chr_r.get("ret_nedeni") == "sert_ret" and chr_r.get("kavga_bayragi", 0) == 1, "Gerçek CHR zorunlu ret kilidi")
	var o := _oturum(true, true)
	dene(o.karar_ver(_gelen(), &"ret").durum == "siradan_ret", "Yer var, kusur yok: sıradan ret")
	for mekan in ["koy_meydani", "sifahane", "divan"]:
		o = _oturum(true)
		o.set_meta(&"cat01_mekan", mekan)
		dene(o.karar_ver(_gelen(), &"ret").kavga_bayragi == 0, "Yasak mekan: " + mekan)
	o = _oturum(true)
	var g := _gelen()
	g.set_meta(DiplomatikHeyet.META, {})
	dene(o.karar_ver(g, &"ret").get("kavga_bayragi", 0) == 0 and A.al(o).kavga.aktif_kavga().is_empty(), "Heyet gerçek özel karar yolunda kavga açmaz")
	o = _oturum(true)
	g = _gelen()
	dene(o.karar_ver(g, &"ret").kavga_bayragi == 1, "İlk istek")
	dene(o.karar_ver(g, &"ret").kavga_bayragi == 0, "Tek oturum nesnesi günlük kilidi korur")
	o.yonetim.gun += 1
	dene(o.karar_ver(g, &"ret").kavga_bayragi == 1, "Ertesi gün istek açılabilir")
	o = _oturum(false)
	var r := o.karar_ver(_gelen(), &"ret")
	dene(not r.dedikodu_yazildi and o.dedikodu.kayitlar().is_empty(), "Tanıksız tehditte dedikodu yok")
	return true

func _veri_ve_kuyruk() -> bool:
	var o := _oturum(true)
	var gorulen := {}
	# Gerçek sınıf üretimini ve heybe/aile sonrasındaki veri eşlemesini sınar.
	for i in 100:
		var g := o._figur_sablon()
		g.heybe = o.heybe_uret(g.sinif)
		A.kuyruk_hazirla(o, [g])
		if not g.kavga_tip.is_empty():
			gorulen[g.kavga_tip] = true
			dene(o.karar_ver(g, &"ret").kavga_bayragi == 1, "Gerçek üretimden gelen tip gerçek rette açılır")
	dene(gorulen.has("genc_erkek") and gorulen.has("asker_kacagi"), "Gerçek şablon üretimi iki tipi veri tablosundan alır")
	var g := _gelen("")
	g.heybe = Heybe.new()
	g.aile = [{"ad": "reis"}, {"ad": "üye"}]
	A.kuyruk_hazirla(o, [g])
	dene(g.kavga_tip == "ac_aile_reisi", "Yoksul aile reisi veri eşlemesi")
	dene(o.karar_ver(g, &"ret").kavga_bayragi == 1, "Veriden aile tipi gerçek ret yolunda açılır")
	# Üretim hattındaki çağrı gerçek kuyrukta da bulunmalı.
	o.yonetim.gun = 9
	for i in 12:
		var kuyruk := o.gece_kuyrugu()
		for aday in kuyruk:
			if not aday.kavga_tip.is_empty(): gorulen["kuyruk"] = true
	dene(gorulen.has("kuyruk"), "gece_kuyrugu tip alanını gerçekten doldurur")
	return true

func _ayrilis() -> bool:
	for surgun in [false, true]:
		var o := _oturum(true)
		var r := o.karar_ver(_gelen(), &"ret")
		var id := o.yonetim.koylular[0].id
		if surgun: o.yonetim.surgun(id)
		else: o.yonetim.bosalt(id)
		dene(r.durum == "kacti" and not r.secenekler_acik and not r.sahne_acildi, "Gerçek görevden alma/sürgün açık sahneyi kaçışa çevirir")
	var o := _oturum(true)
	var a = A.al(o)
	var r := o.karar_ver(_gelen(), &"ret")
	# Henüz açılmamış isteğin aynı gerçek nöbet ayrılış sinyali.
	a.kavga._aktif_kavga.sahne_basladi = false
	o.yonetim.bosalt(o.yonetim.koylular[0].id)
	dene(r.durum == "tehdit_edip_gitti" and not r.sahne_acildi, "Bekleyen istek gerçek ayrılışta tehdide döner")
	return true

func dene(v: bool, ad: String) -> void:
	kontrol += 1
	if not v:
		hata += 1
		push_error(ad)
