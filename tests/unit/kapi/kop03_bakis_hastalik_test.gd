## KOP-03: Hastalık, bakışın bir bölgesidir birim testi.
extends SceneTree

const BAKIS = preload("res://src/soz/bakis.gd")
const TESHIS = preload("res://src/kapi/hastalik_teshis_adaptoru.gd")
var hata := 0

func dene(ok: bool, mesaj: String) -> void:
	if not ok:
		hata += 1
		push_error(mesaj)

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 803)
	var y := o.yonetim
	_sifahane_ve_hekim_hazirla(y)
	y.kaynaklar.ekle("gida", 20)

	# 1. Kural 2 & Kabul: Aynı ziyarette ayrı teşhis düğmesi 0'dır.
	var bakis := BAKIS.new()
	dene(TESHIS.teshis_dugmesi_sayisi() == 0 and bakis.teshis_dugmesi_sayisi == 0, "Ayrı teşhis düğmesi sayısı 0")

	# 2. Kural 3 & Kabul: Belirti satırı yokken enfeksiyon ipucu 0.
	var g_saglikli := _gelen([])
	var veri_belirtisiz := {
		"yuz": {
			"satirlar": ["Güneşten yanmış, yorgun bir çehre."],
			"ipucu": "Clue_Enfeksiyon_Ates" # Satırda belirti yokken enfeksiyon ipucu yazılmaz!
		},
		"eller": {
			"satirlar": ["Topraktan nasır tutmuş parmaklar."]
		}
	}
	var r_belirtisiz := bakis.bak("yuz", veri_belirtisiz, {"isik": true}, null, g_saglikli)
	dene(String(r_belirtisiz.get("enfeksiyon_ipucu", "")).is_empty() and String(r_belirtisiz.get("ipucu", "")).is_empty(), "Belirti satırı yokken enfeksiyon ipucu 0")
	dene(TESHIS.kaydet(g_saglikli).is_empty(), "Belirti yokken teşhis kaydı 0")

	# 3. Kural 3 & Kabul: Işıksız bakışta belirti de ipucu da 0.
	var g_atesli := _gelen(["belirti_ates"])
	var veri_atesli := {
		"yuz": {
			"satirlar": ["Yüzünde ateş ve titreme belirtisi var."],
			"belirti": "belirti_ates"
		},
		"eller": {
			"satirlar": ["Avucundaki bezde kanlı öksürük izi ve yarada irin görülüyor."]
		}
	}
	var bakis_isiksiz := BAKIS.new()
	var r_isiksiz := bakis_isiksiz.bak("yuz", veri_atesli, {"kosul": {"baglam": {"isik": false}}}, null, g_atesli)
	dene(String(r_isiksiz.get("ipucu", "")).is_empty() and TESHIS.kaydet(g_atesli).is_empty(), "Işıksız bakışta belirti ve ipucu 0")

	# 4. Kural 1, 2, 4 & Kabul: Yüz bölgesinde ateş satırı varken bakış Clue_Enfeksiyon_Ates üretir ve kabul karantina şartını 1 kez açar.
	var bakis_isikli := BAKIS.new()
	var r_yuz := bakis_isikli.bak("yuz", veri_atesli, {"isik": true}, null, g_atesli)
	dene(r_yuz.get("ipucu") == "Clue_Enfeksiyon_Ates", "Yüzde ateş satırı KRI-11 Clue_Enfeksiyon_Ates ipucunu üretir")
	dene(int(r_yuz.get("teshis_dugmesi", -1)) == 0, "Bakış sonucunda teşhis düğmesi 0")
	dene(TESHIS.kaydet(g_atesli) == ["Clue_Enfeksiyon_Ates"], "Bakis ve hastalik_teshis_adaptoru aynı kaydı yazar")

	# Aynı bölgeye ikinci bakış yeni belirti üretmez
	var r_yuz_tekrar := bakis_isikli.bak("yuz", veri_atesli, {"isik": true}, null, g_atesli)
	dene(String(r_yuz_tekrar.get("ipucu", "")).is_empty() and TESHIS.kaydet(g_atesli).size() == 1, "Aynı bölgeye ikinci bakış yeni belirti üretmez")

	# Heybede hastalık nesnesi yoksa yalnız bakış ipucu sayılır ve kabul karantina şartını 1 kez açar
	var kabul_sonuc := o.karar_ver(g_atesli, &"kabul")
	var k := y.koylu(int(kabul_sonuc.get("koylu_id", -1)))
	dene(bool(kabul_sonuc.get("karantina", false)) and k != null and KarantinaYoneticisi.aktif(k), "Yüzde ateş satırı varken kabul karantina şartını 1 kez açar")

	# İkinci kez kabul çağrısı engellenir (1 kez yazar)
	var ikinci_kabul := o.karar_ver(g_atesli, &"kabul")
	dene(bool(ikinci_kabul.get("engellendi", false)), "Kabul karantina bayrağına yalnız 1 kez yazar")

	# 5. Uç durum: Karakter kaçarsa (ZAR-03) ipucu kişi hafızasında kalır, karantina açılmaz.
	var g_kacan := _gelen(["belirti_irin"])
	var veri_eller := {
		"eller": {
			"satirlar": ["Parmak boğumlarındaki yarada irin görülüyor."]
		}
	}
	var bakis_kacan := BAKIS.new()
	var r_eller := bakis_kacan.bak("eller", veri_eller, {"isik": true}, null, g_kacan)
	dene(r_eller.get("ipucu") == "Clue_Enfeksiyon_Irin", "Eller bölgesinde irin belirtisi Clue_Enfeksiyon_Irin üretir")
	var kisi_hafiza := {}
	TESHIS.kacista_hafizaya_yaz(g_kacan, kisi_hafiza)
	dene(kisi_hafiza.get("enfeksiyon_ipuclari") == ["Clue_Enfeksiyon_Irin"] and bool(kisi_hafiza.get("karantina_acildi", true)) == false, "Karakter kaçarsa ipucu kişi hafızasında kalır, karantina açılmaz")

	# 6. Gerçek kapı eylem/bölge düğmeleri Bakis üzerinden çalışır (karanlıkta 0 ipucu, aydınlıkta yüz+el).
	var karanlik_gelen := _gelen(["belirti_ates"])
	karanlik_gelen.set_meta(&"bakis_isik", false)
	var r_karanlik := TESHIS.bolge_bak(null, karanlik_gelen, "yuz")
	dene(String(r_karanlik.get("ipucu", "")).is_empty() and TESHIS.kaydet(karanlik_gelen).is_empty(), "Kapı bölge bakışı karanlıkta enfeksiyon ipucu yazmaz")

	var bolge_gelen := _gelen(["humma", "belirti_irin"])
	var kutu := VBoxContainer.new()
	var sahte_ekran := Node.new()
	# Gerçek KapiEkrani ui testi hastalik_teshis_kontrol.tscn içinde ayrıca koşulur.
	var r_bolge_yuz := TESHIS.bolge_bak(null, bolge_gelen, "yuz")
	var r_bolge_el := TESHIS.bolge_bak(null, bolge_gelen, "eller")
	var bakis_ornegi := bolge_gelen.get_meta(TESHIS.BAKIS_META, null) as RefCounted
	dene(bakis_ornegi != null and r_bolge_yuz.get("ipucu") == "Clue_Enfeksiyon_Ates" and r_bolge_el.get("ipucu") == "Clue_Enfeksiyon_Irin", "HastalikTeshisAdaptoru gerçek Bakis örneğiyle yüz ve el ipuçlarını üretir")
	dene(String(r_bolge_yuz.get("satir", "")).contains("ateş") and String(r_bolge_el.get("satir", "")).contains("irin"), "Bölge bakışı yüz ve el satırlarını ayrı ayrı üretir")
	TESHIS.eylem(sahte_ekran, bolge_gelen, kutu)
	dene(kutu.get_node_or_null("BakisYuz") != null and kutu.get_node_or_null("BakisEller") != null, "Kapı eylem kutusuna BakisYuz ve BakisEller bölge düğmeleri eklenir")
	kutu.free()
	sahte_ekran.free()

	print("KOP03 BAKIS HASTALIK: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _gelen(bayraklar: Array) -> Gelen:
	var g := Gelen.new()
	g.ad_anahtari = "Ziyaretçi"
	g.acik_bayraklar = PackedStringArray(bayraklar)
	g.secenekler = ["kabul", "ret"]
	g.heybe = Heybe.new()
	return g

func _sifahane_ve_hekim_hazirla(y: KoyYonetimi) -> void:
	for tur in ["odun", "tas", "kereste"]:
		y.kaynaklar.ekle(tur, 40)
	var hekim := y.kabul({"ad": "Hekim", "bayraklar": ["usta_cerrah"]})
	hekim.zanaat_turu = ZanaatTuru.Tur.CERRAH
	hekim.yapi_bilgisi = PackedStringArray(["sifahane", "kulube"])
	var k1_kuruldu := false
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("kulube", h).olur:
				var k1 := y.bina(y.bina_kur("kulube", h).id)
				if k1 != null:
					k1.insa_kalan = 0
					k1_kuruldu = true
				break
		if k1_kuruldu:
			break
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("sifahane", h).olur:
				var b := y.bina(y.bina_kur("sifahane", h).id)
				if b != null:
					b.insa_kalan = 0
					y.ata(hekim.id, b.id)
				return
