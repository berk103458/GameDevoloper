## ZAR-05: Tekrar edilebilir ve tek şanslık kontroller birim testi.
extends SceneTree

const SORGU_ZARI = preload("res://src/kapi/sorgu_zari.gd")
const SOZ_SEMASI = preload("res://src/soz/soz_semasi.gd")
var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _initialize() -> void:
	var kurallar: Resource = load("res://data/chr_runtime/sorgu_kurallari.tres")
	dene(kurallar != null, "sorgu_kurallari.tres yüklendi")

	# 1. Kural 5: Tür boşsa doğrulayıcı hata verir, sessizce tekrar sayılmaz
	var bos_hata := SORGU_ZARI.kontrol_dogrula("", "konu_is", {})
	dene(bos_hata.size() == 1 and bos_hata[0] == "zar_kontrol_turu_bos", "Boş tür doğrulama hatası verir")

	# 2. Kural 3 & Uç durumlar: Sır/ikilem dışında yazılan tek_sans 1 hata verir
	var sir_disi_hata := SORGU_ZARI.kontrol_dogrula("tek_sans", "konu_nereden", {"konu": "nereden"})
	dene(sir_disi_hata.size() == 1 and sir_disi_hata[0] == "sir_disinda_tek_sans", "Sır dışında tek_sans 1 hata verir")

	# Şema doğrulayıcısında da sır dışında tek_sans 1 hata verir
	var hatali_sema := {
		"konusmaci": "chr_001",
		"cekirdek": "durust",
		"dugumler": {
			"giris": {
				"id": "giris",
				"satir": "Selam",
				"zar": {"kontrol_turu": "tek_sans", "zar_turu": "d6"},
				"secenekler": []
			}
		}
	}
	var sema_hatalari := SOZ_SEMASI.dogrula(hatali_sema)
	dene(sema_hatalari.has("sir_disinda_tek_sans_giris"), "SozSemasi sır dışında tek_sans için 1 hata verir")

	# Sır/yüzleşme düğümünde tek_sans geçerlidir
	var sir_dogru := SORGU_ZARI.kontrol_dogrula("tek_sans", "yuzlesme", {"dugum_turu": "ikilem"})
	dene(sir_dogru.is_empty(), "Sır/ikilem düğümünde tek_sans geçerlidir")

	# 3. Kabul: Koşul değişmeden ikinci beyaz ("tekrar") atış 0'dır; kanıt eklenince 1 atış daha açılır.
	var hafiza := {}
	var baglam_ilk := {"kanitlar": [], "tansiyon": 2, "guven": 3}

	# Zar 1 gelmesi için tohum seçelim veya yüksek zorluk verelim (deger=4 -> gerekli=5, zar=1..4 başarısız)
	var rng := RandomNumberGenerator.new()
	rng.seed = 100
	# İlk beyaz atış (başarısız olmasını garantilemek için deger=4, d6 -> gerekli 5)
	# Zar 1 geldiği uç durumu da test edelim:
	var tohum_bir := 1
	for s in range(1, 500):
		var test_rng := RandomNumberGenerator.new()
		test_rng.seed = s
		if SORGU_ZARI.at(test_rng, &"d6") == 1:
			tohum_bir = s
			break
	rng.seed = tohum_bir
	var ilk_atis := SORGU_ZARI.kontrol_at(rng, hafiza, "kontrol_beyaz_1", "tekrar", &"d6", 3, 2, 0, kurallar, baglam_ilk, "konu_is")
	dene(bool(ilk_atis.get("atildi", false)) == true, "İlk beyaz kontrol atışı yapıldı")
	dene(int(ilk_atis.get("zar", 0)) == 1 and not bool(ilk_atis.get("basarili", true)), "İlk beyaz atışta zar 1 geldi ve başarısız oldu")
	dene(String(ilk_atis.get("kenar", "")) == "beyaz", "Tekrar kontrolü beyaz kenarlıdır")

	# Koşul aynıyken ikinci beyaz atış 0'dır (düğme kilitlidir)
	dene(not SORGU_ZARI.kontrol_acik_mi(hafiza, "kontrol_beyaz_1", "tekrar", baglam_ilk, "konu_is", {}, kurallar), "Zar 1 gelmişse koşul aynıyken düğme kilitlidir")
	var ikinci_atis := SORGU_ZARI.kontrol_at(rng, hafiza, "kontrol_beyaz_1", "tekrar", &"d6", 3, 2, 0, kurallar, baglam_ilk, "konu_is")
	dene(bool(ikinci_atis.get("atildi", true)) == false, "Koşul değişmeden ikinci beyaz atış 0'dır")

	# Ek şart: Menü açılıp kapanınca veya odak değişince tekrar hakkı aynı kalır (düşmez ve yeniden açılmaz)
	SORGU_ZARI.menu_veya_odak_degisti(hafiza)
	dene(not SORGU_ZARI.kontrol_acik_mi(hafiza, "kontrol_beyaz_1", "tekrar", baglam_ilk, "konu_is", {}, kurallar), "Menü açılıp kapanınca kilitli durum değişmez")

	# Kanıt eklenince 1 atış daha açılır
	var baglam_kanitli := {"kanitlar": ["clue_ muhur"], "tansiyon": 2, "guven": 3}
	dene(SORGU_ZARI.kontrol_acik_mi(hafiza, "kontrol_beyaz_1", "tekrar", baglam_kanitli, "konu_is", {}, kurallar), "Kanıt eklenince beyaz kontrol yeniden açılır")

	# Menü açılıp kapanınca açılan tekrar hakkı düşmez
	SORGU_ZARI.menu_veya_odak_degisti(hafiza)
	dene(SORGU_ZARI.kontrol_acik_mi(hafiza, "kontrol_beyaz_1", "tekrar", baglam_kanitli, "konu_is", {}, kurallar), "Menü açılıp kapanınca tekrar hakkı aynı kalır")

	var ucuncu_atis := SORGU_ZARI.kontrol_at(rng, hafiza, "kontrol_beyaz_1", "tekrar", &"d6", 1, 2, -1, kurallar, baglam_kanitli, "konu_is")
	dene(bool(ucuncu_atis.get("atildi", false)) == true, "Kanıt eklendikten sonra 1 atış daha yapıldı")

	# 4. Kural 3 & 4 & Uç durumlar: Kırmızı ("tek_sans") kontrol bir kez atılır, başarı da başarısızlık da dalı kapatır;
	# karakter kaçıp dönerse tek şans sonucu hafızada durur, düğüm açılmaz; kod türü kendiliğinden değiştirmez.
	var kirmizi_atis := SORGU_ZARI.kontrol_at(rng, hafiza, "kontrol_kirmizi_sir", "tek_sans", &"d6", 4, 2, 0, kurallar, baglam_ilk, "yuzlesme_sir")
	dene(bool(kirmizi_atis.get("atildi", false)) == true, "Tek şans kontrolü bir kez atıldı")
	dene(String(kirmizi_atis.get("kenar", "")) == "kirmizi", "Tek şans kırmızı kenarlıdır")
	dene(bool(kirmizi_atis.get("dal_kapandi", false)) == true, "Tek şans dalı kapatır")
	dene(String(kirmizi_atis.get("kontrol_turu", "")) == "tek_sans", "Kod türü kendiliğinden değiştirmez")

	# Koşul veya kanıt değişse bile ya da karakter kaçıp dönse bile tek_sans bir daha açılmaz
	var baglam_donus := {"kanitlar": ["clue_1", "clue_2"], "tansiyon": 6, "guven": 9, "donus_ziyareti": true}
	dene(not SORGU_ZARI.kontrol_acik_mi(hafiza, "kontrol_kirmizi_sir", "tek_sans", baglam_donus, "yuzlesme_sir", {}, kurallar), "Tek şans sonucu hafızada durur, karakter dönse veya kanıt değişse de açılmaz")
	var kirmizi_tekrar := SORGU_ZARI.kontrol_at(rng, hafiza, "kontrol_kirmizi_sir", "tek_sans", &"d6", 1, 2, 0, kurallar, baglam_donus, "yuzlesme_sir")
	dene(bool(kirmizi_tekrar.get("atildi", true)) == false, "Tek şans ikinci kez atılmaz")

	print("ZAR TUR TESTI: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)
