extends SceneTree

var _hata := 0
func _initialize() -> void:
 var k := Katalog.new()
 k.yukle()
 var o := Oturum.new(k, 84)
 var y := o.yonetim
 var n := Node.new()
 KapiFirtinaKuyrugu.kur(o, n)
 _dene(KapiFirtinaKuyrugu.kapasite(n) == KapiSahnesi.KUYRUK_GORUNEN, "kapi_firtina_kuyrugu_test.gd:9")
 var normal := o.gece_kuyrugu()
 _dene(normal.size() == 3, "kapi_firtina_kuyrugu_test.gd:11")
 var g := o._adli_gelen(&"chr_001")
 var figur := Gelen.new()
 var sıra: Array[Gelen] = [g, figur]
 var s: RefCounted = g.chr_sorgusu()
 var bas: int = s.tansiyon
 var kaynak: int = s.karakter.baslangic_tansiyonu
 var rng := o._rng.state
 KapiFirtinaKuyrugu.beklet(o, sıra, 1)
 _dene(s.tansiyon == bas and not figur.has_meta(KapiFirtinaKuyrugu.BEKLEME), "kapi_firtina_kuyrugu_test.gd:20")
 IklimDeneyi.degistir(o, -1, "kar_firtinasi")
 KapiFirtinaKuyrugu.kur(o, n)
 _dene(KapiFirtinaKuyrugu.kapasite(n) == 1, "kapi_firtina_kuyrugu_test.gd:23")
 KapiFirtinaKuyrugu.beklet(o, sıra, 1)
 _dene(s.tansiyon == bas + 1 and figur.get_meta(KapiFirtinaKuyrugu.BEKLEME).toplam == 1, "kapi_firtina_kuyrugu_test.gd:25")
 KapiFirtinaKuyrugu.beklet(o, sıra, 1)
 _dene(s.tansiyon == bas + 1, "kapi_firtina_kuyrugu_test.gd:27")
 for i in range(2, 15): KapiFirtinaKuyrugu.beklet(o, sıra, i)
 _dene(s.tansiyon == 10 and s.bayraklar.Flag_Kilitlendi and not s.karar_acik(&"kabul"), "kapi_firtina_kuyrugu_test.gd:29")
 _dene(s.karakter.baslangic_tansiyonu == kaynak and o._rng.state == rng, "kapi_firtina_kuyrugu_test.gd:30")
 _dene(KapiFirtinaKuyrugu.sira_olayi(o, n, 3) == null and o._rng.state == rng, "kapi_firtina_kuyrugu_test.gd:31")
 y.gun = 26
 KapiFirtinaKuyrugu.kur(o, n)
 _dene(KapiFirtinaKuyrugu.kapasite(n) == 0, "kapi_firtina_kuyrugu_test.gd:34")
 var geri := Oturum.kayittan(k, JSON.parse_string(JSON.stringify(o.kaydet())))
 _dene(KapiFirtinaKuyrugu.sinir(geri.yonetim) == 0, "kapi_firtina_kuyrugu_test.gd:36")
 IklimDeneyi.degistir(o, -1, "normal")
 KapiFirtinaKuyrugu.kur(o, n)
 _dene(KapiFirtinaKuyrugu.kapasite(n) == KapiSahnesi.KUYRUK_GORUNEN, "kapi_firtina_kuyrugu_test.gd:39")
 n.free()
 print("FIRTINA KUYRUK: GEÇTİ" if _hata == 0 else "FIRTINA KUYRUK: KALDI (%d hata)" % _hata)
 quit(1 if _hata > 0 else 0)


func _dene(kosul: bool, ad: String) -> void:
 if not kosul:
  _hata += 1
  push_error(ad)
