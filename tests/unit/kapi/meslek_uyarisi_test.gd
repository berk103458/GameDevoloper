extends SceneTree
const U = preload("res://src/kapi/meslek_uyarisi.gd")
var hata := 0
func dene(v: bool,ad: String) -> void:
	if not v:
		hata+=1
		push_error(ad)
func gelen(id: String) -> Gelen:
	var g := Gelen.new(); g.adli=true; g.id=StringName(id)
	return g
func _initialize() -> void:
	var kat := Katalog.new(); kat.yukle()
	var o := Oturum.new(kat,2001); var y := o.yonetim
	var g := gelen("chr_028")
	var once := JSON.stringify(o.kaydet()); var rng := o._rng.state
	var s := U.satirlar(y,g)
	dene(s.size()==1 and s[0].contains("Kumaşçı") and s[0].contains("dokuma tezgâhı yok"),"Atölyesiz kumaşçı tek uyarı")
	dene(s[0].contains("günde 1 erzak") and s[0].contains("%50 verim"),"Mevcut tüketim ve ISG-02 tablo verimi")
	dene(JSON.stringify(o.kaydet())==once and o._rng.state==rng,"Uyarı kayıt/RNG/stok yazmaz")
	var b := KoyBinasi.new(); b.id=1; b.tur="bez_evi"; b.insa_kalan=1; y.binalar.append(b)
	dene(U.satirlar(y,g).size()==1,"İnşaat halindeki yapı hazır sayılmaz")
	b.insa_kalan=0
	dene(U.satirlar(y,g).is_empty(),"Hazır dokuma tezgâhında uyarı yok")
	dene(U.satirlar(y,gelen("chr_001")).is_empty(),"Mesleği olmayan kişiye uyarı yok")
	var es := gelen("chr_028"); es.acik_bayraklar.append("acl01_es")
	dene(U.satirlar(y,es).is_empty(),"Eş kendi panelindedir, uyarı yok")
	y.binalar.clear()
	dene(U.satirlar(y,gelen("chr_003")).size()==2,"Kaynakta iki meslekli Haydar iki eksik mesleği görür")
	var sf := KoyBinasi.new(); sf.id=2; sf.tur="sifahane"; y.binalar.append(sf)
	dene(U.satirlar(y,gelen("chr_003")).size()==1,"Bir mesleğin binası hazırsa yalnız diğeri uyarır")
	var figur := gelen("chr_003"); figur.adli=false; figur.sinif=&"esnaf"
	dene(U.meslekler(figur).is_empty(),"Figüre adlı kişinin ikinci mesleği sızmaz")
	var verim_once: Variant=GeciciIsler.AYAR.verim_yuzde
	GeciciIsler.AYAR.verim_yuzde=37
	dene(U.satirlar(y,g)[0].contains("%37"),"Verim uyarıda sabit değildir")
	GeciciIsler.AYAR.verim_yuzde=verim_once
	for meslek in U.AYAR.meslekler:
		var tur := int(ZanaatTuru.Tur[meslek])
		var hedefler := []
		for hedef in U.AYAR.meslekler[meslek].binalar:
			dene(kat.binalar.var_mi(hedef.tur),"Eşleme gerçek katalog türü: "+hedef.tur)
			hedefler.append(String(hedef.tur))
		dene(hedefler==MeslekUyumu.UYGUN[tur],"Uyarı mevcut UZM-03 uygunluğunu değiştirmez: "+meslek)
	_tuketim(kat)
	print("MESLEK UYARISI: GEÇTİ" if hata==0 else "MESLEK UYARISI: KALDI")
	quit(hata)

func _tuketim(kat: Katalog) -> void:
	for hazir in [false,true]:
		var o := Oturum.new(kat,2011); var y := o.yonetim
		y.gun=5; y.a=y.a.duplicate(true); y.a.isyan_esigi=-1; y.a.ambar_taban_kapasite=1000
		y.kaynaklar=Kaynaklar.new(1000,{"gida":100,"su":100,"odun":100})
		y.kabul({"ad":"Kumaşçı","adli_id":&"chr_028","sinif":&"esnaf"})
		if hazir:
			var b := KoyBinasi.new(); b.id=1; b.tur="bez_evi"; y.binalar.append(b)
		var once := JSON.stringify(o.kaydet())
		var s := U.satirlar(y,gelen("chr_028"))
		dene(s.size()==(0 if hazir else 1),"Tüketim fikstürü uyarı açık/kapalı")
		dene(JSON.stringify(o.kaydet())==once and not once.contains("meslek_uyarisi"),"Uyarı kayıt alanı değildir")
		var r := y.gece()
		dene(int(r.tuketim.get("gida",0))==1,"Uyarı açıkken de kapalıyken de tek erzak payı")
