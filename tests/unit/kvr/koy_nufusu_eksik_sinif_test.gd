## TEK-01 (TST-0001) regresyonu: KoyNufusu.sayi() olmayan sınıf anahtarında SCRIPT ERROR basıyordu
## (oyun 107: 60 hata, koy_nufusu.gd:28). Beklenen: hata yok, dönüş 0 ve anahtar başına bir kez uyarı.
extends SceneTree

var hata := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var koy := KoyNufusu.new()

	# Kabul 1: eksik anahtarda SCRIPT ERROR yok (bu betik hata basarsa sanity SCRIPT ERROR diye sayar) ve dönüş 0.
	_kontrol(koy.sayi(&"zanaatkar") == 0, "Eksik anahtar zanaatkar: sayi() 0 döner")
	_kontrol(koy.sayi(&"dervis") == 0, "Eksik anahtar dervis: sayi() 0 döner")

	# Kabul 2: aynı eksik anahtar tekrar tekrar uyarı basmaz; uyarı anahtar başına bir kez işaretlenir.
	_kontrol(koy._uyarilan_siniflar.size() == 2, "İki eksik anahtar için iki uyarı işareti var")
	for tekrar in 5:
		koy.sayi(&"zanaatkar")
	_kontrol(koy._uyarilan_siniflar.size() == 2, "Aynı anahtarın tekrar sorgusu yeni uyarı üretmez")

	# Kabul 3: var olan sınıf eski değeri döndürür; toplam() ve kayıt biçimi değişmez.
	koy.ekle(&"ciftci")
	koy.ekle(&"ciftci")
	_kontrol(koy.sayi(&"ciftci") == 2, "Var olan sınıf gerçek sayıyı döndürür")
	_kontrol(koy.toplam() == 2, "toplam() yalnız gerçek nüfusu sayar")
	_kontrol(koy.sayilar.keys().size() == 3, "Kayıt biçimi değişmedi: yalnız üç başlangıç sınıfı")
	_kontrol(not koy.sayilar.has(&"zanaatkar"), "Eksik anahtar sorgusu sözlüğe hayalet anahtar eklemez")
	_kontrol(koy._uyarilan_siniflar.size() == 2, "Var olan sınıf sorgusu ek uyarı üretmez")

	# Sıfır durum: boş nüfusta da mevcut ve olmayan sınıf güvenli; uyarı durumu örnek başına tutulur.
	var bos := KoyNufusu.new()
	_kontrol(bos.sayi(&"asker") == 0, "Boş nüfusta mevcut sınıf 0 döner")
	_kontrol(bos.sayi(&"olmayan_sinif") == 0, "Boş nüfusta olmayan sınıf 0 döner")
	_kontrol(bos._uyarilan_siniflar.size() == 1, "Yeni örnek kendi uyarı durumunu taşır")

	koy = null
	bos = null
	await process_frame
	await process_frame
	await create_timer(0.2).timeout
	print("KOY NUFUSU EKSIK SINIF: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)