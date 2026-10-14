## ZAR-01: Görünür zar — d6 ve d12 birim testi.
extends SceneTree

const SORGUSARI = preload("res://src/kapi/sorgu_zari.gd")
var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _initialize() -> void:
	var kurallar: Resource = load("res://data/chr_runtime/sorgu_kurallari.tres")
	dene(kurallar != null, "sorgu_kurallari.tres yüklendi")

	# Kural 1, 2, 4 & Kabul: Değer 2, sakin ve değiştirici 0 iken gerekli 3'tür; panikte gerekli 5'tir.
	# Değer 2: sakin (tansiyon 2 -> ek 0) -> 2 + 1 + 0 + 0 = 3
	dene(SORGUSARI.gerekli(2, 2, 0, kurallar) == 3, "Değer 2, sakin (2) gerekli 3")
	# gergin (tansiyon 5 -> ek 1) -> 2 + 1 + 1 + 0 = 4
	dene(SORGUSARI.gerekli(2, 5, 0, kurallar) == 4, "Değer 2, gergin (5) gerekli 4")
	# panik (tansiyon 8 -> ek 2) -> 2 + 1 + 2 + 0 = 5
	dene(SORGUSARI.gerekli(2, 8, 0, kurallar) == 5, "Değer 2, panik (8) gerekli 5")

	# d20 reddedilir
	dene(not SORGUSARI.gecerli_tur(&"d20"), "d20 reddedilir")
	dene(SORGUSARI.gecerli_tur(&"d6"), "d6 geçerlidir")
	dene(SORGUSARI.gecerli_tur(&"d12"), "d12 geçerlidir")

	# Uç durumlar: gerekli zarın tavanından büyükse (d6'da 7 ve üstü) kilitli, zar atılmaz
	dene(SORGUSARI.kilitli(7, &"d6"), "d6 gerekli 7 kilitli")
	dene(not SORGUSARI.kilitli(6, &"d6"), "d6 gerekli 6 kilitli değil")
	dene(SORGUSARI.kilitli(13, &"d12"), "d12 gerekli 13 kilitli")
	dene(not SORGUSARI.kilitli(12, &"d12"), "d12 gerekli 12 kilitli değil")

	# d6'da 6 ve d12'de 12 her zaman başarıdır; 1 her zaman başarısızdır. Değiştirici 1'i başarıya çevirmez.
	dene(SORGUSARI.basarili(6, 6, &"d6"), "d6'da 6 her zaman başarıdır")
	dene(SORGUSARI.basarili(6, 10, &"d6"), "d6'da 6 gerekli 10 olsa da tavan olarak başarıdır")
	dene(not SORGUSARI.basarili(1, 1, &"d6"), "d6'da 1 her zaman başarısızdır")
	dene(not SORGUSARI.basarili(1, 0, &"d6"), "d6'da 1 gerekli 0 olsa da başarısızdır")
	dene(SORGUSARI.basarili(12, 12, &"d12"), "d12'de 12 her zaman başarıdır")
	dene(not SORGUSARI.basarili(1, 1, &"d12"), "d12'de 1 her zaman başarısızdır")

	# Başarı ve başarısızlık sözcük anahtarıyla yazılır
	var rng := RandomNumberGenerator.new()
	rng.seed = 12345
	var r_kilit := SORGUSARI.sonuc(rng, &"d6", 10, 0, 0, kurallar)
	dene(not r_kilit["atildi"] and r_kilit["sozcuk"] == SORGUSARI.SOZCUK_KILITLI, "Kilitli zar atılmaz, sozcuk kilitli")

	# Ek şart: aynı tohumla iki atış aynı sayıyı verir
	var rng1 := RandomNumberGenerator.new()
	rng1.seed = 98765
	var atis1 := SORGUSARI.at(rng1, &"d6")
	var rng2 := RandomNumberGenerator.new()
	rng2.seed = 98765
	var atis2 := SORGUSARI.at(rng2, &"d6")
	dene(atis1 == atis2, "Aynı tohum aynı zar sonucunu verir")

	# Kabul: On bin atışta d6 dağılımı teorik orandan en fazla yüzde 2 sapar.
	# d6'da her yüzün teorik olasılığı 1/6 ~= %16.6667. %2 sapma aralığı: [14.66%, 18.66%].
	var frekans := {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0}
	var rng_sim := RandomNumberGenerator.new()
	rng_sim.seed = 42
	for i in 10000:
		var z := SORGUSARI.at(rng_sim, &"d6")
		frekans[z] += 1
	for yuz in range(1, 7):
		var oran := float(frekans[yuz]) / 10000.0
		var fark := absf(oran - (1.0 / 6.0))
		dene(fark <= 0.02, "d6 yüz %d dağılım sapması %f <= 0.02" % [yuz, fark])

	# Teorik olasılık hesabı
	# d6 için: gerekli 3 -> 1 başarısız (kural), 2 başarısız, 3,4,5,6 başarılı -> 4/6 = 0.6667
	var ol := SORGUSARI.olasilik(3, &"d6")
	dene(absf(ol - (4.0 / 6.0)) < 0.001, "Gerekli 3 olasılık 4/6")

	print("SORGU ZARI: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)
