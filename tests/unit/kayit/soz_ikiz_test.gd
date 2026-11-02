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
	_karantina(kat)
	_bina_ilerlemesi(kat)
	_terazi(kat)
	_tehdit_takvimi(kat)
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
	print("KAYIT İKİZİ (KAY-23/45/46/47/65/66/67/68): GEÇTİ" if hata == 0 else "KAYIT İKİZİ (KAY-23/45/46/47/65/66/67/68): KALDI")
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

func _karantina(kat: Katalog) -> void:
	for kalan in [1, 2]:
		var o := Oturum.new(kat, 3165)
		o.yonetim.gun = 10
		o.yonetim.kaynaklar.ekle("gida", 20)
		var b := KoyBinasi.new()
		b.id = 1
		b.tur = "sifahane"
		o.yonetim.binalar.append(b)
		var hekim := o.yonetim.kabul({"ad":"Hekim"})
		hekim.zanaat_turu = ZanaatTuru.Tur.CERRAH
		dene(o.yonetim.ata(hekim.id, b.id), "Karantina fikstüründe çalışan hekim")
		var k := o.yonetim.kabul({"ad":"Hasta"})
		k.saglik = 35
		k.enfeksiyon = {"tur":"humma", "bitis":14, "son_gece":9, "hasar_gecesi":-1, "hasta_sahibi":true}
		k.gizli_bayraklar.append("hasta")
		dene(KarantinaYoneticisi.al(o.yonetim, k.id), "Gerçek karantina giriş yolu")
		o.yonetim.gun = 12 - kalan
		var durum := k.karantina.duplicate(true)
		var hastalik := k.enfeksiyon.duplicate(true)
		for surum in [2, 3]:
			var veri: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
			veri.surum = surum
			var geri := Oturum.kayittan(kat, veri)
			dene(geri != null, "Karantina kaydı açılır")
			if geri == null: continue
			var hasta := geri.yonetim.koylu(k.id)
			dene(hasta != null and hasta.ad == k.ad, "Karantinadaki kişi kimliği korunur")
			if hasta == null: continue
			dene(hasta.karantina == durum and int(hasta.karantina.bitis) - geri.gun == kalan, "Bir veya iki gün kalan karantina sıfırlanmaz")
			dene(hasta.saglik == 35 and hasta.enfeksiyon == hastalik and SaglikYoneticisi.hasta(hasta), "Göç hastayı iyileştirmez")
			dene(not SaglikYoneticisi.temas_edebilir(geri.yonetim, hasta), "Yükleme karantina temas engelini kaldırmaz")

func _bina_ilerlemesi(kat: Katalog) -> void:
	var o := Oturum.new(kat, 3166)
	var b := KoyBinasi.new()
	b.id = 7
	b.tur = "kulube"
	b.hucre = Vector2i(3, 4)
	b.insa_kalan = 2
	b.seviye = 2
	b.harcanan = {"odun":8, "tas":4}
	o.yonetim.binalar.append(b)
	var once: Dictionary = JSON.parse_string(JSON.stringify(b.kaydet()))
	for surum in [2, 3]:
		var veri: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
		veri.surum = surum
		var korunmus := veri.duplicate(true)
		var geri := Oturum.kayittan(kat, veri)
		dene(geri != null, "Yarım bina kaydı açılır")
		if geri == null: continue
		dene(geri.yonetim.binalar.size() == 1, "Göç yeni bina oluşturmaz")
		var yuklu := geri.yonetim.bina(7)
		dene(yuklu != null, "Yarım bina kimliği korunur")
		if yuklu == null: continue
		dene(yuklu.insa_kalan == 2 and yuklu.seviye == 2 and not yuklu.hazir(), "Göç inşaatı bitirmez, günü/seviyeyi değiştirmez")
		dene(JSON.parse_string(JSON.stringify(yuklu.kaydet())) == once, "Bina türü/konumu/maliyeti dahil tüm kayıt aynı")
		dene(veri == korunmus, "Kaynak bina verisi değişmez")
		var ikiz := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(geri.kaydet())))
		dene(ikiz.yonetim.binalar.size() == 1 and ikiz.yonetim.bina(7).insa_kalan == 2 and ikiz.yonetim.bina(7).seviye == 2, "Tekrar yüklemede bina ilerlemez")
	dene(b.insa_kalan == 2 and b.seviye == 2, "Kaynak yarım bina korunur")

func _terazi(kat: Katalog) -> void:
	for adalet in [15, 73]:
		var o := Oturum.new(kat, 3167)
		o.yonetim.adalet = adalet
		o.karar_ver(o._adli_gelen(&"chr_001"), &"rusvet")
		o.koy_akce = 100
		dene(KasaTransferi.uygula(o, "zimmet", 5), "Terazi için gerçek zimmet")
		var once := MuhafizTerazisi.durum(o)
		dene(once.rusvet == 1 and once.zimmet == 5 and once.yozlasma > 0, "Gerçek makbuzlu terazi fikstürü")
		var kaynak := JSON.stringify(o.kaydet())
		for surum in [2, 3]:
			var veri: Dictionary = JSON.parse_string(kaynak)
			veri.surum = surum
			var geri := Oturum.kayittan(kat, veri)
			dene(geri != null, "Terazi kaydı açılır")
			if geri == null: continue
			dene(MuhafizTerazisi.durum(geri) == once, "Adalet/yozlaşma/denge/unvan ve makbuzlar göçte aynı")
			var ikiz := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(geri.kaydet())))
			dene(MuhafizTerazisi.durum(ikiz) == once, "Tekrar yüklemede skor çoğalmaz")
		dene(JSON.stringify(o.kaydet()) == kaynak and MuhafizTerazisi.durum(o) == once, "Kaynak terazi/kayıt korunur")

func _tehdit_takvimi(kat: Katalog) -> void:
	var varis := int(MogolOncusu.AYAR.varis_gunu)
	for gun in [0, varis - 5, varis - 2, varis, varis + 1]:
		var o := Oturum.new(kat, 3168)
		o.yonetim.gun = gun
		var olaylar: Array[Dictionary] = []
		var rapor := {"gun":gun - 1, "olaylar":olaylar}
		MogolOncusu.gece(o, rapor)
		var tehdit := MogolOncusu.durum(o)
		var takvim := MevsimYoneticisi.durum(o.yonetim)
		var uyari := MogolOncusu.oku(o.mogol_oncusu)
		dene(tehdit.kalan == maxi(0, varis - gun), "HAR-02 mutlak kalan gün fikstürü")
		dene(takvim.mevsim_gunu == gun % kat.koy_ayarlari.mevsim_gun + 1, "MEV-01 ayrı mevsim günü fikstürü")
		for surum in [2, 3]:
			var veri: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
			veri.surum = surum
			var geri := Oturum.kayittan(kat, veri)
			dene(geri != null, "Tehdit/takvim kaydı açılır")
			if geri == null: continue
			dene(MogolOncusu.durum(geri) == tehdit, "Moğol kalan günü göçte aynı")
			dene(MevsimYoneticisi.durum(geri.yonetim) == takvim, "Mevsim günü göçte ayrı korunur")
			dene(MogolOncusu.oku(geri.mogol_oncusu) == uyari, "Uyarı makbuzu korunur")
			var yeni_olaylar: Array[Dictionary] = []
			MogolOncusu.gece(geri, {"gun":gun - 1, "olaylar":yeni_olaylar})
			dene(yeni_olaylar.is_empty(), "Aynı gece yüklemesi uyarıyı tekrarlamaz")
