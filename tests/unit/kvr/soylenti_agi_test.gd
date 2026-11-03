# gdlint: disable=max-line-length
extends SceneTree

const SoylentiAgi = preload("res://src/sistemler/soylenti_agi.gd")
const Dedikodu = preload("res://src/sistemler/dedikodu.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	var dedikodu_motoru := Dedikodu.new()
	var ag := SoylentiAgi.new(dedikodu_motoru)

	# ----------------------------------------------------
	# SOY-50: Kapanış testi — Yedi adım tek koşuda
	# ----------------------------------------------------

	# Adım 1: Tanıklı rüşvet kaydı
	var sonuc1 := ag.soylenti_ekle("rusvet_01", "rusvet", "tanik_hasan", true, {"gece": 1})
	if not sonuc1.get("olur"):
		hatalar.append("Adım 1: Tanıklı rüşvet söylenti ağına eklenemedi!")

	var ilk_baglam := ag.baglam_sorgusu_al("tanik_hasan", "rusvet_01")
	if not ilk_baglam.get("duydu"):
		hatalar.append("Adım 1: Tanık söylentiyi duymuş görünmüyor!")

	# Adım 2: 3 gece yayılım (10 kişilik köy)
	ag.gece_ilerlet(2, 10)
	ag.gece_ilerlet(3, 10)
	ag.gece_ilerlet(4, 10)

	var yayilmis_kayit: Dictionary = ag.ag_kayitlari.get("rusvet_01", {})
	var duyan_sayisi: int = (yayilmis_kayit.get("duyanlar", []) as Array).size()
	if duyan_sayisi < 4: # %40 eşiği = 4 kişi
		hatalar.append("Adım 2: 3 gece sonra söylenti yeterince yayılmadı! (Duyan: %d, Beklenen: >= 4)" % duyan_sayisi)

	# Adım 3: Kamuoyu konusu olması
	if not bool(yayilmis_kayit.get("kamuoyu_oldu", false)):
		hatalar.append("Adım 3: Eşik aşılmasına rağmen kamuoyu konusu olmadı!")

	var hud_satiri := ag.kamuoyu_hud_satiri_al()
	if not hud_satiri.contains("rusvet"):
		hatalar.append("Adım 3: HUD şeridinde kamuoyu satırı görünmedi!")

	# Adım 4: Bar -1 bir kez uygulanması
	if ag.bar_degisimi_toplam != -1:
		hatalar.append("Adım 4: Kamuoyu oluşunca bar -1 uygulanmadı! (Mevcut: %d)" % ag.bar_degisimi_toplam)

	# Bir gece daha ilerletelim; bar ikinci kez düşmemeli (tek seferlik kuralı)
	ag.gece_ilerlet(5, 10)
	if ag.bar_degisimi_toplam != -1:
		hatalar.append("Adım 4: Bar -1 ikinci kez uygulandı, tek seferlik kuralı ihlal edildi!")

	# Adım 5: Meclis şikayeti seçimi
	var meclis_sikayeti := ag.meclis_sikayeti_sec()
	if meclis_sikayeti.get("olay_id") != "rusvet_01":
		hatalar.append("Adım 5: Çınar meclisi kamuoyu konusunu şikayet olarak seçmedi!")

	# Adım 6: Divan hükmü verilmesi ve kamuoyunun sıfırlanması
	ag.divan_hukmu_ver("rusvet_01")
	var sonraki_sikayet := ag.meclis_sikayeti_sec()
	if not sonraki_sikayet.is_empty():
		hatalar.append("Adım 6: Divan hükmünden sonra kamuoyu şikayeti kapanmadı!")

	# Adım 7: Yanlış söylenti kopyası ve kaynak güvenilirliğinin -1 düşmesi
	ag.soylenti_ekle("uydurma_01", "siddet", "yalanci_ali", false, {"gece": 1})
	var baslangic_guven := ag.guvenilirlik_al("yalanci_ali")
	if baslangic_guven != 2:
		hatalar.append("Adım 7: Başlangıç güvenilirliği 2 değil! (%d)" % baslangic_guven)

	ag.yanlis_soylenti_dogrulandi("uydurma_01")
	var son_guven := ag.guvenilirlik_al("yalanci_ali")
	if son_guven != 1:
		hatalar.append("Adım 7: Yanlış söylenti sonrası kaynak güvenilirliği 1'e düşmedi! (%d)" % son_guven)

	var kelime := ag.guvenilirlik_kelimesi("yalanci_ali")
	if kelime != "uyduruyor":
		hatalar.append("Adım 7: 1 güvenilirlik kelimesi 'uyduruyor' dönmedi! (%s)" % kelime)

	# ----------------------------------------------------
	# Ek Kurallar: Küçük köy (SOY-40), Defter (SOY-29), Kayıt (SOY-42)
	# ----------------------------------------------------
	# SOY-40: Nüfus 3 olan köyde ağ susar
	var kucuk_ag := SoylentiAgi.new()
	kucuk_ag.soylenti_ekle("kucuk_01", "siddet", "koylu_1", true, {"gece": 1})
	kucuk_ag.gece_ilerlet(2, 3)
	if kucuk_ag.meclis_sikayeti_sec().size() > 0:
		hatalar.append("SOY-40: Küçük köyde kamuoyu oluştu, susmalıydı!")

	# SOY-29: Defter sayfası
	var defter_sayfasi := ag.soylenti_sayfasi_al(10)
	if defter_sayfasi.is_empty():
		hatalar.append("SOY-29: Defter söylenti sayfası boş döndü!")

	# SOY-42: Kayıt ve yükleme zinciri
	var kayit_verisi := ag.kayit_verisi_al()
	var yeni_ag := SoylentiAgi.new()
	yeni_ag.kayit_verisi_yukle(kayit_verisi)
	if yeni_ag.bar_degisimi_toplam != ag.bar_degisimi_toplam:
		hatalar.append("SOY-42: KAY yüklemesinde bar değişimi eşleşmedi!")
	if yeni_ag.guvenilirlik_al("yalanci_ali") != 1:
		hatalar.append("SOY-42: KAY yüklemesinde güvenilirlik eşleşmedi!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("PASS: SOY-01..50 Soylenti Agi kapanis testi basariyla gecti.")
	quit(0)
