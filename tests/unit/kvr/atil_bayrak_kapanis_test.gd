extends SceneTree
var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 1111)
	var y := o.yonetim
	y.kaynaklar = Kaynaklar.new(1000, {"gida": 200, "su": 200, "odun": 100})
	y.akce = 100
	y.gun = 1
	while not Takvim.hafta_basi(y.gun + 1, y.a.mevsim_gun): y.gun += 1
	var k := y.kabul({"ad": "Hasta"})
	SaglikYoneticisi.enfekte(y, k, "humma")
	k.bayrak_ac("hasta")
	k.moral = 50
	o.bayraklar[&"baci_tezgah"] = true
	o.bayraklar[&"dervis"] = true
	var kontrol := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	kontrol.bayraklar.clear()
	var once := y.akce
	var eski := kontrol.gece_sonu()
	var s := o.gece_sonu()
	dene(Takvim.hafta_basi(y.gun, y.a.mevsim_gun), "Gerçek gece hafta başına girdi")
	dene(s.rapor.akce == eski.rapor.akce + 2 and y.akce == s.rapor.akce, "Kira rapor kapanışına dahil")
	dene(s.rapor.huzur == y.huzur() and s.rapor.huzur == eski.rapor.huzur + 2, "Dua rapor Huzur kapanışına dahil")
	dene(s.rapor.akce_once == once and s.bilanco.kamu.sonra == s.rapor.akce, "Açılış korunur, bilanço mutabık")
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	dene(geri.akce == s.rapor.akce and geri.yonetim.huzur() == s.rapor.huzur, "JSON kayıt kapanışı aynı")
	var e: Array = s.olaylar.filter(func(x: Dictionary) -> bool: return x.has("atil_bayrak"))
	dene(e.size() == 1 and IflasYoneticisi.olay_metin(e[0]).contains("kira"), "Olay dict metni mevcut adaptörde")
	print("ATIL BAYRAK KAPANIS: GEÇTİ" if hata == 0 else "ATIL BAYRAK KAPANIS: KALDI")
	quit(hata)
