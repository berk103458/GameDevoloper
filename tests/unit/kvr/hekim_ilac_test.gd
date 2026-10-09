extends SceneTree
var hata := 0
var kat: Katalog
func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	_yetkinlik()
	_hasar_ve_olum()
	_uretim_tedavi_kayit()
	print("HEKIM ILAC: GEÇTİ" if hata == 0 else "HEKIM ILAC: KALDI")
	quit(hata)

func _yetkinlik() -> void:
	for kimlik in [&"chr_003", &"chr_008"]:
		var o := hazir()
		var y := o.yonetim
		var b := kur(y, "sifahane")
		var k := y.koylu(o.karar_ver(o._adli_gelen(kimlik), &"kabul").koylu_id)
		var rng := y._rng.state
		dene(not HekimIlac.etkin(y), "Kabul tek başına hekim koruması vermez")
		dene(y.ata(k.id, b.id) and HekimIlac.etkin(y), "Gerçek CHR ataması etkin: " + String(kimlik))
		dene(HekimIlac.hastalik_kaybi(y, 12) == 2 and HekimIlac.hastalik_kaybi(y, 8) == 1, "Hastalık hasarına ×0,20")
		SifahaneKontenjani.kullan(y)
		dene(Sifahane.tedavi_kapasitesi(y) == 0 and HekimIlac.etkin(y), "Tedavi kotası pasif hekim korumasını tüketmez")
		dene(y._rng.state == rng, "Yetkinlik ve hasar RNG çekmez")
		var durum := k.kaydet()
		for engel in ["hasta", "karantina", "ac", "zindan", "yarali", "yanik", "kis", "dis", "olum", "yas"]:
			k = Koylu.kayittan(durum)
			y.koylular[0] = k
			match engel:
				"hasta": k.gizli_bayraklar.append("hasta")
				"karantina": k.karantina = {"baslangic": y.gun, "bitis": y.gun + 2, "bina": b.id}
				"ac": k.ac = true
				"zindan": k.bayrak_ekle(DivanHukmu.FLAG)
				"yarali": k.bayrak_ekle("agir_yarali")
				"yanik": k.zanaat_kazasi = {"kalan": 1}
				"kis": k.kis_hastaligi = {"bitis": y.gun + 2}
				"dis": y.kervan_koruma[str(k.id)] = {"baslangic": y.gun, "donus": y.gun + 2}
				"olum": k.saglik = 0
				"yas": k.yas_grubu = &"cocuk"
			dene(not HekimIlac.etkin(y), "Çalışamayan hekim koruması yok: " + engel)
			y.kervan_koruma.clear()
		k = Koylu.kayittan(durum)
		y.koylular[0] = k
		b.insa_kalan = 1
		dene(not HekimIlac.etkin(y), "Hazır olmayan bina etkin değil")
		b.insa_kalan = 0
		y.isyan_kalan = 1
		dene(not HekimIlac.etkin(y), "Köy isyanında hizmet durur")
		y.isyan_kalan = -1
		var b2 := kur(y, "sifahane")
		dene(HekimIlac.etkin(y) and not HekimIlac.etkin(y, b2.id), "Yerel bina bilgisi başka hekime atfedilmez")
		var ikinci := y.kabul({"adli_id": "chr_003"})
		y.ata(ikinci.id, b.id)
		dene(HekimIlac.hastalik_kaybi(y, 12) == 2, "İki hekim bonusu üst üste binmez")
		k.toplumsal_bag = {"grup": "ilk", "dusman_gruplar": ["ikinci"]}
		ikinci.toplumsal_bag = {"grup": "ikinci", "dusman_gruplar": []}
		dene(not HekimIlac.etkin(y), "Kan davası Şifahane hizmetini durdurur")
	var k := Koylu.new()
	k.ad = "CHR_008 Dudu Hatun"
	k.zanaat_turu = ZanaatTuru.Tur.OTACI
	k.stat = 5
	dene(not HekimIlac.yetkin(k), "İsim veya kalfa kimlik yerine geçmez")
	k.stat = 7
	dene(HekimIlac.yetkin(k), "Adsız legacy usta otacı fallback")
	k.adli_id = &"chr_007"
	dene(not HekimIlac.yetkin(k), "Bilinen başka CHR fallback kullanmaz")
	k.adli_id = &""
	k.zanaat_turu = ZanaatTuru.Tur.CERRAH
	k.stat = 5
	k.gelisim = {"CERRAH": {"kademe": 2, "bonus": true, "xp": 0, "son_gece": 0}}
	dene(HekimIlac.yetkin(k), "Kazanılmış usta seviyesi fallback")

func _hasar_ve_olum() -> void:
	for hekimli in [false, true]:
		var o := hazir()
		var y := o.yonetim
		var k := y.kabul({"ad": "Son Hasta", "gizli": ["veba"]})
		k.saglik = 8
		if hekimli:
			var b := kur(y, "sifahane")
			var d := y.kabul({"adli_id": "chr_008"})
			y.ata(d.id, b.id)
			# Ortak kış/yanık kotası dolu: ilaç/erzak tedavisi yapılamaz.
			SifahaneKontenjani.kullan(y)
		var r: Dictionary = o.gece_sonu().rapor
		dene((y.koylu(k.id) != null) == hekimli and r.olenler.has(k.ad) == (not hekimli), "Gerçek gece tek ölüm yolunda koruma")
		if hekimli: dene(k.saglik == 6 and SaglikYoneticisi.hasta(k), "Kotası dolu hastada yalnız hasar 12→2")
	var o := hazir()
	var y := o.yonetim
	var b := kur(y, "sifahane")
	var d := y.kabul({"adli_id": "chr_003"})
	y.ata(d.id, b.id)
	var k := y.kabul({"gizli": ["humma"]})
	SaglikYoneticisi.gece(y, [])
	var rng := y._rng.state
	k.saglik = 20
	SaglikYoneticisi.saglik_kaybi(y, k)
	SaglikYoneticisi.saglik_kaybi(y, k)
	dene(k.saglik == 19 and y._rng.state == rng, "Aynı gece hasarı bir kez, yeni zar yok")
	y.gun += 1
	k.karantina = {"baslangic": y.gun, "bitis": y.gun + 2, "bina": b.id}
	k.enfeksiyon.son_gece = y.gun
	SaglikYoneticisi.saglik_kaybi(y, k)
	SaglikYoneticisi.tedavi(y, [])
	dene(k.saglik == 18 and SaglikYoneticisi.hasta(k) and Sifahane.tedavi_kapasitesi(y) == 1, "İzole hasta hasarı azalır fakat tedavi kotası tüketmez")
	var ac := y.kabul({"ad": "Aç"})
	ac.saglik = 1
	ac.ac = true
	y._saglik_ve_moral([], [])
	dene(y.koylu(ac.id) == null, "Açlık ölümü hekimle önlenmez")

func _uretim_tedavi_kayit() -> void:
	var o := hazir()
	var y := o.yonetim
	var b := kur(y, "sifahane")
	var d := y.kabul({"adli_id": "chr_008"})
	y.ata(d.id, b.id)
	dene(b.recete == "bakim", "Yeni Şifahane üretimi varsayılan kapalı")
	y.kaynaklar.ekle("afyon", 4)
	y.kaynaklar.ekle("su", 4)
	var rng := y._rng.state
	y._uret({}, [])
	dene(y.kaynaklar.miktar("afyon") == 4 and y.kaynaklar.miktar("ilac") == 0 and y._rng.state == rng, "Kapalı üretim stok/RNG değiştirmez")
	dene(y.recete_sec(b.id, "ilac"), "Mevcut reçete seçme API")
	var uretim := {}
	y._uret(uretim, [])
	dene(y.kaynaklar.miktar("afyon") == 3 and y.kaynaklar.miktar("su") == 3 and y.kaynaklar.miktar("ilac") >= 1 and int(uretim.get("ilac", 0)) >= 1, "Gerçek üretim formülü tek ambara ilaç teslim eder")
	dene(y._rng.state == rng, "Uyumlu hekim üretimi yeni RNG çekmez")
	var k := y.kabul({"gizli": ["humma"]})
	k.saglik = 40
	var gida := y.kaynaklar.miktar("gida")
	var ilac := y.kaynaklar.miktar("ilac")
	var olaylar: Array[Dictionary] = []
	SaglikYoneticisi.tedavi(y, olaylar)
	dene(k.saglik == 65 and not SaglikYoneticisi.hasta(k) and y.kaynaklar.miktar("ilac") == ilac - 1 and y.kaynaklar.miktar("gida") == gida, "İlaç erzak yerine +25 sağlıkla tedavi eder")
	dene(olaylar.size() == 1 and String(olaylar[0].anahtar).contains("1 ilaç"), "Tedavi raporu gerçek bedeli gösterir")
	var sabit := y.kaydet()
	SaglikYoneticisi.tedavi(y, [])
	dene(y.kaydet() == sabit, "Tekrarlı tedavi ikinci ilaç/sağlık harcamaz")
	var ikinci := y.kabul({"gizli": ["veba"]})
	SaglikYoneticisi.tedavi(y, [])
	dene(SaglikYoneticisi.hasta(ikinci) and y.kaynaklar.miktar("ilac") == ilac - 1, "Ortak kontenjan ilaçla aşılmaz")
	y.gun += 1
	y.kaynaklar.azalt("ilac", 100)
	ikinci.saglik = 95
	SaglikYoneticisi.tedavi(y, [])
	dene(ikinci.saglik == 100 and y.kaynaklar.miktar("gida") == gida - 2, "İlaçsız legacy erzak tedavisi ve sağlık sınırı")
	var ucuncu := y.kabul({"gizli": ["humma"]})
	y.gun += 1
	y.kaynaklar.azalt("gida", 10000)
	SaglikYoneticisi.tedavi(y, [])
	dene(SaglikYoneticisi.hasta(ucuncu) and Sifahane.tedavi_kapasitesi(y) == 1, "Yetersiz bedelde kota tüketilmez")
	y.kaynaklar.ekle("ilac", 1)
	SaglikYoneticisi.tedavi(y, [])
	dene(not SaglikYoneticisi.hasta(ucuncu), "Erzaksız köyde ilaç tedavisi")
	# Girdi yoksa mevcut üretim atomic bekler; izole/hasta/vasıfsız üretmez.
	y.kaynaklar.azalt("su", 100)
	sabit = y.kaynaklar.kaydet()
	y._uret({}, [])
	dene(y.kaynaklar.kaydet() == sabit and b.bekliyor == "girdi", "Eksik su afyonu tüketmez")
	y.kaynaklar.ekle("su", 2)
	d.karantina = {"baslangic": y.gun, "bitis": y.gun + 2, "bina": b.id}
	sabit = y.kaynaklar.kaydet()
	y._uret({}, [])
	dene(y.kaynaklar.kaydet() == sabit, "Karantinadaki hekim ilaç üretmez")
	d.karantina.clear()
	d.zanaat_turu = ZanaatTuru.Tur.CIFTCI
	y._uret({}, [])
	dene(y.kaynaklar.kaydet() == sabit, "Vasıfsız çalışan ilaç üretmez")
	d.zanaat_turu = ZanaatTuru.Tur.OTACI
	y.kaynaklar.ekle("gida", 100)
	y.kaynaklar.ekle("ilac", 3)
	SaglikYoneticisi.enfekte(y, ucuncu)
	var gizli := HekimIlac.metin(y)
	dene(not gizli.contains("chr_") and not gizli.contains("Dudu") and not gizli.contains("Humma") and SaglikYoneticisi.metin(ucuncu, y).is_empty(), "Hizmet bilgisi kimlik/gizli hastalık açmaz")
	var kayit: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
	var geri := Oturum.kayittan(kat, kayit)
	dene(geri.yonetim.kaynaklar.miktar("ilac") == 3 and geri.yonetim.bina(b.id).recete == "ilac" and HekimIlac.etkin(geri.yonetim), "Optional ilaç/gerçek hekim ve reçete JSON dönüşü")
	var r1: Dictionary = o.gece_sonu().rapor
	var r2: Dictionary = geri.gece_sonu().rapor
	dene(r1 == r2 and JSON.parse_string(JSON.stringify(y.kaydet())) == JSON.parse_string(JSON.stringify(geri.yonetim.kaydet())), "İlaç üretimi/tedavi/gece/RNG kayıttan aynı akış")
	kayit.koy_yonetimi.kaynaklar.stok.erase("ilac")
	for bina in kayit.koy_yonetimi.binalar:
		if bina.tur == "sifahane": bina.recete = ""
	geri = Oturum.kayittan(kat, kayit)
	dene(geri.yonetim.kaynaklar.miktar("ilac") == 0 and geri.yonetim.bina(b.id).recete == "", "Legacy ilaçsız ve boş reçete aynen güvenli")
	for bozuk in [null, "3", INF, NAN, -1]:
		var stok := Kaynaklar.kayittan({"stok": {"ilac": bozuk}})
		dene(stok.miktar("ilac") == 0, "Bozuk optional ilaç güvenli")
	var ambar := Kaynaklar.new(10, {"ilac": 10})
	ambar.kapasite = 2
	dene(ambar.toplam() == 2 and ambar.bakim.tasma.ilac == 8, "İlaç ambar kapasite düşüşünü aşmaz")

func hazir() -> Oturum:
	var o := Oturum.new(kat, 222)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.isyan_esigi = -1
	y.a.ambar_taban_kapasite = 10000
	kat.koy_ayarlari = y.a
	y.kaynaklar.kapasite = 10000
	for tur in ["gida", "odun", "tas", "kereste"]: y.kaynaklar.ekle(tur, 500)
	return o
func kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h).olur:
				var b := y.bina(y.bina_kur(tur, h).id)
				b.insa_kalan = 0
				return b
	return null
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
