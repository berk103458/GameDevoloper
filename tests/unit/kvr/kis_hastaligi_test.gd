extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 22)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	kat.koy_ayarlari = y.a
	y.kaynaklar.kapasite = 10000
	for t in ["odun", "gida", "tas", "kereste"]: y.kaynaklar.ekle(t, 100)
	var k := y.kabul({"ad":"Hasta", "sinif":"ciftci", "stat":5})
	var risk: int = KisHastaligi.AYAR.risk_yuzde
	KisHastaligi.AYAR.risk_yuzde = 100
	y.gun = 24
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	var olaylar: Array[Dictionary] = []
	KisHastaligi.gece(y, olaylar)
	dene(KisHastaligi.hasta(k) and k.saglik == 95 and KisHastaligi.FLAG in k.bayraklar and not CirakEgitimi.saglam(k), "Sert kış mevcut sağlık/iş gücü")
	dene(Uretim.koylu_carpani(k, "", y.a) < 1.0, "Mevcut olumsuz üretim çarpanı")
	KisHastaligi.gece(geri.yonetim, [])
	dene(geri.kaydet() == o.kaydet(), "Risk/kişi/sağlık restore eşitliği")
	var sabit := JSON.stringify(o.kaydet())
	KisHastaligi.gece(y, olaylar)
	dene(JSON.stringify(o.kaydet()) == sabit and olaylar.size() == 1, "Çift gece risk/hasar yok")
	KisHastaligi.AYAR.risk_yuzde = 0
	var b := kur(y, "sifahane")
	var doktor := y.kabul({"ad":"Cerrah", "sinif":"ciftci", "stat":5})
	doktor.zanaat_turu = ZanaatTuru.Tur.CERRAH
	dene(y.ata(doktor.id, b.id) and Sifahane.tedavi_kapasitesi(y) == 1, "Gerçek çalışan şifahane")
	var yanik := y.kabul({"ad":"Yanık", "sinif":"ciftci", "stat":5})
	yanik.zanaat_kazasi = {"tur":"yanik", "kalan":1, "son_gece":23, "tedavi":true}
	ZanaatKazalari.gece(y, [])
	var gida := y.kaynaklar.miktar("gida")
	KisHastaligi.tedavi(y, [])
	dene(KisHastaligi.hasta(k) and y.kaynaklar.miktar("gida") == gida and Sifahane.tedavi_kapasitesi(y) == 0, "Yanık aynı günlük kontenjanı kullandı; çift hasta ücreti yok")
	geri = Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	dene(Sifahane.tedavi_kapasitesi(geri.yonetim) == 0, "Kontenjan kayıtla korunur")
	y.gun += 1
	k.bayrak_ekle("hasta")
	KisHastaligi.tedavi(y, [])
	dene(not KisHastaligi.hasta(k) and "hasta" in k.bayraklar and KisHastaligi.FLAG not in k.bayraklar and y.kaynaklar.miktar("gida") == gida - 2, "Yeni gün tek tedavi; yalnız kendi bayrağı temizlenir")
	gida = y.kaynaklar.miktar("gida")
	KisHastaligi.tedavi(y, [])
	dene(y.kaynaklar.miktar("gida") == gida, "Tekrar tedavi ücret yaratmaz")
	k.kis_hastaligi = {"bitis":y.gun + 3,"son_gece":y.gun}
	k.bayrak_ekle(KisHastaligi.FLAG)
	geri = Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	var rapor := y.gece()
	dene(geri.yonetim.gece() == rapor, "Gerçek üretim/tedavi/gece restore")
	y.gun = 0
	var rng := y._rng.state
	KisHastaligi.gece(y, [])
	dene(y._rng.state == rng, "Sıcak havada yeni risk zarı yok")
	dene(KisHastaligi.oku({"bitis":3,"son_gece":-1}).is_empty(), "Bozuk optional hastalık ret")
	k.kis_hastaligi = {"bitis":3,"son_gece":0}
	k.bayrak_ekle(KisHastaligi.FLAG)
	y.gun = 3
	KisHastaligi.gece(y, [])
	dene(not KisHastaligi.hasta(k) and "hasta" in k.bayraklar, "Süre dolunca kendi bayrağı temizlenir; yabancı hasta korunur")
	var eski := k.kaydet()
	eski.erase("kis_hastaligi")
	dene(Koylu.kayittan(eski).kis_hastaligi.is_empty(), "Eski köylü kaydı sağlam")
	KisHastaligi.AYAR.risk_yuzde = risk
	print("KIŞ HASTALIĞI: GEÇTİ" if hata == 0 else "KIŞ HASTALIĞI: KALDI")
	quit(hata)
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
