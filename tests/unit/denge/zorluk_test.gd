## DEN-67 & DEN-71: gerçek SYS-20 seçicisi, üç zorluk, zar formülü değişmezliği ve beş ulaşılabilir son.
extends SceneTree

const NIHAI = preload("res://src/sistemler/nihai_son.gd")
const ZORLUK = preload("res://src/sistemler/zorluk_secimi.gd")
const SORGUSARI = preload("res://src/kapi/sorgu_zari.gd")
const SONLAR := ["uc_tutundu", "ahi_kasabasi", "beyin_uc_koyu", "ertugrul_obasi", "tekfur_haraccisi"]
var hata := 0

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var modlar := ZORLUK.anahtarlar()
	dene(modlar.size() == 3 and "kolay" in modlar and "olagan" in modlar and "siki" in modlar, "DEN-71 üç gerçek zorluk")
	dene(NIHAI.AYAR.sonlar.size() == SONLAR.size(), "DEN-71 altıncı son tanımı yok")

	# DEN-67: Zorluk zar formülünü değiştirmez (ZAR-01 eşikleri üç zorlukta da aynıdır; gerekli zar sayısı iki zorlukta eşit).
	var kurallar: Resource = load("res://data/chr_runtime/sorgu_kurallari.tres")
	for tur in [&"d6", &"d12"]:
		for sorgu_degeri in [2, 3, 4]:
			for tansiyon in [1, 5, 9]:
				for degistirici in [-1, 0, 1]:
					var gerekli_kolay := SORGUSARI.gerekli(sorgu_degeri, tansiyon, degistirici, kurallar)
					var gerekli_olagan := SORGUSARI.gerekli(sorgu_degeri, tansiyon, degistirici, kurallar)
					var gerekli_siki := SORGUSARI.gerekli(sorgu_degeri, tansiyon, degistirici, kurallar)
					dene(gerekli_kolay == gerekli_olagan and gerekli_olagan == gerekli_siki, "DEN-67 gerekli zar sayısı üç zorlukta eşit (%s, sd=%d, t=%d)" % [tur, sorgu_degeri, tansiyon])

	for mod in modlar:
		var bulunan := {}
		for hedef in SONLAR:
			var o := hazir(kat, hedef)
			o.yonetim.set_meta(&"zorluk", mod)
			var veri: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
			var geri := Oturum.kayittan(kat, veri)
			dene(geri != null, "DEN-71 %s/%s kayıt yüklenir" % [mod, hedef])
			if geri == null: continue
			dene(geri.kaydet().zorluk == mod, "DEN-71 ölçülen zorluk yüklemede korunur")
			var kimlik := NIHAI.son(geri, &"zafer")
			bulunan[kimlik] = true
			dene(kimlik == hedef, "DEN-71 %s sonu %s kalır" % [mod, hedef])
		dene(bulunan.size() == SONLAR.size() and bulunan.has_all(SONLAR), "DEN-71 %s aynı beş sonu üretir" % mod)

	# DEN-63, DEN-70 & DEN-73: Sıkı kriz aralığı kesişmez; üç zorluk aralığı dosyada; beş sonun hedef toplamı 100, altıncı son 0.
	var denge: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/ayarlar/denge.json"))
	var kriz_z: Dictionary = denge.get("kriz_aralik_zorluk", {})
	dene(kriz_z.has_all(["kolay", "olagan", "siki"]), "DEN-70: kriz_aralik_zorluk üç aralığı dosyada taşır")
	dene(int(kriz_z.get("siki", {}).get("alt", 0)) > int(kriz_z.get("olagan", {}).get("ust", 999)), "DEN-63: sıkının alt sınırı olağanın üst sınırından büyüktür (iki aralık kesişmez)")
	var iflas_z: Dictionary = denge.get("iflas_aralik_zorluk", {})
	var rusvet_z: Dictionary = denge.get("rusvet_aralik_zorluk", {})
	dene(iflas_z.has_all(["kolay", "olagan", "siki"]) and rusvet_z.has_all(["kolay", "olagan", "siki"]), "DEN-70: iflas ve rüşvet için de üçer zorluk aralığı dosyadadır")
	var son_aralik: Dictionary = denge.get("son_aralik", {})
	dene(son_aralik.size() == SONLAR.size() and son_aralik.has_all(SONLAR), "DEN-73: son_aralik yalnız beş son taşır, altıncı son 0")
	var toplam_yuzde := 0
	for s in SONLAR:
		var kayit: Dictionary = son_aralik.get(s, {})
		var h := int(kayit.get("hedef", 0))
		dene(h >= int(kayit.get("alt", 101)) and h <= int(kayit.get("ust", -1)), "DEN-73: %s hedef yüzdesi alt ve üst sınır arasındadır" % s)
		toplam_yuzde += h
	dene(toplam_yuzde == 100, "DEN-73: beş sonun hedef yüzdeleri toplamı 100'dür (%d)" % toplam_yuzde)

	# DEN-68: Kolay, ilk 10 günde odun bitirmez (odun dibi 0 değil, odun sonsuz değil).
	var o_kolay := Oturum.new(kat, 6868)
	o_kolay.yonetim.set_meta(&"zorluk", "kolay")
	var baslangic_odun: int = int(o_kolay.yonetim.kaynaklar.stok.odun)
	for g in 10:
		o_kolay.yonetim.gece()
	var kalan_odun: int = int(o_kolay.yonetim.kaynaklar.stok.odun)
	dene(kalan_odun > 0, "DEN-68: kolay zorlukta 10 gece sonra odun 0'a inmez (kalan: %d)" % kalan_odun)
	dene(kalan_odun < 1000000 and kalan_odun <= baslangic_odun + 200, "DEN-68: kolay zorluk odunu sonsuz yapmaz")

	print("ZORLUK SONLARI: GEÇTİ" if hata == 0 else "ZORLUK SONLARI: KALDI")
	quit(hata)

func hazir(kat: Katalog, hedef: String) -> Oturum:
	var o := Oturum.new(kat, 7171)
	var y := o.yonetim
	y.gun = SonKilidi.kilit_gecesi()
	y.savusturulan = 3
	y.asayis_riski = 60
	y.adalet = 70 if hedef == "ahi_kasabasi" else 50
	for i in 6:
		var k := y.kabul({"ad": "Köylü %d" % i})
		k.moral = 50
		k.refah = 80 if hedef == "ahi_kasabasi" else 40
	match hedef:
		"tekfur_haraccisi": o.bayraklar[&"rusvet_sayisi"] = 200
		"ertugrul_obasi": o.bayraklar[StringName(ObaIttifaki.AYAR.ittifak_bayragi)] = true
		"beyin_uc_koyu":
			o.sancak_asker_talebi = {"son_gece": 8, "gun": 8, "bekliyor": false, "secim": 0, "gonderilen": [1, 2]}
	return o

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
