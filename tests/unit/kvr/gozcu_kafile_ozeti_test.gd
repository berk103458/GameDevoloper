extends SceneTree
const OZET = preload("res://src/sistemler/gozcu_kafile_ozeti.gd")
var hata := 0
func dene(v: bool, s: String) -> void:
	if not v: hata += 1; push_error(s)

func hazir(kat: Katalog) -> Oturum:
	var o := Oturum.new(kat,1931)
	o.ayarlar=o.ayarlar.duplicate(true)
	var y := o.yonetim
	y.a=y.a.duplicate(true)
	y.akce=100
	y.kaynaklar.kapasite=1000
	for tur in ["odun","tas","kereste","gida","su"]: y.kaynaklar.ekle(tur,100)
	for yy in y.a.izgara_boyut.y:
		for x in y.a.izgara_boyut.x:
			var konum := Vector2i(x,yy)
			if not y.yerlesim(GozcuKulesi.TUR,konum).olur: continue
			var r := y.bina_kur(GozcuKulesi.TUR,konum)
			y.bina(int(r.id)).insa_kalan=0
			var k := y.kabul({"ad":"Gözcü","sinif":"asker","stat":5})
			dene(y.ata(k.id,int(r.id)),"Gerçek gözcü atanır")
			o._koy_esitle()
			return o
	dene(false,"Kule için yer bulunamadı")
	return o

func rngler(o: Oturum) -> Array:
	return [o._rng.state,o._rng_donus.state,o._rng_ad.state,o._rng_heybe.state,o.yonetim._rng.state]

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := hazir(kat)
	var y := o.yonetim
	y.gun=24; y.agalik=true
	y.a.harac_araligi=25; y.a.kervan_araligi=26
	o.ayarlar.perde2_gece_basina_gelen=12
	o.muhafiz_akce=37
	o.set_meta(DiplomatikHeyet.META,{"tekfur_gun":18,"mogol":[2]})
	y.tuccar_girisi={"varis":1,"uzman":String(GezginTuccarTakvimi.AYAR.uzmanlar[0].id),"karar":"harc","alinan":5}
	var once := JSON.stringify(o.kaydet())
	var rng := rngler(o)
	var stok := y.kaynaklar.stok.duplicate(true)
	var kasa := [o.koy_akce,o.muhafiz_akce]
	var heyet: Dictionary = o.get_meta(DiplomatikHeyet.META).duplicate(true)
	var tuccar := y.tuccar_girisi.duplicate(true)
	var kadro := o.kadro.kaydet().duplicate(true)
	var d := GozcuOngoru.durum(o)
	dene(d.aktif and d.gun==25 and d.adaylar.size()==8,"Aynı HAR-06 günü ve ayrıntı sınırı")
	dene(d.ozet.toplam>8 and d.ozet.tuccar==1 and d.ozet.heyetler==["Moğol öncü heyeti","Tekfur haraç heyeti"],"Tam kuyruk: iki gerçek heyet ve gezgin tüccar")
	dene(d.ozet.toplam==d.ozet.yolcu+d.ozet.tuccar+d.ozet.heyetler.size(),"Her ziyaret yalnız bir kategoride sayılır")
	var metin := GozcuOngoru.metin(o)
	dene(metin.contains("Gözcü öngörüsü · 26. gün") and metin.contains("Kafile özeti:") and metin.contains("Öncelikli heyet: Moğol öncü heyeti") and metin.contains("Öncelikli heyet: Tekfur haraç heyeti"),"Mevcut harita notunda public heyet önceliği")
	dene(String(CevreHaritasi.bilgi(o,"hisar").metin).contains(metin),"Tek mevcut Hisar bilgi alanı")
	dene(GozcuOngoru.durum(o)==d,"Tekrarlı okuma deterministik")
	dene(JSON.stringify(o.kaydet())==once and rngler(o)==rng and y.kaynaklar.stok==stok and [o.koy_akce,o.muhafiz_akce]==kasa,"Kaynak kayıt, beş RNG, stok ve iki kasa değişmez")
	dene(o.get_meta(DiplomatikHeyet.META)==heyet and y.tuccar_girisi==tuccar and o.kadro.kaydet()==kadro,"Heyet/tüccar/CHR ziyaret makbuzları değişmez")
	var z := Oturum.kayittan(kat,JSON.parse_string(once))
	z.ayarlar=o.ayarlar.duplicate(true); z.yonetim.a=y.a.duplicate(true)
	dene(GozcuOngoru.durum(z)==d,"Kayıt yükleme sonrası aynı özet")
	z.gece_sonu()
	var gercek := z.gece_kuyrugu()
	dene(OZET.kuyruktan(gercek)==d.ozet,"Gerçek ertesi gün kuyruğunun tamamıyla eşleşme")
	# Public sınıf dışında gizli karakter alanları özetin girdisi değildir.
	var gizli := Gelen.new()
	gizli.adli=true; gizli.id=&"chr_002"; gizli.ad_anahtari="GIZLI_KIMLIK"
	gizli.tehlikeli=true; gizli.gizli_bayraklar=PackedStringArray(["GIZLI_NIYET"])
	var guvenli := OZET.kuyruktan([gizli])
	dene(guvenli=={"toplam":1,"yolcu":1,"tuccar":0,"ticaret_yolcusu":0,"heyetler":[]} and not JSON.stringify(guvenli).contains("GIZLI") and not OZET.metin(guvenli).contains("chr_"),"Gizli CHR kimliği/niyeti/sorgusu dışarı çıkmaz")
	dene(not gizli._chr_kontrol_edildi,"Özet CHR sorgusunu açmaz")
	dene(OZET.kuyruktan([]).toplam==0 and OZET.metin(OZET.kuyruktan([])).contains("ziyareti yok"),"Gerçek boş kuyruk açıkça belirtilir")
	d.ozet.heyetler.clear()
	dene(GozcuOngoru.durum(o).ozet.heyetler.size()==2,"Dönen özet dışarıdan değişse de sonraki okuma korunur")
	# Eşik dışı sıradan gün ve eski makbuzların ertesi günü engellememesi.
	y.gun=0; y.agalik=false
	dene(GozcuOngoru.durum(o).ozet.heyetler.is_empty(),"Eşik dışı gün hayali diplomatik heyet yok")
	y.gun=29; o.mogol_oncusu={"son_gece":29,"uyarilar":[5,2,0]}
	o.set_meta(DiplomatikHeyet.META,{"tekfur_gun":18,"mogol":[5,2,0]})
	dene(GozcuOngoru.durum(o).ozet.heyetler.is_empty(),"Dinlenmiş sınır heyeti tekrar vaat edilmez")
	y.agalik=true; y.harac_bekliyor=true; y.tekfur_baski=100
	once=JSON.stringify(o.kaydet())
	var belirsiz := GozcuOngoru.durum(o)
	dene(belirsiz.aktif and belirsiz.ozet.is_empty() and belirsiz.adaylar.is_empty() and String(belirsiz.not).contains("üretilemedi"),"Gece yenilgisi sahte boş kafile veya heyet vaadi üretmez")
	dene(JSON.stringify(o.kaydet())==once,"Belirsiz gece de kaynak talebi/sonucunu değiştirmez")
	y.son=KoyYonetimi.SON_TEKFUR
	var terminal := GozcuOngoru.durum(o)
	dene(not terminal.aktif and terminal.ozet.is_empty() and terminal.adaylar.is_empty(),"Biten oyunda kule kapalı, sahte kuyruk özeti yok")
	for b in y.binalar:
		if b.tur==GozcuKulesi.TUR: b.insa_kalan=1
	dene(not GozcuOngoru.durum(o).aktif and GozcuOngoru.durum(o).ozet.is_empty(),"Kapalı kule özet sızdırmaz")
	print("GOZCU KAFILE OZETI: GEÇTİ" if hata==0 else "GOZCU KAFILE OZETI: KALDI")
	quit(hata)
