## BUG-24 kabulü: gerçek köy GUI yüzeyi, takip, ayar kaydı ve kapı geçişi.
extends SceneTree

const NOKTA := Vector2(900, 400)
const ADIM := Vector2(40, 20)
var hata := 0
var kontrol_sayisi := 0
var ekran: Control


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	create_timer(60.0).timeout.connect(func() -> void: quit(1))
	root.size = Vector2i(1920, 1080)
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 24)
	var kisi := o.yonetim.kabul({"ad": "Kamera deneği", "sinif": "ciftci"})
	ekran_kur(o)
	await process_frame
	await process_frame
	var s: KoyYonetimSahnesi = ekran.sahne3b
	var n := s.get_node_or_null("kamera_surukleme") as KameraSurukleme
	_kontrol(n != null and s.find_children("kamera_surukleme", "", true, false).size() == 1, "TEK_BAG: gerçek köy yüzeyinde tek bileşen")
	KameraSurukleme.kur(s)
	_kontrol(s.find_children("kamera_surukleme", "", true, false).size() == 1, "TEKRAR_KUR: ikinci bağlantı yok")
	s.halk_hareketi.set_process(false)
	s.halk_hareketi._bekleyen.clear()
	var f := s.halk_hareketi.modeller[kisi.id] as KarakterModel
	f.yurumeyi_durdur()
	f.position = Vector3.ZERO
	var kayit := JSON.stringify(o.kaydet())
	var veri: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(KameraSurukleme.DENGE_YOLU))
	var temel_hiz := float(veri.kamera_surukleme.hiz)
	_kontrol(is_equal_approx(n.hiz, temel_hiz) and temel_hiz > 0, "DENGE: hız üretim JSON dosyasından")

	# Varsayılan: altındaki zemin noktası el yönünde yeni ekrana gelir.
	s.hedef = Vector3.ZERO
	s._kamera_yerlestir()
	var zemin := Plane(Vector3.UP)
	var tutulan: Vector3 = zemin.intersects_ray(s.kamera.project_ray_origin(ekran._vp_konum(NOKTA)), s.kamera.project_ray_normal(ekran._vp_konum(NOKTA)))
	_hareket(NOKTA)
	_kontrol(root.gui_get_hovered_control() == ekran._kap, "GUI: imleç gerçek dünya yüzeyinde")
	_dugme(NOKTA, true)
	_hareket(NOKTA + ADIM, true)
	var duz := s.hedef
	_kontrol(duz.length() > 0, "SURUKLE: orta tuş dünyayı kaydırır")
	_kontrol(s.kamera.unproject_position(tutulan).distance_to(ekran._vp_konum(NOKTA + ADIM)) < 0.01, "DUZ_YON: varsayılanda harita el yönüne gelir")
	_dugme(NOKTA + ADIM, false)
	var birakilan := s.hedef
	_hareket(NOKTA + ADIM * 2, true) # Bayat button_mask de bırakılmış sürüklemeyi açamaz.
	n._process(10.0)
	_kontrol(s.hedef == birakilan and not n._surukleniyor, "BIRAKMA: son karede ve sonrasında fazladan kayma sıfır")

	ekran.ayarlar.ayarla(&"kamera_eksen_ters", true)
	s.hedef = Vector3.ZERO
	s._kamera_yerlestir()
	_hareket(NOKTA)
	_dugme(NOKTA, true)
	_hareket(NOKTA + ADIM, true)
	_kontrol(s.hedef.is_equal_approx(-duz), "TERS_YON: açık ayar iki ekseni ters çevirir")
	_dugme(NOKTA + ADIM, false)
	ekran.ayarlar.ayarla(&"kamera_eksen_ters", false)

	# Başka JSON verisi davranışı değiştirir; gd piksel/elle hız sabiti taşımaz.
	var denge_yolu := "user://bug24_denge.json"
	var dosya := FileAccess.open(denge_yolu, FileAccess.WRITE)
	dosya.store_string(JSON.stringify({"kamera_surukleme": {"hiz": temel_hiz * 2}}))
	dosya.close()
	n.denge_yukle(denge_yolu)
	s.hedef = Vector3.ZERO
	s._kamera_yerlestir()
	_hareket(NOKTA)
	_dugme(NOKTA, true)
	_hareket(NOKTA + ADIM, true)
	_kontrol(s.hedef.is_equal_approx(duz * 2), "DENGE_ETKISI: JSON hız iki katken kayma iki kat")
	_dugme(NOKTA + ADIM, false)
	DirAccess.remove_absolute(denge_yolu)
	n.denge_yukle()

	# relative alanına FPS birikimi yazılsa da yalnız son iki konum kullanılır.
	s.hedef = Vector3.ZERO
	s._kamera_yerlestir()
	_hareket(NOKTA)
	_dugme(NOKTA, true)
	_hareket(NOKTA + ADIM, true, Vector2(100000, -100000))
	_kontrol(s.hedef.is_equal_approx(duz), "DUSUK_FPS: birikmiş relative yerine son iki imleç konumu")
	n._process(10.0)
	_kontrol(s.hedef.is_equal_approx(duz) and not n._surukleniyor, "FPS_DELTA: büyük delta hareket eklemez; kayıp bırakma temizlenir")
	_dugme(NOKTA + ADIM, false)

	# Her olayın ardından, kare beklemeden sınır kontrolü; dönük kamera/dikdörtgen harita.
	dosya = FileAccess.open(denge_yolu, FileAccess.WRITE)
	dosya.store_string(JSON.stringify({"kamera_surukleme": {"hiz": temel_hiz * 1000}}))
	dosya.close()
	n.denge_yukle(denge_yolu)
	var boyut := s.yonetim.a.izgara_boyut
	s.yonetim.a = s.yonetim.a.duplicate(true)
	s.yonetim.a.izgara_boyut = Vector2i(boyut.x, boyut.y + 7)
	var alt := s.hucre_kosesi(Vector2i.ZERO)
	var ust := s.hucre_kosesi(s.yonetim.a.izgara_boyut)
	s.hedef = ust + Vector3(3, 0, 3)
	s._kamera_yerlestir()
	_hareket(NOKTA)
	_dugme(NOKTA, true)
	_kontrol(s.hedef.x == ust.x and s.hedef.z == ust.z, "SINIR_BASLANGIC: önceki serbest kamera sınır dışındaysa ilk basışta kırpılır")
	_dugme(NOKTA, false)
	var dis_kare := 0
	for yon in [0.0, 90.0, 180.0, 270.0]:
		s.yon = yon
		s.hedef = Vector3.ZERO
		s._kamera_yerlestir()
		_hareket(NOKTA)
		_dugme(NOKTA, true)
		for i in range(160):
			_hareket(NOKTA + Vector2(i + 1, i + 1) * 3, true)
			if s.hedef.x < alt.x or s.hedef.x > ust.x or s.hedef.z < alt.z or s.hedef.z > ust.z:
				dis_kare += 1
		_dugme(NOKTA, false)
	_kontrol(dis_kare == 0, "SINIR: dört yönde dikdörtgen haritada sınır dışındaki kare sıfır")
	_kontrol(is_equal_approx(absf(s.hedef.x), absf(alt.x)) or is_equal_approx(s.hedef.z, ust.z) or is_equal_approx(s.hedef.z, alt.z), "SINIRA_ULASTI: sınır testi gerçekten kenara dayanır")
	n.denge_yukle()
	DirAccess.remove_absolute(denge_yolu)
	s.yonetim.a.izgara_boyut = boyut
	s.yon = 25.0
	s.hedef = Vector3.ZERO
	s._kamera_yerlestir()

	# ANI-14, aynı olayda iptal; kare sonrası kendiliğinden dönmez, tekrar seçim döndürür.
	KoyluTakibi.sec(s, kisi.id)
	var takip := s.get_node("koylu_takibi") as KoyluTakibi
	_hareket(NOKTA)
	_dugme(NOKTA, true)
	_kontrol(not takip.takip, "TAKIP_ANINDA: orta tuşa basınca kare beklemeden takip biter")
	_hareket(NOKTA + ADIM, true)
	_dugme(NOKTA + ADIM, false)
	var serbest := s.hedef
	f.position += Vector3(3, 0, 2)
	await process_frame
	takip.guncelle()
	_kontrol(not takip.takip and s.hedef == serbest, "TAKIP_GERI_DONMEZ: bırakma ve sonraki karede hedef korunur")
	KoyluTakibi.sec(s, kisi.id)
	_kontrol(takip.takip and s.hedef == f.position, "YENIDEN_SECIM: kişiye tekrar seçim takibi başlatır")

	# Gerçek panel GUI kalkanı: üstünde başlama ve sürüklerken üstüne gelme.
	var panel := PanelContainer.new()
	panel.position = NOKTA - Vector2(50, 50)
	panel.size = Vector2(200, 200)
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	ekran.add_child(panel)
	var once := s.hedef
	_hareket(NOKTA)
	_dugme(NOKTA, true)
	_hareket(NOKTA + ADIM, true)
	_dugme(NOKTA + ADIM, false)
	_kontrol(s.hedef == once and takip.takip, "PANEL: panel üstünde kayma sıfır, takip iptal edilmez")
	panel.hide()
	_hareket(NOKTA)
	_dugme(NOKTA, true)
	panel.show()
	_hareket(NOKTA + ADIM, true)
	_dugme(NOKTA + ADIM, false)
	_kontrol(s.hedef == once and not n._surukleniyor, "PANELE_GIRIS: yakalanmış orta tuş panelde hareket etmez")
	panel.free()
	_hareket(NOKTA)
	_dugme(NOKTA, true)
	paused = true
	_hareket(NOKTA + ADIM, true)
	_kontrol(s.hedef == once and not n._surukleniyor, "DURAKLAT: duraklat menüsü dünyayı kaydırmaz")
	_dugme(NOKTA + ADIM, false)
	paused = false
	_hareket(NOKTA + ADIM * 2, true)
	_kontrol(s.hedef == once, "DURAKLAT_DONUS: yeni basış olmadan sürükleme dönmez")
	_hareket(NOKTA)
	_dugme(NOKTA, true)
	root.focus_exited.emit()
	_hareket(NOKTA + ADIM, true)
	_kontrol(s.hedef == once and not n._surukleniyor, "ODAK_KAYBI: pencere odağı kaybolunca sürükleme iptal")
	_dugme(NOKTA + ADIM, false)

	var zoom := s.uzaklik
	_dugme(NOKTA, true, MOUSE_BUTTON_WHEEL_UP)
	_kontrol(is_equal_approx(s.uzaklik, clampf(zoom * 0.9, 14.0, 80.0)), "TEKERLEK: mevcut yakınlaştırma korunur")
	_kontrol(JSON.stringify(o.kaydet()) == kayit, "SALT_OKUNUR: kayıt ve RNG değişmez")
	_ayar_kontrol()

	# Devam eden sürükleme ile köyden çıkış, gerçek kapı kamerası sabit kalır.
	_hareket(NOKTA)
	_dugme(NOKTA, true)
	ekran.free()
	var kapi := KapiSahnesi.new()
	root.add_child(kapi)
	var kapi_once := kapi.kamera.transform
	_hareket(NOKTA + ADIM, true)
	_dugme(NOKTA + ADIM, false)
	await process_frame
	_kontrol(kapi.kamera.transform == kapi_once and kapi.get_node_or_null("kamera_surukleme") == null, "KAPI: geçişte köy kaydırması kalmaz, kapı kamerası değişmez")
	kapi.free()
	print("KAMERA SURUKLEME: GEÇTİ (%d kontrol)" % kontrol_sayisi if hata == 0 else "KAMERA SURUKLEME: KALDI (%d)" % hata)
	quit(hata)


func ekran_kur(o: Oturum) -> void:
	# Ses autoload'u -s betiğinin derlenmesinden sonra kurulur; UI'yi çalışma anında yükle.
	ekran = load("res://src/arayuz/koy_ekrani.gd").new()
	ekran.oturum = o
	ekran.ayarlar = Ayarlar.new("user://bug24_unused.cfg")
	ekran.theme = Tema.olustur(ekran.ayarlar)
	root.add_child(ekran)


func _ayar_kontrol() -> void:
	var yol := "user://bug24_ayarlar.cfg"
	var cfg := ConfigFile.new()
	cfg.set_value("ayarlar", "ses_ana", 3)
	_kontrol(cfg.save(yol) == OK, "ESKI_AYAR_FIXTURE: user:// dosyası yazılır")
	var a := Ayarlar.new(yol)
	a.yukle()
	_kontrol(a.al(&"ses_ana") == 3 and a.al(&"kamera_eksen_ters") == false, "ESKI_AYAR: optional alan yokken varsayılan ve eski değer okunur")
	var ui := AyarlarEkrani.new()
	ui.ayarlar = a
	ui.theme = Tema.olustur(a)
	root.add_child(ui)
	_kontrol(ui._degerler.has(&"kamera_eksen_ters"), "AYAR_UI: eksen ters menüde var")
	ui._degistir(&"kamera_eksen_ters", 1)
	_kontrol(a.al(&"kamera_eksen_ters") == true and ui._degerler[&"kamera_eksen_ters"].text == TranslationServer.translate("arayuz.ayarlar.kamera_eksen.acik"), "AYAR_UI_ACIK: seçim anında uygulanır ve çevrilir")
	ui._kapat()
	var b := Ayarlar.new(yol)
	b.yukle()
	_kontrol(b.al(&"kamera_eksen_ters") == true and b.al(&"ses_ana") == 3, "AYAR_KAYIT: yeni alan yazılır/yüklenir, eski değer korunur")
	ui._degistir(&"kamera_eksen_ters", -1)
	_kontrol(a.al(&"kamera_eksen_ters") == false, "AYAR_UI_KAPALI: diğer ok ayarı geri kapatır")
	a.ayarla(&"kamera_eksen_ters", 1)
	_kontrol(a.al(&"kamera_eksen_ters") == false, "AYAR_TIP: boolean dışı değer reddedilir")
	a.ayarla(&"kamera_eksen_ters", true)
	a.varsayilana_don()
	_kontrol(a.al(&"kamera_eksen_ters") == false, "AYAR_VARSAYILAN: el yönü geri gelir")
	ui.free()
	DirAccess.remove_absolute(yol)


func _hareket(p: Vector2, orta: bool = false, goreli: Vector2 = Vector2.ZERO) -> void:
	var e := InputEventMouseMotion.new()
	e.position = p
	e.global_position = p
	e.relative = goreli
	e.button_mask = MOUSE_BUTTON_MASK_MIDDLE if orta else 0
	root.push_input(e, true)


func _dugme(p: Vector2, bas: bool, tus: MouseButton = MOUSE_BUTTON_MIDDLE) -> void:
	var e := InputEventMouseButton.new()
	e.position = p
	e.global_position = p
	e.button_index = tus
	e.pressed = bas
	e.button_mask = MOUSE_BUTTON_MASK_MIDDLE if bas and tus == MOUSE_BUTTON_MIDDLE else 0
	root.push_input(e, true)


func _kontrol(v: bool, ad: String) -> void:
	kontrol_sayisi += 1
	if not v:
		hata += 1
		push_error(ad)
