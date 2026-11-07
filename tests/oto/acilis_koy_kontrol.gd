## ACL-01: gerçek Ana yeni oyun/devam akışı; yalnız pid adlı ayrı kayıt.
extends Node
const ACILIS = preload("res://src/sistemler/acilis_senaryosu.gd")
const FAZ = preload("res://src/sistemler/oturum_fazi.gd")

class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		GuvenliMetin.kur()
		ayarlar = Ayarlar.new("user://unused_acl01.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		kayit = GuvenliKayit.new("user://acl01_%d.json" % OS.get_process_id())
		theme = Tema.olustur(ayarlar)

var hata := 0

func _ready() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	get_tree().create_timer(90.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	GirdiEylemleri.kur("user://ogr22_%d.cfg" % OS.get_process_id())
	dene(AyarlarEk.ayarla(ana.ayarlar, &"zorluk", &"siki"), "DEN-66 yeni oyunun zorluk tercihi")
	ana.oyuncu_izi.sifirla()
	ana._yeni_oyun_ekrani()
	var secim := ana._ekran as YeniOyunEkrani
	secim.baslatildi.emit(1401, "eski_levent")
	var kadraj := ana._ekran as BilgiEkrani
	dene(kadraj != null and kadraj.name == &"IlkSaatKadraci" and ana.oturum == null, "OGR-41 seçimden sonra tek kadraj")
	await get_tree().process_frame
	dene(ana._ekran == kadraj and kadraj.dugmeler.size() == 1 and kadraj.metin.split("\n").size() == 3, "OGR-41 üç satır ve tek ilerleme girdisi")
	kadraj.secildi.emit(0)
	await get_tree().process_frame
	await _arazi_hazir(ana)
	var e := ana._ekran as KoyEkrani
	dene(preload("res://src/sistemler/kayit_gocu_soz.gd").oynanis_acik(), "Gerçek Ana köy ekranı göç için oynanış sayılır")
	for k in ana.oturum.yonetim.koylular:
		dene(not k.ad.contains("acilis.") and not k.ad.is_empty(), "Nüfus satırında kişi adı teknik anahtar değildir")
		var ozet := KoyluKartiVerisi.ozet(ana.oturum.yonetim, k)
		dene(not ozet.contains("[KEY_NOT_FOUND") and not ozet.contains("acl01_"), "Kuruluş kimliği kartta teknik anahtar olarak görünmez")
	dene(e != null and ana._kapi == null and not ana._kapi_yukleniyor, "Gerçek yeni oyun köy ekranında, kapı/kuyruk kurulmaz")
	if e != null:
		var serit := e.find_child("IpucuSeridi", true, false) as IpucuSeridi
		dene(serit != null and serit.visible and serit.aktif_metin().contains(GirdiEylemleri.tus_adi("hiz_dur")), "OGR-22 ilk gerçek köy ekranında güncel hız ipucu")
		var etiket := e.hud.find_child("acilis_kapi_durumu", true, false) as Label
		dene(etiket != null and etiket.visible and etiket.text == tr("acilis.kapi.kapali"), "Gerçek HUD Kapı kapalı yazar")
		dene(e.sahne3b.halk_hareketi.modeller.size() == 2, "Mevcut köy sahnesinde iki gerçek model")
		var malzemeler: Array = []
		for f in e.sahne3b.halk_hareketi.modeller.values():
			var ad := f.find_child("acilis_hane_etiketi", true, false) as Label3D
			dene(ad != null and not ad.text.is_empty(), "Her yer tutucuda kısa isim etiketi")
			var parcalar: Array[Node] = f.find_children("*", "MeshInstance3D", true, false)
			if not parcalar.is_empty(): malzemeler.append(parcalar[0].material_overlay)
		dene(malzemeler.size() == 2 and malzemeler[0] != malzemeler[1], "Muhafız/eş yer tutucuları farklı renkte")
		malzemeler.clear()
	ana._kapiya_git()
	dene(ana._ekran is KoyEkrani and ana._kapi == null, "İlk gün doğrudan kapı çağrısı da kuyruk kurmaz")
	dene(ana._ekran == e, "Kapalı kapı çağrısı mevcut köy ekranını yeniden kurmaz")
	var kayit := ana.kayit.oku()
	dene("koy_hizi" in kayit.ogretici.gorulen, "OGR-22 ilk açılış kaydı gösterilen ipucunu taşır")
	dene(kayit.get("zorluk") == "siki" and not kayit.koy_yonetimi.has("zorluk"), "DEN-66 sıkı zorluk kayıt kökünde tek alan")
	var gerek := TuketimDengesi.gerek(ana.oturum.yonetim)
	dene(ana.oturum.yonetim.kaynaklar.miktar("gida") == 26 and 26 > int(gerek.gida), "DEN-69 sıkı gerçek açılış erzağı 30'dan az ve bir geceden çok")
	dene(String(ana.oturum.yonetim.get_meta(&"zorluk", "olagan")) == "siki", "DEN-66 yeni oyun sıkı zorluğu köy hesabına bağlar")
	dene(AyarlarEk.ayarla(ana.ayarlar, &"zorluk", &"kolay"), "DEN-66 yüklemeden önce global tercih değişir")
	dene(kayit.get("faz") == "koy" and kayit.koy_yonetimi.koylular.size() == 2, "Gerçek kayıt köy fazını/iki kişiyi taşır")
	ana.devam_et()
	await get_tree().process_frame
	await _arazi_hazir(ana)
	dene(ana._ekran is KoyEkrani and ana.oturum.gun == 0 and ana.oturum.yonetim.yatak_kapasitesi() == 4, "Yeni kuruluş kaydından aynı köye devam")
	dene(ana._ekran.find_child("IpucuSeridi", true, false) == null, "OGR-22 kayıt dönüşünde ipucu tekrar çıkmaz")
	dene(String(ana.oturum.yonetim.get_meta(&"zorluk", "olagan")) == "siki" and TuketimDengesi.gerek(ana.oturum.yonetim) == gerek, "DEN-66 yükleme sıkı zorluğu ve tüketim hesabını korur")
	dene(ana.oturum.yonetim.kaynaklar.miktar("gida") == 26, "DEN-69 açılış indirimi yüklemede yeniden uygulanmaz")
	ana._kayit_yaz()
	dene(ana.kayit.oku().get("zorluk") == "siki", "DEN-66 yeni kayıt yüklenen oyunun zorluğunu korur")
	var cikti := OS.get_environment("ACL01_TEST_CIKTI")
	if not cikti.is_empty() and DisplayServer.get_name() != "headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(cikti.path_join("acl01_koy.png"))
	for faz in ["kapi", "koy"]:
		var eski := Oturum.new(ana.katalog, 1942)
		eski.gun = 8
		FAZ.ayarla(eski, faz)
		var v := eski.kaydet()
		v.erase("acilis_hanesi")
		if faz == "kapi":
			v.erase("zorluk")
		else:
			v["zorluk"] = "ustalik"
		v.surum = 2 # KAY-71: açık Devam et isteği önce yükleme aşamasına geçer.
		ana.kayit.yaz(v)
		ana.devam_et()
		await get_tree().process_frame
		while ana._kapi_yukleniyor or ana.find_children("*", "CanvasLayer", true, false).any(func(n: Node) -> bool: return n is VarlikYuklemePaneli):
			await get_tree().process_frame
		await _arazi_hazir(ana)
		dene((ana._ekran is KapiEkrani if faz == "kapi" else ana._ekran is KoyEkrani) and ana.oturum.gun == 8, "Eski kayıt gerçek aynı faz/günde açılır")
		dene(preload("res://src/sistemler/kayit_gocu_soz.gd").oynanis_acik(), "Gerçek kapı/köy fazı göç için oynanış sayılır")
		dene(ACILIS.durum(ana.oturum).is_empty() and ana.oturum.yonetim.nufus() == 0 and ana.oturum.yonetim.binalar.is_empty(), "Eski kayda zorla ev/eş eklenmez")
		dene(ana.oturum.kaydet().get("zorluk") == "olagan", "DEN-66 eksik veya bilinmeyen eski zorluk olağan açılır")
	ana.oyuncu_izi.ilk_oyun_bitti = true
	ana._gecmis_secildi(1401, "eski_levent")
	dene(ana._ekran is KoyEkrani, "OGR-48 mevcut bitmiş oyuncu izinde kadraj atlanır")
	ana.ana_menu()
	dene(not preload("res://src/sistemler/kayit_gocu_soz.gd").oynanis_acik(), "Gerçek menü geçişi göç kilidini kaldırır")
	ana.kayit.sil()
	ana.free()
	await get_tree().process_frame
	print("AÇILIŞ KÖY: GEÇTİ" if hata == 0 else "AÇILIŞ KÖY: KALDI")
	await Ses.cik(hata)

func _arazi_hazir(ana: Ana) -> void:
	# NoiseTexture2D görüntüsü arka planda hazırlanır; yüklemeyi başlatıp
	# aynı karede sahneyi silmek renderer çıkışını yarışa sokar.
	var gurultu: NoiseTexture2D
	if ana._ekran is KoyEkrani:
		gurultu = ana._ekran.sahne3b.arazi._zemin_mat.get_shader_parameter("gurultu")
	elif ana._ekran is KapiEkrani:
		gurultu = KapiManzarasi._gurultu
	if gurultu != null and gurultu.get_image() == null:
		await gurultu.changed
	if DisplayServer.get_name() != "headless": await RenderingServer.frame_post_draw

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
