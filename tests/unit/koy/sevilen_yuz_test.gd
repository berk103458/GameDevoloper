# gdlint: disable=max-line-length
extends SceneTree

const SevilenYuz = preload("res://src/koy/sevilen_yuz.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	var sy := SevilenYuz.new()

	# 1. SEV-01: Boş gün kontrolü
	if not sy.bos_gun_mu([]):
		hatalar.append("Ziyaretçi yokken boş gün olarak tespit edilmedi!")
	if sy.bos_gun_mu([{"id": "chr_001"}]):
		hatalar.append("Ziyaretçi varken boş gün olarak kabul edildi!")

	# 2. SEV-02: Tanıdık yüz ateşe gelir
	var koy_kaydi := [
		{"id": "chr_004", "ad": "Yusuf", "durum": "koyde", "son_karar": "kabul"}
	]
	var ates_kisi := sy.ates_ziyaretcisi_sec(koy_kaydi)
	if ates_kisi.get("ad") != "Yusuf" or not ates_kisi.has("ates_sozu"):
		hatalar.append("Tanıdık yüz Yusuf ateşe gelmedi!")

	# 3. SEV-03: Kişisel iz
	sy.kisisel_iz_birak("chr_004", "ahsap_oyuncak")
	if sy.kisisel_izler.get("chr_004") != "ahsap_oyuncak":
		hatalar.append("Kişisel iz köyde kalmadı!")

	# 4. SEV-04: Tek istek
	var istek := sy.istek_uret("chr_004")
	if istek.get("istek") != "bir_cuval_tohum":
		hatalar.append("Tek istek üretilemedi!")

	# 5. SEV-05: Köylü bağları
	sy.bag_kur("chr_004", "chr_005", "dostluk")
	if sy.koylu_baglari.is_empty():
		hatalar.append("Köylüler arası bağ kurulmadı!")

	# 6. SEV-06: İsim ancak sorulunca kartta durur
	var ilk_kart_adi := sy.kart_gorunum_adi("chr_004", "Yusuf", "Çoban")
	if ilk_kart_adi != "Çoban":
		hatalar.append("İsim sorulmadan kartta gerçek ad göründü! (Beklenen: Çoban)")
	sy.isim_sor("chr_004")
	var sonraki_kart_adi := sy.kart_gorunum_adi("chr_004", "Yusuf", "Çoban")
	if sonraki_kart_adi != "Yusuf":
		hatalar.append("İsim sorulduktan sonra kartta gerçek ad görünmedi!")

	# 7. SEV-07: Veda o kişiyi götürür
	var veda := sy.veda_et("chr_004")
	if not veda.get("ayrildi"):
		hatalar.append("Veda edilen kişi ayrılmadı!")
	if not sy.ates_ziyaretcisi_sec(koy_kaydi).is_empty():
		hatalar.append("Ayrılan kişi tekrar ateşe geldi!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	_test_koylu_bagi()
	print("TEST PASS: sevilen_yuz_test.gd")
	quit(0)


func _test_koylu_bagi() -> void:
	const Katalog = preload("res://src/cekirdek/katalog.gd")
	const Oturum = preload("res://src/sistemler/oturum.gd")
	const KoyluBagi = preload("res://src/koy/koylu_bagi.gd")
	const KanDavasi = preload("res://src/koy/kan_davasi.gd")

	var kat := Katalog.new()
	kat.yukle()
	var o_baza := Oturum.new(kat, 91)
	var o := Oturum.new(kat, 91)
	var y_baza := o_baza.yonetim
	var y := o.yonetim
	y_baza.a = y_baza.a.duplicate(true)
	y_baza.a.ambar_taban_kapasite = 10000
	y_baza.kaynaklar.kapasite = 10000
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	y_baza.koylular.clear()
	y.koylular.clear()
	for tur in ["gida", "odun", "tas", "kereste", "su"]:
		y_baza.kaynaklar.ekle(tur, 100)
		y.kaynaklar.ekle(tur, 100)

	var a_baza := y_baza.kabul({"ad": "Ali", "sinif": "ciftci", "stat": 4, "moral": 80, "toplumsal_bag": {"grup": "oba_a", "dusman_gruplar": []}})
	var b_baza := y_baza.kabul({"ad": "Bora", "sinif": "ciftci", "stat": 4, "moral": 80, "toplumsal_bag": {"grup": "oba_b", "dusman_gruplar": []}})
	var a := y.kabul({"ad": "Ali", "sinif": "ciftci", "stat": 4, "moral": 80, "toplumsal_bag": {"grup": "oba_a", "dusman_gruplar": []}})
	var b := y.kabul({"ad": "Bora", "sinif": "ciftci", "stat": 4, "moral": 80, "toplumsal_bag": {"grup": "oba_b", "dusman_gruplar": []}})
	var c := y.kabul({"ad": "Can", "sinif": "ciftci", "stat": 4, "moral": 80, "toplumsal_bag": {"grup": "oba_c", "dusman_gruplar": []}})

	var tarla_baza := _test_tarla_kur(y_baza)
	var tarla := _test_tarla_kur(y)
	assert(tarla_baza != null and tarla != null, "Tarla kurulabilmeli")
	assert(y_baza.ata(a_baza.id, tarla_baza.id) and y_baza.ata(b_baza.id, tarla_baza.id), "Baz tarla ataması")
	assert(y.ata(a.id, tarla.id) and y.ata(b.id, tarla.id), "Dost tarla ataması")

	# Kayıtta baglar yoksa bağsız açılır ve yasak alanlar (kalp/romans/hediye) tutulmaz.
	var ham_kayit := o.kaydet()
	ham_kayit.erase("baglar")
	ham_kayit["koy_yonetimi"].erase("baglar")
	var yuklenen := Oturum.kayittan(kat, ham_kayit)
	assert(yuklenen != null and yuklenen.yonetim.baglar.is_empty(), "baglar yoksa bağsız açılmalı")
	var yasakli := KoyluBagi.oku([
		{"kisiler": [a.id, b.id], "uc": "dost", "kalp": 5},
		{"kisiler": [a.id, c.id], "uc": "dost", "romans": true},
		{"kisiler": [b.id, c.id], "uc": "dost", "hediye": "gul"},
	])
	assert(yasakli.is_empty(), "kalp/romans/hediye alanlı kayıtlar yazılmamalı")

	var itibar_once := o.grup_itibari.kaydet()
	assert(KoyluBagi.kur(y, a.id, b.id, "dost"), "Dost bağ kurulabilmeli")
	assert(o.grup_itibari.kaydet() == itibar_once, "Bağ grup itibarına yazılmaz")
	assert(not KoyluBagi.kur(y, a.id, c.id, "dost"), "Aynı günde en çok bir çift için bağ kurulur")
	y.gun += 1
	assert(not KoyluBagi.kur(y, a.id, b.id, "dusman"), "Aynı çifte dost ve düşman bağ yazılamaz")

	assert(is_equal_approx(KoyluBagi.verim_farki(y, a, tarla.id), KoyluBagi.dost_verim_farki()), "Dost çift aynı binada fark almalı")
	assert(KoyluBagi.ates_satiri(y, [a, b]) == "anlati.bag.dost", "İki dost köydeyken ateşte dost satırı duyulmalı")

	var kelime := KoyluBagi.kart_kelimesi(y, a)
	assert(not kelime.is_empty() and not (" " in kelime), "Kartta bağ tek kelime olmalı")
	for d in "0123456789":
		assert(not (d in kelime), "Kartta sayı durmaz")

	# Gerçek üretim farkı doğrulaması (_uret çıktısı + kesir artığı)
	var u_baza := {}
	var u_dost := {}
	y_baza._uret(u_baza, [])
	y._uret(u_dost, [])
	var top_baza := float(u_baza.get("gida", 0.0)) + float(y_baza._artik.get("%d:gida" % tarla_baza.id, 0.0))
	var top_dost := float(u_dost.get("gida", 0.0)) + float(y._artik.get("%d:gida" % tarla.id, 0.0))
	assert(top_dost > top_baza, "Dost çift üretimi bazdan büyük olmalı: dost=%f baz=%f" % [top_dost, top_baza])

	# Kaydet / kayittan turu
	kat.koy_ayarlari = y.a.duplicate(true)
	var kayit_bagli := o.kaydet()
	assert(kayit_bagli.get("baglar", []).size() == 1, "Kayıtta baglar alanı bulunmalı")
	var geri := Oturum.kayittan(kat, kayit_bagli)
	assert(geri != null and geri.yonetim.baglar.size() == 1, "baglar kayıttan geri yüklenmeli")

	# Taraflardan biri köyde değilken verim farkı ve ateş cümlesi uygulanmaz
	y.koylular.erase(b)
	assert(is_equal_approx(KoyluBagi.verim_farki(y, a, tarla.id), 0.0), "Biri köyde değilse verim farkı uygulanmaz")
	assert(KoyluBagi.ates_satiri(y, [a]) == "", "Biri köyde değilse ateş cümlesi duyulmaz")

	# Düşman çiftte UZM-07 davranışı değişmez
	var x := y.kabul({"ad": "Zahir", "sinif": "ciftci", "toplumsal_bag": {"grup": "koy_x", "dusman_gruplar": ["koy_z"]}})
	var z := y.kabul({"ad": "Zeynel", "sinif": "ciftci", "toplumsal_bag": {"grup": "koy_z", "dusman_gruplar": []}})
	assert(not KoyluBagi.kur(y, x.id, z.id, "dost"), "Düşman çifte dost bağ kurulamaz")
	assert(y.ata(x.id, tarla.id) and y.ata(z.id, tarla.id), "Düşman çift tarlaya atanır")
	assert(KanDavasi.engel(y, tarla.id), "Düşman çiftte UZM-07 duruşu korunur")


func _test_tarla_kur(y: KoyYonetimi) -> KoyBinasi:
	for tb in y.binalar:
		if tb.tur == "tarla" and tb.hazir():
			return tb
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("tarla", h).get("olur", false):
				var b := y.bina(y.bina_kur("tarla", h)["id"])
				b.insa_kalan = 0
				return b
	return null
