extends SceneTree
var hata := 0
func dene(v: bool, s: String) -> void:
	if not v: hata += 1; push_error(s)
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat,1301)
	var y := o.yonetim
	y.agalik = true
	y.gun = 4
	var olaylar: Array[Dictionary] = []
	y._asamalar(olaylar)
	dene(not y.harac_bekliyor, "Altıncı günden önce heyet yok")
	y.gun = 5
	olaylar.clear()
	y._asamalar(olaylar)
	dene(y.harac_bekliyor and olaylar.size()==1, "Altıncı gün mevcut döngü tek heyet")
	dene(IflasYoneticisi.olay_metin(olaylar[0]).contains("buğday"), "Rapor gıda değil buğday gösterir")
	y.akce = y.a.harac_akce
	y.kaynaklar.stok["bugday"] = y.a.harac_gida-1
	y.kaynaklar.stok["gida"] = 200
	var once := JSON.stringify(o.kaydet())
	dene(not y.harac_ode() and JSON.stringify(o.kaydet())==once, "Eksik buğday atomik ret, gıda yerine geçmez")
	y.kaynaklar.stok["bugday"] = y.a.harac_gida
	y.akce -= 1
	once = JSON.stringify(o.kaydet())
	dene(not y.harac_ode() and JSON.stringify(o.kaydet())==once, "Eksik kamu akçesi atomik ret")
	y.akce += 1
	var para := o.muhafiz_akce
	var rng := y._rng.state
	dene(y.harac_ode() and y.akce==0 and y.kaynaklar.miktar("bugday")==0 and y.kaynaklar.miktar("gida")==200, "Tam ödeme kamu akçesi/buğday")
	dene(o.muhafiz_akce==para and y._rng.state==rng and y.tekfur_baski==0, "Kişisel kese/RNG/baskı korunur")
	once = JSON.stringify(o.kaydet())
	dene(not y.harac_ode() and JSON.stringify(o.kaydet())==once, "İkinci ödeme yok")
	o = Oturum.kayittan(kat,JSON.parse_string(once))
	y = o.yonetim
	dene(not y.harac_ode(), "JSON sonrası ödendi makbuzu mevcut harac alanı")
	y.gun = 11
	olaylar.clear()
	y._asamalar(olaylar)
	dene(y.harac_bekliyor and olaylar.size()==1, "On ikinci gün aynı döngü")
	y.harac_reddet()
	y.harac_reddet()
	dene(y.tekfur_baski==1 and not y.harac_bekliyor, "Ret yalnız bir baskın hazırlığı")
	olaylar.clear()
	y._asamalar(olaylar)
	dene(y.son==KoyYonetimi.SON_TEKFUR, "Mevcut savunmasız Tekfur baskını korunur")
	y.harac_bekliyor = true
	y.akce = 100
	y.kaynaklar.stok["bugday"] = 100
	once = JSON.stringify(o.kaydet())
	dene(not y.harac_ode() and JSON.stringify(o.kaydet())==once, "Terminalde ödeme yok")
	var z := Oturum.new(kat,1302).yonetim
	z.agalik = true
	z.harac_bekliyor = true
	olaylar.clear()
	z._asamalar(olaylar)
	dene(z.tekfur_baski==1 and z.son==KoyYonetimi.SON_TEKFUR, "Cevapsız heyet mevcut ret/baskın")
	print("TEKFUR HEYETI: GEÇTİ" if hata==0 else "TEKFUR HEYETI: KALDI")
	quit(hata)
