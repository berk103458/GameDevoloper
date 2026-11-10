extends SceneTree
## SOY-14: grubu anan kamuoyu konusu DIY-12 grup itibarına bir kez yazar; grupsuz konu yazmaz.

var hata := 0


func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)


func _gelen(id: String, sinif: StringName) -> Gelen:
	var g := Gelen.new()
	g.id = StringName(id)
	g.ad_anahtari = "test"
	g.sinif = sinif
	return g


func _koy(kat: Katalog, sinif: StringName) -> Oturum:
	var o := Oturum.new(kat, 717)
	o.yonetim.gun = 5
	o.gun = 5
	o.yonetim.a = o.yonetim.a.duplicate(true)
	o.yonetim.a.ambar_taban_kapasite = 100000
	o.karar_ver(_gelen("yolcu_a", sinif), &"ret")
	for i in 20:
		o.karar_ver(_gelen("koylu_%d" % i, &"koylu"), &"kabul")
	o.yonetim.kaynaklar = Kaynaklar.new(100000, {"gida": 20000, "odun": 2000})
	return o


func _yazim(o: Oturum, grup: String) -> int:
	return o.grup_itibari.yazim_kayitlari().filter(func(x: Dictionary) -> bool: return x.grup == grup).size()


func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := _koy(kat, &"tuccar")
	var kamuoyu := false
	for i in 3:
		o.gece_sonu()
		kamuoyu = kamuoyu or not SoylentiKoprusu.kamuoyu_satiri(o).is_empty()
	dene(kamuoyu, "Tüccar reti kamuoyu oldu")
	dene(o.grup_itibari.deger("tuccar") == -1 and _yazim(o, "tuccar") == 1, "Tüccar itibarı bir kez −1")
	o = Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	for i in 2:
		o.gece_sonu()
	dene(_yazim(o, "tuccar") == 1 and o.grup_itibari.deger("tuccar") == -1, "Kayıttan sonra ikinci yazım yok")
	var c := _koy(kat, &"ciftci")
	for i in 3:
		c.gece_sonu()
	dene(not SoylentiKoprusu.kamuoyu_satiri(c).is_empty() and c.grup_itibari.yazim_kayitlari().is_empty(), "Grubu anmayan konu itibara yazmaz")
	print("SÖYLENTİ GRUP: GEÇTİ" if hata == 0 else "SÖYLENTİ GRUP: KALDI (%d hata)" % hata)
	quit(1 if hata > 0 else 0)
