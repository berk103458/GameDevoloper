## DIY-09: Kural tablosu ile baglamsal satir secimi birim testi.
## Kabul kriterleri:
## - Bes kosul tutan (6'da 5 kismi tutan) varyant, uc kosulun ucu de tutani 1000 secimde 0 kez yener.
## - Bes kosulun besi de tam tutan varyant, uc kosul tutani 1000 secimde 1000 kez yener (3 kosullu 0 kez yener).
## - Onceliksiz esitlikte yukleme 1 hata verir; dosya sirasi hakem olmaz.
## - Hicbiri tutmazsa varsayilan gelir; varsayilan yoksa satir susar, motor cokmez.
## - Ek sart: Ac kisinin soz baglamina aclik anahtari yazilir; motor ikinci cumle uretmez.
## - Ek sart: Dunya isareti soz baglamina dunya oneki ve olay kimligi olarak girer; motor yeni cumle uretmez.
extends SceneTree

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var oturum := Oturum.new(katalog, 4213)
	var sorgu := BaglamSorgusu.new()
	var temel_baglam := sorgu.kur(oturum, null)

	_test_kismi_tutma_ve_1000_secim(temel_baglam)
	_test_tam_tutma_5e_karsi_3_1000_secim(temel_baglam)
	_test_oncelik_ve_esitlik_hatasi(temel_baglam)
	_test_varsayilan_ve_susma(temel_baglam)
	_test_tansiyon_mevsim_kriz_hafiza_tek_secici(temel_baglam)
	_test_aclik_anahtari_tek_cumle(temel_baglam)
	_test_dunya_oneki_tek_cumle(temel_baglam)

	await process_frame
	print("SATIR SECICI: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _test_kismi_tutma_ve_1000_secim(temel: Dictionary) -> void:
	var secici := SatirSecici.new()
	var baglam := temel.duplicate(true)
	baglam["gun"] = 5
	baglam["mevsim"] = 1
	baglam["hava"] = "yagmur"
	baglam["nufus"] = 12
	baglam["salgin"] = true
	baglam["tipi"] = false

	# Varyant A: 6 kosulun 5'i tutuyor, 1'i tutmuyor (tipi: true bekliyor ama tipi: false).
	var varyant_6da_5 := {
		"id": "altida_bes_kismi",
		"metin": "Altı koşulun beşi tuttu.",
		"kosullar": {
			"gun": 5,
			"mevsim": 1,
			"hava": "yagmur",
			"nufus": 12,
			"salgin": true,
			"tipi": true,
		},
	}
	# Varyant B: 3 kosulun 3'u de tam tutuyor.
	var varyant_3te_3 := {
		"id": "ucte_uc_tam",
		"metin": "Üç koşulun üçü de tuttu.",
		"kosullar": {
			"gun": 5,
			"mevsim": 1,
			"hava": "yagmur",
		},
	}

	var kismi_kazanma := 0
	for _i in range(1000):
		var secilen := secici.sec([varyant_6da_5, varyant_3te_3], baglam)
		if String(secilen.get("id", "")) == "altida_bes_kismi":
			kismi_kazanma += 1

	_kontrol(kismi_kazanma == 0, "Altı koşulun beşi tutan varyant, üç koşul tutanı 1000 seçimde 0 kez yenmeli (kazanma=%d)" % kismi_kazanma)


func _test_tam_tutma_5e_karsi_3_1000_secim(temel: Dictionary) -> void:
	var secici := SatirSecici.new()
	var baglam := temel.duplicate(true)
	baglam["gun"] = 5
	baglam["mevsim"] = 1
	baglam["hava"] = "yagmur"
	baglam["nufus"] = 12
	baglam["salgin"] = true

	var varyant_5 := {
		"id": "beste_bes",
		"metin": "Beş koşul tam eşleşti.",
		"kosullar": {
			"gun": 5,
			"mevsim": 1,
			"hava": "yagmur",
			"nufus": 12,
			"salgin": true,
		},
	}
	var varyant_3 := {
		"id": "ucte_uc",
		"metin": "Üç koşul tam eşleşti.",
		"kosullar": {
			"gun": 5,
			"mevsim": 1,
			"hava": "yagmur",
		},
	}

	var uc_kosul_kazanma := 0
	var bes_kosul_kazanma := 0
	for _i in range(1000):
		var secilen := secici.sec([varyant_3, varyant_5], baglam)
		var kimlik := String(secilen.get("id", ""))
		if kimlik == "ucte_uc":
			uc_kosul_kazanma += 1
		elif kimlik == "beste_bes":
			bes_kosul_kazanma += 1

	_kontrol(uc_kosul_kazanma == 0, "Üç koşul tutan, beş koşul tam tutanı 1000 seçimde 0 kez yenmeli")
	_kontrol(bes_kosul_kazanma == 1000, "Beş koşul tam tutan 1000 seçimde 1000 kez seçilmeli")


func _test_oncelik_ve_esitlik_hatasi(temel: Dictionary) -> void:
	var secici := SatirSecici.new()
	var baglam := temel.duplicate(true)
	baglam["mevsim"] = 2
	baglam["salgin"] = true

	# 1) Esit sayida kosul tutan iki varyantta oncelik kazanir (dosya sirasindan bagimsiz)
	var dusuk_oncelik := {
		"id": "dusuk",
		"oncelik": 1,
		"kosullar": {"mevsim": 2, "salgin": true},
	}
	var yuksek_oncelik := {
		"id": "yuksek",
		"oncelik": 5,
		"kosullar": {"mevsim": 2, "salgin": true},
	}
	var s1 := secici.sec([dusuk_oncelik, yuksek_oncelik], baglam)
	var s2 := secici.sec([yuksek_oncelik, dusuk_oncelik], baglam)
	_kontrol(String(s1.get("id", "")) == "yuksek", "Eşit koşul sayısında yüksek öncelik kazanmalı (sıra 1)")
	_kontrol(String(s2.get("id", "")) == "yuksek", "Eşit koşul sayısında yüksek öncelik kazanmalı (sıra 2)")

	# 2) Onceliksiz esitlikte yukleme 1 hata verir; dosya sirasi hakem olmaz
	var esit_a := {
		"id": "esit_a",
		"kosullar": {"mevsim": 2, "salgin": true},
	}
	var esit_b := {
		"id": "esit_b",
		"kosullar": {"mevsim": 2, "salgin": true},
	}
	var yukleme := secici.yukle([esit_a, esit_b], baglam)
	_kontrol(int(yukleme.get("hata_sayisi", 0)) == 1, "Önceliksiz eşitlikte yükleme tam 1 hata vermeli (alınan=%d)" % int(yukleme.get("hata_sayisi", 0)))
	var esit_secim := secici.sec([esit_a, esit_b], baglam)
	_kontrol(esit_secim.is_empty() and secici.hatalar().size() == 1, "Önceliksiz eşitlikte dosya sırası hakem olmamalı")


func _test_varsayilan_ve_susma(temel: Dictionary) -> void:
	var secici := SatirSecici.new()
	var baglam := temel.duplicate(true)
	baglam["mevsim"] = 0

	var tutmayan := {
		"id": "kis_satiri",
		"metin": "Kış sert geçti.",
		"kosullar": {"mevsim": 3},
	}
	var varsayilan := {
		"id": "varsayilan_satir",
		"metin": "Hayırlı akşamlar.",
		"kosullar": {},
	}

	# Hicbiri tutmazsa bos kosullu varsayilan gelir
	var secilen := secici.sec([tutmayan, varsayilan], baglam)
	_kontrol(String(secilen.get("id", "")) == "varsayilan_satir", "Hiçbir koşul tutmazsa boş koşullu varsayılan gelmeli")

	# Varsayilan yoksa satir susar, motor cokmez
	var sessiz := secici.sec([tutmayan], baglam)
	_kontrol(sessiz.is_empty(), "Varsayılan yoksa satır susmalı (boş sözlük)")
	_kontrol(secici.sec_metin([tutmayan], baglam) == "", "Varsayılan yoksa metin boş dönmeli")


func _test_tansiyon_mevsim_kriz_hafiza_tek_secici(temel: Dictionary) -> void:
	var secici := SatirSecici.new()
	var baglam := SatirSecici.baglam_hazirla(temel, {
		"tansiyon": "panik",
		"mevsim": 3,
		"krizler": ["kitlik", "salgin"],
		"onceki_ziyaret": 2,
		"son_karar": "ret",
	})

	var varyantlar := [
		{
			"id": "sakin_genel",
			"kosullar": {"tansiyon": "sakin"},
		},
		{
			"id": "panik_kis_salgin_hafiza",
			"kosullar": {
				"tansiyon": "panik",
				"mevsim": 3,
				"kriz": "salgin",
				"onceki_ziyaret": 2,
				"son_karar": "ret",
			},
		},
	]
	var secilen := secici.sec(varyantlar, baglam)
	_kontrol(String(secilen.get("id", "")) == "panik_kis_salgin_hafiza", "Tansiyon, mevsim, kriz ve hafıza tek seçiciyle eşleşmeli")


func _test_aclik_anahtari_tek_cumle(temel: Dictionary) -> void:
	var secici := SatirSecici.new()
	var ac_baglam := SatirSecici.baglama_aclik_yaz(temel, true)
	_kontrol(ac_baglam.has("aclik") and bool(ac_baglam["aclik"]) == true, "Aç kişinin söz bağlamına aclik anahtarı yazılmalı")

	var varyantlar := [
		{
			"id": "normal_selam",
			"metin": "Kapıyı aç muhafız, yoldan geldim.",
			"kosullar": {},
		},
		{
			"id": "ac_selam",
			"metin": "Kursak boş muhafız, iki gündür lokma görmedim.",
			"kosullar": {"aclik": true},
		},
	]
	var metin := secici.sec_metin(varyantlar, ac_baglam)
	_kontrol(metin == "Kursak boş muhafız, iki gündür lokma görmedim.", "Açlık bağlamında aç varyantı seçilmeli")
	_kontrol(metin.find("\n") == -1 and not metin.contains("Kapıyı aç muhafız"), "Motor ikinci cümle üretmemeli, yalnız seçilen varyant dönmeli")


func _test_dunya_oneki_tek_cumle(temel: Dictionary) -> void:
	var secici := SatirSecici.new()
	var isaretli_baglam := SatirSecici.baglama_dunya_isareti_yaz(temel, "mogol_elcisi", "ret")
	_kontrol(isaretli_baglam.has("dunya.mogol_elcisi"), "Dünya işareti söz bağlamına dunya.<id> anahtarıyla girmeli")
	_kontrol(String(isaretli_baglam.get("dunya.mogol_elcisi", "")) == "ret", "Dünya işareti değeri korunmalı")

	# Ayrica BaglamSorgusu icindeki dunya_olaylari.gorulenler listesinden de dunya.<id> otomatik acilmali
	var gorulenli := temel.duplicate(true)
	gorulenli["dunya_olaylari"] = {"tehdit_kapisi": true, "gorulenler": ["keci_kiz_01"]}
	var hazir := SatirSecici.baglam_hazirla(gorulenli)
	_kontrol(bool(hazir.get("dunya.keci_kiz_01", false)) == true, "Görülen dünya olayı dunya.<id> olarak bağlama girmeli")

	var varyantlar := [
		{
			"id": "varsayilan_yolcu",
			"metin": "Yollar sessiz.",
			"kosullar": {},
		},
		{
			"id": "elci_ret_yolcu",
			"metin": "Elçiyi kapıdan çevirmişsiniz, ovada herkes bunu konuşuyor.",
			"kosullar": {"dunya.mogol_elcisi": "ret"},
		},
	]
	var metin := secici.sec_metin(varyantlar, isaretli_baglam)
	_kontrol(metin == "Elçiyi kapıdan çevirmişsiniz, ovada herkes bunu konuşuyor.", "dunya.<id> koşuluyla ilgili satır seçilmeli")
	_kontrol(metin.find("\n") == -1 and not metin.contains("Yollar sessiz."), "Dünya işareti yeni/ikinci cümle üretmemeli")


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
