extends SceneTree
## SOY-41: aynı tohumla iki gerçek koşuda söylenti ağının gece gece günlüğü eşittir.

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


func _kos(kat: Katalog) -> Array:
	var o := Oturum.new(kat, 4242)
	o.yonetim.gun = 5
	o.gun = 5
	o.yonetim.a = o.yonetim.a.duplicate(true)
	o.yonetim.a.ambar_taban_kapasite = 100000
	o.karar_ver(_gelen("yolcu_a"), &"ret")
	o.karar_ver(_gelen("rusvetci"), &"rusvet")
	for i in 30:
		o.karar_ver(_gelen("koylu_%d" % i), &"kabul")
	o.yonetim.kaynaklar = Kaynaklar.new(100000, {"gida": 20000, "odun": 2000})
	var gunluk: Array = []
	for gece in 6:
		o.gece_sonu()
		gunluk.append(JSON.stringify(SoylentiKoprusu.ag(o).kayit_verisi_al(), "", true))
	return gunluk


func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var bir := _kos(kat)
	var iki := _kos(kat)
	dene(bir.size() == 6 and bir == iki, "İki koşunun yayılım günlüğü eşit")
	dene(bir[0] != bir[3], "Günlük gece gece değişir")
	print("SÖYLENTİ İKİZ: GEÇTİ" if hata == 0 else "SÖYLENTİ İKİZ: KALDI (%d hata)" % hata)
	quit(1 if hata > 0 else 0)
