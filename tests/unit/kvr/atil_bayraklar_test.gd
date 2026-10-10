## SYS-18: atıl olay bayrakları gece/diplomasi sonucuna bağlanır; bayraksız oyun değişmez; RNG yok.
extends SceneTree
const ATIL = preload("res://src/sistemler/atil_bayraklar.gd")
var hata := 0
var kat: Katalog

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func hazir() -> Oturum:
	var o := Oturum.new(kat, 1818)
	var y := o.yonetim
	y.kaynaklar = Kaynaklar.new(1000, {"gida": 300, "odun": 100, "su": 100})
	y.akce = 100
	y.adalet = 60
	y.asayis_riski = 30
	var h := y.kabul({"ad": "Hasta"})
	SaglikYoneticisi.enfekte(y, h, "humma")
	h.enfeksiyon.bitis = y.gun + 10
	h.bayrak_ac("hasta")
	h.moral = 50
	return o

func haftaya(o: Oturum) -> void:
	while not Takvim.hafta_basi(o.yonetim.gun, o.yonetim.a.mevsim_gun): o.yonetim.gun += 1

func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	# Haftalık etkiler: aynı köyün bayraklı/bayraksız kopyası.
	var a := hazir()
	var b := hazir()
	haftaya(a)
	haftaya(b)
	for f in [&"baci_tezgah", &"turkmen_kin", &"thessra_kirgin", &"miraen_sadik", &"dervis"]: a.bayraklar[f] = true
	a.bayraklar[&"rusvet_sayisi"] = 7
	var ra := {"olaylar": []}
	var rb := {"olaylar": []}
	var rng := a._rng.state
	ATIL.gece(a, ra)
	ATIL.gece(b, rb)
	var ya := a.yonetim
	var yb := b.yonetim
	dene(rb.olaylar.is_empty() and yb.akce == 100 and yb.adalet == 60 and yb.asayis_riski == 30, "Bayraksız oyun değişmez")
	dene(ya.akce == 100 + int(ATIL.AYAR.baci_tezgah_akce), "baci_tezgah haftalık akçe")
	dene(ya.husumet.puan == yb.husumet.puan + int(ATIL.AYAR.turkmen_husumet), "turkmen_kin husumet")
	dene(ya.adalet == 60 - int(ATIL.AYAR.thessra_adalet), "thessra_kirgin adalet")
	dene(ya.asayis_riski == 30 - int(ATIL.AYAR.miraen_asayis) + 2, "miraen_sadik −1, rüşvet 7/3=+2")
	dene(ya.koylular[0].moral == 50 + int(ATIL.AYAR.dervis_moral), "dervis hastaya moral")
	dene(ra.olaylar.size() == 1 and IflasYoneticisi.olay_metin(ra.olaylar[0]).begins_with("Eski kararların izi"), "Tek rapor satırı")
	dene(a._rng.state == rng, "RNG çekilmez")
	# Aynı gece ikinci çağrı tekrar uygulamaz.
	ATIL.gece(a, ra)
	dene(ya.akce == 100 + int(ATIL.AYAR.baci_tezgah_akce) and ra.olaylar.size() == 1, "Aynı gece tekrar yok")
	# Hafta ortası: yalnız gecelik etkiler.
	var c := hazir()
	haftaya(c)
	c.yonetim.gun += 1
	c.bayraklar[&"baci_tezgah"] = true
	c.bayraklar[&"miraen_sadik"] = true
	var rc := {"olaylar": []}
	ATIL.gece(c, rc)
	dene(c.yonetim.akce == 100 and c.yonetim.asayis_riski == 29, "Hafta ortası: tezgâh yok, devriye var")
	# Rüşvet eşik altı etkisiz.
	var d := hazir()
	haftaya(d)
	d.bayraklar[&"rusvet_sayisi"] = 2
	ATIL.gece(d, {"olaylar": []})
	dene(d.yonetim.asayis_riski == 30, "2 rüşvet etkisiz")
	# Gerçek gece_sonu entegrasyonu + kayıt (bayraklar kayıtta).
	var e := hazir()
	e.bayraklar[&"miraen_sadik"] = true
	var s := e.gece_sonu()
	dene(s.olaylar.filter(func(x: Dictionary) -> bool: return x.has("atil_bayrak")).size() == 1, "Gerçek gecede satır")
	var geri := Oturum.kayittan(kat, e.kaydet())
	dene(geri.bayraklar.has(&"miraen_sadik"), "Bayrak kayıtta kalıcı")
	print("ATIL BAYRAKLAR: GEÇTİ" if hata == 0 else "ATIL BAYRAKLAR: KALDI")
	quit(hata)
