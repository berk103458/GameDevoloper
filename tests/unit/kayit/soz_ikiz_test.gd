extends SceneTree
# KAY-23: aynı mutlak takvimden yüklenen iki oturumun dedikodu yaşı.
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	_kasalar(kat)
	_takvim(kat)
	_sonlar(kat)
	var asil := Oturum.new(kat, 3123)
	asil.yonetim.gun = 8
	dene(asil.dedikodu.olay_kaydet("iki_gecelik", "rusvet", 6, "tanik_23", 3).olur, "Tanıklı iki gecelik fikstür")
	var veri: Dictionary = JSON.parse_string(JSON.stringify(asil.kaydet()))
	var a := Oturum.kayittan(kat, veri)
	var b := Oturum.kayittan(kat, veri)
	for o in [a, b]:
		var kayit: Dictionary = o.dedikodu.kayitlar()[0]
		dene(o.gun == 8 and o.gun - int(kayit.kayit_gecesi) == 2, "Yüklemede yaş tam iki gece")
		dene(int(kayit.yayilim_gecesi) == 9 and kayit.tanik_id == "tanik_23", "Tanık ve mutlak yayılma tarihi korunur")
		dene(not kayit.yayildi and not kayit.basildi, "Yüklemek yayın veya basım yapmaz")
		dene(o.dedikodu.pusula_satirlari(8).is_empty(), "İki gecelik haber erken basılmaz")
	dene(a.dedikodu.kaydet() == b.dedikodu.kaydet(), "JSON ikizlerinin kuyrukları aynı")
	for o in [asil, a, b]:
		o.gece_sonu()
		dene(o.gun == 9 and o.dedikodu.pusula_satirlari(9).size() == 1, "Gerçek üçüncü gecede tek yayın")
	# JSON sayıları float açar; karşılaştırmanın iki tarafını aynı sınırdan geçir.
	dene(JSON.parse_string(JSON.stringify(asil.dedikodu.kaydet())) == a.dedikodu.kaydet() and a.dedikodu.kaydet() == b.dedikodu.kaydet(), "Kayıtsız ve yüklenmiş zaman çizgileri aynı")
	print("KAYIT İKİZİ (KAY-23/45/46/47): GEÇTİ" if hata == 0 else "KAYIT İKİZİ (KAY-23/45/46/47): KALDI")
	quit(hata)

func _kasalar(kat: Katalog) -> void:
	# KAY-45: farklı tutarlar aktarımı ve birbirine karışmayı yakalar.
	for tutarlar in [[17, 71], [0, 83], [29, 0]]:
		var o := Oturum.new(kat, 3145)
		o.muhafiz_akce = tutarlar[0]
		o.koy_akce = tutarlar[1]
		for surum in [2, 3]:
			var veri: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
			veri.surum = surum
			var once := veri.duplicate(true)
			var geri := Oturum.kayittan(kat, veri)
			dene(geri != null, "Kasa fikstürü açılır")
			if geri == null: continue
			dene(geri.muhafiz_akce == tutarlar[0] and geri.koy_akce == tutarlar[1], "Kişisel kese ve köy akçesi göçte ayrı korunur")
			dene(geri.muhafiz_akce + geri.koy_akce == o.muhafiz_akce + o.koy_akce, "Göç para üretmez veya kaybetmez")
			dene(veri == once, "Kasa göçü kaynak veriyi değiştirmez")
			var ikiz := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(geri.kaydet())))
			dene(ikiz.muhafiz_akce == tutarlar[0] and ikiz.koy_akce == tutarlar[1], "Tekrar yüklemede transfer yok")
		dene(o.muhafiz_akce == tutarlar[0] and o.koy_akce == tutarlar[1], "Kaynak oturum kasaları aynı")

func _takvim(kat: Katalog) -> void:
	# KAY-46: ilk gün, her mevsim sınırının iki yanı ve yıl dönüşü.
	var sure := kat.koy_ayarlari.mevsim_gun
	for gun in [0, sure - 1, sure, 2 * sure - 1, 2 * sure, 3 * sure - 1, 3 * sure, 4 * sure - 1, 4 * sure, 8 * sure + 2]:
		var o := Oturum.new(kat, 3146)
		o.yonetim.gun = gun
		var once := MevsimYoneticisi.durum(o.yonetim)
		dene(o.gun == gun and o.yonetim.mevsim() == (gun / sure) % 4, "Sınır fikstürünün gerçek mevsimi")
		dene(int(once.mevsim_gunu) == gun % sure + 1, "Fikstürün mevsim günü")
		for surum in [2, 3]:
			var veri: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
			veri.surum = surum
			if surum == 2: veri.erase("mevsim")
			var geri := Oturum.kayittan(kat, veri)
			dene(geri != null, "Takvim kaydı açılır")
			if geri == null: continue
			dene(geri.gun == gun and MevsimYoneticisi.durum(geri.yonetim) == once, "Göç gün/mevsim/mevsim günü/yıl takvimini ilerletmez")
			var ikiz := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(geri.kaydet())))
			dene(ikiz.gun == gun and MevsimYoneticisi.durum(ikiz.yonetim) == once, "Tekrar yüklemede takvim aynı")
		dene(o.gun == gun and MevsimYoneticisi.durum(o.yonetim) == once, "Kaynak takvim korunur")

func _sonlar(kat: Katalog) -> void:
	var nihai = preload("res://src/sistemler/nihai_son.gd")
	var kimlikler := ["uc_tutundu", "ahi_kasabasi", "beyin_uc_koyu", "ertugrul_obasi", "tekfur_haraccisi"]
	dene(nihai.AYAR.sonlar.size() == 5, "SYS-20 tam beş nihai son")
	for id in kimlikler:
		var o := Oturum.new(kat, 3147)
		o.yonetim.gun = SonKilidi.kilit_gecesi()
		o.yonetim.kaynaklar = Kaynaklar.new(1000, {"gida":100, "su":100})
		o.yonetim.adalet = 50
		o.yonetim.asayis_riski = 60
		o.yonetim.savusturulan = 3
		for i in 6:
			var k := o.yonetim.kabul({"ad":"Son kişisi %d" % i})
			k.moral = 50
			k.refah = 40
		match id:
			"ahi_kasabasi":
				o.yonetim.adalet = 70
				for k in o.yonetim.koylular: k.refah = 80
			"beyin_uc_koyu":
				o.sancak_asker_talebi = {"son_gece":8,"gun":8,"bekliyor":false,"secim":0,"gonderilen":[1,2]}
			"ertugrul_obasi":
				o.bayraklar[StringName(ObaIttifaki.AYAR.ittifak_bayragi)] = true
			"tekfur_haraccisi":
				o.bayraklar[&"rusvet_sayisi"] = 200
		dene(nihai.son(o, &"zafer") == id, "Kaynak nihai son: " + id)
		for surum in [2,3]:
			var veri: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
			veri.surum = surum
			var geri := Oturum.kayittan(kat, veri)
			dene(geri != null, "Nihai son kaydı açılır")
			if geri == null: continue
			dene(nihai.son(geri, &"zafer") == id, "Göç nihai kimliği değiştirmez: " + id)
			dene(nihai.son(geri, &"zafer") in kimlikler, "Altıncı son üretilmez")
			dene(nihai.son(geri, &"isyan") == "", "Kayıp sonucu zafer kimliğine çevrilmez")
