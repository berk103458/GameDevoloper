extends SceneTree
const T := preload("res://src/kapi/hastalik_teshis_adaptoru.gd")
var hata := 0
var kat: Katalog

func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	_gizlilik_ve_ipucu()
	_kilit_ve_kabul()
	_snapshot_ve_kayit()
	print("KAPI HASTALIK TEŞHİSİ: GEÇTİ" if hata == 0 else "KAPI HASTALIK TEŞHİSİ: KALDI")
	quit(hata)

func _gizlilik_ve_ipucu() -> void:
	var g := _gelen([])
	var bos := T.metin(g)
	g.gizli_bayraklar = ["veba", "hasta", "belirti_irin"]
	g.giris_anahtari = "Ateş başında hasta komşuma sargı verdim; kan ve irin hikâyesi"
	dene(T.belirtiler(g).is_empty() and T.metin(g) == bos, "Gizli bayrak/hikâye/ateş kelimesi kanıt değil")
	dene(T.incele(g, "portre") == T.incele(_gelen([]), "portre"), "Gizli hasta ile sağlıklı aynı inceleme")
	var o := Oturum.new(kat, 711)
	for id in [&"chr_002", &"chr_003", &"chr_008"]:
		var chr := o._adli_gelen(id)
		chr.acik_bayraklar = ["hasta"] if id == &"chr_002" else PackedStringArray()
		dene(T.belirtiler(chr).is_empty(), "Deri etiketi/şifacı/cerrah sargısı kanıt olmaz")
	for bayrak in ["belirti_irin", "belirti_ates", "belirti_kanli_oksuruk", "veba", "humma", "hasta"]:
		var v := _gelen([bayrak])
		var profil: Dictionary = T.AYAR.belirtiler[bayrak]
		dene(T.kaydet(v).is_empty(), "İnceleme öncesi ipucu yok")
		dene(T.incele(v, "yanlis").is_empty() and T.kaydet(v).is_empty(), "Sahte kaynak keşif yapmaz")
		T.incele(v, "heybe" if profil.kaynak == "portre" else "portre")
		dene(T.kaydet(v).is_empty(), "Yanlış yüzey sağlık ipucu vermez")
		T.incele(v, profil.kaynak)
		dene(T.kaydet(v).size() == 1 and T.metin(v).contains("enfeksiyon şüphesi"), "Üç belirti ve eski açık etiketler aynı ibreye gider")
		T.incele(v, profil.kaynak)
		dene(T.kaydet(v).size() == 1, "Tekrar inceleme yığılmaz")
	var chr := o._adli_gelen(&"chr_008")
	chr.acik_bayraklar = ["belirti_ates"]
	var s := chr.chr_sorgusu()
	var sayac := [0]
	s.ipucu_bulundu.connect(func(_id: StringName) -> void: sayac[0] += 1)
	var rng: int = s.get("_rng").state
	T.incele(chr, "portre")
	T.incele(chr, "portre")
	dene(s.ipuclari.has(&"Clue_Enfeksiyon_Ates") and sayac[0] == 1 and s.get("_rng").state == rng, "CHR'nin tek servis/sinyali kullanılır; RNG çekilmez")
	dene(T.kaydet(_gelen(["belirti_ates"])).is_empty(), "Ziyaretler ipucu paylaşmaz")

func _kilit_ve_kabul() -> void:
	for karar in [&"kabul", &"harc", &"rusvet", &"kisla"]:
		var o := Oturum.new(kat, 712)
		var y := o.yonetim
		var g := _gelen(["veba", "belirti_kanli_oksuruk"])
		var once := o.kaydet()
		dene(o.karar_ver(g, karar).get("engellendi", false) and o.kaydet() == once, "İncelemesiz tüm kabul yolları atomik kapalı")
		T.incele(g, "heybe")
		dene(o.karar_ver(g, karar).get("engellendi", false) and o.kaydet() == once, "Şifahane yoksa atomik kapalı")
		var bina := _kur(y)
		once = o.kaydet()
		dene(o.karar_ver(g, karar).get("engellendi", false) and o.kaydet() == once, "Hekimsiz Şifahane kabul etmez")
		_hekim(y, bina)
		y.kaynaklar.azalt("gida", y.kaynaklar.miktar("gida"))
		once = o.kaydet()
		dene(o.karar_ver(g, karar).get("engellendi", false) and o.kaydet() == once, "Erzaksız rüşvet/harç dahil atomik ret")
		y.kaynaklar.ekle("gida", 20)
		var rng := y._rng.state
		var gida := y.kaynaklar.miktar("gida")
		var r := o.karar_ver(g, karar)
		var k := y.koylu(int(r.get("koylu_id", -1)))
		dene(r.get("karantina", false) and k != null and KarantinaYoneticisi.aktif(k), "Tüm kabul yollarında aynı izolasyon")
		dene(k.enfeksiyon.tur == "veba" and not SaglikYoneticisi.temas_edebilir(y, k), "Gerçek enfeksiyon korunur; temas kapanır")
		dene(y.kaynaklar.miktar("gida") == gida-1 and y._rng.state == rng and k.karantina.bitis == y.gun+2, "Mevcut tek bedel ve 2 gün; RNG yok")
		once = o.kaydet()
		dene(o.karar_ver(g, karar).get("engellendi", false) and o.kaydet() == once, "Çift tık yeni köylü/ücret oluşturmaz")
		var ikinci := _gelen(["belirti_ates"])
		T.incele(ikinci, "portre")
		var rr := o.karar_ver(ikinci, &"kabul")
		var saglam := y.koylu(rr.koylu_id)
		dene(KarantinaYoneticisi.aktif(saglam) and not SaglikYoneticisi.hasta(saglam), "Şüphe enfeksiyon üretmez; sağlıklı da izole olur")
		var ucuncu := _gelen(["humma"])
		T.incele(ucuncu, "portre")
		once = o.kaydet()
		dene(o.karar_ver(ucuncu, &"kabul").get("engellendi", false) and o.kaydet() == once, "Son yatak dolunca bayat karar atomik engellenir")
		dene(not o.karar_ver(ucuncu, &"ret").kaldi, "Ret karantinaya bağlı değil")
	# Dış görev/isyan/terminal gibi KRI-02 hizmet sınırları devralınır.
	var o := _hazir()
	var g := _gelen(["humma"])
	T.incele(g, "portre")
	o.yonetim.isyan_kalan = 1
	dene(not T.neden(o, g, &"kabul").is_empty(), "İsyan hizmet kapısı")
	o.yonetim.isyan_kalan = -1
	o.yonetim.son = &"zafer"
	var once := o.kaydet()
	dene(o.karar_ver(g, &"kabul").get("engellendi", false) and o.kaydet() == once, "Terminal model kapısı")

func _snapshot_ve_kayit() -> void:
	var o := _hazir()
	var g := _gelen(["belirti_ates"])
	T.incele(g, "portre")
	var veri: Dictionary = JSON.parse_string(JSON.stringify(KapiAnlikGoruntusu.gelen_kaydet(g)))
	var geri := KapiAnlikGoruntusu.gelen_yukle(veri, kat)
	dene(geri != null and T.kaydet(geri) == T.kaydet(g), "Adsız ziyaret ipucu JSON snapshotta sürer")
	veri.erase("hastalik_teshisi")
	var legacy := KapiAnlikGoruntusu.gelen_yukle(veri, kat)
	dene(legacy != null and T.kaydet(legacy).is_empty(), "Legacy keşif yapmaz; kabul için inceleme gerekir")
	for v in [null, "Clue_Enfeksiyon_Ates", {}, ["Clue_CHR001_Yalan"], ["Clue_Enfeksiyon_Irin"], [12, false]]:
		var temiz := _gelen(["belirti_ates"])
		T.yukle(temiz, v)
		dene(T.kaydet(temiz).is_empty(), "Bozuk/yabancı/yüzeye uymayan ipucu kabul edilmez")
	var r := o.karar_ver(geri, &"kabul")
	var k := o.yonetim.koylu(r.koylu_id)
	var yuklenen := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	dene(yuklenen.yonetim.koylu(k.id).karantina == k.karantina, "Normal kayıtta mevcut KRI-02 süresi devam eder")
	var chr := o._adli_gelen(&"chr_008")
	chr.acik_bayraklar = ["belirti_ates"]
	T.incele(chr, "portre")
	veri = JSON.parse_string(JSON.stringify(KapiAnlikGoruntusu.gelen_kaydet(chr)))
	geri = KapiAnlikGoruntusu.gelen_yukle(veri, kat)
	dene(geri != null and T.kaydet(geri) == T.kaydet(chr), "CHR ziyaretin mevcut servisi snapshotta korunur")

func _gelen(bayraklar: Array) -> Gelen:
	var g := Gelen.new()
	g.ad_anahtari = "Ziyaretçi"
	g.acik_bayraklar = PackedStringArray(bayraklar)
	g.secenekler = ["kabul", "harc", "rusvet", "kisla", "ret"]
	g.heybe = Heybe.new()
	return g

func _hazir() -> Oturum:
	var o := Oturum.new(kat, 713)
	_hekim(o.yonetim, _kur(o.yonetim))
	o.yonetim.kaynaklar.ekle("gida", 20)
	return o

func _kur(y: KoyYonetimi) -> KoyBinasi:
	for tur in ["odun", "tas", "kereste"]: y.kaynaklar.ekle(tur, 40)
	var bilgi_sahibi: Koylu = y.koylular[0] if not y.koylular.is_empty() else y.kabul({"ad": "Usta"})
	bilgi_sahibi.yapi_bilgisi = PackedStringArray(["sifahane", "kulube"])
	if not YapiKilidi.durum(y, "sifahane").acik:
		for cy in y.a.izgara_boyut.y:
			var k_kuruldu := false
			for cx in y.a.izgara_boyut.x:
				var kh := Vector2i(cx, cy)
				if y.yerlesim("kulube", kh).olur:
					var kb := y.bina(y.bina_kur("kulube", kh).id)
					kb.insa_kalan = 0
					k_kuruldu = true
					break
			if k_kuruldu: break
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("sifahane", h).olur:
				var b := y.bina(y.bina_kur("sifahane", h).id)
				b.insa_kalan = 0
				return b
	return null

func _hekim(y: KoyYonetimi, bina: KoyBinasi) -> void:
	var k := y.kabul({"ad": "Hekim", "bayraklar": ["usta_cerrah"]})
	k.zanaat_turu = ZanaatTuru.Tur.CERRAH
	dene(y.ata(k.id, bina.id), "Hekim gerçek Şifahaneye atanır")

func dene(ok: bool, mesaj: String) -> void:
	if not ok:
		hata += 1
		push_error(mesaj)
