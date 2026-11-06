extends SceneTree
const TAKVIM = preload("res://src/sistemler/tehdit_takvimi.gd")
var hata := 0
var kat: Katalog

func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	_denge_alisma()
	_erken_gelis()
	_mogol()
	_resmi_bildiri()
	_gec_agirlik()
	_ayar()
	_sabotaj_baskin()
	_debug_ve_kayit()
	print("TEHDIT TAKVIMI: GEÇTİ" if hata == 0 else "TEHDIT TAKVIMI: KALDI")
	quit(hata)

func riskler() -> Array[StringName]:
	var ids: Array[StringName] = []
	for id in GuvenlikKafileDengesi.AYAR.risk_profilleri: ids.append(StringName(id))
	return ids

func _erken_gelis() -> void:
	var o := Oturum.new(kat, 1818)
	o.gun = 13
	var ids := riskler()
	var once := JSON.stringify(o.kaydet())
	for agirlik in GuvenlikKafileDengesi.adli_agirliklar(o, ids):
		dene(agirlik == 0.0, "13. gün tehdit ağırlığı sıfır")
	dene(JSON.stringify(o.kaydet()) == once, "Ağırlık sorgusu kayıt/RNG yazmaz")
	var rng := o._rng.state
	dene(GuvenlikKafileDengesi.sec(o._rng, [0.0, 0.0]) == -1 and o._rng.state == rng, "Sıfır ağırlıklı havuzdan tehdit seçilmez, zar harcanmaz")
	dene(GuvenlikKafileDengesi.aralik([1.0, 0.0], 1.0) == 0, "Üst zar sınırı sıfır ağırlıklı son adayı seçmez")
	o.ayarlar = o.ayarlar.duplicate(true)
	o.ayarlar.adli_olasiligi = 1.0
	for id in o.kadro.durumlar:
		if id not in ids: o.kadro.durumlar[id].istendi = true
	var tehdit := 0
	for g in o.gece_kuyrugu():
		if g.id in ids: tehdit += 1
	dene(tehdit == 0, "Yalnız riskli adaylar kaldığında gerçek kapı kuyruğu tehdit üretmez")

func _mogol() -> void:
	var o := Oturum.new(kat, 1820)
	o.gun = 13
	o.yonetim.kabul({"ad": "Takvim tanığı"})
	o.yonetim.kaynaklar.ekle("gida", 100)
	o.yonetim.kaynaklar.ekle("su", 100)
	var kalan := int(MogolOncusu.durum(o).kalan)
	o.gece_sonu()
	dene(o.gun == 14 and MogolOncusu.durum(o).kalan == kalan - 1 and MogolOncusu.oku(o.mogol_oncusu).son_gece == 14, "13. gün kapalı tehdit takvimi HAR-02 ilerleyişini durdurmaz")

func _resmi_bildiri() -> void:
	var o := Oturum.new(kat, 1821)
	o.haberci_agi = {"bekleyen": [{"kaynak": "tekfur", "gun": 1, "metin": "Mühürlü bildiri"}]}
	var e := o.olay_sec()
	dene(e != null and HaberciAgi.tanimli(e) and e.metin_anahtari.contains("ulak"), "İlk gün resmi ulak haberi engellenmez")
	o.yonetim.agalik = true
	o.yonetim.harac_bekliyor = true
	var kuyruk: Array[Gelen] = []
	DiplomatikHeyet.ekle(o, kuyruk)
	dene(kuyruk.size() == 1 and DiplomatikHeyet.gecerli(o, kuyruk[0]), "İlk gün mevcut diplomatik heyet engellenmez")

func _gec_agirlik() -> void:
	var o := Oturum.new(kat, 1822)
	o.gun = 15
	o.yonetim.asayis_riski = 40
	for agirlik in GuvenlikKafileDengesi.adli_agirliklar(o, riskler()):
		dene(agirlik == 1.0, "15. gün taban tehdit ağırlığı geri gelir")
	o.ayarlar = o.ayarlar.duplicate(true)
	o.ayarlar.adli_olasiligi = 1.0
	for id in o.kadro.durumlar:
		if id not in riskler(): o.kadro.durumlar[id].istendi = true
	var tehdit := 0
	for g in o.gece_kuyrugu():
		if g.id in riskler(): tehdit += 1
	dene(tehdit > 0, "15. gün gerçek kuyruk tekrar tehdit seçebilir")

func _ayar() -> void:
	dene(not TAKVIM.acik(13) and TAKVIM.acik(14), "Varsayılan sınır tamamlanan gün kaydını okur")
	var eski: int = TAKVIM.AYAR.tehdit_baslangic_gunu
	TAKVIM.AYAR.tehdit_baslangic_gunu = 20
	var o := Oturum.new(kat, 1826)
	o.gun = 15
	dene(not TAKVIM.acik(15) and TAKVIM.acik(20) and GuvenlikKafileDengesi.adli_agirliklar(o, riskler())[0] == 0.0, "Süre JSON ayarından gelir; koda 14 gömülmez")
	TAKVIM.AYAR.tehdit_baslangic_gunu = eski

func _sabotaj_baskin() -> void:
	for id in [&"chr_001", &"chr_002"]:
		var o := Oturum.new(kat, 1823)
		o.karar_ver(o._adli_gelen(id), &"kabul")
		var y := o.yonetim
		y.gun = 13
		var b := KoyBinasi.new()
		b.id = 18
		b.tur = "ambar"
		y.binalar.append(b)
		y.kaynaklar.ekle("gida", 50)
		var once := JSON.stringify(y.kaydet())
		var olaylar: Array[Dictionary] = []
		AmbarKundaklamasi.gece(y, olaylar)
		KuyuZehirleme.gece(y, {"taze": 20}, olaylar)
		CasusGeceTakibi.gece(y)
		dene(olaylar.is_empty() and JSON.stringify(y.kaydet()) == once, "13. gün doğal sabotaj fiili/makbuzu yok")
		y.gun = 15
		if id == &"chr_001":
			AmbarKundaklamasi.gece(y, olaylar)
			dene(AmbarKundaklamasi.durum(y).kisiler[str(y.koylu(1).id)].uygulandi == 15, "15. gün ertelenmiş doğal kundaklama açılır")
		else:
			KuyuZehirleme.gece(y, {"taze": 20}, olaylar)
			dene(y.koylu(1).saglik < 100, "15. gün ertelenmiş doğal zehirleme açılır")
	var o := Oturum.new(kat, 1824)
	var y := o.yonetim
	y.gun = 13
	y.a = y.a.duplicate(true)
	y.a.baskin_zar = 1.0
	y.husumet.puan = 100
	y.kabul({"ad": "Baskın hedefi"})
	var rng := y._rng.state
	var olaylar: Array[Dictionary] = []
	y._husumet(olaylar)
	dene(olaylar.is_empty() and y._rng.state == rng and y.husumet.puan == 100 - y.a.husumet_sonum, "13. gün baskın yok; normal husumet sönümü sürer, tehdit zarı atılmaz")
	HusumetBaskini.uygula(y, olaylar)
	dene(olaylar.is_empty() and y.koylu(1).saglik == 100, "Ortak doğal baskın adaptörü de erken çalışmaz")
	var c := Oturum.new(kat, 1827)
	c.karar_ver(c._adli_gelen(&"chr_004"), &"kabul")
	var k := c.yonetim.koylu(1)
	CasusGeceTakibi.kaydet(c.yonetim, k, "cephanelik", -1, "sabotaj", "alet", 0, true)
	dene(DivanHukmu.uygula(c, k.id, "zindan"), "Gerçek çete reisinin zindan hükmü")
	c.gun = 13
	var once := JSON.stringify(c.yonetim.kaydet())
	dene(KaraboranIntikami.tetikle(c.yonetim, olaylar).is_empty() and JSON.stringify(c.yonetim.kaydet()) == once, "Erken doğal intikam baskını/makbuzu üretilmez")
	c.gun = 15
	dene(KaraboranIntikami.tetikle(c.yonetim, olaylar) == "baskin" and KaraboranIntikami.durum(c.yonetim) == [k.id], "15. gün ertelenmiş intikam tek makbuzla açılır")
	dene(KaraboranIntikami.tetikle(c.yonetim, olaylar).is_empty(), "Erteleme baskını iki kez tetiklemez")

func _debug_ve_kayit() -> void:
	var o := Oturum.new(kat, 1825)
	o.gun = 13
	o.yonetim.kaynaklar.ekle("gida", 30)
	var mogol := o.mogol_oncusu.duplicate(true)
	o._adli_gelen(&"chr_001")
	dene(KrizEnjektoru.tetikle(o, "kundak").ok, "Erken debug deneyi çalışır")
	dene(o.gun == 13 and o.mogol_oncusu == mogol, "Debug tehdit çağrısı doğal takvimi artırmaz")
	var y := o.yonetim
	y.set_meta(TAKVIM.DEBUG_BASKIN, true)
	var kayit := y.kaydet()
	var olaylar: Array[Dictionary] = []
	HusumetBaskini.uygula(y, olaylar)
	dene(not olaylar.is_empty() and o.gun == 13 and not kayit.has(TAKVIM.DEBUG_BASKIN), "Açık debug baskın izni kayda/doğal takvime yazılmaz")
	y.remove_meta(TAKVIM.DEBUG_BASKIN)
	dene(not TAKVIM.baskin_acik(y), "Debug bittiğinde doğal alışma kapısı geri gelir")
	o.gun = 25
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	dene(geri != null and geri.gun == 25, "14 günü geçmiş eski kayıt başa sarılmaz")
	dene(GuvenlikKafileDengesi.adli_agirliklar(geri, riskler())[0] > 0.0, "Eski kayıt açık tehditle devam eder")

func dene(ok: bool, mesaj: String) -> void:
	if not ok:
		hata += 1
		push_error(mesaj)

## DEN-58: DEN gözlemi ve yüksek taban ağırlık alışma kapısını gevşetmez.
func _denge_alisma() -> void:
	var o := Oturum.new(kat, 1858)
	for gun in range(int(TAKVIM.AYAR.tehdit_baslangic_gunu)):
		o.gun = gun
		var once := o.kaydet()
		DengeOlcumu.olustur(o, {})
		for id in riskler():
			dene(TAKVIM.agirlik(o.gun, id, 10000.0) == 0.0, "DEN-58: alışma gününde yüksek risk ağırlığı da sıfır %d/%s" % [gun,id])
		dene(o.kaydet() == once, "DEN-58: ölçüm takvim/kayıt/RNG değiştirmez")
	o.gun = int(TAKVIM.AYAR.tehdit_baslangic_gunu)
	for id in riskler():
		dene(TAKVIM.agirlik(o.gun, id, 2.0) == 2.0, "DEN-58: sınırdan sonra gerçek taban ağırlık korunur")
