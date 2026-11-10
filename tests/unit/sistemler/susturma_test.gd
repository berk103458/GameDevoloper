extends SceneTree
## SOY-20: "Bunu konuşma" — güvenilir kaynakta yayılım durur, güvenilmezde hızlanır; oyuncuya iki durumda aynı söz.

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


func _koy(kat: Katalog) -> Oturum:
	var o := Oturum.new(kat, 515)
	o.yonetim.gun = 5
	o.gun = 5
	o.yonetim.a = o.yonetim.a.duplicate(true)
	o.yonetim.a.ambar_taban_kapasite = 100000
	o.karar_ver(_gelen("yolcu_a"), &"ret")
	for i in 40:
		o.karar_ver(_gelen("koylu_%d" % i), &"kabul")
	o.yonetim.kaynaklar = Kaynaklar.new(100000, {"gida": 20000, "odun": 2000})
	o.gece_sonu()
	return o


## Asıl kaydın kaynağına susturma söylenir; ertesi gece asıl kayıtta yeni duyan sayısı döner.
func _dene(kat: Katalog, guven: int) -> Array:
	var o := _koy(kat)
	var a: RefCounted = SoylentiKoprusu.ag(o)
	var id: String = a.ag_kayitlari.keys().filter(func(x: String) -> bool: return not x.contains("~"))[0]
	var kaynak := o.yonetim.koylu(int(a.ag_kayitlari[id].kaynak))
	var soz := ""
	if guven >= 0:
		a.guvenilirlikler[str(kaynak.id)] = guven
		soz = NeDuydun.susturma_cevabi(o, kaynak)
	var once: int = a.ag_kayitlari[id].duyanlar.size()
	o.gece_sonu()
	return [a.ag_kayitlari[id].duyanlar.size() - once, soz]


func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var normal := _dene(kat, -1)
	var sessiz := _dene(kat, 3)
	var ters := _dene(kat, 0)
	dene(int(normal[0]) > 0, "Susturmasız yayılım sürer")
	dene(int(sessiz[0]) == 0, "Güvenilir kaynak susunca yayılım durur")
	dene(int(ters[0]) > int(normal[0]), "Güvenilmez kaynakta susturma yayılımı hızlandırır")
	dene(sessiz[1] == ters[1] and not String(sessiz[1]).is_empty(), "Oyuncu iki durumda aynı sözü görür")
	print("SUSTURMA: GEÇTİ" if hata == 0 else "SUSTURMA: KALDI (%d hata)" % hata)
	quit(1 if hata > 0 else 0)
