extends SceneTree

var hata := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var gelen := Gelen.new()
	gelen.id = &"chr_001"
	gelen.adli = true
	var sorgu: RefCounted = gelen.chr_sorgusu()
	_kontrol(sorgu != null and gelen.chr_sorgusu() == sorgu, "Ziyaret aynı sorguyu koruyor")
	var diger := Gelen.new()
	diger.id = gelen.id
	diger.adli = true
	_kontrol(diger.chr_sorgusu() != sorgu, "İki ziyaret bağımsız")
	var diyalog = load("res://src/arayuz/chr_diyalog_paneli.gd").new()
	diyalog.sorgu = sorgu
	root.add_child(diyalog)
	_kontrol((diyalog.get_node("Secenek2") as Button).disabled, "Kanıtsız Dal 3 düğmesi kilitli")
	_kontrol(not sorgu.secenek_sec(2) and sorgu.dugum_id == &"00", "Programatik kanıtsız suçlama da engelleniyor")
	var ekran := Control.new()
	root.add_child(ekran)
	var eylemler := VBoxContainer.new()
	ekran.add_child(eylemler)
	load("res://src/arayuz/chr_kapi_adaptoru.gd").inceleme_dugmesi(ekran, gelen, eylemler)
	(eylemler.get_child(0) as Button).pressed.emit()
	var panel := ekran.get_node("ChrInceleme")
	(panel.get_child(0).get_child(1) as Button).pressed.emit()
	_kontrol(sorgu.ipuclari.has(&"Clue_CHR001_KavliCakmak"), "Gerçek panel tıklaması nişan ipucunu kaydediyor")
	var kart := panel.get_node("EsyaDetayKarti") as Control
	_kontrol(kart.mouse_filter == Control.MOUSE_FILTER_STOP and kart.aciklama == sorgu.karakter.obje_1["aciklama"], "Nişan fiziksel açıklaması modal kartta")
	kart.free()
	_kontrol(not (diyalog.get_node("Secenek2") as Button).disabled, "Tek ipucu Dal 3 kilidini açıyor")
	sorgu.obje_incele(1)
	_kontrol(sorgu.ipuclari.size() == 1, "Tekrarlı inceleme idempotent")
	(panel.get_child(0).get_child(2) as Button).pressed.emit()
	_kontrol(sorgu.ipuclari.has(&"Clue_CHR001_KatranliBez") and sorgu.ipuclari.size() == 2, "Yük/gizli bölme tıklaması ayrı ipucu veriyor")
	_kontrol(panel.get_node("EsyaDetayKarti").baslik == "İncelenen yük", "Yük ayrı modal karta açılır")
	panel.get_node("EsyaDetayKarti").free()
	_kontrol(sorgu.obje_incele(0) == "" and sorgu.ipuclari.size() == 2, "Geçersiz inceleme ipucu üretmiyor")
	var gorsel_iz: TextureButton = panel.call("gorsel_iz_dugmesi")
	_kontrol(gorsel_iz != null and panel.is_ancestor_of(gorsel_iz) and gorsel_iz.get_parent().get_combined_minimum_size().y >= 220,
		"Görsel iz düğmesi çerçeveyle de erişilebilir ve tıklanabilir boyutta")
	if gorsel_iz != null:
		gorsel_iz.pressed.emit()
	_kontrol(sorgu.ipuclari.has(&"Clue_Görsel_CHR001_KukurtYanigi") and sorgu.ipuclari.size() == 3, "2D portre tıklaması görsel ipucu veriyor")
	_kontrol(sorgu.gorsel_incele().contains("kükürt") and sorgu.ipuclari.size() == 3, "Görsel açıklama kaynak metni; tekrar ipucu üretmez")
	_kontrol(diger.chr_sorgusu().ipuclari.is_empty(), "İpucu başka ziyarete sızmıyor")
	_kontrol(sorgu.secenek_sec(2) and sorgu.dugum_id == &"3.1", "Kanıtlı suçlama hedef düğüme gidiyor")
	_kontrol(sorgu.secenek_sec(0) and sorgu.dugum_id == &"3.3" and sorgu.bayraklar["Flag_Sir_Tamamen_Cozuldu"], "Düşük tansiyonda yönlendirme sırrı çözüyor")
	var panik: RefCounted = diger.chr_sorgusu()
	panik.obje_incele(1)
	panik.tansiyon = 6
	_kontrol(panik.secenek_sec(2) and panik.tansiyon == 8 and panik.bayraklar["Flag_Kilitlendi"] and panik.dugum_id == &"Final_Ret", "8 eşiğinde kalıcı panik")
	_kontrol(not panik.karar_acik(&"kabul") and not panik.karar_acik(&"harc") and panik.karar_acik(&"ret") and panik.karar_acik(&"kisla") and panik.karar_acik(&"rusvet"), "Panikte yalnız zorunlu ret/kışla/rüşvet")
	panik.tansiyon = 2
	_kontrol(not panik.karar_acik(&"kabul"), "Panik bayrağı tansiyon düşse de çözülmüyor")
	var katalog := Katalog.new()
	katalog.yukle()
	var oturum := Oturum.new(katalog, 17)
	var once := oturum.akce
	_kontrol(oturum.karar_ver(diger, &"kabul").get("engellendi", false) and oturum.akce == once, "Oturum API kabulü yan etkisiz engelliyor")
	var beceri := preload("res://src/sistemler/chr_sorgusu.gd").new(sorgu.karakter)
	beceri.tohumla(42)
	var dusuk: float = beceri.basari_olasiligi()
	_kontrol(is_equal_approx(dusuk, SorguZari.olasilik(SorguZari.gerekli(beceri.karakter.sorgu_degeri, 0, 0, beceri.kurallar), beceri.zar_turu())), "KAP-09 olasılığı ZAR-01 formülünden geliyor")
	beceri.tecrube = 10
	var tec_deg: Dictionary = beceri.yaklasim_degistiricisi({"beceri": "ikna"})
	_kontrol(int(tec_deg["toplam"]) == -1 and String(tec_deg["satirlar"][-1]["tur"]) == "tecrube", "Tecrübe eşiği görünür -1 değiştirici satırı")
	_kontrol(beceri.basari_olasiligi(int(tec_deg["toplam"])) > dusuk, "Tecrübe ikna olasılığını artırıyor")
	beceri.tansiyon = 7
	_kontrol(beceri.basari_olasiligi() < dusuk, "Tansiyon ikna olasılığını düşürüyor")
	var tohum := 0
	while true:
		var r := RandomNumberGenerator.new()
		r.seed = tohum
		if SorguZari.at(r, beceri.zar_turu()) == 1:
			break
		tohum += 1
	beceri.tohumla(tohum)
	beceri._dugume_git(&"1.1")
	_kontrol(beceri.secenek_sec(1) and not beceri.son_zar["basarili"] and beceri.bayraklar["Flag_Kilitlendi"], "Başarısız blöf 7→8 panik oluşturuyor")
	_kontrol(beceri.replik_baslat() and not beceri.replik_baslat(), "UI yenileme aynı repliği/sesi tekrar başlatmıyor")
	var sesler := preload("res://src/sistemler/chr_sorgu_sesi.gd")
	_kontrol(sesler.efekt(sorgu.karakter, "Hançer kabzasına sarılır") == &"sfx_chr_kabza", "Kabza eylemi replikle eşzamanlı seçiliyor")
	_kontrol(root.has_node("Ses") and sesler.cal(sorgu.karakter, "Hançer kabzasına sarılır"), "Kayıtlı Ses autoload replik efektini oynattı")
	for ses in ["metal", "kagit", "bebek", "kabza", "deri", "sikke"]:
		_kontrol(ResourceLoader.exists(HazirSesKaynaklari.yol("sfx_chr_" + ses)), "Yönlendirilen SFX mevcut: " + ses)
	var karar_sesi: Dictionary = load("res://src/kapi/karar_replik_adaptoru.gd").uygula(gelen, "rusvet")
	_kontrol(karar_sesi.dosya and karar_sesi.calindi, "Karar sesi kayıtlı kaynaktan çalındı")
	diyalog.free()
	ekran.free()
	await process_frame
	await process_frame
	await create_timer(0.8).timeout
	print("CHR SORGU: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	await root.get_node("Ses").call("cik", hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
