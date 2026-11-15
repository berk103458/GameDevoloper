# gdlint: disable=max-line-length
extends SceneTree

var _hatalar: Array[String] = []


func _dogrula(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hatalar.append(mesaj)


func _init() -> void:
	var onceki_dil := TranslationServer.get_locale()
	TranslationServer.set_locale("tr")

	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 9)
	var kaynak := o.yonetim.kabul({"ad": "Kamil", "sinif": &"ciftci"})
	var k_ciftci := o.yonetim.kabul({"ad": "Veli", "sinif": &"ciftci"})
	var k_esnaf := o.yonetim.kabul({"ad": "Hasan", "sinif": &"esnaf"})
	var k_asker := o.yonetim.kabul({"ad": "Durmus", "sinif": &"asker"})
	var k_tanidik := o.yonetim.kabul({"ad": "Aliye", "adli_id": &"chr_002", "sinif": &"ciftci"})

	var ag := SoylentiKoprusu.ag(o)
	ag.soylenti_ekle("olay_rusvet_1", "rusvet", str(kaynak.id), true, {"gece": o.gun})
	ag.gece_ilerlet(o.gun, 10, {str(kaynak.id): [str(k_ciftci.id), str(k_esnaf.id), str(k_asker.id), str(k_tanidik.id)]})

	var c_ciftci := NeDuydun.olay_cumlesi(o, k_ciftci)
	var c_esnaf := NeDuydun.olay_cumlesi(o, k_esnaf)
	var c_asker := NeDuydun.olay_cumlesi(o, k_asker)
	var c_tanidik := NeDuydun.olay_cumlesi(o, k_tanidik)

	_dogrula(not c_ciftci.is_empty() and not c_esnaf.is_empty(), "Çiftçi ve esnaf söylenti cümlesi üretmeli")
	_dogrula(c_ciftci != c_esnaf, "Aynı olay için iki karakterde farklı cümle yapısı olmalı (%s == %s)" % [c_ciftci, c_esnaf])
	_dogrula(c_esnaf != c_asker and c_asker != c_tanidik and c_ciftci != c_tanidik, "Farklı sınıf ve hitaplar farklı cümle kurmalı")

	for cumle in [c_ciftci, c_esnaf, c_asker, c_tanidik]:
		_dogrula(not cumle.contains("{") and not cumle.contains("}"), "Doldurulmamış şablon alanı kaldı: %s" % cumle)
		_dogrula(not cumle.contains(" dedi,") and not cumle.contains("Kamil"), "Kaynak dedi kalıbı veya kaynak adı olmamalı: %s" % cumle)
		_dogrula(not cumle.contains(";"), "USLUP §1 noktalı virgül yasağı ihlali: %s" % cumle)

	# İngilizce çeviri anahtarları da dolmalı.
	TranslationServer.set_locale("en")
	var en_ciftci := NeDuydun.olay_cumlesi(o, k_ciftci)
	var en_esnaf := NeDuydun.olay_cumlesi(o, k_esnaf)
	_dogrula(not en_ciftci.is_empty() and en_ciftci != en_esnaf and not en_ciftci.contains("{"), "EN şablonlar dolmalı ve ayrışmalı")

	TranslationServer.set_locale(onceki_dil)

	if not _hatalar.is_empty():
		for h in _hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: SOY-43 soylenti_duydum_uslup_test")
	quit(0)
