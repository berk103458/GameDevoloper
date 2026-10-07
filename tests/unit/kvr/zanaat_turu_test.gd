extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 95)
	# Kaynak kimlikleri için beklenen birincil roller; maske gerçek meslek sayılmaz.
	var beklenen := [0,1,8,0,0,0,11,12,0,10,1,13,1,5,4,13,5,4,14,1,3,15,16,17,18,19,20,21,9,6]
	for i in 30:
		var id := StringName("chr_%03d" % (i + 1))
		var g := o._adli_gelen(id)
		var kaynak: KarakterVerisi = kat.karakter(id)
		_kontrol(kaynak.zanaat_turu == beklenen[i], "CHR birincil meslek: " + String(id))
		var k := o.yonetim.kabul({"adli_id": id, "sinif": g.sinif, "stat": g.stat})
		_kontrol(k.zanaat_turu == beklenen[i] and k.sinif == g.sinif and k.stat == g.stat, "Kabulde meslek/sınıf/beceri ayrı: " + String(id))
		var veri := k.kaydet()
		_kontrol(veri["zanaat_turu"] is String and Koylu.kayittan(JSON.parse_string(JSON.stringify(veri))).zanaat_turu == beklenen[i], "Kararlı enum anahtarı JSON turu")
		veri.erase("zanaat_turu")
		_kontrol(Koylu.kayittan(veri).zanaat_turu == beklenen[i], "Eski CHR kaydı gerçek rolden tamamlanır")
	for sinif in [&"ciftci", &"esnaf", &"asker"]:
		var k := o.yonetim.kabul({"sinif": sinif})
		_kontrol(k.zanaat_turu == ZanaatTuru.coz(&"", sinif), "Genel köylü eski sınıftan türetilir")
	var kalayci := o.yonetim.kabul({"sinif": "esnaf", "zanaat_turu": "KALAYCI"})
	_kontrol(kalayci.zanaat_turu == ZanaatTuru.Tur.KALAYCI, "Enum explicit zanaat desteği")
	for v in [-1, 900, "UYDURMA", 1.5, null]:
		var veri := kalayci.kaydet()
		veri["zanaat_turu"] = v
		_kontrol(Koylu.kayittan(veri).zanaat_turu == ZanaatTuru.Tur.ESNAF, "Hatalı alan güvenli eski sınıfa döner")
	var normal := Oturum.new(kat, 98)
	var sonuc := normal.karar_ver(normal._adli_gelen(&"chr_003"), &"kabul")
	_kontrol(normal.yonetim.koylu(sonuc["koylu_id"]).zanaat_turu == ZanaatTuru.Tur.CERRAH, "Gerçek kapı kabul kararı cerrah rolünü taşır")
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	_kontrol(geri.yonetim.koylular.size() == o.yonetim.koylular.size() and geri.yonetim.koylular.back().zanaat_turu == ZanaatTuru.Tur.KALAYCI, "Tam oturum kayıt turunda açık rol korunur")
	print("ZANAAT TÜRÜ: GEÇTİ" if hata == 0 else "ZANAAT TÜRÜ: KALDI")
	quit(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
