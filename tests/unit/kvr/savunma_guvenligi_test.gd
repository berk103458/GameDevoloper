extends SceneTree
const FORMUL = preload("res://src/koy/savunma_guvenligi.gd")
var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 1915)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.muhafiz_azami = 20
	y.koylular.clear()
	y.asayis_riski = 24
	dene(FORMUL.katkisi(y) == 0 and KervanKorumasi.guvenlik(y) == 76, "Boş kadro eski Güvenlik")
	var k := y.kabul({"sinif": "asker", "stat": 5})
	k.moral = 100
	k.saglik = 100
	dene(y.muhafiz_ata(k.id), "Gerçek kabul ve muhafız ataması")
	dene(FORMUL.katkisi(y) == 0, "İlk perdede nöbetçi bonus vermez")
	y.agalik = true
	dene(FORMUL.katkisi(y) == 1 and KervanKorumasi.guvenlik(y) == 77, "Stat5 devriye yalnız +1; temel nöbet +5 tekrar eklenmez")
	dene(SavunmaKonuslanmasi.ata(y, k.id, "kapi"), "Gerçek kapı rolü")
	dene(FORMUL.katkisi(y) == 3, "Kapı +3; devriye ile toplanmaz")
	y.sur_seviye = 1
	dene(SavunmaKonuslanmasi.ata(y, k.id, "sur"), "Gerçek sur rolü")
	dene(FORMUL.katkisi(y) == 4 and FORMUL.kisiler(y).size() == 1, "Sur +4; tek gerçek kişi")
	y.a.muhafiz_asayis = 8
	dene(FORMUL.katkisi(y) == 1, "Temel nöbet payı mevcut ayardan çıkarılır; sabit5 çiftlenmez")
	y.a.muhafiz_asayis = 5
	dene(KervanKorumasi.guvenlik(y) == 80 and StatEnjektoru.oku(o, "Guvenlik") == 80 and o.gosterge(3) == 8, "Tek kaynak: stat100 ve gösterge10")
	dene(GuvenlikKafileDengesi.sinif_agirliklar(o)[1] == 2.0, "HAR11 yüksek eşik gerçek konuşlanmayla geçilir")
	y.asayis_riski = 64
	var ids: Array[StringName] = [&"chr_001", &"chr_003"]
	dene(o.gosterge(3) == 4 and GuvenlikKafileDengesi.adli_agirliklar(o, ids)[0] == 1.0, "HAR11 düşük eşik 36+4=40")
	SavunmaKonuslanmasi.ata(y, k.id, "")
	dene(o.gosterge(3) == 3 and GuvenlikKafileDengesi.adli_agirliklar(o, ids)[0] == 3.0, "Devriyeye dönüş risk eşiğine geri döner")
	SavunmaKonuslanmasi.ata(y, k.id, "sur")
	y.asayis_riski = 24
	k.saglik = 75
	dene(FORMUL.katkisi(y) == 1, "Kişi başına aşağı yuvarlama: stat5 sur sağlık75 yalnız +1")
	k.stat = 10
	k.saglik = 50
	dene(FORMUL.katkisi(y) == 2, "Sağlık50 dahil; stat10 sur +2")
	k.saglik = 49
	dene(FORMUL.katkisi(y) == 0, "HAR10 sağlık49 dışarıda")
	k.saglik = 100
	dene(FORMUL.katkisi(y) == 9, "Stat10 sur +9")
	k.stat = 999
	k.saglik = 999
	dene(FORMUL.katkisi(y) == 9, "Kayıttan taşan stat/sağlık güvenli üst sınır")
	k.stat = -999
	dene(FORMUL.katkisi(y) == 0, "Negatif stat negatif katkı vermez")
	k.stat = 5
	k.saglik = 100
	for alan in ["bayraklar", "gizli_bayraklar"]:
		for bayrak in ["yarali", "agir_yarali", "hasta", "zindanda"]:
			k.set(alan, PackedStringArray([bayrak]))
			dene(FORMUL.katkisi(y) == 0, alan + ": " + bayrak + " katkısız")
			k.set(alan, PackedStringArray())
	k.is_kazasi = {"tur": "yaralanma", "kalan": 1, "bayrak_eklendi": false}
	dene(FORMUL.katkisi(y) == 0, "Bayrak eksik yaralanma kaydı dışarıda")
	k.is_kazasi = {"tur": "uyuklama", "kalan": 1}
	dene(FORMUL.katkisi(y) == 0, "Uyuklayan dışarıda")
	k.is_kazasi = {}
	k.zanaat_kazasi = {"tur": "yanik", "kalan": 0, "tedavi": true}
	dene(FORMUL.katkisi(y) == 0, "Tedavi bekleyen yanık dışarıda")
	k.zanaat_kazasi = {}
	k.ac = true
	dene(FORMUL.katkisi(y) == 0, "Aç nöbetçi dışarıda")
	k.ac = false
	k.yas_grubu = &"cocuk"
	dene(FORMUL.katkisi(y) == 0, "Çocuk dışarıda")
	k.yas_grubu = &"yetiskin"
	y.maas_durumu[str(k.id)] = {"borc": 1}
	dene(FORMUL.katkisi(y) == 0, "Borçlu dışarıda")
	y.maas_durumu.clear()
	var zanaat := k.zanaat_turu
	k.zanaat_turu = ZanaatTuru.Tur.CIFTCI
	k.moral = 0
	dene(FORMUL.katkisi(y) == 0, "İsyancı dışarıda")
	k.zanaat_turu = zanaat
	k.moral = 100
	y.sur_hasar = 100
	dene(FORMUL.katkisi(y) == 1 and FORMUL.kisiler(y)[k.id] == "devriye", "İşlevsiz sur eski gerçek devriye fallback'ı; sur bonusu yok")
	y.sur_hasar = 0
	var once := JSON.stringify(o.kaydet())
	var guc := y.savunma_gucu()
	for i in 20:
		KervanKorumasi.guvenlik(y)
		FORMUL.metin(y)
		GuvenlikKafileDengesi.adli_agirliklar(o, ids)
	dene(JSON.stringify(o.kaydet()) == once and y.savunma_gucu() == guc, "Tekrarlı okuma tüm kayıt/RNG/kasa/asayiş/savunmayı korur; birikme yok")
	var yuk := Oturum.kayittan(kat, JSON.parse_string(once))
	dene(FORMUL.katkisi(yuk.yonetim) == 4 and yuk.gosterge(3) == o.gosterge(3), "JSON katkıyı mevcut rol/stat/sağlıktan yeniden türetir")
	# Aynı kayıt/RNG'de taktik rolün gece ekonomisine ikinci etkisi yoktur.
	var a := Oturum.kayittan(kat, JSON.parse_string(once))
	var b := Oturum.kayittan(kat, JSON.parse_string(once))
	a.yonetim.akce = 1000
	b.yonetim.akce = 1000
	SavunmaKonuslanmasi.ata(b.yonetim, k.id, "")
	a.yonetim.gece()
	b.yonetim.gece()
	dene(a.yonetim.asayis_riski == b.yonetim.asayis_riski and a.yonetim._rng.state == b.yonetim._rng.state and a.yonetim.akce == b.yonetim.akce, "Sur/devriye gerçek gecede aynı temel asayiş/maaş/RNG; yeni bonus geceye yazılmaz")
	var legacy: Dictionary = JSON.parse_string(once)
	legacy.koy_yonetimi.erase("savunma_konuslanmasi")
	var eski := Oturum.kayittan(kat, legacy)
	dene(FORMUL.katkisi(eski.yonetim) == 1, "Eski ağalık kaydı gerçek devriyeyle açılır; yeni alan/sürüm gerekmez")
	# Gerçek kışla ve kiralama API: bonus kalkar, eski dış görev kaybı bir kez kalır.
	y.akce = 1000
	y.kaynaklar.kapasite = 10000
	for tur in ["odun", "tas", "kereste", "gida", "alet"]: y.kaynaklar.ekle(tur, 100)
	var kisla := kur(y)
	dene(y.ata(k.id, kisla.id), "Aynı kişi gerçek kışlaya atanır")
	y.gun = 3
	dene(KervanKorumasi.kirala(y, k.id), "Gerçek uzman kervanı aynı kişiyi kiralar")
	dene(FORMUL.katkisi(y) == 0 and KervanKorumasi.guvenlik(y) == 71, "Kiralanan +4 sayılmaz; eski -5 bir kez")
	yuk = Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	dene(FORMUL.katkisi(yuk.yonetim) == 0 and KervanKorumasi.guvenlik(yuk.yonetim) == 71, "Kiralanan kayıt dönüşünde de hariç")
	y.gun = 6
	dene(FORMUL.katkisi(y) == 4 and KervanKorumasi.guvenlik(y) == 80, "Dönüşte aynı rol katkısı ve kayıp doğal yenilenir")
	y.bosalt(k.id)
	dene(FORMUL.katkisi(y) == 0, "Pasif defter tek başına savunma vermez")
	y.koylular.erase(k)
	dene(FORMUL.katkisi(y) == 0 and FORMUL.kisiler(y).is_empty(), "Ölen/ayrılan gerçek kişi katkı vermez")
	y.koylular.append(k)
	y.muhafiz_ata(k.id)
	# Üç sur + iki kapı + bir devriye; tüm kadro 20 puan tavanını aşamaz.
	for i in 6:
		var n := y.kabul({"sinif": "asker", "stat": 10})
		n.moral = 100
		n.saglik = 100
		y.muhafiz_ata(n.id)
		SavunmaKonuslanmasi.ata(y, n.id, "sur" if i < 4 else "kapi")
	dene(FORMUL.katkisi(y) == 20 and FORMUL.kisiler(y).size() == 7, "Kalabalık kadro tavan20; kontenjan fazlası yalnız devriye")
	var d := SavunmaKonuslanmasi.durum(y)
	d["999999"] = "sur"
	y.set_meta(SavunmaKonuslanmasi.META, d)
	dene(FORMUL.katkisi(y) == 20 and FORMUL.kisiler(y).size() == 7, "Ghost ID kadro yaratmaz")
	y.asayis_riski = 0
	dene(KervanKorumasi.guvenlik(y) == 100, "Son Güvenlik 100 tavanı")
	y.son = &"yenilgi"
	dene(FORMUL.katkisi(y) == 0, "Terminal katkısız")
	y.son = &""
	y.agalik = false
	y.asayis_riski = 100
	dene(FORMUL.katkisi(y) == 0 and KervanKorumasi.guvenlik(y) == 0, "İlk perde ve alt sınır")
	print("SAVUNMA GUVENLIGI: GEÇTİ" if hata == 0 else "SAVUNMA GUVENLIGI: KALDI")
	quit(hata)

func kur(y: KoyYonetimi) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("muhafiz_kislasi", h).olur:
				var b := y.bina(y.bina_kur("muhafiz_kislasi", h).id)
				b.insa_kalan = 0
				return b
	assert(false)
	return null
