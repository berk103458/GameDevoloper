extends SceneTree
## SOY-39: 30 gecelik gerçek koşuda DEN raporunun her gecesinde söylenti satırı (canlı, kamuoyu, yanlış oranı) vardır
## ve ağın kendisiyle uyuşur; hedefler (canlı ≤ 3, kamuoyu ≤ 1) öneridir, rapor yazılır.

var hata := 0


func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)


func _gelen(id: String) -> Gelen:
	var g := Gelen.new()
	g.id = StringName(id)
	g.ad_anahtari = "test"
	g.sinif = &"koylu"
	return g


func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 3939)
	o.yonetim.gun = 5
	o.gun = 5
	o.yonetim.a = o.yonetim.a.duplicate(true)
	o.yonetim.a.ambar_taban_kapasite = 1000000
	for i in 12:
		o.karar_ver(_gelen("ilk_%d" % i), &"kabul")
	var olcumler: Array[Dictionary] = []
	var uyumlu := true
	for gece in 30:
		if gece % 3 == 0:
			o.karar_ver(_gelen("yabanci_%d" % gece), &"ret" if gece % 2 == 0 else &"rusvet")
		o.karar_ver(_gelen("gocmen_%d" % gece), &"kabul")
		o.yonetim.kaynaklar = Kaynaklar.new(1000000, {"gida": 50000, "odun": 5000})
		var olcum := DengeOlcumu.olustur(o, o.gece_sonu())
		var s: Dictionary = olcum.get("soylenti", {})
		var a: RefCounted = SoylentiKoprusu.ag(o)
		var canli: Array = a.ag_kayitlari.values().filter(func(k: Dictionary) -> bool: return not bool(k.get("hukme_baglandi", false)))
		uyumlu = uyumlu and s.get("canli") == canli.size() and s.get("kamuoyu") == canli.filter(func(k: Dictionary) -> bool: return bool(k.kamuoyu_oldu)).size()
		olcumler.append(s)
	dene(olcumler.size() == 30 and uyumlu, "30 gecenin her DEN raporunda ağla uyuşan söylenti satırı")
	dene(olcumler.any(func(s: Dictionary) -> bool: return int(s.get("canli", 0)) > 0), "Koşuda söylenti yaşandı")
	var en_canli := 0
	var en_kamuoyu := 0
	var yanlis := 0.0
	for s in olcumler:
		en_canli = maxi(en_canli, int(s.get("canli", 0)))
		en_kamuoyu = maxi(en_kamuoyu, int(s.get("kamuoyu", 0)))
		yanlis += float(s.get("yanlis_orani", 0.0))
	print("SÖYLENTİ YOĞUNLUĞU: en çok canlı %d (hedef ≤ 3), en çok kamuoyu %d (hedef ≤ 1), ortalama yanlış oranı %.2f" % [en_canli, en_kamuoyu, yanlis / 30.0])
	print("SÖYLENTİ YOĞUNLUĞU: GEÇTİ" if hata == 0 else "SÖYLENTİ YOĞUNLUĞU: KALDI (%d hata)" % hata)
	quit(1 if hata > 0 else 0)
