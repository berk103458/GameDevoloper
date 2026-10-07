extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 12)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	for i in 2:
		var k := y.kabul({"ad": "Vergi mükellefi", "stat": 5})
		k.moral = 50
	_kontrol(VergiPolitikasi.bedel(y) == 2, "Varsayılan orta eski haftalık vergi bedelini korur")
	_kontrol(not VergiPolitikasi.sec(y, "uydurma") and y.vergi_orani == "orta", "Bilinmeyen vergi reddedilir")
	_kontrol(VergiPolitikasi.sec(y, "dusuk") and VergiPolitikasi.bedel(y) == 1, "Düşük vergi gerçek bedeli yarıya indirir")
	y.gun = y.a.mevsim_gun - 1
	var olaylar: Array[Dictionary] = []
	var once := y.akce
	y._akce(olaylar)
	_kontrol(y.akce == once + 1 and y.huzur() == 52 and EkonomikRefah.oku(y) == 52, "Gerçek düşük tahsilat kamu kasasını ve Moral etkisini uygular")
	var tekrar := y.kaydet()
	y._akce(olaylar)
	_kontrol(y.kaydet() == tekrar, "Aynı gece tekrar tahsilat yapılmaz")
	VergiPolitikasi.sec(y, "agir")
	y.gun += y.a.mevsim_gun
	once = y.akce
	y._akce(olaylar)
	_kontrol(y.akce == once + 4 and y.huzur() == 47 and EkonomikRefah.oku(y) == 47, "Ağır vergi gerçek kamu geliri ve Moral kaybı")
	y.gun += y.a.mevsim_gun
	y.vergi_muaf = true
	var muaf := y.kaydet()
	y._akce(olaylar)
	_kontrol(y.kaydet() == muaf, "İsyan çıkışı vergi muafiyetini korur; etkiler uygulanmaz")
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	_kontrol(geri.yonetim.vergi_orani == "agir" and geri.yonetim.son_vergi_gece == y.son_vergi_gece, "Seçim/tahsilat koruması JSON'da korunur")
	var eski := y.kaydet()
	eski.erase("vergi_politikasi")
	_kontrol(KoyYonetimi.kayittan(y.a, y.katalog, eski).vergi_orani == "orta", "Eski kayıt orta vergiyle başlar")
	for bozuk in [{"oran": "uydurma", "son_gece": 2.5}, {"oran": 4, "son_gece": -2}, {"oran": "orta", "son_gece": "6"}, ["agir"]]:
		var kayit := y.kaydet()
		kayit.vergi_politikasi = bozuk
		var temiz := KoyYonetimi.kayittan(y.a, y.katalog, kayit)
		_kontrol(temiz.vergi_orani == "orta" and temiz.son_vergi_gece == -1, "Bozuk oran/gün güvenli varsayılanla açılır")
	var bos := Oturum.new(kat, 13).yonetim
	_kontrol(VergiPolitikasi.bedel(bos) == 0, "Nüfussuz köy vergi üretmez")
	var norm := y.kaydet()
	var rng_once := y._rng.state
	VergiPolitikasi.metin(y)
	VergiPolitikasi.bedel(y)
	_kontrol(y.kaydet() == norm and y._rng.state == rng_once, "Pazar gözlemi model/RNG değiştirmez")
	var gece_y := Oturum.new(kat, 14).yonetim
	gece_y.gun = gece_y.a.mevsim_gun - 1
	for i in 2:
		var k := gece_y.kabul({"ad": "Gece vergi mükellefi", "stat": 5})
		k.moral = 80
	VergiPolitikasi.sec(gece_y, "agir")
	var kasa_once := gece_y.akce
	var rapor := gece_y.gece()
	var tahsil_var := false
	for olay in rapor.olaylar:
		if olay.get("anahtar", "") == "koy.olay.vergi" and olay.deger == [4]: tahsil_var = true
	_kontrol(tahsil_var and gece_y.akce == kasa_once + 4 and gece_y.son_vergi_gece == gece_y.a.mevsim_gun - 1, "Gerçek gece döngüsü ağır kamu vergisini bir kez uygular ve raporlar")
	print("VERGİ POLİTİKASI: GEÇTİ" if hata == 0 else "VERGİ POLİTİKASI: KALDI")
	quit(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
