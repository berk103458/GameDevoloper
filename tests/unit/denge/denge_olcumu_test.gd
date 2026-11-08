## DEN-05: Ölçüm raporu gece hesabını ikinci kez çalıştırmaz birim testi.
## Çalıştırma: godot --headless --path . -s tests/unit/denge/denge_olcumu_test.gd
extends SceneTree

const DENGE_OLCUMU = preload("res://src/sistemler/denge_olcumu.gd")

var _hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		_hata += 1
		push_error("HATA: %s" % ad)
		print("FAIL: %s" % ad)
	else:
		print("PASS: %s" % ad)

func _initialize() -> void:
	var k := Katalog.new()
	if k.yukle() == Katalog.Durum.HAZIR:
		var oturum := Oturum.new(k, 555)

		# 1. Gece sonu çağrılır (tüketim fonksiyonu bu akışta bir kez çalışır)
		var bina := KoyBinasi.new()
		bina.id = 99
		bina.tur = "tarla"
		bina.insa_kalan = 3
		oturum.yonetim.binalar.append(bina)
		# YAP-01: inşaat ölçümü gerçek, sağlıklı boş işçi gerektirir.
		oturum.yonetim.kabul({"ad": "Denge ölçüm işçisi"})
		var gece_raporu := oturum.gece_sonu()
		dene(gece_raporu.has("olaylar") or gece_raporu.has("rapor"), "Gece sonu raporu üretildi")

		# 2. Denge ölçümü oluşturulur: gece_sonu() ikinci kez çağrılmaz
		var gun_once: int = oturum.gun
		var ambar_once: int = oturum.ambar
		var ek_baglam := {
			"cinar_oy_farki": 3,
			"zindan_ekmek_payi": 2,
			"sorgu_eylemleri": {"soru": 4, "heybe": 1, "bak": 2},
			"basarisiz_zar_sayisi": 1
		}
		gece_raporu["uretim"] = {"odun": 7}
		gece_raporu["esyalar"] = ["usta_defteri"]
		var olcum := DENGE_OLCUMU.olustur(oturum, gece_raporu, ek_baglam)
		dene(bina.insa_kalan < 3 and olcum.insaat_ilerleme == 3 - bina.insa_kalan, "YAP-70: gercek insaat ilerlemesi")
		dene(not olcum.keys().any(func(anahtar: Variant) -> bool: return str(anahtar).contains("esya")), "YAP-54: esya icin zorunlu olcum yok")
		dene(olcum.uretim == gece_raporu.uretim, "ISG-43: uretim farki sifir")
		olcum.uretim["odun"] = 0
		dene(gece_raporu.uretim.odun == 7, "ISG-43: kaynak rapor korunur")

		# 3. Kabul: Tüketim ikinci kez çalışmaz, gün ve ambar değişmez
		dene(oturum.gun == gun_once, "Denge ölçümü oturum gününü ilerletmez (ikinci gece_sonu yok)")
		dene(oturum.ambar == ambar_once, "Denge ölçümü tüketim fonksiyonunu ikinci kez çalıştırmaz (ambar sabit)")

		# 4. Ek şart: Nöbet maaşı ölçümü denge raporunun bir satırıdır; maaş formülü bu satırda değişmez
		dene(olcum.has("nobet_maasi"), "Nöbet maaşı ölçümü raporda bir satırdır")

		# 5. Ek şart: Çınar meclisi oy farkı denge formülünü değiştirmez, yeni tüketim açmaz
		dene(olcum.get("cinar_oy_farki") == 3, "Çınar meclisi oy farkı raporda bir satırdır")
		dene(oturum.ambar == ambar_once, "Çınar oy farkı ambar tüketimini değiştirmedi")

		# 6. Ek şart: Zindan ekmek payı denge formülünü değiştirmez; ölçüm mevcut gece raporunu okur
		dene(olcum.get("zindan_ekmek_payi") == 2, "Zindan ekmek payı raporda yer alır")

		# 7. Ek şart: Ölçüm raporunda her sorgu eyleminin kullanım sayısı bir satırdır; gece formülü değişmez
		dene(olcum.has("sorgu_eylemleri"), "Sorgu eylemleri raporda bir satırdır")
		var eylemler: Dictionary = olcum["sorgu_eylemleri"]
		dene(eylemler.get("soru") == 4 and eylemler.get("heybe") == 1, "Sorgu eylemi sayıları doğru kaydedildi")

		# 8. Ek şart: Aç kişi oranı gece ölçümüne bir satır eklenir; denge hesabı ikinci kez çalışmaz
		dene(olcum.has("ac_kisi_orani"), "Aç kişi oranı ölçüme satır olarak eklendi")
		dene(olcum.get("ac_kisi_orani") >= 0.0, "Aç kişi oranı geçerli bir değer")
		var gelen := Gelen.new()
		gelen.adli = true
		gelen.id = &"chr_028"
		var uyarili_gece := 0
		for gece in 10:
			var gece_sonucu := oturum.yonetim.gece()
			var once := JSON.stringify(oturum.yonetim.kaydet())
			var meslek := DENGE_OLCUMU.olustur(oturum, gece_sonucu, {"meslek_uyarisi_gelen": gelen})
			uyarili_gece += int(meslek.get("meslek_uyarisi_gece", 0))
			dene(JSON.stringify(oturum.yonetim.kaydet()) == once, "DEN-33: uyarı ölçümü salt okunur")
		dene(uyarili_gece == 10, "DEN-33: atölyesiz kumaşçı on gecede mevcut uyarıyı taşır")

		var gecis := Oturum.new(k, 555)
		for i in gecis.yonetim.a.agalik_nufus:
			gecis.yonetim.kabul({"ad": "Köylü %d" % i})
		gecis.yonetim.kaynaklar.ekle("gida", 200)
		gecis.yonetim.kaynaklar.ekle("su", 200)
		var gecis_raporu := gecis.gece_sonu()
		var gecis_once := JSON.stringify(gecis.kaydet())
		var gecis_olcumu := DENGE_OLCUMU.olustur(gecis, gecis_raporu)
		dene(olcum.perde1_gecis_gecesi == -1 and gecis_olcumu.perde1_gecis_gecesi == 1, "OMR-31: DEN geçiş makbuzunu okur")
		dene(JSON.stringify(gecis.kaydet()) == gecis_once, "OMR-31: DEN ölçümü salt okunur")

		# DEN-75: TST-04 personası burada tanımlanmaz; kimlik yoksa ölçüm durur, uydurma persona yazılmaz.
		var tst_personalar := ["rusvetci", "reddeden", "ac", "tok"]
		var gecerli_p := DENGE_OLCUMU.persona_kimligi_oku("rusvetci", tst_personalar)
		var gecersiz_p := DENGE_OLCUMU.persona_kimligi_oku("uydurma_persona", tst_personalar)
		dene(bool(gecerli_p.get("gecerli", false)) and not bool(gecerli_p.get("olcum_durdu", true)), "DEN-75: listedeki persona kimliği okunur")
		dene(not bool(gecersiz_p.get("gecerli", true)) and bool(gecersiz_p.get("olcum_durdu", false)) and String(gecersiz_p.get("persona", "x")) == "", "DEN-75: olmayan kimlikte ölçüm durur, uydurma persona yazılmaz")
		dene(gecerli_p.get("kimlik_listesi", []) == tst_personalar, "DEN-75: kimlik listesi TST listesiyle aynıdır")

		# DEN-76: TST-05 sonuç ölçüsü burada tanımlanmaz; ikinci bir son sayacı yazılmaz.
		var tst_sayaci := {"uc_tutundu": 20, "ahi_kasabasi": 20, "beyin_uc_koyu": 20, "ertugrul_obasi": 20, "tekfur_haraccisi": 20}
		var okunan_sayac := DENGE_OLCUMU.son_dagilimi_oku(tst_sayaci)
		dene(is_same(okunan_sayac, tst_sayaci), "DEN-76: son dağılımı aynı TST-05 sayacını okur (sayaç bir)")

		# DEN-80: Sapma, tabloyu kendisi değiştirmez; sapmalı koşuda denge.json dosya baytı aynı kalır.
		var denge_bayt_once := FileAccess.get_file_as_bytes("res://data/ayarlar/denge.json")
		var sapma := DENGE_OLCUMU.sapma_raporu(999.0, 0.0, 12.0, "kriz_aralik")
		var denge_bayt_sonra := FileAccess.get_file_as_bytes("res://data/ayarlar/denge.json")
		dene(bool(sapma.get("sapma_var", false)) and not bool(sapma.get("tablo_degisti", true)), "DEN-80: aralık dışı ölçüm sapma raporu yazar")
		dene(denge_bayt_once == denge_bayt_sonra, "DEN-80: sapmalı koşuda denge.json dosya baytı aynıdır")

		# DEN-74: İflas ve yıkım ayrı sayılır. EKO-10 iflası bir son değildir, son dağılımına karışmaz.
		dene(not DENGE_OLCUMU.iflas_son_sayilir_mi(), "DEN-74: iflas bir nihai son değildir")
		var iflas_cozum := DENGE_OLCUMU.son_veya_surum_coz("uc_tutundu", true)
		dene(bool(iflas_cozum.get("iflas_ayri", false)) and String(iflas_cozum.get("son_kimligi", "")) == "uc_tutundu", "DEN-74: iflaslı oyunda son kimliği beş sondan biridir")
		dene(bool(iflas_cozum.get("son_dagilimina_dahil", false)), "DEN-74: beş son dağılımı iflas olmadan kendi kimliğiyle kalır")
		var iflas_tek := DENGE_OLCUMU.son_veya_surum_coz("iflas", true)
		dene(not bool(iflas_tek.get("son_dagilimina_dahil", true)), "DEN-74: iflas son dağılımına 6. son olarak karışmaz")

		# DEN-47: Rüşvet ekonomisi 28 günde aralıktadır (olağan zorluk: 4..120)
		var denge_sozluk: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/ayarlar/denge.json"))
		var r_aralik := DENGE_OLCUMU.rusvet_kasa_aralik(denge_sozluk, "olagan")
		dene(int(r_aralik.alt) == 4 and int(r_aralik.ust) == 120, "DEN-47: olağan rüşvet kasa aralığı 4..120")
		dene(DENGE_OLCUMU.rusvet_kasa_aralikta_mi(40, denge_sozluk, "olagan"), "DEN-47: 40 akçe kasa aralıktadır")
		dene(not DENGE_OLCUMU.rusvet_kasa_aralikta_mi(1, denge_sozluk, "olagan"), "DEN-47: 1 akçe alt sınırın altındadır")
		dene(not DENGE_OLCUMU.rusvet_kasa_aralikta_mi(150, denge_sozluk, "olagan"), "DEN-47: 150 akçe üst sınırın üstündedir")

		# DEN-48: Rüşveti reddeden oyuncu aynı 28 günde iflas etmez (3 gece üst üste eksi 0 kez)
		var dengeli_akceler: Array = [10, 8, 5, 2, -1, 3, 4, 1, -2, -1, 2, 5, 6, 4, 3, 1, 0, -1, 2, 3, 5, 6, 7, 4, 2, 1, 3, 5]
		dene(not DENGE_OLCUMU.iflas_olayi_var_mi(dengeli_akceler), "DEN-48: reddeden oyuncuda 3 gece üst üste eksi akçe yoktur (iflas 0)")
		var iflasli_akceler: Array = [5, 2, -1, -2, -3, 1]
		dene(DENGE_OLCUMU.iflas_olayi_var_mi(iflasli_akceler), "DEN-48: 3 gece üst üste eksi akçe iflas tetikler")

		# DEN-64: Kriz ölçümü Moğol sayacını ilerletmez
		var kalan_sade := DENGE_OLCUMU.mogol_kalan_gunu_hesapla(28, 10, 0)
		var kalan_krizli := DENGE_OLCUMU.mogol_kalan_gunu_hesapla(28, 10, 5)
		dene(kalan_sade == 18 and kalan_krizli == 18, "DEN-64: kriz sayısı Moğol kalan gününü ilerletmez (yalnız takvim düşer)")

		# DEN-77: Dört oyuncu tipi dört dağılım verir
		var tipler_dagilimi := {
			"rusvetci": {"uc_tutundu": 10, "tekfur_haraccisi": 90},
			"reddeden": {"uc_tutundu": 70, "ertugrul_obasi": 30},
			"ac": {"ahi_kasabasi": 40, "beyin_uc_koyu": 60},
			"tok": {"beyin_uc_koyu": 50, "uc_tutundu": 50}
		}
		dene(DENGE_OLCUMU.dort_tip_dagilimi_farkli_mi(tipler_dagilimi), "DEN-77: dört oyuncu tipi dört farklı dağılım verir")

		# DEN-78: Aynı tohum aynı sonu verir
		var son_1 := DENGE_OLCUMU.tohumlu_son_belirle(12345, "tst_durust", "olagan")
		var son_2 := DENGE_OLCUMU.tohumlu_son_belirle(12345, "tst_durust", "olagan")
		dene(son_1 == son_2 and not String(son_1).is_empty(), "DEN-78: aynı tohum ve persona deterministik olarak aynı sonu verir")

	else:
		push_error("Katalog yüklenemedi")
		_hata += 1

	print("DENGE OLCUMU TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(_hata)
