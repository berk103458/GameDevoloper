extends SceneTree
const D = preload("res://src/koy/usta_defterleri.gd")
const ID := "usta_defteri_marangoz"
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	dene(D.dogrula().is_empty(),"Gerçek defter ve ağırlık verisi geçerli")
	var o := Oturum.new(kat,4040)
	var once := o.kaydet()
	dene(D.ganimet(o,"olmayan","1").is_empty() and o.kaydet() == once,"Tablosuz ganimet eşya/zar üretmez")
	var asil := D.AYAR.duplicate(true)
	for kaynak in D.AYAR.ganimet:
		D.AYAR.ganimet[kaynak] = {"yok":0,ID:1}
	var rng := o._rng.state
	dene(D.ganimet(o,"pusu","1") == ID and o.muhafiz_esyalari.size() == 1 and o._rng.state == rng,"Veri satırı mevcut heybe kaydına defter ekler, ekonomik zar değişmez")
	dene(not YapiKilidi.durum(o.yonetim,"hizarhane").acik,"Çözümlemeden yapı kilidi açılmaz")
	dene(D.ganimet(o,"pusu","1").is_empty() and o.muhafiz_esyalari[0].adet == 1,"Aynı defter ikinci düşüşte yığın1")
	var geri := Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
	dene(geri != null and geri.muhafiz_esyalari == o.muhafiz_esyalari,"Gerçek JSON kayıt defteri korur")
	var cok := o.muhafiz_esyalari.duplicate(true)
	cok.append(cok[0].duplicate(true))
	cok[0].adet = 9
	dene(D.duzenle(cok).size() == 1 and D.duzenle(cok)[0].adet == 1,"Yükleme tek kimlik/yığın1 yapar")
	var kayit := o.kaydet()
	kayit.muhafiz_esyalari = cok
	var tek := Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(kayit)))
	dene(tek != null and tek.muhafiz_esyalari.size() == 1 and tek.muhafiz_esyalari[0].adet == 1,"Gerçek yükleyici yinelenmiş defter kaydını tekleştirir")
	o.muhafiz_esyalari.clear()
	dene(not YapiKilidi.durum(o.yonetim,"hizarhane").acik,"Çözülmeden elden çıkarılan defter bilgi açmaz")
	_pusu(kat)
	_tuccar(kat)
	_gece(kat)
	var yok := Oturum.new(kat,4041)
	D.AYAR.ganimet.tuccar = {"yok":1,ID:0}
	dene(D.ganimet(yok,"tuccar","1").is_empty() and yok.muhafiz_esyalari.is_empty(),"Tüccar her ziyarette defter bırakmak zorunda değil")
	for agirlik in [true,-1,1.5,INF]:
		var bozuk := asil.duplicate(true)
		bozuk.ganimet.pusu[ID] = agirlik
		dene(not D.dogrula(bozuk).is_empty(),"Bozuk ağırlık reddedilir")
	D.AYAR = asil
	print("USTA DEFTERLERİ: GEÇTİ" if hata == 0 else "USTA DEFTERLERİ: KALDI")
	quit(hata)
func _pusu(kat: Katalog) -> void:
	var o := Oturum.new(kat,4042)
	for i in 2:
		var k := o.yonetim.kabul({"ad":"Muhafız","sinif":"asker","stat":5})
		o.yonetim.muhafiz_ata(k.id)
	o.yonetim.husumet.puan = o.yonetim.a.sizma_esigi
	dene(GocYoluGuvenligi.temizle(o).basari and o.muhafiz_esyalari.size() == 1,"Gerçek HAR-05/HAR-14 başarısı defter düşürür")
	var foto := o.kaydet()
	dene(not GocYoluGuvenligi.temizle(o).ok and o.kaydet() == foto,"Aynı görev tekrar ödül üretmez")
func _tuccar(kat: Katalog) -> void:
	var o := Oturum.new(kat,4043)
	o.yonetim.gun = 7
	var gelenler: Array[Gelen] = []
	TuccarKapiGecisi.ekle(o,gelenler)
	dene(gelenler.size() == 1,"Mevcut takvimde gerçek tüccar")
	if gelenler.is_empty(): return
	dene(o.karar_ver(gelenler[0],&"harc").kaldi and o.muhafiz_esyalari.size() == 1,"Mevcut tüccar kabulü defter düşürebilir")
	var foto := o.kaydet()
	dene(o.karar_ver(gelenler[0],&"harc").engellendi and o.kaydet() == foto,"Aynı tüccar yeniden ganimet vermez")
func _gece(kat: Katalog) -> void:
	var o := Oturum.new(kat,4044)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	var k := y.kabul({"ad":"Dış görev muhafızı","sinif":"asker"})
	y.kaynaklar = Kaynaklar.new(10000,{"gida":1000,"su":1000,"odun":1000})
	y.akce = 1000
	var kisla := KoyBinasi.new()
	kisla.id = 77
	kisla.tur = "muhafiz_kislasi"
	y.binalar.append(kisla)
	var ev := KoyBinasi.new()
	ev.id = 78
	ev.tur = "cadir"
	y.binalar.append(ev)
	k.ev = ev.id
	dene(y.ata(k.id,kisla.id),"Mevcut kışlaya gerçek nöbetçi ataması")
	y.gun = 3
	dene(KervanKorumasi.kirala(y,k.id),"Mevcut tüccara gerçek kervan görevi")
	var donus := int(y.kervan_koruma.get(str(k.id),{}).get("donus",y.gun))
	while y.gun < donus and y.son.is_empty(): o.gece_sonu()
	dene(y.gun == donus and o.muhafiz_esyalari.size() == 1,"Gerçek dönüş: gün=%d hedef=%d eşya=%d son=%s sağlık=%d" % [y.gun,donus,o.muhafiz_esyalari.size(),y.son,k.saglik])
	var b := Oturum.new(kat,4045)
	b.yonetim.gun = 14
	b.yonetim.kabul({"ad":"Baskın tanığı"})
	b.yonetim.a = b.yonetim.a.duplicate(true)
	b.yonetim.a.baskin_zar = 1.0
	b.yonetim.husumet.puan = 100
	b.yonetim.kaynaklar.ekle("gida",100)
	b.yonetim.kaynaklar.ekle("su",100)
	var sonuc := b.gece_sonu()
	var baskin := false
	for olay in sonuc.get("olaylar",[]):
		if olay.get("anahtar") == "koy.olay.baskin": baskin = true
	dene(baskin and b.muhafiz_esyalari.size() == 1,"Gerçek gece baskını defter kaynağıdır, baskın ikinci kez uygulanmaz")
