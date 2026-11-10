extends SceneTree
## OMR-08: nüfus 18'e varınca "Köy oturdu" gecesinden sonraki kapı kuyruğu boştur; bir sonraki gece kapı yine açılır.

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
	var o := Oturum.new(kat, 808)
	o.yonetim.a = o.yonetim.a.duplicate(true)
	o.yonetim.a.ambar_taban_kapasite = 100000
	o.yonetim.kaynaklar = Kaynaklar.new(100000, {"gida": 20000, "odun": 2000})
	dene(not o.gece_kuyrugu().is_empty(), "Geçiş öncesi kuyruk dolu")
	for i in o.yonetim.a.agalik_nufus:
		o.karar_ver(_gelen("koylu_%d" % i), &"kabul")
	dene(not o.yonetim.agalik, "Gece öncesi ağalık kapalı")
	o.gece_sonu()
	dene(o.yonetim.agalik and GecisGecesi.gecis_gecesi_mi(o.yonetim), "Nüfus 18 gecesinden sonra geçiş gecesi")
	dene(o.gece_kuyrugu().is_empty(), "Geçiş gecesi kapı kuyruğu boş")
	o.gece_sonu()
	dene(not GecisGecesi.gecis_gecesi_mi(o.yonetim), "Ertesi gece geçiş bitti")
	dene(not o.gece_kuyrugu().is_empty(), "Ertesi gece kapı yine açık")
	print("OMR-08 GEÇİŞ GECESİ: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(1 if hata > 0 else 0)
