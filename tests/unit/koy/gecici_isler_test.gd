extends SceneTree
var hata := 0
var kat: Katalog
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func bina(y: KoyYonetimi,tur: String,id: int,kalan: int=0) -> KoyBinasi:
	var b := KoyBinasi.new()
	b.id=id; b.tur=tur; b.hucre=Vector2i(id*2,2); b.insa_kalan=kalan
	y.binalar.append(b)
	return b
func hazir() -> Oturum:
	var o := Oturum.new(kat, 2002)
	var y := o.yonetim
	y.a=y.a.duplicate(true); y.a.ambar_taban_kapasite=10000; y.a.isyan_esigi=-1; y.a.insa_yardim_bolen=10000
	y.kaynaklar=Kaynaklar.new(10000,{"gida":1000,"su":1000,"odun":1000,"afyon":7})
	y.gun=2
	bina(y,"kulube",1)
	bina(y,"odunluk",2)
	bina(y,"kulube",4,10)
	y.tas_yatagi=TasYatagi.yeni(y,22)
	return o
func isci(y: KoyYonetimi, ad: String="İşçi") -> Koylu:
	var k := y.kabul({"ad":ad}); k.ev=1
	return k
func _initialize() -> void:
	kat=Katalog.new(); kat.yukle()
	var ids := []
	for d in GeciciIsler.AYAR.isler:
		ids.append(String(d.id))
		if d.has("binalar"):
			dene(d.binalar.any(func(t: Variant) -> bool: return kat.binalar.var_mi(String(t)) and not bool(kat.binalar.veri(String(t)).get("chr_hedef",false))), "İş en az bir gerçek kurulabilir yapı üzerinden erişilir: "+d.id)
	ids.sort()
	var beklenen := ["tas_toplama","dal_toplama","su_tasima","yol_hendek","insaat_yardimi","nobete_eslik","yun_egirme","ot_mantar","bakim"]
	beklenen.sort()
	dene(ids==beklenen,"Dokuz geçici iş tek veri listesinde")
	for id in ids: _tek_is(id)
	_kisitlar()
	_sinirlar()
	_kayit_ve_atama()
	_ikiz()
	_meclis()
	_su_siniri()
	print("GEÇİCİ İŞLER: GEÇTİ" if hata==0 else "GEÇİCİ İŞLER: KALDI")
	quit(hata)
func _tek_is(id: String) -> void:
	var o := hazir(); var y := o.yonetim; var k := isci(y)
	if id=="yun_egirme":
		k.yas_grubu=&"yasli"
		bina(y,"agil",6)
	if id=="bakim":
		var cocuk := isci(y,"Çocuk"); cocuk.yas_grubu=&"cocuk"
	if id=="nobete_eslik":
		var nobetci := isci(y,"Nöbetçi"); KapiNobeti.yaz(y,nobetci.id)
	dene(GeciciIsler.ata(y,k.id,id),"İşe atanır: "+id)
	dene(not GeciciIsler.ata(y,k.id,"dal_toplama"),"Aynı kişiye ikinci geçici iş yok: "+id)
	var afyon := y.kaynaklar.miktar("afyon")
	var r := y.gece()
	dene(int(r.tuketim.get("gida",0))==y.koylular.size(),"Geçici iş ikinci erzak bedeli yazmaz: "+id)
	var satirlar: Array=r.get("gecici_isler",[])
	dene(satirlar.size()==1 and satirlar[0].is_id==id,"Gerçek bilançoda kendi kimliğiyle tek satır: "+id)
	if not satirlar.is_empty(): dene(satirlar[0].miktar==1,"Veri tablosundan bir katkı: "+id)
	dene(y.kaynaklar.miktar("afyon")==afyon,"Geçici iş afyon üretmez: "+id)
	if int(GeciciIsler.tanim(id).yorgunluk)>0: dene(NobetYorgunlugu.aktif(k,y),"Mevcut yorgunluk kaydı: "+id)
	if id in ["yol_hendek","insaat_yardimi"]: dene(y.bina(4).insa_kalan==8,"Tek inşaat hesabına +1 yardım")
	var stok := y.kaynaklar.kaydet()
	# Aynı raporu tekrar sunmak ikinci üretim veya bilançoya ikinci satır açmaz.
	GeciciIsler.gece(y,r,{})
	dene(y.kaynaklar.kaydet()==stok and r.gecici_isler.size()==1,"Aynı rapor idempotent: "+id)
func _kisitlar() -> void:
	var o := hazir(); var y := o.yonetim; var k := isci(y)
	k.yas_grubu=&"cocuk"
	dene(not GeciciIsler.ata(y,k.id,"dal_toplama"),"Çocuk atanmaz")
	k.yas_grubu=&"yetiskin"; k.bayraklar.append("agir_yarali")
	dene(not GeciciIsler.ata(y,k.id,"dal_toplama"),"Yaralı atanmaz")
	k.bayraklar.clear(); KapiNobeti.yaz(y,k.id)
	dene(not GeciciIsler.ata(y,k.id,"dal_toplama"),"Yuvadaki nöbetçi atanmaz")
	KapiNobeti.yukle(y,{})
	dene(y.ata(k.id,2),"Mevcut bina işi")
	dene(not GeciciIsler.ata(y,k.id,"dal_toplama"),"Bina çalışanı aynı gece geçici işe yazılmaz")
	y.bosalt(k.id); k.set_meta("hediye",true)
	var once := y.kaynaklar.kaydet()
	dene(GeciciIsler.secili(k).is_empty() and y.kaynaklar.kaydet()==once,"Hediye iş açmaz")
	dene(GeciciIsler.ata(y,k.id,"dal_toplama"),"Nöbete geçiş öncesi geçici iş")
	dene(KapiNobeti.yaz(y,k.id) and GeciciIsler.secili(k).is_empty(),"Nöbet ataması geçici işi bırakır")
	dene(KapiNobeti.durum(y).yuva==k.id and KapiNobeti.durum(y).eski_is==KoyYonetimi.BOSTA,"Nöbet kaydına geçici iş sentinel'i sızmaz")
func _sinirlar() -> void:
	var o := hazir(); var y := o.yonetim; var k := isci(y)
	y.tas_yatagi.kalan=0
	dene(not GeciciIsler.ata(y,k.id,"tas_toplama"),"Sıfır taş yatağı kapalı")
	dene(GeciciIsler.ata(y,k.id,"dal_toplama"),"Diğer iş sürer")
	GeciciIsler.birak(y,k); y.gun=3*y.a.mevsim_gun
	dene(GeciciIsler.ata(y,k.id,"ot_mantar"),"Kışın ot işi kaydı açılabilir")
	var r := y.gece()
	dene(r.gecici_isler.size()==1 and r.gecici_isler[0].miktar==0,"Ot vermeyen mevsimde sıfır katkı")
func _kayit_ve_atama() -> void:
	var o := hazir(); var y := o.yonetim; var k := isci(y)
	dene(GeciciIsler.ata(y,k.id,"dal_toplama"),"Kayıt ataması")
	var veri: Dictionary=JSON.parse_string(JSON.stringify(o.kaydet()))
	var geri := Oturum.kayittan(kat,veri)
	dene(geri!=null and GeciciIsler.secili(geri.yonetim.koylu(k.id))=="dal_toplama","Kişi üzerindeki atama korunur")
	dene(not JSON.stringify(veri).contains("havuz_sira"),"Havuz sırası kayda gömülmez")
	dene(y.ata(k.id,2) and GeciciIsler.secili(k).is_empty(),"Yapıya atama geçici işi bırakır")
	y.bina_yik(2)
	dene(k.is_yeri==KoyYonetimi.BOSTA,"Yıkılan binanın işçisi boşa düşer")
	dene(GeciciIsler.secili(k).is_empty(),"Boşalan iş kendiliğinden doldurulmaz")

func _ikiz() -> void:
	var o := hazir(); var y := o.yonetim; var k := isci(y)
	GeciciIsler.ata(y,k.id,"dal_toplama")
	var eski_ayar := kat.koy_ayarlari
	kat.koy_ayarlari=y.a
	var geri := Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
	kat.koy_ayarlari=eski_ayar
	for gece in 2:
		var a := y.gece(); var b := geri.yonetim.gece()
		dene(a.gecici_isler==b.gecici_isler and GeciciIsler.secili(k)==GeciciIsler.secili(geri.yonetim.koylu(k.id)),"Aynı tohumda iki gece aynı kişi/iş")
		dene(a.gecici_isler.size()==1 and a.gecici_isler[0].is_id=="dal_toplama","Sabah havuzu atamayı kendiliğinden değiştirmez")

func _meclis() -> void:
	var o := hazir(); var y := o.yonetim
	var gecici := isci(y,"Geçici"); GeciciIsler.ata(y,gecici.id,"dal_toplama")
	var normal := isci(y,"Oduncu")
	var tarla := bina(y,"tarla",5)
	tarla.recete="bugday"
	normal.stat=10
	dene(y.ata(normal.id,5),"Meclis gecesi bina çalışanı")
	var hasta := isci(y,"Belirtili hasta")
	SaglikYoneticisi.enfekte(y,hasta,"tifo"); hasta.bayrak_ac("hasta")
	dene(CinarAltiMeclisi.topla(y,"salgin"),"Gerçek çınar meclisi toplandı")
	var r: Dictionary = o.gece_sonu().rapor
	dene(r.get("gecici_isler",[]).size()==1 and r.gecici_isler[0].is_id=="dal_toplama","Meclis gecesinde geçici iş biter")
	dene(int(r.get("uretim",{}).get("bugday",0))>0,"Meclis gecesinde bina üretimi de sürer")

func _su_siniri() -> void:
	var o := hazir(); var y := o.yonetim
	var a := isci(y,"Su taşıyan bir"); var b := isci(y,"Su taşıyan iki")
	var durum := SuDengesi.durum(y)
	durum.gun=y.gun; durum.adet=int(SuDengesi.AYAR.kuyu_gunluk)-1
	SuDengesi.yukle(y,durum)
	dene(GeciciIsler.ata(y,a.id,"su_tasima") and GeciciIsler.ata(y,b.id,"su_tasima"),"Gerçek konut/ortak kuyu ile su işi erişilir")
	var once := y.kaynaklar.miktar("su"); var para := y.akce
	var r := {"uretim":{},"olaylar":[]}
	GeciciIsler.gece(y,r,{})
	dene(y.kaynaklar.miktar("su")==once+1 and SuDengesi.taze(y)==0,"İki işçi aynı günlük kuyunun son tek birimini taşır")
	dene(r.gecici_isler.size()==1 and r.gecici_isler[0].kisi==2 and r.gecici_isler[0].miktar==1,"Aynı iş tek bilanço satırında toplanır")
	dene(y.akce==para,"İşçi emeğine ikinci elle doldurma bedeli yazılmaz")
