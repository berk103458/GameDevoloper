## DEN-71: gerçek SYS-20 seçicisi, üç zorluk ve beş ulaşılabilir son.
extends SceneTree

const NIHAI = preload("res://src/sistemler/nihai_son.gd")
const ZORLUK = preload("res://src/sistemler/zorluk_secimi.gd")
const SONLAR := ["uc_tutundu", "ahi_kasabasi", "beyin_uc_koyu", "ertugrul_obasi", "tekfur_haraccisi"]
var hata := 0

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var modlar := ZORLUK.anahtarlar()
	dene(modlar.size() == 3 and "kolay" in modlar and "olagan" in modlar and "siki" in modlar, "DEN-71 üç gerçek zorluk")
	dene(NIHAI.AYAR.sonlar.size() == SONLAR.size(), "DEN-71 altıncı son tanımı yok")
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
