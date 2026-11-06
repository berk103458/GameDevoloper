extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 3535)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 100000
	y.a.evsiz_moral = 0
	y.a.isyan_esigi = -1
	y.akce = 10000
	y.kaynaklar = Kaynaklar.new(100000, {"gida":10000,"su":10000,"odun":10000})
	for i in 3: y.kabul({"ad":"Boşta %d" % i,"sinif":"esnaf"})
	var olcumler: Array[Dictionary] = []
	for gece in 20:
		var r := y.gece()
		dene(y.gun == gece + 1 and y.son.is_empty(), "Gerçek gece tamamlanır")
		var once := o.kaydet()
		var olcum := DengeOlcumu.olustur(o,r)
		olcumler.append(olcum)
		dene(o.kaydet() == once, "Ölçüm kayıt/RNG değiştirmez")
		if gece < 2: dene(olcum.bosta_terk.kisiler.is_empty(), "ISG-03 öncesi erken istek yok")
	var foto := o.kaydet()
	var rapor := DengeOlcumu.bosta_terk_raporu(olcumler)
	print("DEN-35 gerçek ölçüm: ", rapor)
	dene(rapor.get("hazir",false) and rapor.get("gun",0) == 20 and rapor.get("terk_istegi_sayisi",-1) == 3 and rapor.get("bantta",false), "Üç kişilik boş köyde20 gecede üç istek, veri bandında")
	dene(DengeOlcumu.bosta_terk_raporu(olcumler) == rapor and o.kaydet() == foto, "Tekrar salt okunur")
	dene(not DengeOlcumu.bosta_terk_raporu(olcumler.slice(0,19)).get("hazir",true), "Eksik pencere kabul edilmez")
	var ayni := olcumler.duplicate(true)
	ayni.append(ayni[0].duplicate(true))
	dene(DengeOlcumu.bosta_terk_raporu(ayni) == rapor, "Mükerrer fotoğraf sayılmaz")
	ayni.back().bosta_terk.kisiler = [999]
	dene(not DengeOlcumu.bosta_terk_raporu(ayni).get("hazir",true), "Çelişen gece reddedilir")
	var sentetik: Array[Dictionary] = []
	for gun in 20: sentetik.append({"bosta_terk":{"gun":gun,"kisiler":[1] if gun in [2,3,5] else []}})
	dene(DengeOlcumu.bosta_terk_raporu(sentetik).get("terk_istegi_sayisi",-1) == 2, "Süren istek tek, sıfırlandıktan sonraki yeniden istek ayrı")
	var tasan := sentetik.duplicate(true)
	for satir in tasan: satir.bosta_terk.kisiler = [1,2,3,4] if int(satir.bosta_terk.gun) == 3 else []
	dene(not DengeOlcumu.bosta_terk_raporu(tasan).get("bantta",true), "Üst bant dışı sonuç otomatik düzeltilmez")
	for bozuk in [{}, {"gun":true,"kisiler":[]}, {"gun":1,"kisiler":[true]}, {"gun":1,"kisiler":[1,1]}, {"gun":1,"kisiler":[0]}]:
		var kotu := sentetik.duplicate(true)
		kotu[0].bosta_terk = bozuk
		dene(not DengeOlcumu.bosta_terk_raporu(kotu).get("hazir",true), "Bozuk kişi/gece fotoğrafı reddedilir")
	sentetik[1].bosta_terk.gun = 30
	dene(not DengeOlcumu.bosta_terk_raporu(sentetik).get("hazir",true), "Kesik pencere kabul edilmez")
	print("BOŞTA TERK ÖLÇÜMÜ: GEÇTİ" if hata == 0 else "BOŞTA TERK ÖLÇÜMÜ: KALDI")
	quit(hata)
