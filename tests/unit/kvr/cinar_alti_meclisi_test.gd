extends SceneTree
var hata := 0
var kat: Katalog

func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	_oy_ve_gizlilik()
	_karar_ve_kayit()
	_diger_krizler()
	_donem_ve_sinirlar()
	print("ÇINAR ALTI MECLİSİ: GEÇTİ" if hata == 0 else "ÇINAR ALTI MECLİSİ: KALDI")
	quit(hata)

func hazir() -> KoyYonetimi:
	var a := kat.koy_ayarlari.duplicate(true) as KoyAyarlari
	a.ambar_taban_kapasite = 10000
	var y := KoyYonetimi.new(a, kat.binalar, 307)
	y.kaynaklar = Kaynaklar.new(10000, {"gida": 100, "kirec": 10, "odun": 100, "tas": 100, "kereste": 100})
	y.akce = 100
	y.gun = 3
	for idx in 4:
		var k := y.kabul({"ad": "Özel kimlik %d" % idx})
		k.moral = 60
		k.sadakat = 80
	return y

func _oy_ve_gizlilik() -> void:
	var y := hazir()
	var k := y.koylular[0]
	SaglikYoneticisi.enfekte(y, k)
	dene(not CinarAltiMeclisi.topla(y, "salgin"), "Gizli kuluçka kriz çağrısı açmaz")
	k.bayrak_ac("hasta")
	k.toplumsal_bag = {"grup": "bag", "dusman_gruplar": []}
	y.koylular[1].toplumsal_bag = k.toplumsal_bag.duplicate(true)
	y.koylular[1].ac = true
	var bagli := CinarAltiMeclisi.puan(y, k, "salgin", "as")
	y.koylular[1].toplumsal_bag.grup = "baska"
	dene(bagli > CinarAltiMeclisi.puan(y, k, "salgin", "as"), "Grubun açık açlığı dayanışma oyunu değiştirir")
	var guvenli := CinarAltiMeclisi.puan(y, k, "salgin", "karantina")
	k.sadakat = 0
	dene(CinarAltiMeclisi.puan(y, k, "salgin", "karantina") < guvenli, "Sadakat kriz çözümüne güveni değiştirir")
	var tok := CinarAltiMeclisi.puan(y, k, "salgin", "as")
	k.moral = 0
	dene(CinarAltiMeclisi.puan(y, k, "salgin", "as") > tok, "Düşük moral temel ihtiyaç oyunu artırır")
	var kimlik := k.ad
	k.gizli_egilim.tur = "casus"
	k.gizli_bayraklar.append("fail_sirri")
	var rng := y._rng.state
	var g := geri(y)
	g.koylular.reverse()
	for kisi in g.koylular:
		kisi.ad = "Farklı ad"
		kisi.adli_id = &"chr_030"
		kisi.gizli_egilim.tur = "haydut"
		kisi.gizli_bayraklar.clear()
	dene(CinarAltiMeclisi.topla(y, "salgin") and CinarAltiMeclisi.topla(g, "salgin"), "Açık salgın meclisi")
	var o: Dictionary = CinarAltiMeclisi.durum(y).oylama
	dene(o == CinarAltiMeclisi.durum(g).oylama and y._rng.state == rng, "Kimlik/gizli eğilim/dizi sırası ve RNG oyu etkilemez")
	var metin := CinarAltiMeclisi.ozet(o)
	var kayit := JSON.stringify(CinarAltiMeclisi.durum(y))
	dene(not metin.contains(kimlik) and not kayit.contains("casus") and not kayit.contains("fail_sirri") and not kayit.contains("bag"), "Yalnız anonim toplam oy kayıt/görünümü")
	var once := JSON.stringify(y.kaydet())
	dene(not CinarAltiMeclisi.topla(y, "salgin") and JSON.stringify(y.kaydet()) == once, "Tek oylama tekrarında model değişmez")
	# Temsil: izole yetişkin oy verir; çocuk, ölü, zindan/dış görev vermez.
	y.koylular[0].karantina = {"baslangic": 3, "bitis": 5, "bina": 1}
	y.koylular[1].yas_grubu = &"cocuk"
	y.koylular[2].bayrak_ekle(DivanHukmu.FLAG)
	y.kervan_koruma[str(y.koylular[3].id)] = {"baslangic": 3, "donus": 5}
	dene(CinarAltiMeclisi.secmenler(y).size() == 1, "İzolasyonda temsil; çocuk/zindan/dış görev hariç")
	y.koylular[0].saglik = 0
	dene(CinarAltiMeclisi.secmenler(y).is_empty(), "Ölü seçmen yok")
	var esit := hazir()
	for idx in 4:
		var kisi := esit.koylular[idx]
		SaglikYoneticisi.enfekte(esit, kisi)
		kisi.bayrak_ac("hasta")
		kisi.moral = 0 if idx < 2 else 100
		kisi.sadakat = 0 if idx < 2 else 100
		kisi.ac = idx < 2
	CinarAltiMeclisi.topla(esit, "salgin")
	var esit_oy: Dictionary = CinarAltiMeclisi.durum(esit).oylama
	dene(esit_oy.oylar == [2, 2] and esit_oy.kazanan == 0, "Gerçek eşit oyda ilan edilen ilk seçenek kazanır")

func _karar_ve_kayit() -> void:
	var y := hazir()
	KuyuKirliligi.kirlet(y)
	var rng := y._rng.state
	dene(CinarAltiMeclisi.topla(y, "kuyu"), "Kuyu krizi toplanır")
	var o: Dictionary = CinarAltiMeclisi.durum(y).oylama
	dene(o.secenekler[o.kazanan] == "kirec" and o.oylar == [4, 0], "Sağlıklı/tok köy kireçlemeyi seçer")
	var g := geri(y)
	dene(CinarAltiMeclisi.durum(g) == CinarAltiMeclisi.durum(y), "Pending JSON kaydı toplu oy ve tek karar kilidini taşır")
	y.kaynaklar.azalt("kirec", 10)
	var once := JSON.stringify(y.kaydet())
	dene(not karar(y, o, true) and JSON.stringify(y.kaydet()) == once, "Eksik bedelde atomik ret, ödül ve karar yok")
	y.kaynaklar.ekle("kirec", 2)
	dene(karar(y, o, true) and not KuyuKirliligi.kirli(y) and y.kaynaklar.miktar("kirec") == 0, "Gerçek kuyu API'si ve tam bedel")
	dene(y.koylular[0].moral == 63 and y.koylular[0].sadakat == 84 and y.adalet == 70 and y.huzur() == 63, "Uygulama sadakat/moral/huzur")
	once = JSON.stringify(y.kaydet())
	dene(not karar(y, o, true) and not karar(y, o, false) and JSON.stringify(y.kaydet()) == once, "Çift uygulama/bayat ret tekrar etki üretmez")
	dene(CinarAltiMeclisi.durum(geri(y)).oylama.karar == "uygulandi" and y._rng.state == rng, "Tamamlanan optional makbuz ve sıfır RNG")
	var adalet := g.adalet
	var moral := g.koylular[0].moral
	var stok := g.kaynaklar.stok.duplicate()
	dene(karar(g, o, false), "Halkı muhafız kararıyla ezme")
	dene(g.adalet == adalet - 5 and g.koylular[0].sadakat == 74 and g.koylular[0].moral == moral and g.kaynaklar.stok == stok and KuyuKirliligi.kirli(g), "Ret adalet/sadakat düşürür; seçeneği uygulamaz")
	dene(CinarAltiMeclisi.durum(geri(g)).oylama.karar == "reddedildi", "Ret kaydı restore")
	var legacy := y.kaydet()
	legacy.erase("cinar_alti_meclisi")
	dene(CinarAltiMeclisi.durum(KoyYonetimi.kayittan(y.a, y.katalog, legacy)).oylama.is_empty(), "Legacy hayalet karar üretmez")
	for bozuk in [null, [], "x", {"son_gun": NAN, "izler": {}}, {"son_gun": 10.5, "izler": {}}, {"son_gun": 3, "izler": {}, "oylama": {"tur": "kuyu"}}]:
		dene(CinarAltiMeclisi.oku(bozuk) == CinarAltiMeclisi.oku({}), "Bozuk optional kayıt güvenli")
	for alan in ["oylar", "kazanan", "secenekler", "sira", "katilim"]:
		var d := CinarAltiMeclisi.durum(g)
		d.oylama[alan] = [999, -1] if alan == "oylar" else -1
		dene(CinarAltiMeclisi.oku(d) == CinarAltiMeclisi.oku({}), "Bozuk oylama alanı güvenli: " + alan)
	var gelecek := g.kaydet()
	gelecek.cinar_alti_meclisi.son_gun = 100
	dene(CinarAltiMeclisi.durum(KoyYonetimi.kayittan(g.a, g.katalog, gelecek)).oylama.is_empty(), "Gelecek meclis kaydı yok")

func _diger_krizler() -> void:
	var y := hazir()
	y.kaynaklar.azalt("gida", 10000)
	var olaylar: Array[Dictionary] = []
	KitlikIsyani.gece(y, olaylar)
	y.gun += 1
	KitlikIsyani.gece(y, olaylar)
	for k in y.koylular: k.ac = true
	CinarAltiMeclisi.esitle(y) # Gece adaptörü kıtlık kaynaklı isyanı görür.
	y.kaynaklar.ekle("gida", 100) # Gerçek isyan sürer, kıtlık serisi sıfırlanır.
	dene(CinarAltiMeclisi._krizler(y).has("kitlik"), "Erzak gelse de mevcut kıtlık isyanı sürer")
	dene(CinarAltiMeclisi.topla(y, "kitlik"), "Gerçek iki sıfır gecenin mevcut kıtlık isyanı")
	var o: Dictionary = CinarAltiMeclisi.durum(y).oylama
	dene(o.secenekler[o.kazanan] == "as", "Aç köy ambarı seçer")
	var gida_once := y.kaynaklar.miktar("gida")
	dene(karar(y, o, true) and y.kaynaklar.miktar("gida") == gida_once - y.nufus() * y.a.as_dagit_gida, "Erzak tedariğiyle mevcut as_dagit uygulanabilir")
	# Vergi API'si düşük güvenli kıtlıkta kullanılabilir.
	y = hazir()
	y.kaynaklar.azalt("gida", 10000)
	KitlikIsyani.gece(y, olaylar)
	y.gun += 1
	KitlikIsyani.gece(y, olaylar)
	for k in y.koylular:
		k.sadakat = 0
		k.moral = 80
	dene(CinarAltiMeclisi.topla(y, "kitlik"), "Düşük güvenli kıtlık meclisi")
	o = CinarAltiMeclisi.durum(y).oylama
	dene(o.secenekler[o.kazanan] == "vergi" and karar(y, o, true) and y.vergi_muaf, "Mevcut vergi_sifirla API'si")
	# Gerçek işler Şifahane ve açık hastalar: aynı izolasyon API'si.
	y = hazir()
	var sif := kur(y, "sifahane")
	var hekim := y.kabul({"ad": "Hekim"})
	hekim.zanaat_turu = ZanaatTuru.Tur.CERRAH
	hekim.sadakat = 100
	hekim.moral = 100
	dene(y.ata(hekim.id, sif.id), "İşler hekim ataması")
	for k in y.koylular.slice(0, 3):
		SaglikYoneticisi.enfekte(y, k)
		k.bayrak_ac("hasta")
		k.sadakat = 100
		k.moral = 100
	dene(CinarAltiMeclisi.topla(y, "salgin"), "Salgın meclisi 2 seçenek")
	o = CinarAltiMeclisi.durum(y).oylama
	var gida := y.kaynaklar.miktar("gida")
	dene(o.secenekler[o.kazanan] == "karantina" and karar(y, o, true), "Karantina oyu uygulandı")
	dene(KarantinaYoneticisi.dolu(y, sif.id) == 2 and y.kaynaklar.miktar("gida") == gida - 2 and y.koylular[2].karantina.is_empty(), "Mevcut kontenjan/tam erzak/ID sırası")
	dene(not KarantinaYoneticisi.aktif(hekim) and SaglikYoneticisi.hasta(y.koylular[0]), "Hekim işler kalır; izolasyon hastayı sihirli iyileştirmez")
	# Bekleyen cenaze 3 seçenek; kapanmış kararda yas 2 mevcut seçenek.
	y = hazir()
	var olen := y.kabul({"ad": "Kayıp"})
	var kisiler: Array[Koylu] = y.koylular.duplicate()
	y.koylular.erase(olen)
	CenazeYasi.gece(y, {"olenler": [olen.ad], "olaylar": []}, kisiler)
	y.gun += 1
	dene(CinarAltiMeclisi.topla(y, "yas"), "Yas meclisi")
	o = CinarAltiMeclisi.durum(y).oylama
	var para := y.akce
	gida = y.kaynaklar.miktar("gida")
	dene(o.secenekler.size() == 3 and o.secenekler[o.kazanan] == "toren" and karar(y, o, true), "CenazeYasi.sec ile tören")
	dene(CenazeYasi.durum(y).secim == "toren" and y.akce == para - 2 and y.kaynaklar.miktar("gida") == gida - 2, "Tören tam kamu/erzak bedeli ve yas kaydı")
	dene(CinarAltiMeclisi.secenekler(y, "yas") == ["as", "vergi"], "Verilmiş cenaze kararı yeniden yazılmaz")
	# Karar sonrası yas meclisi gerçekten mevcut aş API'sini uygular.
	var destek := hazir()
	olen = destek.kabul({"ad": "Kayıp"})
	kisiler = destek.koylular.duplicate()
	destek.koylular.erase(olen)
	CenazeYasi.gece(destek, {"olenler": [olen.ad], "olaylar": []}, kisiler)
	destek.gun += 1
	CenazeYasi.sec(destek, int(CenazeYasi.durum(destek).olum_gecesi), "toplu_mezar")
	for k in destek.koylular: k.ac = true
	dene(CinarAltiMeclisi.topla(destek, "yas"), "Normal oyun: cenaze kararı sonrası aktif yas meclisi")
	o = CinarAltiMeclisi.durum(destek).oylama
	dene(o.secenekler == ["as", "vergi"] and karar(destek, o, true) and CenazeYasi.durum(destek).secim == "toplu_mezar", "Yas desteği önceki cenaze kararını korur")

func _donem_ve_sinirlar() -> void:
	var y := hazir()
	KuyuKirliligi.kirlet(y)
	CinarAltiMeclisi.topla(y, "kuyu")
	var o: Dictionary = CinarAltiMeclisi.durum(y).oylama
	karar(y, o, false)
	y.gun += 2
	dene(not CinarAltiMeclisi.topla(y, "kuyu"), "İki gün geçse de aynı kriz tek meclis")
	KuyuKirliligi.temizle(y)
	CinarAltiMeclisi.esitle(y)
	KuyuKirliligi.kirlet(y)
	dene(CinarAltiMeclisi.topla(y, "kuyu") and CinarAltiMeclisi.durum(y).oylama.sira == 2, "Yeni dönemde yeni meclis; eski makbuz kilidi korunur")
	o = CinarAltiMeclisi.durum(y).oylama
	var once := y.koylular[0].sadakat
	y.gun += 2
	dene(not karar(y, o, false) and CinarAltiMeclisi.durum(y).oylama.karar == "suresi_doldu" and y.koylular[0].sadakat == once, "Süre dolunca ret/ödül yok")
	# Farklı kriz aynı gün global beklemeyi aşamaz.
	y = hazir()
	KuyuKirliligi.kirlet(y)
	CinarAltiMeclisi.topla(y, "kuyu")
	karar(y, CinarAltiMeclisi.durum(y).oylama, false)
	SaglikYoneticisi.enfekte(y, y.koylular[0])
	y.koylular[0].bayrak_ac("hasta")
	dene(not CinarAltiMeclisi.topla(y, "salgin"), "İki kriz global bekleme")
	y.gun += 2
	dene(CinarAltiMeclisi.topla(y, "salgin"), "Bekleme bitince diğer kriz")
	# Hasta grubunun değişmesi kesintisiz salgında tekrar oy üretmez.
	karar(y, CinarAltiMeclisi.durum(y).oylama, false)
	SaglikYoneticisi.enfekte(y, y.koylular[1])
	y.koylular[1].bayrak_ac("hasta")
	SaglikYoneticisi.iyilestir(y.koylular[0])
	y.gun += 2
	dene(not CinarAltiMeclisi.topla(y, "salgin"), "Salgın kaynak kişi değişse de tek dönem")
	for k in y.koylular: SaglikYoneticisi.iyilestir(k)
	CinarAltiMeclisi.esitle(y)
	SaglikYoneticisi.enfekte(y, y.koylular[2])
	y.koylular[2].bayrak_ac("hasta")
	dene(CinarAltiMeclisi.topla(y, "salgin"), "Salgın kapandıktan sonra yeni dönem")
	y.son = "isyan"
	dene(not karar(y, CinarAltiMeclisi.durum(y).oylama, false), "Bitmiş oyunda karar yok")
	y = hazir()
	y.koylular.clear()
	KuyuKirliligi.kirlet(y)
	dene(not CinarAltiMeclisi.topla(y, "kuyu"), "Boş köy oy üretmez")

func karar(y: KoyYonetimi, o: Dictionary, uygula: bool) -> bool:
	return CinarAltiMeclisi.karar(y, int(o.gun), o.tur, int(o.sira), uygula)

func geri(y: KoyYonetimi) -> KoyYonetimi:
	return KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))

func kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h).olur:
				var b := y.bina(y.bina_kur(tur, h).id)
				b.insa_kalan = 0
				return b
	return null

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
