extends SceneTree
## SOY-21/07/11: meclis şikâyeti hükme bağlanınca kamuoyu söner, kopyalar kapanır; doğru kaynak +1, bozan −1;
## sabaha tek satır düşer ve kayıttan döner.

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


func _satir(r: Dictionary) -> int:
	return (r.get("olaylar", []) as Array).filter(func(x: Dictionary) -> bool: return String(x.anahtar).begins_with("Çınar altında hüküm")).size()


func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 3112)
	o.yonetim.gun = 5
	o.gun = 5
	o.yonetim.a = o.yonetim.a.duplicate(true)
	o.yonetim.a.ambar_taban_kapasite = 100000
	o.karar_ver(_gelen("yolcu_a"), &"ret")
	for i in 30:
		o.karar_ver(_gelen("koylu_%d" % i), &"kabul")
	o.yonetim.kaynaklar = Kaynaklar.new(100000, {"gida": 20000, "odun": 2000})
	var a: RefCounted = SoylentiKoprusu.ag(o)
	var asil := "kapi_haksiz_ret_5_yolcu_a"
	for gece in 4:
		o.gece_sonu()
	var kopyalar: Array = a.ag_kayitlari.keys().filter(func(id: String) -> bool: return id.begins_with(asil + "~"))
	dene(not kopyalar.is_empty() and not SoylentiKoprusu.meclis_sikayeti(o).is_empty(), "Kamuoyu şikâyeti ve bozuk kopya var")
	var kaynak := String(a.ag_kayitlari[asil].kaynak)
	var bozan := String(a.ag_kayitlari[kopyalar[0]].kaynak)
	var g_kaynak: int = a.guvenilirlik_al(kaynak)
	var g_bozan: int = a.guvenilirlik_al(bozan)
	var satir := SoylentiKoprusu.hukme_bagla(o)
	dene(not satir.is_empty(), "Hüküm verildi")
	dene(SoylentiKoprusu.meclis_sikayeti(o).is_empty() and SoylentiKoprusu.kamuoyu_satiri(o).is_empty(), "Hükümden sonra kamuoyu ve şikâyet 0")
	dene(kopyalar.all(func(id: String) -> bool: return bool(a.ag_kayitlari[id].hukme_baglandi)), "Bütün kopyalar kapandı")
	dene(a.guvenilirlik_al(kaynak) == mini(3, g_kaynak + 1), "Doğru çıkan kaynak +1")
	dene(a.guvenilirlik_al(bozan) == maxi(0, g_bozan - 1) and a.guvenilirlik_al(bozan) < g_bozan, "Yanlış çıkan bozan −1")
	dene(SoylentiKoprusu.hukme_bagla(o).is_empty(), "Aynı konu ikinci kez hükme bağlanmaz")
	dene(SoylentiKoprusu.defter_satirlari(o).any(func(s: Dictionary) -> bool: return bool(s.dogrulandi)), "Defterde doğrulandı")
	o = Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	dene(_satir(o.gece_sonu()) == 1, "Sabaha tek hüküm satırı (kayıttan sonra)")
	dene(_satir(o.gece_sonu()) == 0, "Ertesi sabah satır yok")
	print("SÖYLENTİ HÜKÜM: GEÇTİ" if hata == 0 else "SÖYLENTİ HÜKÜM: KALDI (%d hata)" % hata)
	quit(1 if hata > 0 else 0)
