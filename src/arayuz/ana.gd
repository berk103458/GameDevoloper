## Oyunun kök sahnesi: kataloğu ve ayarları kurar, ekranlar arasında geçer.
## Günlük döngü (design/gdd/koy-yonetimi.md, 14): Kapı (gündüz) → Köy yönetimi (akşam) → Gece hesaplaşması ve rapor
## → bir sonraki gün. Ağalık eşiğinde geçiş kartı; son ekranı istatistiklerle (16.5). Her faz geçişinde kayıt (13.4).
class_name Ana
extends Control

var katalog: Katalog
var ayarlar: Ayarlar
var kayit: GuvenliKayit
var oturum: Oturum
var _ekran: Control
var _kapi: KapiEkrani
var _ust: Control
var _kapi_yukleniyor := false


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_eylemleri_kur()
	if AdminHud.arac_acik():
		var admin := AdminHud.new()
		admin.baglam = self
		add_child(admin)
	TranslationServer.set_locale("tr")
	GuvenliMetin.kur()  # BUG-07: eksik metin anahtarı kilitlemez
	ayarlar = Ayarlar.new()
	ayarlar.yukle()
	AyarlarEk.bagla(ayarlar)  # AYR-02: bölümün ek anahtarları ayrı dosyadan kaydolur
	ayarlar.uygula()
	var giris_kaynaklari := await VarlikYuklemePaneli.hazirla(self, GirisVarliklari.menu())
	ayarlar.degisti.connect(func(_a: StringName) -> void: theme = Tema.olustur(ayarlar))
	theme = Tema.olustur(ayarlar)
	_imleci_kur()
	kayit = GuvenliKayit.new()
	katalog = Katalog.new()
	if katalog.yukle() != Katalog.Durum.HAZIR:
		_hata_goster()
		return
	var denge_hatasi := _denge_hatasi()
	if not denge_hatasi.is_empty():
		var etiket := Label.new()
		etiket.text = tr("acilis.denge_hatasi") % denge_hatasi
		etiket.position = Vector2(80, 80)
		add_child(etiket)
		return
	ana_menu()
	await VarlikYuklemePaneli.bitir(self, giris_kaynaklari)
	Ses.dongu_baslat()
	preload("res://src/debug/oyun_koprusu.gd").bagla(self)


## Ana menüyü gösterir.
func _denge_hatasi() -> String:
	return preload("res://src/sistemler/denge_sinir_denetimi.gd").acilis_hatasi()


func ana_menu() -> void:
	var e := MenuEkrani.new()
	e.ayarlar = ayarlar
	e.ust_satir = tr("arayuz.menu.ust")
	e.baslik = tr("arayuz.menu.baslik")
	e.ipucu = tr("arayuz.menu.ipucu")
	e.dugmeler = PackedStringArray([tr("arayuz.menu.yeni"), tr("arayuz.menu.devam"), tr("arayuz.menu.ayarlar"), tr("arayuz.menu.cik")])
	if not kayit.var_mi():
		e.pasifler = [1]
	e.secildi.connect(func(i: int) -> void:
		match i:
			0: yeni_oyun()
			1: devam_et()
			2: _ayarlari_ac(ana_menu)
			3: Ses.cik()
	)
	_goster(e)


func yeni_oyun(tohum: int = 0, gecmis: String = "") -> void:
	var g = preload("res://src/sistemler/muhafiz_gecmisi.gd")
	if not g.VERI.has(gecmis):
		var adlar: Array = []
		for id in g.SIRA: adlar.append(String(g.VERI[id].ad))
		adlar.append("Ana menüye dön")
		var e := _bilgi("Muhafızın geçmişi", "Geçmişini seç. Bu seçim oyun boyunca değişmez.", adlar, -1, "")
		e.secildi.connect(func(i: int) -> void:
			if i >= 0 and i < g.SIRA.size(): yeni_oyun(tohum, g.SIRA[i])
			else: ana_menu()
		)
		_goster(e)
		return
	kayit.sil()
	oturum = Oturum.new(katalog, tohum)
	preload("res://src/sistemler/denge_tablosu.gd").acilis_erzagini_yaz(oturum.yonetim.kaynaklar)
	g.sec(oturum, gecmis)
	preload("res://src/sistemler/acilis_senaryosu.gd").kur(oturum)
	_koye_git()


func devam_et() -> void:
	# Açık yükleme isteği oynanış aşamasını bitirir; göç ekranda çalışan oyun işi değildir.
	preload("res://src/sistemler/kayit_gocu_soz.gd").oynanis_isaretle(_ekran, false)
	var o = preload("res://src/sistemler/kayit_gocu_soz.gd").oturum_veya_yedek(katalog, kayit)
	if o == null:
		preload("res://src/arayuz/kayit_hata_paneli.gd").goster(self)
		return
	oturum = o
	if preload("res://src/sistemler/oturum_fazi.gd").durum(o) == "koy":
		_koye_git()
	else:
		_kapiya_git()


func _kapiya_git(snapshot: Dictionary = {}) -> void:
	if preload("res://src/sistemler/acilis_senaryosu.gd").kapi_kapali(oturum):
		if not _ekran is KoyEkrani: _koye_git()
		return
	if _kapi_yukleniyor:
		return
	_kapi_yukleniyor = true
	var giris_kaynaklari := await VarlikYuklemePaneli.hazirla(self, GirisVarliklari.kapi())
	_kapi = KapiEkrani.new()
	_kapi.oturum = oturum
	_kapi.ayarlar = ayarlar
	_kapi.gece_bitti.connect(_koye_git)
	_kapi.oturum_bitti.connect(func(_k: int) -> void: _son_goster(&"halk_kirildi"))
	_kapi.duraklat_istendi.connect(_duraklat)
	_goster(_kapi)
	if snapshot.is_empty():
		_kapi.gece_baslat()
	else:
		await KapiAnlikGoruntusu.goster(_kapi, snapshot)
	await VarlikYuklemePaneli.bitir(self, giris_kaynaklari)
	_kapi_yukleniyor = false


## Kapı nöbeti bitti (Faz 1 → Faz 2): kayıt, sonra köy yönetimi.
func _koye_git(_rapor: Dictionary = {}) -> void:
	preload("res://src/sistemler/oturum_fazi.gd").ayarla(oturum, "koy")
	kayit.yaz(oturum.kaydet())
	var koy := KoyEkrani.new()
	koy.oturum = oturum
	koy.ayarlar = ayarlar
	koy.oturum_bitti.connect(_son_goster)
	koy.devam_istendi.connect(func(rapor: Dictionary) -> void:
		# Gece çözüldü ve olay seçildi: kayıt, sonra yeni gün (Ağalıkta önce geçiş kartı).
		preload("res://src/sistemler/oturum_fazi.gd").ayarla(oturum, "kapi")
		kayit.yaz(oturum.kaydet())
		if rapor.get("perde_degisti", false):
			_perde_gecisi()
		else:
			_kapiya_git()
	)
	_goster(koy)


func _son_goster(son: StringName) -> void:
	kayit.sil()
	Ses.cal(&"sfx_bar_kirildi" if son != &"zafer" else &"sfx_gece_bitti")
	var y := oturum.yonetim
	var son_metni := preload("res://src/sistemler/nihai_son.gd").son_metni(oturum, son, SancakTeftisi.son_metni(son))
	var metin := MuhafizEpilogu.metin(oturum, son, String(son_metni.metin)) + "\n\n" + tr("arayuz.son.istatistik") % [y.gun, y.kabul_sayisi, y.ret_sayisi, y.nufus()]
	var e := _bilgi(String(son_metni.baslik), metin, [tr("arayuz.son.yeniden"), tr("arayuz.son.menu")],
		oturum.gun, "3d_koy")
	e.oturum = oturum
	e.secildi.connect(_son_secimi)
	_goster(e)
	OdaTeftisNotu.son_kur(e, son)
	MuhafizEpiloguSunumu.kur(e)


func _perde_gecisi() -> void:
	var e := _bilgi(tr("arayuz.perde.baslik"), tr("arayuz.perde.metin"), [tr("arayuz.perde.devam")], -1, "3d_koy")
	e.oturum = oturum
	e.secildi.connect(func(_i: int) -> void: _kapiya_git())
	_goster(e)


func _son_secimi(i: int) -> void:
	if i == 0:
		yeni_oyun()
	else:
		ana_menu()


func _duraklat() -> void:
	if _ust != null:
		return
	var e := _bilgi(tr("arayuz.duraklat.baslik"), "", [tr("arayuz.duraklat.devam"), tr("arayuz.menu.ayarlar"), tr("arayuz.duraklat.menu"), tr("arayuz.duraklat.defter")], -1, "")
	e.secildi.connect(func(i: int) -> void:
		_ust_kapat()
		match i:
			1: _ayarlari_ac(_duraklat, true)
			2: ana_menu()
			3: HafizaDefteriBaglantisi.duraklatdan_ac(self)
	)
	_ust_ac(e)


func _ayarlari_ac(sonra: Callable, ustte: bool = false) -> void:
	var a := AyarlarEkrani.new()
	a.ayarlar = ayarlar
	if ustte:
		a.kapandi.connect(func() -> void:
			_ust_kapat()
			sonra.call()
		)
		_ust_ac(a)
	else:
		a.kapandi.connect(func() -> void: sonra.call())
		_goster(a)


func _ust_ac(e: Control) -> void:
	_ust = e
	add_child(e)
	if _ekran != null:
		_ekran.process_mode = Node.PROCESS_MODE_DISABLED


func _ust_kapat() -> void:
	if _ust != null:
		_ust.queue_free()
		_ust = null
	if _ekran != null:
		_ekran.process_mode = Node.PROCESS_MODE_INHERIT


func _bilgi(baslik: String, metin: String, dugmeler: Array, sayi: int = -1, arka: String = "3d_kapi") -> BilgiEkrani:
	var e := BilgiEkrani.new()
	e.ayarlar = ayarlar
	e.baslik = baslik
	e.metin = metin
	e.dugmeler = PackedStringArray(dugmeler)
	e.sayi = sayi
	e.sayi_etiketi = tr("arayuz.son.gun")
	e.arka_plan = arka
	return e


func _goster(e: Control) -> void:
	Ses.efektleri_temizle()
	_ust_kapat()
	if _ekran != null:
		preload("res://src/sistemler/kayit_gocu_soz.gd").oynanis_isaretle(_ekran, false)
		_ekran.queue_free()
	preload("res://src/sistemler/kayit_gocu_soz.gd").oynanis_isaretle(e, e is KoyEkrani or e is KapiEkrani)
	_ekran = e
	add_child(e)
	if e is KoyEkrani or e is KapiEkrani:
		preload("res://src/debug/performans_gunlugu.gd").bagla(self, oturum)
	var grafik := GrafikProfiliAdaptoru.new()
	grafik.ayarlar = ayarlar
	grafik.hedef = e
	e.add_child(grafik)
	# Köyde gece ortamı (cırcır, rüzgâr, uzak köpek); başka her yerde kapı meşalesi. Olay müziği ekranla biter.
	if e is KoyEkrani:
		e.ortam_baslat()
	else:
		Ses.ortam_cal(&"")
	Ses.muzik_cal(&"")


func _hata_goster() -> void:
	# Tablo bozuk olabileceği için bu metin koddadır (İçerik veri hattı, Open Question 2).
	var l := Label.new()
	l.text = "Oyun içeriği yüklenemedi.\n\n" + "\n".join(katalog.hatalar)
	l.position = Vector2(80, 80)
	add_child(l)


func _imleci_kur() -> void:
	var t := Sanat.doku("ui", "ui_cursor_arrow_32")
	if t != null:
		Input.set_custom_mouse_cursor(t, Input.CURSOR_ARROW)
		Input.set_custom_mouse_cursor(t, Input.CURSOR_POINTING_HAND)


## Girdi eylemleri (Girdi ve odak gezinmesi GDD, kural 1). Gezinme ve onay Godot'un ui_* eylemleridir.
func _eylemleri_kur() -> void:
	var tuslar := {
		"geri": [KEY_ESCAPE], "menu": [KEY_P],
		"kisayol_1": [KEY_1], "kisayol_2": [KEY_2], "kisayol_3": [KEY_3], "kisayol_4": [KEY_4], "kisayol_5": [KEY_5],
	}
	for eylem in tuslar:
		if InputMap.has_action(eylem):
			continue
		InputMap.add_action(eylem)
		for k in tuslar[eylem]:
			var o := InputEventKey.new()
			o.physical_keycode = k
			InputMap.action_add_event(eylem, o)
	var gamepad := {"geri": JOY_BUTTON_B, "menu": JOY_BUTTON_START}
	for eylem in gamepad:
		var j := InputEventJoypadButton.new()
		j.button_index = gamepad[eylem]
		InputMap.action_add_event(eylem, j)
