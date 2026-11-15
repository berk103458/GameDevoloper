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
	# SOY-37: "yol_guvensiz" kamuoyu olunca kapıya gelen sayısı o gece -1; doğruysa ertesi gün de.
	var so_y := Oturum.new(kat, 9137)
	so_y.gun = 3
	for i in 6:
		so_y.yonetim.kabul({"sinif": "ciftci"})
	var baz_gelen := so_y.gece_kuyrugu().size()
	var ag_y := SoylentiKoprusu.ag(so_y) as SoylentiAgi
	var y_ek := ag_y.soylenti_ekle("yol_yanlis_1", "yol_guvensiz", str(so_y.yonetim.koylular[0].id), false, {"gece": so_y.gun})
	dene(bool(y_ek.get("olur", false)), "Yol güvensiz söylentisi ağa girer")
	ag_y.gece_ilerlet(so_y.gun, so_y.yonetim.koylular.size())
	ag_y.gece_ilerlet(so_y.gun, so_y.yonetim.koylular.size())
	dene(so_y.gece_kuyrugu().size() == baz_gelen - 1, "SOY-37: yol güvensiz (yanlış) o gece gelen -1")
	so_y.gun += 1
	dene(so_y.gece_kuyrugu().size() == baz_gelen, "SOY-37: yanlış söylenti ertesi gün normale döner")
	var so_d := Oturum.new(kat, 9138)
	var so_ref := Oturum.new(kat, 9138)
	so_d.gun = 3
	so_ref.gun = 3
	for i in 6:
		so_d.yonetim.kabul({"sinif": "ciftci"})
		so_ref.yonetim.kabul({"sinif": "ciftci"})
	var ag_d := SoylentiKoprusu.ag(so_d) as SoylentiAgi
	ag_d.soylenti_ekle("yol_dogru_1", "yol_guvensiz", str(so_d.yonetim.koylular[0].id), true, {"gece": so_d.gun})
	ag_d.gece_ilerlet(so_d.gun, so_d.yonetim.koylular.size())
	ag_d.gece_ilerlet(so_d.gun, so_d.yonetim.koylular.size())
	dene(so_d.gece_kuyrugu().size() == so_ref.gece_kuyrugu().size() - 1, "SOY-37: yol güvensiz (doğru) o gece -1")
	so_d.gun += 1
	so_ref.gun += 1
	dene(so_d.gece_kuyrugu().size() == so_ref.gece_kuyrugu().size() - 1, "SOY-37: yol güvensiz (doğru) ertesi gün de -1")
	so_d.gun += 1
	so_ref.gun += 1
	dene(so_d.gece_kuyrugu().size() == so_ref.gece_kuyrugu().size() and GocYoluGuvenligi.soylenti_gelen_farki(so_d) == 0, "SOY-37: ikinci gün sonrası normal")
	# Gerçek Oturum.gece_sonu() + kaydet/kayittan akışında süre kontrolü (eşli referans oturumla):
	var gs_y := Oturum.new(kat, 9139)
	var gs_y_ref := Oturum.new(kat, 9139)
	for x in [gs_y, gs_y_ref]:
		x.yonetim.kaynaklar = Kaynaklar.new(10000, {"gida": 2000, "odun": 200})
		x.gun = 3
		for i in 6:
			x.yonetim.kabul({"sinif": "ciftci"})
	var ag_gs_y := SoylentiKoprusu.ag(gs_y) as SoylentiAgi
	ag_gs_y.soylenti_ekle("yol_gs_y", "yol_guvensiz", str(gs_y.yonetim.koylular[0].id), false, {"gece": gs_y.gun})
	gs_y.gece_sonu()
	gs_y_ref.gece_sonu()
	dene(GocYoluGuvenligi.soylenti_gelen_farki(gs_y) == -1 and gs_y.gece_kuyrugu().size() == gs_y_ref.gece_kuyrugu().size() - 1, "SOY-37: gece_sonu sonrası yanlış yol söylentisi ilk gece -1")
	var gs_yuk := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(gs_y.kaydet())))
	var gs_ref_yuk := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(gs_y_ref.kaydet())))
	dene(GocYoluGuvenligi.soylenti_gelen_farki(gs_yuk) == -1 and gs_yuk.gece_kuyrugu().size() == gs_ref_yuk.gece_kuyrugu().size() - 1, "SOY-37: kaydet/kayittan sonrası gelen farkı korunur")
	gs_yuk.gece_sonu()
	gs_ref_yuk.gece_sonu()
	dene(GocYoluGuvenligi.soylenti_gelen_farki(gs_yuk) == 0 and gs_yuk.gece_kuyrugu().size() == gs_ref_yuk.gece_kuyrugu().size(), "SOY-37: gece_sonu ertesi yanlış söylenti düzelir")
	var gs_d := Oturum.new(kat, 9140)
	var gs_d_ref := Oturum.new(kat, 9140)
	for x in [gs_d, gs_d_ref]:
		x.yonetim.kaynaklar = Kaynaklar.new(10000, {"gida": 2000, "odun": 200})
		x.gun = 3
		for i in 6:
			x.yonetim.kabul({"sinif": "ciftci"})
	var ag_gs_d := SoylentiKoprusu.ag(gs_d) as SoylentiAgi
	ag_gs_d.soylenti_ekle("yol_gs_d", "yol_guvensiz", str(gs_d.yonetim.koylular[0].id), true, {"gece": gs_d.gun})
	gs_d.gece_sonu()
	gs_d_ref.gece_sonu()
	dene(GocYoluGuvenligi.soylenti_gelen_farki(gs_d) == -1 and gs_d.gece_kuyrugu().size() == gs_d_ref.gece_kuyrugu().size() - 1, "SOY-37: gece_sonu sonrası doğru yol söylentisi 1. gece -1")
	gs_d.gece_sonu()
	gs_d_ref.gece_sonu()
	dene(GocYoluGuvenligi.soylenti_gelen_farki(gs_d) == -1 and gs_d.gece_kuyrugu().size() == gs_d_ref.gece_kuyrugu().size() - 1, "SOY-37: gece_sonu sonrası doğru yol söylentisi 2. gece de -1")
	gs_d.gece_sonu()
	gs_d_ref.gece_sonu()
	dene(GocYoluGuvenligi.soylenti_gelen_farki(gs_d) == 0 and gs_d.gece_kuyrugu().size() == gs_d_ref.gece_kuyrugu().size(), "SOY-37: doğru yol söylentisi 3. gece düzelir")
	print("GOC YOLU: GEÇTİ" if hata==0 else "GOC YOLU: KALDI")
	quit(hata)
