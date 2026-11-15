## Yalnız Codex-Berk'in sahiplendiği GRV dosyaları için tema kabulü.
extends Node

const GRUPLAR := {
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
	if grup == "GRV-17":
		await _odak()
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
	get_tree().quit(0 if _hata == 0 else 1)


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


func _kontrol(durum: bool, mesaj: String) -> void:
	if not durum:
		_hata += 1
		push_error(mesaj)
