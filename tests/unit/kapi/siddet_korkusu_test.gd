## CAT-04: Kapida siddet sirayi korkutur birim testi.
## Kabul kriterleri:
## - Esik alti sirada ayrilan 0'dir.
## - Esik ustu ve olasilik 1 olan satirda ayrilan 1'dir (ve dedikoduya yazilir).
## - Yatistirmada (ve ertelemede) ayrilan 0'dir.
## - Ek sart: menu acilip kapaninca tansiyon artisi degismez.
extends SceneTree

const SiddetKorkusuSinifi = preload("res://src/kapi/siddet_korkusu.gd")
const DedikoduSinifi = preload("res://src/sistemler/dedikodu.gd")

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	_test_esik_alti_ve_esik_ustu_olasilik_bir()
	_test_yatistirma_ve_ertelemede_ayrilan_sifir()
	_test_menu_acik_kapaninca_tansiyon_artisi_degismez()
	_test_uc_durumlar_bos_sira_olasilik_sifir_ve_konu_kisi()

	await process_frame
	print("SIDDET KORKUSU: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _test_esik_alti_ve_esik_ustu_olasilik_bir() -> void:
	var sk := SiddetKorkusuSinifi.new()
	var dedikodu := DedikoduSinifi.new()

	# 1) Esik alti (tansiyon_esigi = 6 iken tansiyon = 4) -> ayrilan 0
	var esik_alti_sonuc: Dictionary = sk.degerlendir(
		"askerle_karsilik",
		[{"id": "sira_1", "tansiyon": 4, "sabir": 3}],
		{"gun": 2},
		dedikodu
	)
	_kontrol(int(esik_alti_sonuc.get("ayrilan_sayisi", -1)) == 0, "Eşik altı sırada ayrılan 0 olmalı")

	# 2) Esik ustu (tansiyon = 10, tablo olasiligi = 1.0) -> ayrilan 1 ve dedikodu 1
	var esik_ustu_sonuc: Dictionary = sk.degerlendir(
		"olum",
		[{"id": "sira_2", "tansiyon": 10, "sabir": 1}],
		{"gun": 2},
		dedikodu
	)
	_kontrol(int(esik_ustu_sonuc.get("ayrilan_sayisi", 0)) == 1, "Eşik üstü ve olasılık 1 olan satırda ayrılan 1 olmalı")
	_kontrol(int(esik_ustu_sonuc.get("dedikodu_sayisi", 0)) == 1 and dedikodu.pusula_satirlari(3).size() == 1, "Ayrılan kişi sonraki gün tanık kuralıyla dedikodu taşımalı")


func _test_yatistirma_ve_ertelemede_ayrilan_sifir() -> void:
	var sk := SiddetKorkusuSinifi.new()
	var sira := [{"id": "sira_yuksek", "tansiyon": 10, "sabir": 1}]

	var yatistirma: Dictionary = sk.degerlendir("sozle_yatistirma", sira, {"gun": 3})
	var erteleme: Dictionary = sk.degerlendir("akceyle_erteleme", sira, {"gun": 3})
	_kontrol(int(yatistirma.get("ayrilan_sayisi", -1)) == 0, "Yatıştırmada ayrılan 0 olmalı")
	_kontrol(int(erteleme.get("ayrilan_sayisi", -1)) == 0, "Ertelemede ayrılan 0 olmalı")


func _test_menu_acik_kapaninca_tansiyon_artisi_degismez() -> void:
	var sk := SiddetKorkusuSinifi.new()
	var dogrudan_artis := sk.tansiyon_artisi_hesapla("olum")
	var baslangic_tansiyon := 4

	sk.menu_durumu_ayarla(true)
	var menu_acikken := sk.tansiyon_uygula(baslangic_tansiyon, "olum")
	_kontrol(menu_acikken == baslangic_tansiyon, "Menü açıkken tansiyon artışı donmalı")

	var menu_kapaninca := sk.menu_kapat_ve_donmus_artisi_coz(menu_acikken)
	_kontrol(menu_kapaninca - baslangic_tansiyon == dogrudan_artis, "Menü açılıp kapanınca tansiyon artışı değişmemeli (%d == %d)" % [menu_kapaninca - baslangic_tansiyon, dogrudan_artis])


func _test_uc_durumlar_bos_sira_olasilik_sifir_ve_konu_kisi() -> void:
	var sk := SiddetKorkusuSinifi.new()
	var dedikodu := DedikoduSinifi.new()

	# Sirada kimse yoksa ayrilma 0, dedikodu 0
	var bos_sonuc: Dictionary = sk.degerlendir("askerle_karsilik", [], {"gun": 4}, dedikodu)
	_kontrol(int(bos_sonuc.get("ayrilan_sayisi", -1)) == 0 and int(bos_sonuc.get("dedikodu_sayisi", -1)) == 0, "Sırada kimse yoksa ayrılma ve dedikodu 0 olmalı")

	# Tabloda olasilik 0 ise ayrilan 0
	var sifir_olasilik: Dictionary = sk.degerlendir(
		"askerle_karsilik",
		[{"id": "sira_olasilik_0", "tansiyon": 8, "tablo_olasilik": 0.0}],
		{"gun": 4},
		dedikodu
	)
	_kontrol(int(sifir_olasilik.get("ayrilan_sayisi", -1)) == 0, "Tabloda olasılık 0 ise ayrılan 0 olmalı")

	# O ziyaretin konusu olan kisi ikinci kez kacmaz; heyet sirasinda siddet olmaz
	var konu_sonuc: Dictionary = sk.degerlendir(
		"olum",
		[{"id": "aktif_konu", "tansiyon": 10}],
		{"gun": 4, "ziyaret_konusu_id": "aktif_konu"},
		dedikodu
	)
	_kontrol(int(konu_sonuc.get("ayrilan_sayisi", -1)) == 0, "O ziyaretin konusu olan kişi ikinci kez kaçmamalı")

	var heyet_sonuc: Dictionary = sk.degerlendir(
		"olum",
		[{"id": "sira_heyet", "tansiyon": 10}],
		{"gun": 4, "heyet_aktif": true},
		dedikodu
	)
	_kontrol(int(heyet_sonuc.get("ayrilan_sayisi", -1)) == 0, "Heyet sırasında şiddet ayrılması olmamalı")


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
