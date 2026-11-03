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
	_goc_fixturu(kat)
	_kasalar(kat)
	_takvim(kat)
	_sonlar(kat)
	_karantina(kat)
	_bina_ilerlemesi(kat)
	_terazi(kat)
	_tehdit_takvimi(kat)
	_kapi_ikizi(kat)
	_zar_ve_soz(kat)
	_guven_itibar(kat)
	_diyalog_sirasi(kat)
	_sure_olcusu(kat)
	_yuz_tohum(kat)
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
	print("KAYIT İKİZİ (KAY-19/20/21/22/23/45/46/47/48/49/59/65/66/67/68/69/72): GEÇTİ" if hata == 0 else "KAYIT İKİZİ (KAY-19/20/21/22/23/45/46/47/48/49/59/65/66/67/68/69/72): KALDI")
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

func _goc_fixturu(kat: Katalog) -> void:
	# KAY-59: tek test komutu v2 fikstürünü kendisi kurar; oyuncu dosyası yok.
	var o := Oturum.new(kat, 3159)
	o.yonetim.gun = 9
	o.yonetim.kabul({"ad":"Göç fikstürü"})
	var veri: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
	veri.surum = 2
	for alan in ["muhafiz_akce", "muhafiz_esyalari", "muhafiz_tecrubesi", "mevsim", "yeni_binalar"]:
		veri.erase(alan)
	var once := veri.duplicate(true)
	var geri := Oturum.kayittan(kat, veri)
	dene(geri != null, "Tek komut v2 fixtürünü gerçek Oturum yolundan göçtürür")
	if geri == null: return
	dene(int(geri.kaydet().surum) == Oturum.KAYIT_SURUMU, "Göç çıktısı güncel kayıt sürümüdür")
	dene(geri.gun == 9 and geri.yonetim.nufus() == 1, "Tek komut fixtürünün günü ve kişisi korunur")
	dene(veri == once and int(veri.surum) == 2, "Test eski fixtürü el ile dönüştürmez")
	print("KAY-59 GÖÇ FİKSTÜRÜ: 2 -> %d" % int(geri.kaydet().surum))

func _kimlik(g: Gelen) -> String:
	return "%s|%s|%s" % [String(g.id), g.ad_anahtari, String(g.sinif)]

func _kapi_ikizi(kat: Katalog) -> void:
	var o := Oturum.new(kat, 3119)
	o.yonetim.kaynaklar.ekle("gida", 30)
	o.yonetim.kaynaklar.ekle("su", 30)
	o.gece_sonu()
	var ham := JSON.stringify(o.kaydet())
	var geri := Oturum.kayittan(kat, JSON.parse_string(ham))
	var ikiz := Oturum.kayittan(kat, JSON.parse_string(ham))
	dene(geri != null and ikiz != null, "KAY-19 yükleme açılır")
	if geri == null or ikiz == null:
		return
	var kuyruk_a := geri.gece_kuyrugu()
	var kuyruk_b := ikiz.gece_kuyrugu()
	dene(not kuyruk_a.is_empty() and not kuyruk_b.is_empty(), "KAY-19 gece sonu kuyruğu boş değil")
	if kuyruk_a.is_empty() or kuyruk_b.is_empty():
		return
	dene(_kimlik(kuyruk_a[0]) == _kimlik(kuyruk_b[0]), "KAY-19 aynı tohumda kapıdaki ilk kişi aynı")

func _zar_ve_soz(kat: Katalog) -> void:
	var o := Oturum.new(kat, 3120)
	o.soz_kaydi.motor.zar_kaydet(4)
	o.soz_kaydi.sozler.ekle("yarin", "yusuf", o.gun + 1, "yarin_gel", false)
	var ham := JSON.stringify(o.kaydet())
	var geri := Oturum.kayittan(kat, JSON.parse_string(ham))
	var rng := RandomNumberGenerator.new()
	rng.seed = 1
	var once := rng.state
	dene(geri.soz_kaydi.motor.zar_at(rng) == 4 and rng.state == once, "KAY-20 kayıtlı zar yeniden atılmaz")
	dene(geri.soz_kaydi.sozler.satirlar().size() == 1 and int(geri.soz_kaydi.sozler.satirlar()[0].gun) == o.gun + 1, "KAY-22 hatırlatma günü kaymaz")

func _guven_itibar(kat: Katalog) -> void:
	var o := Oturum.new(kat, 3121)
	var id: StringName = kat.karakterler()[0].id
	KisiHafizasi.guven_yaz(o.kadro, id, 4)
	KisiHafizasi.korku_yaz(o.kadro, id, 2)
	o.grup_itibari.uygula("turkmen", -3)
	var ham := JSON.stringify(o.kaydet())
	var geri := Oturum.kayittan(kat, JSON.parse_string(ham))
	var h := KisiHafizasi.oku(geri.kadro, id)
	dene(int(h.guven) == 4 and int(h.korku) == 2, "KAY-21 kişi güveni ve korkusu aynı")
	dene(geri.grup_itibari.deger("turkmen") == -3 and geri.grup_itibari.deger("rum") == 0, "KAY-21 altı gruptan Türkmen −3")

func _diyalog_sirasi(kat: Katalog) -> void:
	var o := Oturum.new(kat, 3148)
	o._gemini_sira = 4
	var veri: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
	veri.surum = 2
	for alan in ["muhafiz_akce", "muhafiz_esyalari", "muhafiz_tecrubesi", "mevsim", "yeni_binalar"]:
		veri.erase(alan)
	var geri := Oturum.kayittan(kat, veri)
	dene(geri != null and int(geri.kaydet().diyalog_sira) == 4, "KAY-48 adsız diyalog sırası göçten sonra durur")
	dene(SozMotoru.sira_etkin("chr_001", 4, ["chr_001"]) == -1, "KAY-27 yeni motordaki kişi eski sırayı yok sayar")
	dene(SozMotoru.sira_etkin("chr_002", 4, ["chr_001"]) == 4, "KAY-27 tabloda olmayan kişi eski sırasından devam eder")

func _sure_olcusu(kat: Katalog) -> void:
	var o := Oturum.new(kat, 3149)
	o.yonetim.kabul({"ad": "Ölçü"})
	var veri: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
	veri.surum = 2
	for alan in ["muhafiz_akce", "muhafiz_esyalari", "muhafiz_tecrubesi", "mevsim", "yeni_binalar"]:
		veri.erase(alan)
	var bas := Time.get_ticks_usec()
	var geri := Oturum.kayittan(kat, veri)
	var goc_ms := (Time.get_ticks_usec() - bas) / 1000.0
	print("KAY-49 sure_ms=%.2f" % goc_ms)
	dene(geri != null and goc_ms < 1000.0, "KAY-49 göç ve doğrulama bir saniyenin altında")
	var yol := "user://kay69_%d.json" % OS.get_process_id()
	var kayit := GuvenliKayit.new(yol)
	kayit.sil()
	bas = Time.get_ticks_usec()
	var yazildi := kayit.yaz(geri.kaydet())
	var yaz_ms := (Time.get_ticks_usec() - bas) / 1000.0
	print("KAY-69 sure_ms=%.2f" % yaz_ms)
	dene(yazildi and yaz_ms < 1000.0, "KAY-69 gece sonu yazması bir saniyenin altında")
	kayit.sil()

func _yuz_tohum(kat: Katalog) -> void:
	var sapmalar: Array[String] = []
	var bas := Time.get_ticks_usec()
	for tohum in 100:
		var o := Oturum.new(kat, 4000 + tohum)
		var ham := JSON.stringify(o.kaydet())
		var kuyruk := o.gece_kuyrugu()
		if kuyruk.is_empty():
			sapmalar.append(str(tohum))
			continue
		var beklenen := _kimlik(kuyruk[0])
		var geri := Oturum.kayittan(kat, JSON.parse_string(ham))
		var yuklenen := geri.gece_kuyrugu() if geri != null else []
		if yuklenen.is_empty() or _kimlik(yuklenen[0]) != beklenen:
			sapmalar.append(str(tohum))
	var sure_ms := (Time.get_ticks_usec() - bas) / 1000.0
	print("KAY-72 sure_ms=%.2f sapma=%s" % [sure_ms, ",".join(sapmalar)])
	dene(sapmalar.is_empty(), "KAY-72 yüz tohumda sapma listesi boş")
