## Köy yönetimi çekirdeği (design/gdd/koy-yonetimi.md). Düz betik:
##   godot --headless --path . -s tests/unit/koy_yonetimi/koy_yonetimi_test.gd   (çıkış 0 = geçti)
extends SceneTree

var _hata := 0
var _a: KoyAyarlari
var _k: BinaKatalogu


func _init() -> void:
	_a = load("res://data/ayarlar/koy.tres")
	_k = BinaKatalogu.new()
	_takvim()
	_ambar()
	_formul()
	_izgara()
	_insa_ve_uretim()
	_ticaret()
	_vergi_ve_maas()
	_kapi_kararlari()
	_husumet()
	_sur_ve_rezerv()
	_tuketim_ve_kis()
	_isyan()
	_emniyet_ve_son()
	_tekfur()
	_kayit()
	print("KOY YONETIMI TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(1 if _hata > 0 else 0)


func _koy(nufus: int = 0) -> KoyYonetimi:
	var y := KoyYonetimi.new(_a, _k, 7)
	for i in nufus:
		y.kabul({"ad": "k%d" % i, "sinif": "ciftci", "stat": 5})
	return y


## Meydanın güneyindeki patikanın hemen yanına (doğu) bir yapı kurar ve hazır eder.
func _kur(y: KoyYonetimi, tur: String, hucre: Vector2i) -> int:
	y.kaynaklar.kapasite = 10000
	for t in ["odun", "tas", "kereste", "alet"]:
		y.kaynaklar.ekle(t, 50)
	var d := y.bina_kur(tur, hucre)
	_esit("kurulum %s" % tur, d["olur"], true)
	y.bina(d["id"]).insa_kalan = 0
	return d["id"]


func _takvim() -> void:
	var m := _a.mevsim_gun
	_esit("gün 20 sonbahar", Takvim.mevsim(20, m), 2)
	_esit("gün 21 kış", Takvim.kis_mi(21, m), true)
	_esit("gün 27 kış", Takvim.kis_mi(27, m), true)
	_esit("gün 28 yeni yıl ilkbahar", Takvim.mevsim(28, m), 0)
	_esit("gün 7 hafta başı", Takvim.hafta_basi(7, m), true)
	_esit("gün 0 hafta başı değil", Takvim.hafta_basi(0, m), false)


func _ambar() -> void:
	var k := Kaynaklar.new(10)
	_esit("ambar sığan kadar", k.ekle("odun", 15), 10)
	_esit("ambar dolu", k.dolu_mu(), true)
	_esit("yetmeyen harcama dokunmaz", k.harca({"odun": 11}), false)
	_esit("harcama", k.harca({"odun": 4}), true)
	_esit("kalan", k.miktar("odun"), 6)


func _formul() -> void:
	var c := _a.flag_carpanlari
	_esit("çarpan sade", Uretim.bilesik_carpan(PackedStringArray(), "ciftci", c, _a.carpan_alt, _a.carpan_ust), 1.0)
	_yakin("çarpan usta", Uretim.bilesik_carpan(PackedStringArray(["usta_ciftci"]), "ciftci", c, _a.carpan_alt, _a.carpan_ust), 1.3)
	_yakin("alakasız usta 1.0", Uretim.bilesik_carpan(PackedStringArray(["usta_tasci"]), "ciftci", c, _a.carpan_alt, _a.carpan_ust), 1.0)
	_yakin("olumsuz 0.7", Uretim.bilesik_carpan(PackedStringArray(["tembel"]), "ciftci", c, _a.carpan_alt, _a.carpan_ust), 0.7)
	_yakin("alt sınır 0.4", Uretim.bilesik_carpan(PackedStringArray(["tembel", "agir_yarali", "hasta"]), "", c, _a.carpan_alt, _a.carpan_ust), 0.4)
	_yakin("formül stat 5", Uretim.gunluk(2.0, 5, 1.0), 2.0)
	_yakin("formül stat 10 usta", Uretim.gunluk(2.0, 10, 1.3), 3.9)


func _izgara() -> void:
	var y := _koy()
	var yol_x := _a.meydan.position.x + _a.meydan.size.x / 2
	var dibi := _a.meydan.end.y
	_esit("yol yanına kurulur", y.izgara.yerlesebilir(_hucreler(Vector2i(yol_x + 1, dibi + 1), Vector2i(2, 2)))["olur"], true)
	_esit("yoldan uzak kurulmaz", y.izgara.yerlesebilir(_hucreler(Vector2i(1, 1), Vector2i(2, 2)))["neden"], "yol_yok")
	_esit("yolun üstüne kurulmaz", y.izgara.yerlesebilir(_hucreler(Vector2i(yol_x, dibi + 1), Vector2i(2, 2)))["neden"], "dolu")
	_esit("sınır dışı", y.izgara.yerlesebilir(_hucreler(Vector2i(23, 23), Vector2i(2, 2)))["neden"], "sinir")
	_esit("bağlı yol döşenir", y.yol_kur(Vector2i(yol_x - 1, dibi + 2)), true)
	_esit("kopuk yol döşenmez", y.yol_kur(Vector2i(2, 2)), false)


func _insa_ve_uretim() -> void:
	var y := _koy(3)
	var d := y.bina_kur("tarla", _sag_yol(y))
	_esit("tarla kuruldu", d["olur"], true)
	var b := y.bina(d["id"])
	_esit("iskele: hazır değil", b.hazir(), false)
	_esit("hazır olmayan yapıya atanmaz", y.ata(y.koylular[0].id, b.id), false)
	y.kaynaklar.ekle("gida", 50)
	y.gece()
	_esit("üç boştaki işçi inşaatı bitirdi", b.hazir(), true)
	for k in y.koylular:
		_esit("atama", y.ata(k.id, b.id), true)
	var fazla := y.kabul({"ad": "fazla", "stat": 5})
	_esit("yuva dolu", y.ata(fazla.id, b.id), false)
	var once := y.kaynaklar.miktar("gida")
	var r := y.gece()
	_esit("üç uyumlu çiftçi 9 gıda + 0.6 kesir üretti", int(r["uretim"].get("gida", 0)), 9)
	_esit("dört kişi 4 yedi", y.kaynaklar.miktar("gida"), once + 9 - 4 - int(r.ziyan.bozulma.get("gida", 0)))
	# Yıkım: harcananın yarısı döner.
	var odun := y.kaynaklar.miktar("odun")
	y.bina_yik(b.id)
	_esit("yıkım iadesi", y.kaynaklar.miktar("odun"), odun + int(_k.maliyet("tarla")["odun"] * _a.yikim_iade))
	_esit("çalışanlar boşta", y.bostakiler().size(), 4)
	# Reçete girdisi yoksa yapı bekler.
	var h := _kur(y, "hizarhane", _sag_yol(y))
	y.recete_sec(h, "kereste")
	y.kaynaklar.azalt("odun", 1000)
	y.ata(y.koylular[0].id, h)
	y.gece()
	_esit("girdi yok: bekliyor", y.bina(h).bekliyor, "girdi")


func _ticaret() -> void:
	var y := _koy()
	y.kaynaklar.ekle("odun", 100)
	var once := y.akce
	var r := y.tezgah_sat("odun", 100)
	_esit("tezgâh günlük tavanı", r["akce"], _a.tezgah_gunluk_azami)
	_esit("tezgâh yalnız gereken kadar satar", r["satilan"] < 100, true)
	_esit("tavan dolunca satış yok", y.tezgah_sat("odun", 10)["akce"], 0)
	_esit("akçe arttı", y.akce, once + _a.tezgah_gunluk_azami)
	while not y.kervan_gunu():
		y.gece()
	var k := y.kervana_sat("odun", 20)
	_esit("kervan tam fiyat", k["akce"], int(20 * float(_a.kervan_fiyat["odun"])))


func _vergi_ve_maas() -> void:
	var y := _koy(4)
	y.kaynaklar.ekle("gida", 100)
	y.koylular[0].stat = 8
	var once := y.akce
	for i in _a.mevsim_gun:
		y.gece()
	_esit("haftalık vergi: 3 işçi + 1 usta", y.akce - once, 3 * _a.vergi_isci + _a.vergi_usta)
	y.muhafiz_ata(y.koylular[1].id)
	once = y.akce
	y.gece()
	_esit("muhafız günlük maaş", once - y.akce, _a.muhafiz_maas)


func _kapi_kararlari() -> void:
	var y := _koy()
	var once := y.akce
	var k := y.kabul({"ad": "yoksul"}, true)
	_esit("harç: sömürülmüş", k.bayrak_var("somurulmus"), true)
	_esit("harç: sadakat %30 düşer", k.sadakat, int(_a.baslangic_sadakat * (1.0 - _a.harc_sadakat_orani)))
	_esit("harç: adalet düşer", y.adalet, 70 - _a.harc_adalet)
	_esit("harç: akçe", y.akce, once + _a.harc_akce)
	y.kabul({"ad": "şüpheli"}, false, 5)
	_esit("rüşvet: asayiş riski", y.asayis_riski, 10 + _a.rusvet_asayis)
	# Zengin alınıp usta reddedilirse herkes moral kaybeder.
	y.kabul({"ad": "zengin"}, false, 0, true)
	y.ret("usta çiftçi", true, "ciftci")
	var m := y.koylular[0].moral
	y.kaynaklar.ekle("gida", 50)
	y.gece()
	_esit("iltimas moral cezası", y.koylular[0].moral <= m - _a.iltimas_moral + _a.tok_moral, true)
	_esit("Tekfur'a geçen usta", "ciftci" in y.husumet.tekfura_gecenler, true)


func _husumet() -> void:
	var h := Husumet.new()
	h.ret("a", 0, false, "", _a)
	h.ret("b", 0, true, "", _a)
	_esit("husumet 1 + 3", h.puan, _a.husumet_gerekceli + _a.husumet_haksiz)
	var rng := RandomNumberGenerator.new()
	rng.seed = 1
	h.gece(_a, 0, rng)
	_esit("husumet söner", h.puan, _a.husumet_gerekceli + _a.husumet_haksiz - _a.husumet_sonum)
	var kesin := _a.duplicate() as KoyAyarlari
	kesin.baskin_zar = 1.0
	kesin.sizma_zar = 1.0
	h.puan = kesin.baskin_esigi + 5
	_esit("baskın eşiği", h.gece(kesin, 0, rng), "baskin")
	h.puan = kesin.sizma_esigi + 1
	_esit("sızma eşiği", h.gece(kesin, 0, rng), "sizma")
	kesin.baskin_zar = 0.1
	h.puan = kesin.baskin_esigi + 5
	_esit("muhafız zarı düşürür", h.gece(kesin, 1, rng), "")


func _sur_ve_rezerv() -> void:
	var y := _koy()
	y.akce = 100
	for i in _a.sur_taksit:
		_esit("sur taksiti %d" % i, y.sur_taksit_ode(), true)
	_esit("son taksitle sur 1", y.sur_seviye, 1)
	y.akce = _a.rezerv + y.sur_taksiti() - 1
	_esit("rezerv kilidi", y.sur_taksit_ode(), false)


func _tuketim_ve_kis() -> void:
	var y := _koy(2)
	y.kaynaklar.azalt("gida", 1000)
	y.gece()
	_esit("açlık sağlık", y.koylular[0].saglik, 100 - _a.aclik_saglik)
	_esit("aç işaretli", y.koylular[0].ac, true)
	var z := _koy(2)
	z.gun = 21
	z.kaynaklar.ekle("gida", 50)
	z.kaynaklar.azalt("odun", 1000)
	z.gece()
	_esit("kış odunsuz sağlık", z.koylular[0].saglik, 100 - _a.soguk_saglik)
	var t := _koy(1)
	t.gun = 21
	var tarla := _kur(t, "tarla", _sag_yol(t))
	t.ata(t.koylular[0].id, tarla)
	t.gece()
	_esit("kışın çiftçi tarladan kaydırıldı", t.koylular[0].is_yeri != tarla, true)
	t.gun = 28
	t.gece()
	_esit("baharda tarlaya döndü", t.koylular[0].is_yeri, tarla)


func _isyan() -> void:
	var y := _koy(6)
	y.kaynaklar.ekle("gida", 100)
	for k in y.koylular:
		k.moral = 0
	y.gece()
	_esit("isyan başladı", y.isyan_kalan, _a.isyan_gun)
	for i in _a.isyan_gun:
		for k in y.koylular:
			k.moral = 0
		y.gece()
	_esit("isyan bitmedi: son", y.son, KoyYonetimi.SON_ISYAN)
	var z := _koy(6)
	z.kaynaklar.ekle("gida", 100)
	for k in z.koylular:
		k.moral = 0
	z.gece()
	_esit("aş dağıt", z.as_dagit(), true)
	z.vergi_sifirla()
	z.gece()
	_esit("isyandan çıkış", z.isyan_kalan, -1)


func _emniyet_ve_son() -> void:
	var y := _koy(1)
	y.kaynaklar.ekle("gida", 100)
	for i in 6:
		y.gece()
	_esit("5'e hiç ulaşmayan köy kırılmaz", y.son, "")
	var z := _koy(5)
	z.kaynaklar.ekle("gida", 100)
	for i in 3:
		z.surgun(z.koylular[0].id)
	z.gece()
	_esit("4. günden önce kırılmaz", z.son, "")
	for i in 4:
		z.gece()
	_esit("kilit açılınca halk kırıldı", z.son, KoyYonetimi.SON_HALK)


func _tekfur() -> void:
	var y := _koy(_a.agalik_nufus)
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	y.kaynaklar.ekle("gida", 2000)
	y.gece()
	_esit("ağalık", y.agalik, true)
	while not y.harac_bekliyor:
		y.gece()
	y.akce = 100
	_esit("haraç ödendi", y.harac_ode(), true)
	while not y.harac_bekliyor:
		y.gece()
	y.harac_reddet()
	y.sur_seviye = 0
	for k in y.koylular:
		k.sinif = &"ciftci"
	y.gece()
	_esit("savunmasız köy Tekfur'a düşer", y.son, KoyYonetimi.SON_TEKFUR)


func _kayit() -> void:
	var y := _koy(3)
	_kur(y, "kulube", _sag_yol(y))
	y.ret("x", true)
	y.gece()
	var z := KoyYonetimi.kayittan(_a, _k, JSON.parse_string(JSON.stringify(y.kaydet())))
	_esit("kayıt: nüfus", z.nufus(), y.nufus())
	_esit("kayıt: gün", z.gun, y.gun)
	_esit("kayıt: husumet", z.husumet.puan, y.husumet.puan)
	_esit("kayıt: ızgara", z.izgara.dolu.size(), y.izgara.dolu.size())
	_esit("kayıt: evler", z.koylular[0].ev, y.koylular[0].ev)
	var g := GuvenliKayit.new("user://test_kayit.json")
	g.sil()
	_esit("güvenli yaz", g.yaz({"a": 1}), true)
	_esit("güvenli yaz 2", g.yaz({"a": 2}), true)
	var f := FileAccess.open("user://test_kayit.json", FileAccess.WRITE)
	f.store_string("{bozuk")
	f.close()
	var o := g.oku()
	_esit("bozuk kayıtta yedek", int(o.get("a", 0)), 1)
	_esit("yedekten işaretli", o.get("_yedekten", false), true)
	g.sil()


func _sag_yol(y: KoyYonetimi) -> Vector2i:
	# Patikanın doğusunda ilk boş ve uygun yer.
	var x := _a.meydan.position.x + _a.meydan.size.x / 2 + 1
	for yy in range(_a.meydan.end.y, _a.izgara_boyut.y):
		var h := Vector2i(x, yy)
		if y.izgara.yerlesebilir(_hucreler(h, Vector2i(3, 3)))["olur"]:
			return h
	return Vector2i(x, _a.meydan.end.y)


func _hucreler(h: Vector2i, b: Vector2i) -> Array[Vector2i]:
	var s: Array[Vector2i] = []
	for yy in b.y:
		for xx in b.x:
			s.append(h + Vector2i(xx, yy))
	return s


func _yakin(ad: String, g: float, b: float) -> void:
	if absf(g - b) > 0.001:
		_hata += 1
		print("  KALDI %s: %s != %s" % [ad, g, b])


func _esit(ad: String, gercek: Variant, beklenen: Variant) -> void:
	if gercek != beklenen:
		_hata += 1
		print("  KALDI %s: %s != %s" % [ad, gercek, beklenen])
