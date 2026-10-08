extends SceneTree
var hata := 0
func dene(v: bool, s: String) -> void:
	if not v: hata += 1; push_error(s)
func koy(kat: Katalog) -> Oturum:
	var o := Oturum.new(kat,1401)
	for i in 5: o.yonetim.kabul({"ad":"Levent %d"%i})
	return o
func gece(o: Oturum, no: int) -> void:
	o.gun = no
	var a: Array[Dictionary] = []
	SancakAskerTalebi.gece(o,{"gun":no-1,"olaylar":a})
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := koy(kat)
	gece(o,7)
	dene(SancakAskerTalebi.olay(o)==null,"Ferman erken gelmez")
	gece(o,8)
	var e := SancakAskerTalebi.olay(o)
	dene(e!=null and o.secenek_olur(e,0) and not o.secenek_olur(e,1),"Gerçek iş gücü seçeneği, isyancı uydurulmaz")
	var once := JSON.stringify(o.kaydet())
	var rng := o._rng.state
	SancakAskerTalebi.olay(o)
	gece(o,8)
	dene(JSON.stringify(o.kaydet())==once,"Kart okuması ve tekrar gece saf")
	var para := o.muhafiz_akce
	var kamu := o.yonetim.akce
	var r := o.olay_uygula(e,0)
	dene(r.ok and o.yonetim.nufus()==3 and o.koy.toplam()==3,"İki gerçek levent ve nüfus köprüsü")
	dene(o.muhafiz_akce==para and o.yonetim.akce==kamu and o._rng.state==rng,"Para ve RNG değişmez")
	once = JSON.stringify(o.kaydet())
	dene(not o.olay_uygula(e,0).ok and JSON.stringify(o.kaydet())==once,"Çift seçim yok")
	o = Oturum.kayittan(kat,JSON.parse_string(once))
	dene(not o.secenek_olur(e,0) and SancakAskerTalebi.oku(o.sancak_asker_talebi).gonderilen.size()==2,"JSON makbuzu korunur")
	gece(o,19)
	dene(SancakAskerTalebi.olay(o)==null,"İkinci vade erken gelmez")
	gece(o,20)
	dene(not o.secenek_olur(e,0) and SancakAskerTalebi.olay(o)!=null,"Yeni vade eski kartı geçersiz kılar")
	var yeni := SancakAskerTalebi.olay(o)
	dene(o.olay_uygula(yeni,0).ok and o.yonetim.nufus()==1,"Köyde bir kişi bırakma sınırı")
	gece(o,32)
	dene(not o.secenek_olur(SancakAskerTalebi.olay(o),0),"Son kişi gönderilmez")
	var z := koy(kat)
	for k in z.yonetim.koylular.slice(0,2):
		k.is_yeri = KoyYonetimi.MUHAFIZ
		k.zanaat_turu = ZanaatTuru.Tur.CIFTCI
		k.moral = 0
	gece(z,8)
	e = SancakAskerTalebi.olay(z)
	var aday := SancakAskerTalebi.adaylar(z.yonetim,true)
	dene(aday.size()==2 and z.secenek_olur(e,1),"Gerçek açık iş reddi adayları")
	var id := aday[0].id
	r = z.olay_uygula(e,1)
	dene(r.ok and z.yonetim.koylu(id)==null and z.yonetim.nufus()==3,"İsyancı seçimi gerçek iki kişi, suç hükmü yaratmaz")
	var w := koy(kat)
	w.yonetim.koylular[0].yas_grubu = &"cocuk"
	w.yonetim.koylular[1].bayrak_ekle("zindanda")
	w.yonetim.koylular[2].saglik = 10
	w.yonetim.koylular[3].adli_id = &"chr_001"
	gece(w,8)
	e = SancakAskerTalebi.olay(w)
	dene(not w.secenek_olur(e,0),"Çocuk/hasta/zindan/adlı hikaye karakteri hariç")
	w.yonetim.kervan_koruma[str(w.yonetim.koylular[4].id)] = {"baslangic":8,"donus":10}
	dene(SancakAskerTalebi.adaylar(w.yonetim,false).is_empty(),"Dış kervan nöbetçisi gönderilmez")
	once = JSON.stringify(w.kaydet())
	dene(not w.olay_uygula(e,0).ok and JSON.stringify(w.kaydet())==once,"Eksik aday atomik ret")
	var risk := w.yonetim.asayis_riski
	dene(w.olay_uygula(e,2).ok and w.yonetim.nufus()==5 and w.yonetim.asayis_riski==risk+5,"Ferman reddi tek dış JSON baskı deltası")
	w.yonetim.son = KoyYonetimi.SON_TEKFUR
	gece(w,20)
	dene(SancakAskerTalebi.olay(w)==null,"Terminalde yeni kart yok")
	for bozuk in [null,{}, {"bekliyor":true,"gun":"8","son_gece":true,"secim":2.5,"gonderilen":[true,-1,1.5,"4",INF]}]:
		var d := SancakAskerTalebi.oku(bozuk)
		dene(not d.bekliyor and d.gonderilen.is_empty(),"Bozuk optional kayıt elenir")
	print("SANCAK ASKER TALEBI: GEÇTİ" if hata==0 else "SANCAK ASKER TALEBI: KALDI")
	quit(hata)
