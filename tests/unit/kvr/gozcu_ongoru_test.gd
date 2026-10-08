extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
	if not v: hata+=1; push_error(s)
func _initialize() -> void:
	var kat:=Katalog.new()
	kat.yukle()
	var o:=Oturum.new(kat,1601)
	var y:=o.yonetim
	var eski: Dictionary=JSON.parse_string(FileAccess.get_file_as_string(BinaKatalogu.YOL))
	for tur in eski:
		if not String(tur).begins_with("_"): dene(y.katalog.veri(tur)==eski[tur],"Mevcut yapı verisi korunur")
	dene(y.katalog.veri(GozcuKulesi.TUR).kurulabilir and y.katalog.slot(GozcuKulesi.TUR)==1,"Mevcut CHR türü tek gerçek gözcü yuvası")
	dene(not GozcuOngoru.durum(o).aktif,"Kulesiz önizleme yok")
	y.akce=100
	y.kaynaklar.kapasite=1000
	y.kaynaklar.ekle("odun",100)
	y.kaynaklar.ekle("tas",100)
	y.kaynaklar.ekle("kereste",100)
	var konum:=Vector2i(-1,-1)
	for yy in y.a.izgara_boyut.y:
		for x in y.a.izgara_boyut.x:
			if y.yerlesim(GozcuKulesi.TUR,Vector2i(x,yy)).olur: konum=Vector2i(x,yy); break
		if konum.x>=0: break
	var para:=y.akce
	var r:=y.bina_kur(GozcuKulesi.TUR,konum)
	dene(r.olur and y.akce==para-10,"Gerçek inşa maliyeti")
	var b:=y.bina(int(r.id))
	dene(not GozcuKulesi.aktif(y),"İnşaat halindeki kule uyarı vermez")
	b.insa_kalan=0
	var k:=y.kabul({"ad":"Gözcü","sinif":"asker","stat":5})
	dene(y.ata(k.id,b.id) and GozcuKulesi.aktif(y),"Hazır kule ve gerçek sağlıklı gözcü")
	y.kaynaklar.ekle("gida",100)
	y.kaynaklar.ekle("su",100)
	o._koy_esitle()
	var once:=JSON.stringify(o.kaydet())
	var turler:=JSON.stringify(y.katalog.turler)
	var aralik:=y.a.harac_araligi
	var olasilik:=o.ayarlar.olay_olasiligi
	var d:=GozcuOngoru.durum(o)
	dene(d.aktif and d.gun==o.gun+1 and not d.adaylar.is_empty(),"Ertesi gerçek gün isim/sınıf öngörüsü")
	for g in d.adaylar: dene(g.size()==2 and g.has("ad") and g.has("sinif"),"Gizli bayrak/heybe/Clue/stat açılmaz")
	dene(JSON.stringify(o.kaydet())==once and JSON.stringify(y.katalog.turler)==turler and y.a.harac_araligi==aralik and o.ayarlar.olay_olasiligi==olasilik,"Kaynak runtime/RNG/ayar/katalog değişmez")
	dene(GozcuOngoru.durum(o)==d,"Öngörü tekrarı deterministik ve saf")
	var z:=Oturum.kayittan(kat,JSON.parse_string(once))
	dene(GozcuOngoru.durum(z)==d,"JSON sonrası aynı öngörü")
	var gercek:=Oturum.kayittan(kat,JSON.parse_string(once))
	gercek.gece_sonu()
	var gelenler: Array=[]
	for g in gercek.gece_kuyrugu().slice(0,8): gelenler.append({"ad":gercek.tr_gelen(g),"sinif":gercek.tr_ad(g.sinif)})
	dene(gelenler==d.adaylar,"Gece kararı değişmezse gerçek sonraki kuyrukla eşleşir")
	z.yonetim.bina(int(r.id)).insa_kalan=1
	dene(not GozcuOngoru.durum(z).aktif,"Hazır olmayan kule devre dışı")
	k.bayrak_ekle("zindanda")
	dene(not GozcuKulesi.aktif(y),"Tutuklu gözcü çalışmaz")
	k.bayraklar.clear()
	k.yas_grubu=&"cocuk"
	dene(not GozcuKulesi.aktif(y),"Çocuk gözcü uyarı vermez")
	k.yas_grubu=&"yetiskin"
	k.saglik=10
	dene(not GozcuKulesi.aktif(y),"Hasta gözcü uyarı vermez")
	print("GOZCU ONGORU: GEÇTİ" if hata==0 else "GOZCU ONGORU: KALDI")
	quit(hata)
