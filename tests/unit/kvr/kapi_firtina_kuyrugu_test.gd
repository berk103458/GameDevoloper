extends SceneTree
func _initialize() -> void:
 var k := Katalog.new()
 k.yukle()
 var o := Oturum.new(k, 84)
 var y := o.yonetim
 var n := Node.new()
 KapiFirtinaKuyrugu.kur(o, n)
 assert(KapiFirtinaKuyrugu.kapasite(n) == KapiSahnesi.KUYRUK_GORUNEN)
 var normal := o.gece_kuyrugu()
 assert(normal.size() == 3)
 var g := o._adli_gelen(&"chr_001")
 var figur := Gelen.new()
 var sıra: Array[Gelen] = [g, figur]
 var s: RefCounted = g.chr_sorgusu()
 var bas: int = s.tansiyon
 var kaynak: int = s.karakter.baslangic_tansiyonu
 var rng := o._rng.state
 KapiFirtinaKuyrugu.beklet(o, sıra, 1)
 assert(s.tansiyon == bas and not figur.has_meta(KapiFirtinaKuyrugu.BEKLEME))
 IklimDeneyi.degistir(o, -1, "kar_firtinasi")
 KapiFirtinaKuyrugu.kur(o, n)
 assert(KapiFirtinaKuyrugu.kapasite(n) == 1)
 KapiFirtinaKuyrugu.beklet(o, sıra, 1)
 assert(s.tansiyon == bas + 1 and figur.get_meta(KapiFirtinaKuyrugu.BEKLEME).toplam == 1)
 KapiFirtinaKuyrugu.beklet(o, sıra, 1)
 assert(s.tansiyon == bas + 1)
 for i in range(2, 15): KapiFirtinaKuyrugu.beklet(o, sıra, i)
 assert(s.tansiyon == 10 and s.bayraklar.Flag_Kilitlendi and not s.karar_acik(&"kabul"))
 assert(s.karakter.baslangic_tansiyonu == kaynak and o._rng.state == rng)
 assert(KapiFirtinaKuyrugu.sira_olayi(o, n, 3) == null and o._rng.state == rng)
 y.gun = 26
 KapiFirtinaKuyrugu.kur(o, n)
 assert(KapiFirtinaKuyrugu.kapasite(n) == 0)
 var geri := Oturum.kayittan(k, JSON.parse_string(JSON.stringify(o.kaydet())))
 assert(KapiFirtinaKuyrugu.sinir(geri.yonetim) == 0)
 IklimDeneyi.degistir(o, -1, "normal")
 KapiFirtinaKuyrugu.kur(o, n)
 assert(KapiFirtinaKuyrugu.kapasite(n) == KapiSahnesi.KUYRUK_GORUNEN)
 n.free()
 print("FIRTINA KUYRUK: GEÇTİ")
 quit(0)
