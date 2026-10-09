extends SceneTree
var hata := 0
var kat: Katalog
func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	_kabul_ve_kayit()
	_temas_ve_rng()
	_saglik_ve_tedavi()
	print("SALGIN MOTORU: GEÇTİ" if hata == 0 else "SALGIN MOTORU: KALDI")
	quit(hata)

func _kabul_ve_kayit() -> void:
	var o := hazir()
	var y := o.yonetim
	var rng := y._rng.state
	var g := Gelen.new()
	g.ad_anahtari = "Sığınmacı"
	g.gizli_bayraklar = ["hasta"]
	var k := y.koylu(o.karar_ver(g, &"kabul").koylu_id)
	dene(SaglikYoneticisi.hasta(k) and k.enfeksiyon.tur == "humma" and "hasta" in k.gizli_bayraklar and "hasta" not in k.bayraklar and k.saglik == 100 and y._rng.state == rng, "Gerçek gizli Gelen kabulü hasarsız/RNG'siz kayıt getirir")
	var v := y.koylu(o.karar_ver(g, &"harc").koylu_id)
	dene(SaglikYoneticisi.hasta(v), "Harçla kabul aynı hastalık yolu")
	var once := y.nufus()
	o.karar_ver(g, &"ret")
	dene(y.nufus() == once, "Ret enfeksiyon kaydı oluşturmaz")
	var acik := y.kabul({"bayraklar":["veba"]})
	dene(acik.enfeksiyon.tur == "veba", "Açık veba işareti türü korunur")
	var chr2 := y.koylu(o.karar_ver(o._adli_gelen(&"chr_002"), &"kabul").koylu_id)
	dene(not SaglikYoneticisi.hasta(chr2), "CHR002 eski deri/zehir etiketi bulaşıcı değildir")
	var hekim := y.koylu(o.karar_ver(o._adli_gelen(&"chr_008"), &"kabul").koylu_id)
	dene(not SaglikYoneticisi.hasta(hekim), "Hekimin sargısı ve hasta hikâyesi enfeksiyon değildir")
	var geri := geri_yukle(o)
	dene(geri.yonetim.koylu(k.id).enfeksiyon == k.enfeksiyon and geri.yonetim._rng.state == rng, "Optional enfeksiyon JSON ve RNG roundtrip")
	var eski := k.kaydet()
	eski.erase("enfeksiyon")
	dene(Koylu.kayittan(eski).enfeksiyon.is_empty(), "Legacy hasta bayrağı otomatik salgına dönüştürülmez")
	for bozuk in [null, [], "humma", {"tur":"yok"}, {"tur":"humma","bitis":4,"son_gece":-1,"hasar_gecesi":-1,"hasta_sahibi":"evet"}]:
		dene(SaglikYoneticisi.oku(bozuk).is_empty(), "Bozuk optional kayıt güvenli")
	for alan in ["bitis", "son_gece", "hasar_gecesi"]:
		for bozuk in [null, "3", 0.5, -2, INF, NAN, 1000000001]:
			var d := k.enfeksiyon.duplicate(true)
			d[alan] = bozuk
			dene(SaglikYoneticisi.oku(d).is_empty(), "Bozuk sayı reddi: " + alan)
	var tam := o.kaydet()
	tam.koy_yonetimi.erase("salgin_son_gece")
	dene(Oturum.kayittan(kat, tam).yonetim.get_meta(SaglikYoneticisi.META) == -1, "Legacy yönetim gece makbuzu opsiyonel")

func _temas_ve_rng() -> void:
	var o := hazir()
	var y := o.yonetim
	var ev := kur(y, "cadir")
	var isyeri := kur(y, "tarla")
	var kaynak := y.kabul({"gizli":["veba"]})
	kaynak.ev = ev.id
	var hedefler: Array[Koylu] = []
	for i in 6:
		var k := y.kabul({"ad":"Komşu%d" % i})
		k.ev = ev.id
		hedefler.append(k)
	# İkinci hedefin iş arkadaşına aynı gece ikinci nesil bulaşma olmamalı.
	hedefler[0].is_yeri = isyeri.id
	var zincir := y.kabul({"ad":"İkinci nesil"})
	zincir.is_yeri = isyeri.id
	var dis := y.kabul({"ad":"Dış görev"})
	dis.ev = ev.id
	# Gerçek kirala() makbuzu biçimi; eksik alanlı kayıt yüklemede düşer.
	y.kervan_koruma[str(dis.id)] = {"baslangic":0,"donus":3,"varis":4,"tuccar":String(GezginTuccarTakvimi.AYAR.uzmanlar[0].id),"alinan":int(KervanKorumasi.AYAR.pesin_akce)}
	var oran: int = SaglikYoneticisi.AYAR.veba.risk
	SaglikYoneticisi.AYAR.veba.risk = 100
	var geri := geri_yukle(o)
	var olaylar: Array[Dictionary] = []
	SaglikYoneticisi.gece(y, olaylar)
	SaglikYoneticisi.gece(geri.yonetim, [])
	if geri.yonetim.kaydet() != y.kaydet():
		for alan in y.kaydet():
			if geri.yonetim.kaydet()[alan] != y.kaydet()[alan]: print("DIFF ", alan, " ", y.kaydet()[alan], " / ", geri.yonetim.kaydet()[alan])
	dene(geri.yonetim.kaydet() == y.kaydet(), "Sıralı temas ve mevcut RNG yüklemede birebir aynı")
	dene(hedefler.filter(func(k: Koylu) -> bool: return SaglikYoneticisi.hasta(k)).size() == 2 and not SaglikYoneticisi.hasta(zincir) and not SaglikYoneticisi.hasta(dis), "Gece tavanı iki, ikinci nesil/dış görev bulaşması yok")
	var sabit := y.kaydet()
	SaglikYoneticisi.gece(y, olaylar)
	SaglikYoneticisi.gece(geri.yonetim, [])
	dene(y.kaydet() == sabit and geri.yonetim.kaydet() == sabit and olaylar.size() == 1, "Aynı gece/kayıt makbuzu ikinci zar veya bulaşma oluşturmaz")
	SaglikYoneticisi.AYAR.veba.risk = 0
	# En çok üç başarısız aday zarı; RNG takibi için mevcut durumdan kopya.
	var q := hazir()
	var qy := q.yonetim
	var bina := kur(qy, "tarla")
	var hasta := qy.kabul({"gizli":["veba"]})
	hasta.is_yeri = bina.id
	for i in 8: qy.kabul({}).is_yeri = bina.id
	var kontrol := RandomNumberGenerator.new()
	kontrol.state = qy._rng.state
	for i in SaglikYoneticisi.AZAMI_TEMAS: kontrol.randi_range(1, 100)
	SaglikYoneticisi.gece(qy, [])
	dene(qy._rng.state == kontrol.state and qy.koylular.filter(func(k: Koylu) -> bool: return SaglikYoneticisi.hasta(k)).size() == 1, "Kaynak başına en çok üç temas ve başarısız risk")
	SaglikYoneticisi.AYAR.veba.risk = oran
	var evsiz := hazir().yonetim
	var e := evsiz.kabul({"gizli":["hasta"]})
	var b := evsiz.kabul({})
	var rng := evsiz._rng.state
	SaglikYoneticisi.gece(evsiz, [])
	dene(evsiz._rng.state == rng and not SaglikYoneticisi.hasta(b), "Evsiz/boşta sentinelleri ortak bina sayılmaz")
	e.ev = 999
	b.ev = 999
	dene(not SaglikYoneticisi.ortak_bina(evsiz, e, b), "Olmayan bina bulaştırmaz")
	var saglam := hazir().yonetim
	saglam.kabul({})
	rng = saglam._rng.state
	SaglikYoneticisi.gece(saglam, [])
	dene(saglam._rng.state == rng, "Enfeksiyonsuz köyde RNG akışı değişmez")

func _saglik_ve_tedavi() -> void:
	var o := hazir()
	var y := o.yonetim
	var k := y.kabul({"ad":"Hasta", "gizli":["veba"]})
	var ev := kur(y, "cadir")
	y._barindir()
	var geri := geri_yukle(o)
	var rapor := o.gece_sonu()
	var geri_rapor := geri.gece_sonu()
	if geri.yonetim.kaydet() != y.kaydet():
		for alan in y.kaydet():
			if geri.yonetim.kaydet()[alan] != y.kaydet()[alan]: print("DIFF GECE ", alan, " ", y.kaydet()[alan], " / ", geri.yonetim.kaydet()[alan])
	# `olay` OlayVerisi Resource'u: iki oturumda ayrı örnek; kimliğiyle karşılaştırılır.
	var olay_id := func(r: Dictionary) -> Variant: return r.olay.id if r.get("olay") is OlayVerisi else r.get("olay")
	var r1 := rapor.duplicate(); r1.olay = olay_id.call(rapor)
	var r2 := geri_rapor.duplicate(); r2.olay = olay_id.call(geri_rapor)
	dene(r2 == r1 and geri.yonetim.kaydet() == y.kaydet(), "Gerçek gece üretim/sağlık/RNG restore eşitliği")
	dene(k.ev == ev.id and k.saglik == 93 and k.bayrak_var("hasta"), "Ev +5 ardından veba −12, gizli belirti açılır")
	var saglik := k.saglik
	SaglikYoneticisi.saglik_kaybi(y, k)
	dene(k.saglik == saglik, "Gece hasarı bir kez")
	y.gun = int(k.enfeksiyon.bitis)
	SaglikYoneticisi.gece(y, [])
	dene(not SaglikYoneticisi.hasta(k) and "hasta" not in k.bayraklar + k.gizli_bayraklar, "Süre sonunda kendi bayrağıyla doğal iyileşme")
	k.bayrak_ekle("hasta")
	SaglikYoneticisi.enfekte(y, k)
	SaglikYoneticisi.iyilestir(k)
	dene(k.bayrak_var("hasta"), "Başka kaynağın hasta bayrağı temizlenmez")
	k.bayraklar.erase("hasta")
	SaglikYoneticisi.enfekte(y, k)
	var sifahane := kur(y, "sifahane")
	var doktor := y.kabul({})
	doktor.zanaat_turu = ZanaatTuru.Tur.CERRAH
	dene(y.ata(doktor.id, sifahane.id), "Mevcut Şifahane gerçek hekim ataması")
	SifahaneKontenjani.kullan(y)
	var gida := y.kaynaklar.miktar("gida")
	SaglikYoneticisi.tedavi(y, [])
	dene(SaglikYoneticisi.hasta(k) and y.kaynaklar.miktar("gida") == gida, "Kullanılmış yanık/kış kontenjanına ikinci tedavi yok")
	y.gun += 1
	SaglikYoneticisi.tedavi(y, [])
	dene(not SaglikYoneticisi.hasta(k) and Sifahane.tedavi_kapasitesi(y) == 0 and y.kaynaklar.miktar("gida") == gida - 2, "Aynı Şifahane iki erzak/bir kontenjanla tedavi eder")
	SaglikYoneticisi.tedavi(y, [])
	dene(y.kaynaklar.miktar("gida") == gida - 2, "Tedavi tekrarı ücretsiz ikinci iyileşme yapmaz")
	var olum := hazir()
	var oluy := olum.yonetim
	var hasta := oluy.kabul({"ad":"Son Hasta", "gizli":["veba"]})
	kur(oluy, "cadir")
	hasta.saglik = 1
	var r := olum.gece_sonu()
	dene(oluy.koylu(hasta.id) == null and r.rapor.olenler == ["Son Hasta"] and r.rapor.olaylar.any(func(d: Dictionary) -> bool: return d.anahtar == "koy.olay.olum"), "1 sağlık ev +5 ile dirilmez; mevcut ölüm yolu")
	var zehir := hazir()
	var z := zehir.yonetim.kabul({"gizli":["humma"]})
	KrizEnjektoru.tetikle(zehir, "kuyu")
	KrizEnjektoru.gece(zehir.yonetim, [])
	SaglikYoneticisi.iyilestir(z)
	dene(z.bayrak_var("hasta"), "Sonradan gelen kuyu zehri bayrağı hastalık iyileşmesiyle silinmez")

func hazir() -> Oturum:
	var o := Oturum.new(kat, 222)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.isyan_esigi = -1
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	for tur in ["gida", "odun", "tas", "kereste"]: y.kaynaklar.ekle(tur, 1000)
	return o
func geri_yukle(o: Oturum) -> Oturum:
	var a := kat.koy_ayarlari
	kat.koy_ayarlari = o.yonetim.a
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	kat.koy_ayarlari = a
	return geri
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
