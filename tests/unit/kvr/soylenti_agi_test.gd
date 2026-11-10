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

	_oyun_kosusu(hatalar)

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("PASS: SOY-01..50 Soylenti Agi kapanis testi basariyla gecti.")
	quit(0)


func _gelen(id: String) -> Gelen:
	var g := Gelen.new()
	g.id = StringName(id)
	g.ad_anahtari = "test"
	g.sinif = &"koylu"
	return g


## Aynı yedi adım gerçek oyun zincirinde: kapı kararı → gece sonu → meclis hükmü (Görev 23).
func _oyun_kosusu(hatalar: Array[String]) -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 3112)
	o.yonetim.gun = 5
	o.gun = 5
	o.yonetim.a = o.yonetim.a.duplicate(true)
	o.yonetim.a.ambar_taban_kapasite = 100000
	o.karar_ver(_gelen("rusvetci"), &"rusvet")
	for i in 30:
		o.karar_ver(_gelen("koylu_%d" % i), &"kabul")
	o.yonetim.kaynaklar = Kaynaklar.new(100000, {"gida": 20000, "odun": 2000})
	var a: RefCounted = SoylentiKoprusu.ag(o)
	var asil := "kapi_rusvet_5_rusvetci"
	if not a.ag_kayitlari.has(asil) or not String(a.ag_kayitlari[asil].kaynak).is_valid_int():
		hatalar.append("Oyun 1: Tanıklı rüşvet ağa girmedi ya da kaynak köylü değil")
		return
	var duyan: Array[int] = []
	var bar: Array[int] = []
	var kamuoyu_gecesi := -1
	for gece in 4:
		o.gece_sonu()
		duyan.append((a.ag_kayitlari[asil].duyanlar as Array).size())
		bar.append(int(a.bar_degisimi_toplam))
		if kamuoyu_gecesi < 0 and bool(a.ag_kayitlari[asil].kamuoyu_oldu): kamuoyu_gecesi = gece
	if not (duyan[0] > 1 and duyan[2] > duyan[0]): hatalar.append("Oyun 2: Üç gecede yayılmadı")
	if kamuoyu_gecesi < 0: hatalar.append("Oyun 3: Kamuoyu olmadı")
	if not (bar[bar.size() - 1] == -1 and bar.count(-1) == bar.size() - kamuoyu_gecesi): hatalar.append("Oyun 4: Bar bir kez −1 değil")
	if not SoylentiKoprusu.meclis_sikayeti(o).contains("rüşvet"): hatalar.append("Oyun 5: Meclis şikâyeti rüşveti anmıyor")
	var kopyalar: Array = a.ag_kayitlari.keys().filter(func(id: String) -> bool: return id.begins_with(asil + "~"))
	var bozan := String(a.ag_kayitlari[kopyalar[0]].kaynak) if not kopyalar.is_empty() else ""
	var g_bozan: int = a.guvenilirlik_al(bozan)
	if SoylentiKoprusu.hukme_bagla(o).is_empty(): hatalar.append("Oyun 6: Hüküm verilmedi")
	if not SoylentiKoprusu.kamuoyu_satiri(o).is_empty() or not SoylentiKoprusu.meclis_sikayeti(o).is_empty(): hatalar.append("Oyun 6: Hükümden sonra kamuoyu sönmedi")
	if bozan.is_empty() or a.guvenilirlik_al(bozan) != g_bozan - 1: hatalar.append("Oyun 7: Yanlış kopyanın bozanı −1 olmadı")
