## DYL-06: Dil engeli ve tercuman birim testi.
## Kabul kriterleri:
## - Ortak dil yokken yalniz kirik satirlar gelir; tercuman cagrilinca tam satirlar gelir.
## - Tercuman koylunun is gucu 1.0 iken cagridan sonra 0.5 olur (ikinci cagri 0'a indirmez).
## - Ortak dilde kirik satir 0'dir.
## - Ek sart: tercuman bayragi yokken dugme 0'dir.
extends SceneTree

const DilEngeliSinifi = preload("res://src/soz/dil_engeli.gd")
const MuhafizGecmisiSinifi = preload("res://src/sistemler/muhafiz_gecmisi.gd")

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var oturum := Oturum.new(katalog, 4213)

	_test_ortak_dil_yokken_kirik_ve_tercumanla_tam(oturum)
	_test_tercuman_is_gucu_ve_sabir_bedeli()
	_test_tercuman_bayragi_ve_dugme_gorunurlugu()
	_test_es_tercuman_carpitmaz_ve_grup_carpitmasi()
	_test_koylu_optional_diller_kayit_ve_dogrulayici()

	await process_frame
	print("DIL ENGELI: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _test_ortak_dil_yokken_kirik_ve_tercumanla_tam(oturum: Oturum) -> void:
	var satir := {
		"id": "rum_yolcu_01",
		"tam": "Kayseri'den kumaş taşıyorum, vergimi öderim.",
		"kirik": "Rumca bir şeyler söylüyor. Arada 'Kayseri' diyor.",
		"tercuman": "Kayseri'den geçiyormuş, zararsız bir yolcu.",
		"sezgi": "Tercüman vergi sözünü atladı.",
		"grup": "rum",
	}

	# Medrese talebesi Farsca bilir, Rumca bilmez -> Rumca ile ortak dil yok
	MuhafizGecmisiSinifi.sec(oturum, "medrese_talebesi")
	var m_diller: Array[String] = DilEngeliSinifi.muhafiz_dilleri(oturum)
	var ortak_rumca := DilEngeliSinifi.ortak_dil_var_mi(m_diller, ["rumca"])
	var ortak_farsca := DilEngeliSinifi.ortak_dil_var_mi(m_diller, ["farsca"])
	_kontrol(not ortak_rumca, "Medrese geçmişinde Rumca ortak dil olmamalı")
	_kontrol(ortak_farsca, "Medrese geçmişinde Farsça ortak dil olmalı")

	# 1) Ortak dil yokken yalnız kırık satır gelir
	var kirik_sonuc: Dictionary = DilEngeliSinifi.satir_coz(satir, false, {"aktif": false})
	_kontrol(String(kirik_sonuc.get("secilen_tur", "")) == "kirik" and String(kirik_sonuc.get("metin", "")) == satir["kirik"], "Ortak dil yokken yalnız kırık satır gelmeli")

	# 2) Tercüman çağrılınca tam satır gelir
	var tam_sonuc: Dictionary = DilEngeliSinifi.satir_coz(satir, false, {"aktif": true, "grup": "ahi"})
	_kontrol(String(tam_sonuc.get("secilen_tur", "")) == "tam" and String(tam_sonuc.get("metin", "")) == satir["tam"], "Tercüman çağrılınca tam satır gelmeli")
	_kontrol(int(tam_sonuc.get("kirik_satir_sayisi", -1)) == 0, "Tercüman varken kırık satır sayısı 0 olmalı")

	# 3) Ortak dilde kırık satır 0'dır
	var ortak_sonuc: Dictionary = DilEngeliSinifi.satir_coz(satir, true, {"aktif": false})
	_kontrol(int(ortak_sonuc.get("kirik_satir_sayisi", -1)) == 0 and not bool(ortak_sonuc.get("kirik_mi", true)), "Ortak dilde kırık satır 0 olmalı")


func _test_tercuman_is_gucu_ve_sabir_bedeli() -> void:
	var tercuman := {"id": 1, "ad": "Nikola", "diller": ["rumca"], "is_gucu": 1.0}
	var ilk_cagri: Dictionary = DilEngeliSinifi.tercuman_cagir(tercuman, 5)
	_kontrol(is_equal_approx(float(tercuman["is_gucu"]), 0.5), "Tercüman köylünün iş gücü 1.0 iken çağrıdan sonra 0.5 olmalı")
	_kontrol(int(ilk_cagri.get("kalan_sabir", -1)) == 3, "Tercüman çağırmak sabırdan 2 düşmeli (5 -> 3)")

	# Uç durum: Zaten 0.5 ise ikinci çağrı 0'a indirmez
	var ikinci_cagri: Dictionary = DilEngeliSinifi.tercuman_cagir(tercuman, 3)
	_kontrol(is_equal_approx(float(tercuman["is_gucu"]), 0.5) and is_equal_approx(float(ikinci_cagri.get("is_gucu", 0.0)), 0.5), "İş gücü zaten 0.5 iken ikinci çağrı 0'a indirmemeli")


func _test_tercuman_bayragi_ve_dugme_gorunurlugu() -> void:
	var koylular := [{"id": 1, "diller": ["rumca"]}]
	# Ek şart: tercüman bayrağı yokken düğme 0'dır
	_kontrol(DilEngeliSinifi.tercuman_dugmesi_sayisi(koylular, ["rumca"], false) == 0, "Tercüman bayrağı yokken düğme 0 olmalı")
	# Köyde o dili bilen yoksa düğme 0'dır
	_kontrol(DilEngeliSinifi.tercuman_dugmesi_sayisi(koylular, ["ermeni"], true) == 0, "Köyde dili bilen yoksa tercüman düğmesi 0 olmalı")
	# Köyde dili bilen ve bayrak varken düğme 1'dir
	_kontrol(DilEngeliSinifi.tercuman_dugmesi_sayisi(koylular, ["rumca"], true) == 1, "Köyde tercüman ve bayrak varken düğme 1 olmalı")


func _test_es_tercuman_carpitmaz_ve_grup_carpitmasi() -> void:
	var satir := {
		"id": "rum_vergi_satiri",
		"tam": "Gümrük akçesini yanımda getirmedim.",
		"kirik": "Rumca bir şeyler geveliyor.",
		"tercuman": "Yolda soyulmuş, akçesi kalmamış.",
		"sezgi": "Tercüman hemşehrisini koruyor.",
		"grup": "rum",
	}
	# Eş tercüman çarpıtma varyantı üretmez, akşam sohbeti için anı kaydeder
	var es_sonuc: Dictionary = DilEngeliSinifi.satir_coz(satir, false, {"aktif": true, "es_mi": true, "grup": "rum"}, 10, 5)
	_kontrol(not bool(es_sonuc.get("carpitildi", true)) and String(es_sonuc.get("metin", "")) == satir["tam"], "Eş tercüman çarpıtmamalı")
	_kontrol(not String(es_sonuc.get("es_aksam_anisi", "")).is_empty(), "Eş tercüman akşam sohbeti için duyduğunu kaydetmeli")

	# Aynı gruptan köylü tercüman çarpıtır; tecrübe eşiği üstünde muhafız sezer
	var grup_sonuc: Dictionary = DilEngeliSinifi.satir_coz(satir, false, {"aktif": true, "es_mi": false, "grup": "rum"}, 6, 5)
	_kontrol(bool(grup_sonuc.get("carpitildi", false)) and String(grup_sonuc.get("metin", "")) == satir["tercuman"], "Kendi grubundan tercüman satırı yumuşatabilmeli")
	_kontrol(String(grup_sonuc.get("sezgi", "")) == satir["sezgi"], "Tecrübe eşiği üstünde muhafız çarpıtmayı sezmeli")


func _test_koylu_optional_diller_kayit_ve_dogrulayici() -> void:
	var k := Koylu.new()
	k.id = 7
	k.ad = "Yorgi"
	k.diller = PackedStringArray(["rumca", "turkce"])
	var kayit := k.kaydet()
	var yuklenen := Koylu.kayittan(kayit)
	_kontrol(Array(yuklenen.diller) == ["rumca", "turkce"], "Köylü optional diller alanı kaydedilip yüklenmeli")

	var hatalar: Array[String] = DilEngeliSinifi.dogrula_satirlar(["rumca"], [{"id": "s1", "tam": "Merhaba", "kirik": ""}])
	_kontrol(hatalar.size() == 1, "Eksik kırık varyant doğrulayıcıda 1 hata vermeli")


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
