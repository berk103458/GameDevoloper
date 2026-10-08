extends SceneTree
var hata := 0
func dene(v: bool,s: String) -> void:
	if not v: hata+=1; push_error(s)
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat,1501)
	var y := o.yonetim
	for i in 2:
		var k := y.kabul({"ad":"Yol muhafızı %d"%i,"sinif":"asker","stat":5})
		y.muhafiz_ata(k.id)
	var once := JSON.stringify(o.kaydet())
	dene(not GocYoluGuvenligi.temizle(o).ok and JSON.stringify(o.kaydet())==once,"Tehdit yoksa sahte temizlik yok")
	y.husumet.puan = y.a.sizma_esigi
	var kamu := y.akce
	var para := o.muhafiz_akce
	var rng := o._rng.state
	var rr := y._rng.state
	var r := GocYoluGuvenligi.temizle(o)
	dene(r.ok and r.basari and y.husumet.puan==maxi(0,y.a.sizma_esigi-20),"Gerçek iki güçlü muhafız tehdidi azaltır")
	dene(y.koylular[0].saglik==95 and y.koylular[1].saglik==95,"Gerçek kişilere görev bedeli")
	dene(y.akce==kamu and o.muhafiz_akce==para and o._rng.state==rng and y._rng.state==rr,"Görev kasa/RNG değiştirmez")
	once = JSON.stringify(o.kaydet())
	GocYoluGuvenligi.tip(o)
	CevreHaritasi.bilgi(o,"goc_yolu")
	dene(JSON.stringify(o.kaydet())==once and not GocYoluGuvenligi.temizle(o).ok,"Okuma saf, aynı gün ikinci görev yok")
	o = Oturum.kayittan(kat,JSON.parse_string(once))
	dene(not GocYoluGuvenligi.temizle(o).ok,"JSON sonrası aynı görev yeniden ödüllenmez")
	var taban := Oturum.kayittan(kat,JSON.parse_string(once))
	taban.goc_yolu_guvenligi = {}
	var kuyruk := o.gece_kuyrugu()
	var normal := taban.gece_kuyrugu()
	dene(kuyruk.size()==normal.size()+1,"Başarılı temizlik mevcut kuyruğa bir göç ziyareti ekler")
	var goc: Gelen
	for g in kuyruk:
		if g.get_meta("har05_goc",false): goc=g
	dene(goc!=null and goc.heybe!=null and goc.secenekler.has("kabul") and goc.secenekler.has("ret"),"Gerçek heybe/karar kuralları, otomatik kabul yok")
	dene(GocYoluGuvenligi.oku(o.goc_yolu_guvenligi).bekleyen==1,"Tek ziyaret makbuzu")
	var a: Array[Gelen]=[]
	once = JSON.stringify(o.kaydet())
	GocYoluGuvenligi.ziyaret(o,a)
	dene(a.is_empty() and JSON.stringify(o.kaydet())==once,"Aynı gün ek ziyaret tekrar yok")
	o.gun+=1
	GocYoluGuvenligi.ziyaret(o,a)
	dene(a.size()==1 and GocYoluGuvenligi.oku(o.goc_yolu_guvenligi).bekleyen==0,"İkinci gerçek gün ve ödül tükenir")
	var z := Oturum.new(kat,1502)
	for i in 2:
		var k := z.yonetim.kabul({"ad":"Zayıf muhafız","sinif":"asker","stat":3})
		z.yonetim.muhafiz_ata(k.id)
	z.yonetim.husumet.puan=z.yonetim.a.sizma_esigi
	r=GocYoluGuvenligi.temizle(z)
	dene(r.ok and not r.basari and GocYoluGuvenligi.oku(z.goc_yolu_guvenligi).bekleyen==0,"Yetersiz güçte sahte göç ödülü yok")
	z.yonetim.son=KoyYonetimi.SON_TEKFUR
	z.gun+=1
	dene(not GocYoluGuvenligi.temizle(z).ok,"Terminal görev yok")
	var q:=Oturum.new(kat,1504)
	for i in 3:
		var k:=q.yonetim.kabul({"ad":"Uygun olmayan nöbetçi","sinif":"asker","stat":7})
		q.yonetim.muhafiz_ata(k.id)
	q.yonetim.koylular[0].yas_grubu=&"cocuk"
	q.yonetim.koylular[1].bayrak_ekle("zindanda")
	q.yonetim.kervan_koruma[str(q.yonetim.koylular[2].id)]={"baslangic":0,"donus":2}
	q.yonetim.husumet.puan=q.yonetim.a.sizma_esigi
	once=JSON.stringify(q.kaydet())
	dene(GocYoluGuvenligi.adaylar(q.yonetim).is_empty() and not GocYoluGuvenligi.temizle(q).ok and JSON.stringify(q.kaydet())==once,"Çocuk/zindan/dış görev atomik reddedilir")
	for v in [null,{}, {"son_gun":true,"son_ziyaret":"1","bekleyen":INF,"basari":1.5,"sonuc":"uydurma"}]:
		var d:=GocYoluGuvenligi.oku(v)
		dene(d.son_gun==-1 and d.bekleyen==0,"Bozuk optional alanlar elenir")
	print("GOC YOLU: GEÇTİ" if hata==0 else "GOC YOLU: KALDI")
	quit(hata)
