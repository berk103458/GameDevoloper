extends SceneTree
const C = preload("res://src/koy/cozumleme.gd")
const D = preload("res://src/koy/usta_defterleri.gd")
const ID := "usta_defteri_marangoz"
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func hazir(kat: Katalog, tohum: int) -> Oturum:
	var o := Oturum.new(kat,tohum)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar = Kaynaklar.new(10000,{"gida":1000,"su":1000,"odun":1000,"tomruk":100,"alet":100,"tas":100,"kereste":100})
	y.akce = 1000
	for cift in [[99,"cozumleme_odasi"],[100,"cadir"]]:
		var b := KoyBinasi.new()
		b.id = cift[0]
		b.tur = cift[1]
		y.binalar.append(b)
	var k := y.kabul({"ad":"Araştırmacı","sinif":"esnaf"})
	k.ev = 100
	dene(y.ata(k.id,99),"Gerçek oda ataması")
	D.ekle(o,ID)
	dene(C.baslat(o,ID,99,k.id).ok,"Gerçek başlangıç")
	return o
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := hazir(kat,5052)
	var y := o.yonetim
	var k := y.koylular[0]
	o.gece_sonu()
	dene(C.durum(y).aktif.ilerleme == 1.0,"Gerçek gece ilerler")
	var gece_foto := o.kaydet()
	C.gece(o,{"olaylar":[]},MevsimYoneticisi.durum(y),{"gun":0,"defter":ID,"oda":99,"isci":k.id,"uygun":true})
	dene(o.kaydet() == gece_foto,"Aynı gerçek gecenin tekrarında ilerleme/ücret yok")
	y.bosalt(k.id)
	o.gece_sonu()
	dene(C.durum(y).aktif.ilerleme == 1.0,"İşten alınan işçi ilerlemez")
	dene(y.ata(k.id,99),"Aynı işçi normal atamayla döner")
	o.gece_sonu()
	dene(C.durum(y).aktif.ilerleme == 2.0,"Dönen işçi aynı noktadan sürer")
	kat.koy_ayarlari = y.a.duplicate(true)
	var geri := Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
	dene(geri != null and C.durum(geri.yonetim) == C.durum(y),"Yarım iş gerçek JSON ile korunur")
	if geri == null:
		quit(1)
		return
	var r := o.gece_sonu()
	geri.gece_sonu()
	dene(C.durum(y) == C.durum(geri.yonetim) and y.akce == geri.yonetim.akce,"Yükleme aynı bitişi ve ücreti verir")
	dene(C.uretim_carpani(y,"hizarhane") == C.uretim_carpani(geri.yonetim,"hizarhane"),"Gerçek yükleme aynı sonuç çarpanını korur")
	dene(C.durum(y).aktif.is_empty() and ID in C.durum(y).tamamlanan and o.muhafiz_esyalari[0].get("cozuldu",false),"Verideki süre dolunca mevcut defter çözüldü")
	var bildirim := 0
	for olay in r.olaylar:
		if olay.get("anahtar") == "koy.cozumleme.bitti": bildirim += 1
	dene(bildirim == 1,"Bitiş tek bildirimdir")
	var once := o.kaydet()
	C.gece(o,r,MevsimYoneticisi.durum(y))
	dene(o.kaydet() == once and C.uretim_carpani(y,"hizarhane") == float(D.AYAR.defterler[ID].arastirma.sonuc.carpan) and C.uretim_carpani(y,"tarla") == 1.0,"Tekrar sonuç katlamaz; tek hedef değişir")
	dene(YapiKilidi.durum(y,"hizarhane").acik,"Çözümlemeden sonra mevcut kişi bilgisi yapıyı açar")
	_uretim(o,kat)
	_durma(kat,"olum")
	_durma(kat,"yikim")
	_iyilesme(kat)
	_mevsim(kat)
	_kuyruk(kat)
	print("ÇÖZÜMLEME GECE: GEÇTİ" if hata == 0 else "ÇÖZÜMLEME GECE: KALDI")
	quit(hata)
func _durma(kat: Katalog, tur: String) -> void:
	var o := hazir(kat,5053)
	o.gece_sonu()
	if tur == "olum":
		o.yonetim.koylular[0].saglik = 1
		o.yonetim.kaynaklar.stok["gida"] = 0
	else: dene(o.yonetim.bina_yik(99),"Oda gerçek yıkım API ile yıkılır")
	o.gece_sonu()
	if tur == "olum": dene(o.yonetim.koylular.is_empty(),"İşçi mevcut açlık/ölüm akışında gerçekten ölür")
	dene(C.durum(o.yonetim).aktif.ilerleme == 1.0 and not o.muhafiz_esyalari[0].get("cozuldu",false),"Ölüm/yıkım: %s durum=%s" % [tur,str(C.durum(o.yonetim))])
func _mevsim(kat: Katalog) -> void:
	var o := hazir(kat,5056)
	o.yonetim.gun = 3 * o.yonetim.a.mevsim_gun
	var indis := o.yonetim.mevsim()
	var eski: Variant = MevsimYoneticisi.INSA_CARPANLARI[indis]
	MevsimYoneticisi.INSA_CARPANLARI[indis] = 0.25
	var kayit := MevsimYoneticisi.durum(o.yonetim)
	o.gece_sonu()
	dene(is_equal_approx(float(C.durum(o.yonetim).aktif.ilerleme),float(kayit.insa_carpani)),"Kış ilerlemesi mevcut mevsim kaydından okunur")
	MevsimYoneticisi.INSA_CARPANLARI[indis] = eski
func _kuyruk(kat: Katalog) -> void:
	var asil := D.AYAR.duplicate(true)
	D.AYAR.defterler["ikinci_defter"] = D.AYAR.defterler[ID].duplicate(true)
	var o := hazir(kat,5057)
	D.ekle(o,"ikinci_defter")
	var k := o.yonetim.koylular[0]
	dene(C.baslat(o,"ikinci_defter",99,k.id).kuyrukta,"İkinci defter sırada")
	for gun in 3: o.gece_sonu()
	dene(C.durum(o.yonetim).aktif.is_empty() and C.durum(o.yonetim).kuyruk.size() == 1,"İkinci iş bitiş gecesinde ilerlemez")
	var kasa := o.yonetim.akce
	o.gece_sonu()
	dene(C.durum(o.yonetim).aktif.defter == "ikinci_defter" and C.durum(o.yonetim).aktif.ilerleme == 1.0 and o.yonetim.akce == kasa - int(D.AYAR.cozumleme.kamu_bedel),"Sıradaki gerçek sonraki gecede tek bedelle başlar")
	D.AYAR = asil
func _uretim(o: Oturum, kat: Katalog) -> void:
	var y := o.yonetim
	var b := KoyBinasi.new()
	b.id = 200
	b.tur = "hizarhane"
	b.recete = "kereste"
	y.binalar.append(b)
	var k := y.koylular[0]
	dene(y.ata(k.id,b.id),"Araştırma sonrası gerçek üretim ataması")
	var taban := Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
	C.yukle(taban.yonetim,{})
	var a := {}
	var z := {}
	y._uret(a,[])
	taban.yonetim._uret(z,[])
	var anahtar := str(b.id) + ":kereste"
	var ham := float(z.get("kereste",0)) + float(taban.yonetim._artik.get(anahtar,0.0))
	var sonuc := float(a.get("kereste",0)) + float(y._artik.get(anahtar,0.0))
	dene(ham > 0 and is_equal_approx(sonuc,ham * float(D.AYAR.defterler[ID].arastirma.sonuc.carpan)),"Mevcut gerçek üretim hesabı tek sonuç çarpanını kullanır")

func _iyilesme(kat: Katalog) -> void:
	var o := hazir(kat,5058)
	o.gece_sonu()
	var k := o.yonetim.koylular[0]
	k.saglik = 0
	o.gece_sonu()
	dene(k.saglik > 0 and C.durum(o.yonetim).aktif.ilerleme == 1.0,"Mevcut gece sonu iyileşmesi geçmiş geceye araştırma çalışması yazmaz")
