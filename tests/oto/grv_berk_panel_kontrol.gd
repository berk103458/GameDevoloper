## Yalnız Codex-Berk'in sahiplendiği GRV dosyaları için tema kabulü.
extends Node

const GRUPLAR := {
	"GRV-34": ["res://src/arayuz/esya_karti.gd"],
	"GRV-38": ["res://src/arayuz/koy_atama_alani.gd"],
	"GRV-101": ["res://src/kapi/hastalik_teshis_adaptoru.gd"],
	"GRV-54": ["res://src/kapi/divan_kanit_karti.gd"],
	"GRV-50": ["res://src/kapi/divan_ekrani.gd"],
	"GRV-36": ["res://src/arayuz/koy_ekrani.gd"],
	"GRV-31": ["res://src/arayuz/chr_diyalog_paneli.gd"],
	"GRV-64": ["res://src/arayuz/koy_hud/kuyu_kirecleme_paneli.gd"],
	"GRV-63": ["res://src/arayuz/koy_hud/kundak_clue_bilgisi.gd"],
	"GRV-62": ["res://src/arayuz/koy_hud/kese_gostergesi.gd"],
	"GRV-60": ["res://src/arayuz/koy_hud/histeri_paneli.gd"],
	"GRV-59": ["res://src/arayuz/koy_hud/hekim_ilac_bilgisi.gd"],
	"GRV-58": ["res://src/arayuz/koy_hud/harita_baglantisi.gd"],
	"GRV-57": ["res://src/arayuz/koy_hud/cinar_meclis_paneli.gd"],
	"GRV-56": ["res://src/arayuz/koy_hud/cati_kar_bilgisi.gd"],
	"GRV-55": ["res://src/arayuz/koy_hud/ambar_kapisi_paneli.gd"],
	"GRV-53": ["res://src/kapi/divan_haksizlik_paneli.gd"],
	"GRV-52": ["res://src/kapi/divan_hukum_paneli.gd"],
	"GRV-51": ["res://src/kapi/divan_sorgu_paneli.gd"],
	"GRV-49": ["res://src/arayuz/kapi/kapi_gorus_adaptoru.gd"],
	"GRV-47": ["res://src/arayuz/okculuk_oyunu.gd"],
	"GRV-46": ["res://src/arayuz/harman_oyunu.gd"],
	"GRV-24": ["res://src/arayuz/hafiza_defteri_ekrani.gd"],
	"GRV-17": [],
	"GRV-09": [
		"res://src/arayuz/koy_hud/pazar_satis_paneli.gd",
		"res://src/arayuz/koy_hud/ticaret_fiyat_paneli.gd",
		"res://src/arayuz/koy_hud/pazar_kart_kaydirma.gd",
	],
}

var _hata := 0


func _ready() -> void:
	get_tree().create_timer(60).timeout.connect(func() -> void: get_tree().quit(1))
	var args := OS.get_cmdline_user_args()
	var grup := args[0] if args.size() > 0 else ""
	_kontrol(GRUPLAR.has(grup), "bilinen madde seçilmeli")
	if grup in ["GRV-46", "GRV-47"]:
		await _mini(grup)
	if grup == "GRV-17":
		await _odak()
	if grup == "GRV-24":
		_defter()
	if grup == "GRV-49":
		_gorus()
	if grup in ["GRV-34", "GRV-48", "GRV-61", "GRV-70", "GRV-94"]:
		await _ortak_kart(grup)
	var kaynaklar := _kaynaklar("res://src")
	var ihlal := RegEx.create_from_string("\\bColor\\s*\\(|\\bColor8\\s*\\(|Color\\.from_|Color\\.html|ColorRect\\.new|StyleBoxFlat\\.new|add_theme_stylebox_override|font_size[\\\"']\\s*,\\s*\\d")
	for yol in GRUPLAR.get(grup, []):
		var betik := load(yol) as Script
		_kontrol(betik != null and betik.can_instantiate(), "%s yüklenir" % yol)
		var metin := FileAccess.get_file_as_string(yol)
		var i := 0
		for satir in metin.split("\n"):
			i += 1
			if not satir.strip_edges().begins_with("#"):
				_kontrol(ihlal.search(satir) == null, "%s:%d yerel stil: %s" % [yol, i, satir])
		var ad := String(betik.get_global_name()) if betik != null else ""
		var cagriliyor := false
		for diger in kaynaklar:
			if diger != yol and ((not ad.is_empty() and kaynaklar[diger].contains(ad)) or kaynaklar[diger].contains(String(yol).get_file())):
				cagriliyor = true
		_kontrol(cagriliyor, "%s oyun kaynağında çağrılır" % yol)
	var tema := Tema.olustur(Ayarlar.new("user://grv_berk_kullanilmaz.cfg"))
	for durum in ["normal", "hover", "pressed", "disabled"]:
		_kontrol(tema.has_stylebox(durum, "Button"), "tema düğme durumu " + durum)
	print("%s %s (%d hata)" % [grup, "GEÇTİ" if _hata == 0 else "KALDI", _hata])
	await Ses.cik(0 if _hata == 0 else 1)


func _kaynaklar(kok: String) -> Dictionary:
	var sonuc := {}
	var dizin := DirAccess.open(kok)
	if dizin == null:
		return sonuc
	for alt in dizin.get_directories():
		sonuc.merge(_kaynaklar(kok.path_join(alt)))
	for dosya in dizin.get_files():
		if dosya.ends_with(".gd") or dosya.ends_with(".tscn"):
			sonuc[kok.path_join(dosya)] = FileAccess.get_file_as_string(kok.path_join(dosya))
	return sonuc


func _odak() -> void:
	var palet = preload("res://src/arayuz/renk_paleti.gd")
	var ayar := Ayarlar.new("user://grv17_kullanilmaz.cfg")
	AyarlarEk.bagla(ayar)
	var kok := Control.new()
	add_child(kok)
	var bir := Button.new()
	var iki := Button.new()
	kok.add_child(bir)
	kok.add_child(iki)
	for deger in [&"normal", &"kalin", &"normal"]:
		_kontrol(AyarlarEk.ayarla(ayar, &"odak_cercevesi", deger), "AYR değeri kabul edildi")
		kok.theme = Tema.olustur(ayar)
		palet.uygula(kok.theme, ayar)
		await get_tree().process_frame
		var odak := bir.get_theme_stylebox("focus") as StyleBoxFlat
		_kontrol(odak != null, "AYR odak stili var")
		if odak != null:
			_kontrol(odak == iki.get_theme_stylebox("focus"), "iki düğme aynı odak kaynağını okur")
			_kontrol(odak.border_width_left == (3 if deger == &"kalin" else 1), "odak kalınlığı AYR anahtarından gelir")
			_kontrol(not odak.draw_center, "odak içeriği örtmez")
			_kontrol(odak.border_color == palet.metin_rengi(ayar), "ikinci çerçeve rengi yok")
	kok.free()


func _defter() -> void:
	var ayar := Ayarlar.new("user://grv24_kullanilmaz.cfg")
	var kok := Control.new()
	kok.theme = Tema.olustur(ayar)
	add_child(kok)
	var defter := HafizaDefteriEkrani.new()
	defter.ayarlar = ayar
	kok.add_child(defter)
	var paneller := defter.get_children().filter(func(n: Node) -> bool: return n is PanelContainer)
	_kontrol(not paneller.is_empty(), "hafıza defteri kabuğu mevcut")
	for panel in paneller:
		if panel.has_meta(&"defter_aday"):
			# Mevcut seçilmiş sayfa dokusu palet değildir; aday tercihi korunur.
			var stil := panel.get_theme_stylebox("panel") as StyleBoxTexture
			_kontrol(stil != null and stil.texture != null, "mevcut defter sayfa dokusu korunur")
		else:
			_kontrol(not panel.has_theme_stylebox_override("panel"), "defter yerel palet/stil açmaz: " + String(panel.get_path()))
			_kontrol(panel.get_theme_stylebox("panel") == kok.theme.get_stylebox("panel", "PanelContainer"), "defter ortak panel kaynağını miras alır: " + String(panel.get_path()))
	kok.free()


func _kontrol(durum: bool, mesaj: String) -> void:
	if not durum:
		_hata += 1
		push_error(mesaj)


func _mini(grup: String) -> void:
	var ayar := Ayarlar.new("user://grv_mini_kullanilmaz.cfg")
	var oyun := OyunAyarlari.new()
	var kok := Control.new()
	kok.theme = Tema.olustur(ayar)
	add_child(kok)
	var m := MiniOyun.olustur(&"harman" if grup == "GRV-46" else &"okculuk", ayar, oyun)
	_kontrol(m != null, "fabrika gercek mini oyunu kurar")
	kok.add_child(m)
	m.set_process(false)
	_kontrol(m._alan != null and m._durum != null, "mini oyun kadraji bagli")
	if m is HarmanOyunu:
		m._t = m._vurus[0]
		m.bas()
		_kontrol(m.puan == 1 and m._vuruldu[0], "harman gercek isabet puan verir")
		m._t = m._vurus[1] + oyun.harman_tolerans + 0.01
		m._ilerle(0.01)
		_kontrol(m.puan == 1 and m._vuruldu[1], "kacan vurus puan vermez")
	else:
		m._konum = Vector2.ZERO
		m.bas()
		_kontrol(m.puan == 2 and m._ok == 1, "okculuk merkez iki puan verir")
		m._ilerle(1.0)
		m._konum = Vector2(2, 2)
		m.bas()
		_kontrol(m.puan == 2 and m._ok == 2, "iska puan vermez")
	await get_tree().process_frame
	kok.free()


func _gorus() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var o := Oturum.new(katalog, 84)
	var kok := VBoxContainer.new()
	kok.theme = Tema.olustur(Ayarlar.new("user://grv49_kullanilmaz.cfg"))
	add_child(kok)
	var portre := TextureButton.new()
	portre.name = "GorselIz"
	kok.add_child(portre)
	IklimDeneyi.degistir(o, -1, "kar_firtinasi")
	KapiGorusAdaptoru.uygula(kok, o.yonetim)
	var uyari := kok.get_node_or_null("KapiGorusUyarisi") as Label
	_kontrol(uyari != null and uyari.visible, "tipi uyarısı gerçek adaptörden gelir")
	if uyari != null:
		_kontrol(uyari.get_theme_font_size("font_size") == Kabuk.KUCUK, "uyarı ortak küçük puntoyu okur")
	var mat := portre.material as ShaderMaterial
	_kontrol(mat != null and mat.get_shader_parameter("yaricap") == 4.0, "tipi aynı shader değerini korur")
	IklimDeneyi.degistir(o, -1, "normal")
	KapiGorusAdaptoru.uygula(kok, o.yonetim)
	_kontrol(portre.material == null and not uyari.visible, "normal hava materyali geri yükler")
	kok.free()


func _ortak_kart(grup: String) -> void:
	var kok := Control.new()
	kok.theme = Tema.olustur(Ayarlar.new("user://grv_kart_kullanilmaz.cfg"))
	add_child(kok)
	if grup == "GRV-34":
		var kart := EsyaKarti.new()
		kart.esya = {"id": "akce", "tur": "akce", "adet": 3, "gizli": false, "alinan": 1}
		kok.add_child(kart)
		_kontrol(kart.get_child_count() == 2 and kart.flat, "eşya kartının adet düğmeleri korunur")
		var sonuc := [0]
		kart.adet_istendi.connect(func(d: int) -> void: sonuc[0] += d)
		(kart.get_child(1) as Button).pressed.emit()
		_kontrol(sonuc[0] == 1, "adet düğmesi aynı sinyali yollar")
		for durum in ["normal", "hover", "pressed", "disabled", "focus"]:
			_kontrol(not kart.has_theme_stylebox_override(durum), "eşya kartı yerel stil açmaz: " + durum)
	elif grup == "GRV-48":
		var t := preload("res://src/arayuz/kapi/tansiyon_gostergesi.gd").new()
		kok.add_child(t)
		for deger in [0, 4, 8, 10]:
			t.guncelle(deger, deger == 10)
			_kontrol(t.bar.value == deger and t.etiket.text.contains(str(deger)), "tansiyon değeri ve açıklaması korunur")
			_kontrol(not t.bar.has_theme_stylebox_override("fill"), "tansiyon dolgusu ortak temadan gelir")
		_kontrol(t.etiket.text.contains("kabul kapalı"), "kilit açıklaması korunur")
	elif grup == "GRV-61":
		var k := KaynakGostergesi.new()
		k.kur("gida", Kabuk.KUCUK)
		kok.add_child(k)
		_kontrol(not k.has_theme_stylebox_override("panel"), "kaynak kartı yerel panel stili açmaz")
		for net in [2, 0, -2]:
			k.guncelle(10, net)
			_kontrol(k._miktar.text == "10", "kaynak miktarı korunur")
			_kontrol(k._net.get_theme_color("font_color") == (Kabuk.MORAL if net > 0 else Hud.UYARI if net < 0 else Kabuk.SOLUK), "net değişim rengi ortak kaynaktan gelir")
	elif grup == "GRV-70":
		var katalog := Katalog.new()
		katalog.yukle()
		var o := Oturum.new(katalog, 84)
		var k := YapiKarti.new()
		kok.add_child(k)
		k.kur("kulube", o.yonetim, Ayarlar.new("user://grv70_kullanilmaz.cfg"))
		for durum in ["normal", "hover", "pressed", "disabled", "focus"]:
			_kontrol(not k.has_theme_stylebox_override(durum), "yapı kartı ortak stili miras alır: " + durum)
		_kontrol(k.has_meta("yapi_turu") and k.find_child("YapiKademeBilgisi", true, false) != null, "yapı kimliği ve kademe bilgisi korunur")
	elif grup == "GRV-94":
		for tur in ["saman", "su", "kumas"]:
			var r := TextureRect.new()
			kok.add_child(r)
			_kontrol(GezginStokIkonu.ikon(r, tur), "stok ikonu bağlı: " + tur)
			var c := r.get_child(0) as ColorRect
			_kontrol(c.has_meta("kabuk_yer_tutucu") and c.mouse_filter == Control.MOUSE_FILTER_IGNORE, "stok kutusu ortak fabrikadan gelir")
	await get_tree().process_frame
	kok.free()
