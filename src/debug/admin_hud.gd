## Global geliştirici konsolu; ayrı CanvasLayer, oyun durmaz.
class_name AdminHud
extends CanvasLayer

## SRM-04 / TEK-27: oyuncu surumu kriteri tek yerde. Gelistirici acilisi `--debug-arac` ile acilir; bayraksiz surecte oyuncu surumudur ve hicbir debug araci kurulmaz. Godot kullanici argumanlari `--` ayiricisindan sonra okunur (godot ... -- --debug-arac).
static func arac_acik(argumanlar: PackedStringArray = OS.get_cmdline_user_args()) -> bool:
	return argumanlar.has("--debug-arac")

const SATIR_SINIRI := 100
var baglam: Node
var panel: PanelContainer
var giris: LineEdit
var cikti: RichTextLabel
var durum: Label
var kapi_atla: Button
var zaman_dugmeleri: Array[Button] = []
var kaynak_paneli: KaynakEnjektoruPaneli
var npc_paneli: NpcCagirmaPaneli
var bayrak_paneli: BayrakDenetcisiPaneli
var performans: PerformansSeridi
var bina_paneli: BinaManipulasyonPaneli
var senaryo_paneli: SenaryoPaneli
var anlik_goruntu: AnlikGoruntuPaneli
var kasa_paneli: KasaDenetcisiPaneli
var iklim_paneli: IklimDenetcisiPaneli
var koylu_paneli: KoyluDenetcisiPaneli
var kriz_paneli: KrizPaneli
var diyalog_paneli: DiyalogDeneyiPaneli
var son_zaman_raporu: Dictionary = {}
var _zaman_calisiyor := false
var _gecmis: Array[String] = []
var _sure := 0.0
var _onceki_odak: WeakRef

func _ready() -> void:
	layer = 90
	process_mode = Node.PROCESS_MODE_ALWAYS
	panel = PanelContainer.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	panel.offset_top = -670
	panel.offset_left = 24
	panel.offset_right = -24
	panel.offset_bottom = -24
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(panel)
	var kutu := StyleBoxFlat.new()
	kutu.bg_color = Color(0.035, 0.045, 0.065, 0.97)
	kutu.border_color = Color("#b89c5c")
	kutu.set_border_width_all(2)
	kutu.set_content_margin_all(16)
	panel.add_theme_stylebox_override("panel", kutu)
	var dikey := VBoxContainer.new()
	panel.add_child(dikey)
	var bas := HBoxContainer.new()
	dikey.add_child(bas)
	var baslik := Label.new()
	baslik.text = "Geliştirici konsolu · F1 / ~"
	baslik.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bas.add_child(baslik)
	var kapat := Button.new()
	kapat.text = "Kapat"
	kapat.pressed.connect(func() -> void: ac(false))
	bas.add_child(kapat)
	var denetle := Button.new()
	denetle.text = "Flag / Clue"
	denetle.pressed.connect(func() -> void:
		diyalog_paneli.ac(false)
		kriz_paneli.ac(false)
		koylu_paneli.ac(false)
		kasa_paneli.ac(false)
		iklim_paneli.ac(false)
		bayrak_paneli.ac(not bayrak_paneli.visible))
	bas.add_child(denetle)
	var kasalar := Button.new()
	kasalar.text = "Kasalar"
	kasalar.pressed.connect(func() -> void:
		diyalog_paneli.ac(false)
		kriz_paneli.ac(false)
		koylu_paneli.ac(false)
		bayrak_paneli.ac(false)
		iklim_paneli.ac(false)
		kasa_paneli.ac(not kasa_paneli.visible))
	bas.add_child(kasalar)
	var iklim := Button.new()
	iklim.text = "İklim"
	iklim.pressed.connect(func() -> void:
		diyalog_paneli.ac(false)
		kriz_paneli.ac(false)
		koylu_paneli.ac(false)
		bayrak_paneli.ac(false)
		kasa_paneli.ac(false)
		iklim_paneli.ac(not iklim_paneli.visible))
	bas.add_child(iklim)
	var koyluler := Button.new()
	koyluler.text = "Köylüler"
	koyluler.pressed.connect(func() -> void:
		diyalog_paneli.ac(false)
		kriz_paneli.ac(false)
		bayrak_paneli.ac(false)
		kasa_paneli.ac(false)
		iklim_paneli.ac(false)
		koylu_paneli.ac(not koylu_paneli.visible))
	bas.add_child(koyluler)
	var kriz := Button.new()
	kriz.text = "Kriz"
	kriz.pressed.connect(func() -> void:
		bayrak_paneli.ac(false)
		kasa_paneli.ac(false)
		iklim_paneli.ac(false)
		koylu_paneli.ac(false)
		kriz_paneli.ac(not kriz_paneli.visible))
	bas.add_child(kriz)
	var diyalog := Button.new()
	diyalog.text = "Diyalog"
	diyalog.pressed.connect(func() -> void:
		bayrak_paneli.ac(false)
		kasa_paneli.ac(false)
		iklim_paneli.ac(false)
		koylu_paneli.ac(false)
		kriz_paneli.ac(false)
		diyalog_paneli.ac(not diyalog_paneli.visible))
	bas.add_child(diyalog)
	durum = Label.new()
	durum.add_theme_font_size_override("font_size", 20)
	dikey.add_child(durum)
	performans = PerformansSeridi.new()
	dikey.add_child(performans)
	kapi_atla = Button.new()
	kapi_atla.text = "Kapıyı bitir → Köy"
	kapi_atla.pressed.connect(_kapi_atla)
	dikey.add_child(kapi_atla)
	var zaman := HBoxContainer.new()
	dikey.add_child(zaman)
	for adet in [1, 5, 10]:
		var b := Button.new()
		b.text = "+%d gün" % adet
		b.tooltip_text = "Gece sonunu çalıştırır. Olay seçenekleri rastgele; mini oyun puanı 0. Kapı varışları üretilmez."
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.pressed.connect(_zamani_ilerlet.bind(adet))
		zaman.add_child(b)
		zaman_dugmeleri.append(b)
	kaynak_paneli = KaynakEnjektoruPaneli.new()
	kaynak_paneli.baglam = baglam
	kaynak_paneli.sonuc_alindi.connect(_kaynak_sonucu)
	dikey.add_child(kaynak_paneli)
	npc_paneli = NpcCagirmaPaneli.new()
	npc_paneli.baglam = baglam
	npc_paneli.sonuc_alindi.connect(_npc_sonucu)
	dikey.add_child(npc_paneli)
	bina_paneli = BinaManipulasyonPaneli.new()
	bina_paneli.baglam = baglam
	bina_paneli.sonuc_alindi.connect(_bina_sonucu)
	dikey.add_child(bina_paneli)
	senaryo_paneli = SenaryoPaneli.new()
	senaryo_paneli.baglam = baglam
	senaryo_paneli.sonuc_alindi.connect(_senaryo_sonucu)
	dikey.add_child(senaryo_paneli)
	anlik_goruntu = AnlikGoruntuPaneli.new()
	anlik_goruntu.baglam = baglam
	anlik_goruntu.sonuc_alindi.connect(_anlik_sonuc)
	dikey.add_child(anlik_goruntu)
	cikti = RichTextLabel.new()
	cikti.bbcode_enabled = false
	cikti.scroll_following = true
	cikti.size_flags_vertical = Control.SIZE_EXPAND_FILL
	cikti.custom_minimum_size = Vector2(0, 140)
	cikti.add_theme_font_size_override("normal_font_size", 20)
	dikey.add_child(cikti)
	giris = LineEdit.new()
	giris.placeholder_text = "yardim · durum · temizle"
	giris.text_submitted.connect(_komut)
	dikey.add_child(giris)
	yaz("Konsol hazır. Oyun zamanı konsol açıkken ilerlemeye devam eder.")
	bayrak_paneli = BayrakDenetcisiPaneli.new()
	bayrak_paneli.baglam = baglam
	bayrak_paneli.sonuc_alindi.connect(_bayrak_sonucu)
	add_child(bayrak_paneli)
	kasa_paneli = KasaDenetcisiPaneli.new()
	kasa_paneli.baglam = baglam
	kasa_paneli.sonuc_alindi.connect(_kasa_sonucu)
	add_child(kasa_paneli)
	iklim_paneli = IklimDenetcisiPaneli.new()
	iklim_paneli.baglam = baglam
	iklim_paneli.sonuc_alindi.connect(_iklim_sonucu)
	add_child(iklim_paneli)
	koylu_paneli = KoyluDenetcisiPaneli.new()
	koylu_paneli.baglam = baglam
	add_child(koylu_paneli)
	kriz_paneli = KrizPaneli.new()
	kriz_paneli.baglam = baglam
	kriz_paneli.sonuc_alindi.connect(func(r: Dictionary) -> void: yaz(r.get("mesaj", r.get("neden", ""))))
	add_child(kriz_paneli)
	diyalog_paneli = DiyalogDeneyiPaneli.new()
	diyalog_paneli.baglam = baglam
	diyalog_paneli.sonuc_alindi.connect(func(r: Dictionary) -> void: yaz(r.get("neden", "Tansiyon kilidi uygulandı.")))
	add_child(diyalog_paneli)
	ac(false)

func _input(olay: InputEvent) -> void:
	if not arac_acik():
		return
	if not olay is InputEventKey or not olay.pressed or olay.echo:
		return
	if olay.keycode in [KEY_F1, KEY_QUOTELEFT] or olay.unicode == 126:
		ac(not panel.visible)
		get_viewport().set_input_as_handled()
	elif panel.visible and olay.keycode == KEY_ESCAPE:
		ac(false)
		get_viewport().set_input_as_handled()

func ac(evet: bool) -> void:
	if panel.visible == evet and not evet:
		set_process(false)
		return
	if evet:
		var odak := get_viewport().gui_get_focus_owner()
		_onceki_odak = weakref(odak) if odak != null else null
	panel.visible = evet
	set_process(evet)
	performans.ac(evet)
	if evet:
		_durum_yenile()
		giris.grab_focus()
	else:
		diyalog_paneli.ac(false)
		kriz_paneli.ac(false)
		bayrak_paneli.ac(false)
		kasa_paneli.ac(false)
		giris.release_focus()
		iklim_paneli.ac(false)
		var odak: Object = _onceki_odak.get_ref() if _onceki_odak != null else null
		koylu_paneli.ac(false)
		if is_instance_valid(odak) and odak is Control and odak.is_visible_in_tree():
			odak.grab_focus()
		_onceki_odak = null

func _bayrak_sonucu(sonuc: Dictionary) -> void:
	if sonuc["ok"]:
		yaz("%s = %s (yalnız aktif ziyaret)." % [sonuc["anahtar"], sonuc["acik"]])
	else:
		yaz(sonuc["neden"])

func _kasa_sonucu(sonuc: Dictionary) -> void:
	if sonuc["ok"]:
		yaz("Kasalar · köy %d → %d · muhafız %d → %d · kişisel eşya %d → %d." % [sonuc["once"]["koy"], sonuc["sonra"]["koy"], sonuc["once"]["muhafiz"], sonuc["sonra"]["muhafiz"], sonuc["once"]["esya"], sonuc["sonra"]["esya"]])
		if not sonuc["kaydedildi"]: yaz("Değişiklik uygulandı; güvenli kayıt yazılamadı.")
	else: yaz(sonuc["neden"])
	_durum_yenile()

func _iklim_sonucu(sonuc: Dictionary) -> void:
	if sonuc["ok"]:
		yaz("İklim · mevsim %d · %s · gıda ×%.1f / odun ×%.1f; gün ilerlemedi." % [sonuc["mevsim"], sonuc["hava"], sonuc["gida"], sonuc["odun"]])
		if not sonuc["kaydedildi"]: yaz("İklim değişti; güvenli kayıt yazılamadı.")
	else: yaz(sonuc["neden"])

func _process(delta: float) -> void:
	_sure += delta
	if _sure >= 0.5:
		_sure = 0.0
		_durum_yenile()

func _durum_yenile() -> void:
	var o: Oturum = baglam.get("oturum") if is_instance_valid(baglam) else null
	durum.text = "Oturum yok · FPS %d" % Engine.get_frames_per_second()
	if o != null:
		durum.text = "Gün %d · Köy akçesi %d · Muhafız kesesi %d · FPS %d" % [o.gosterilen_gece(), o.koy_akce, o.muhafiz_akce, Engine.get_frames_per_second()]
	kapi_atla.disabled = not KapiAtlamaAdaptoru.uygun(baglam)
	for b in zaman_dugmeleri:
		b.disabled = _zaman_calisiyor or not ZamanMakinesi.uygun(baglam)
	kaynak_paneli.yenile()
	npc_paneli.yenile()
	bina_paneli.yenile()
	senaryo_paneli.yenile()
	anlik_goruntu.yenile()

func _anlik_sonuc(sonuc: Dictionary) -> void:
	if sonuc["ok"]:
			yaz("Kayıt noktası: gün %d %s.%s" % [sonuc["gun"] + 1, sonuc["islem"], " Yedek kullanıldı." if sonuc.get("yedekten", false) else ""])
	else:
		yaz(sonuc["neden"])
	_durum_yenile()

func _senaryo_sonucu(sonuc: Dictionary) -> void:
	if not sonuc["ok"]:
		yaz(sonuc["neden"])
		return
	yaz("Senaryo %s · %d/%d gece · sonuç %s." % [sonuc["senaryo"], sonuc["gecen"], sonuc["istenen"], sonuc["son"] if sonuc["son"] != "" else "köy devam ediyor"])
	for kayip: Dictionary in sonuc["kayiplar"]:
		yaz("Kıtlık gece %d: %d gıda kaybı (üretim sonrası)." % [kayip["gun"] + 1, kayip["gida_kaybi"]])
	if sonuc["hazirlik"].has("hasta_koylu"):
		yaz("Salgın test girdisi: %d köylüye hasta bayrağı ve −40 sağlık; normal gece iyileşmesi/ölümü çalıştı." % sonuc["hazirlik"]["hasta_koylu"])
	for kayit: Dictionary in sonuc["raporlar"]:
		var r: Dictionary = kayit["rapor"]
		yaz("Gece %d · üretim %s · tüketim %s · ölenler %s · huzur %d" % [r["gun"] + 1, r["uretim"], r["tuketim"], r["olenler"], r["huzur"]])
		for olay: Dictionary in r["olaylar"]:
			yaz("Olay: %s · %s" % [olay["anahtar"], olay.get("deger", [])])
	if sonuc["bekleyen_olay"] != null:
		yaz("Geçerli seçenek bulunamadı; gerçek olay kartı açık bırakıldı.")
	_durum_yenile()

func _bina_sonucu(sonuc: Dictionary) -> void:
	if sonuc["ok"]:
		yaz(sonuc["mesaj"] if sonuc.has("mesaj") else "%d inşaat tamamlandı; gün ilerlemedi." % sonuc["tamamlanan"].size())
		if not sonuc["kaydedildi"]:
			yaz("İnşaatlar tamamlandı; güvenli kayıt yazılamadı.")
	else:
		yaz(sonuc["neden"])
	_durum_yenile()

func _npc_sonucu(sonuc: Dictionary) -> void:
	if sonuc["ok"]:
		yaz("%s kuyruğun önüne %s; mevcut sorgu korunuyor." % [sonuc["id"], "taşındı" if sonuc["tasindi"] else "eklendi"])
	else:
		yaz(sonuc["neden"])
	_durum_yenile()

func _kaynak_sonucu(sonuc: Dictionary) -> void:
	if sonuc["ok"]:
		yaz("%s: %d → %d (uygulanan %+d)." % [sonuc["alan"], sonuc["once"], sonuc["sonra"], sonuc["fark"]])
		if not sonuc["kaydedildi"]:
			yaz("Yerel değişiklik uygulandı; güvenli kayıt yazılamadı.")
	else:
		yaz(sonuc["neden"])
	_durum_yenile()

func _zamani_ilerlet(adet: int) -> void:
	if _zaman_calisiyor:
		return
	_zaman_calisiyor = true
	_durum_yenile()
	son_zaman_raporu = ZamanMakinesi.uygula(baglam, adet)
	if son_zaman_raporu["ok"]:
		yaz("Zaman: %d/%d gün ilerledi → gün %d." % [son_zaman_raporu["gecen"], adet, son_zaman_raporu["gun"] + 1])
		for kayit: Dictionary in son_zaman_raporu["raporlar"]:
			var r: Dictionary = kayit["rapor"]
			yaz("Gece %d · üretim %s · tüketim %s · akçe %d→%d · huzur %d" % [r["gun"] + 1, r["uretim"], r["tuketim"], r["akce_once"], r["akce"], r["huzur"]])
			if kayit["olay_id"] != "":
				yaz("Olay %s · seçenek %d · mini oyun puanı %d" % [kayit["olay_id"], kayit["secenek"] + 1, kayit["mini_oyun_puan"]])
		if son_zaman_raporu["son"] != "":
			yaz("Simülasyon durdu: " + son_zaman_raporu["son"])
		elif son_zaman_raporu["bekleyen_olay"] != null:
			yaz("Simülasyon durdu: gece olayının geçerli seçeneği yok; olay ekranı açıldı.")
	else:
		yaz(son_zaman_raporu["neden"])
	_zaman_calisiyor = false
	_durum_yenile()

func _kapi_atla() -> void:
	var sonuc := KapiAtlamaAdaptoru.atla(baglam)
	if sonuc["ok"]:
		yaz("Kapı tamamlandı: %d kişi · %d kabul / %d ret. Köy yönetimi açıldı." % [sonuc["toplam"], sonuc["kabul"], sonuc["ret"]])
	else:
		yaz(sonuc["neden"])
	_durum_yenile()

func yaz(metin: String) -> void:
	_gecmis.append(metin)
	while _gecmis.size() > SATIR_SINIRI:
		_gecmis.pop_front()
	cikti.text = "\n".join(_gecmis)

func _komut(metin: String) -> void:
	giris.clear()
	var komut := metin.strip_edges().to_lower()
	if komut == "":
		return
	match komut:
		"yardim", "help":
			yaz("yardim: komutlar · durum: mevcut oturum · temizle: konsol geçmişi")
		"durum":
			_durum_yenile()
			yaz(durum.text)
		"temizle", "clear":
			_gecmis.clear()
			cikti.text = ""
		_:
			yaz("Bilinmeyen komut: " + metin + " · yardim yaz.")
