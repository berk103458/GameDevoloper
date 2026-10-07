extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 51)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	y.akce = 1000
	for tur in ["gida", "odun", "tas", "kereste", "demir", "alet"]: y.kaynaklar.ekle(tur, 100)
	var karar := o.karar_ver(o._adli_gelen(&"chr_007"), &"kabul")
	var k := y.koylu(karar["koylu_id"])
	k.moral = 80
	var b := _kur(y, "demirhane")
	y.ata(k.id, b.id)
	_kontrol(MeslekGrevi.aktif(k, y) and IsMemnuniyeti.isyanci(k, y), "Gerçek Şemsettin yüksek moralde bile ağır işi reddeder")
	var demir := y.kaynaklar.miktar("demir")
	var kereste := y.kaynaklar.miktar("kereste")
	var rapor := y.gece()
	_kontrol(rapor["uretim"].is_empty() and y.kaynaklar.miktar("demir") == demir and y.kaynaklar.miktar("kereste") == kereste and k.gelisim.is_empty(), "Gerçek grev üretim/girdi/XP yi durdurur")
	_kontrol(k.grev.gece == 1 and rapor["olaylar"].any(func(e: Dictionary) -> bool: return e["anahtar"].contains("greve başladı")), "Grev gerçek gece raporu ve sayacı")
	kat.koy_ayarlari = y.a.duplicate(true)
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	geri.yonetim.a = y.a.duplicate(true)
	geri.yonetim._ambar_kapasitesi()
	y.gece()
	geri.yonetim.gece()
	_kontrol(k.grev == geri.yonetim.koylu(k.id).grev and k.moral == geri.yonetim.koylu(k.id).moral and y._rng.state == geri.yonetim._rng.state, "Grev JSON sonraki gece moral/RNG yi korur")
	var b2 := _kur(y, "tarla")
	var katip2 := y.kabul({"ad": "Katip", "sinif": "esnaf"})
	katip2.zanaat_turu = ZanaatTuru.Tur.KATIP
	var isci := y.kabul({"sinif": "ciftci", "stat": 5})
	var uzak := y.kabul({"sinif": "ciftci", "stat": 5})
	for kisi in [k, katip2, isci, uzak]: kisi.moral = 80
	y.ata(k.id, b2.id)
	y.ata(katip2.id, b2.id)
	y.ata(isci.id, b2.id)
	var rng := y._rng.state
	var olaylar: Array[Dictionary] = []
	MeslekGrevi.gece(y, olaylar)
	_kontrol(k.moral == 75 and katip2.moral == 75 and isci.moral == 78 and uzak.moral == 80, "İki grevci komşuyu yalnız bir kez etkiler; başka işyerine taşmaz")
	var moral := isci.moral
	MeslekGrevi.gece(y, olaylar)
	_kontrol(isci.moral == moral and y._rng.state == rng, "Aynı gece tekrar işlem ve yeni RNG yok")
	var once := o.kaydet()
	KoyluKartiVerisi.secenekler(y, k)
	KoyluDenetcisi.satirlar(o)
	_kontrol(o.kaydet() == once, "Kart/denetçi grev gözlemi salt okunur")
	_kontrol(y.muhafiz_ata(k.id) and not MeslekGrevi.aktif(k, y), "Kâtibin uygun kışla/nöbet görevine geçişi grevi bitirir")
	y.bosalt(katip2.id)
	_kontrol(not MeslekGrevi.aktif(katip2, y), "Boşa alma da grevi bitirir")
	var soylu := y.kabul({"sinif": "esnaf", "bayraklar": ["soylu"]})
	soylu.bayrak_ekle("soylu")
	y.ata(soylu.id, b.id)
	_kontrol(MeslekGrevi.aktif(soylu, y), "Nötr meslekli açık soylu ağır işi reddeder")
	var kayit := Koylu.kayittan({"id": 1})
	_kontrol(kayit.grev.is_empty(), "Eski kayıt grev geçmişi olmadan açılır")
	for bozuk in [null, {}, {"son_gece": 1.5, "gece": 1}, {"son_gece": 1, "gece": -1}]:
		_kontrol(MeslekGrevi.oku(bozuk).is_empty(), "Bozuk grev geçmişi reddedilir")
	print("MESLEK GREVİ: GEÇTİ" if hata == 0 else "MESLEK GREVİ: KALDI")
	quit(hata)
func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h)["olur"]:
				var b := y.bina(y.bina_kur(tur, h)["id"])
				b.insa_kalan = 0
				return b
	return null
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
