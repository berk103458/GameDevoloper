## Bölüm 35 ek ayarları (AYR-02, AYR-05, AYR-22, AYR-43, AYR-44, AYR-46): çekirdek `ayarlar.gd` değişmez.
## Bu bölümün yeni anahtarları `VARSAYILAN` ve `GECERLI` listelerinde durur ve açılışta
## `Ayarlar.degerler` sözlüğüne birleştirilir; `Ayarlar.al()` ek anahtarı da okur.
## Geçersiz değer o anahtarın varsayılanına döner, tek satır günlük yazılır (AYR-44).
class_name AyarlarEk
extends RefCounted

const SURUM := 1

## Bu bölümün yeni anahtarları ve varsayılanları.
const VARSAYILAN := {
	&"satir_araligi": &"normal",
	&"metin_agirligi": 400,
	&"koy_hizi_varsayilan": 1,
	&"arka_planda_sustur": true,
	&"otomatik_kayit": &"her_gece",
	&"ipuclari": true,
	&"kademeli_hud": true,
	&"okunmus_isaret": true,
	&"renk_paleti": &"olagan",
	&"yuksek_kontrast": false,
	&"hareket_azalt": false,
	&"odak_cercevesi": &"normal",
	&"pencere_boyutu": &"1600x900",
	&"vsync": true,
	&"kare_siniri": 0,
	&"rapor_bekle": true,
	&"olayda_duraklat": false,
	&"karar_onayi": false,
	&"zorluk": &"olagan",
}
## Seçenekli ek anahtarların geçerli değerleri.
const GECERLI := {
	&"satir_araligi": [&"normal", &"genis"],
	&"metin_agirligi": [400, 500],
	&"koy_hizi_varsayilan": [1, 2, 3],
	&"arka_planda_sustur": [true, false],
	&"otomatik_kayit": [&"her_gece", &"uc_gecede_bir", &"kapali"],
	&"ipuclari": [true, false],
	&"kademeli_hud": [true, false],
	&"okunmus_isaret": [true, false],
	&"renk_paleti": [&"olagan", &"deuteranopi", &"protanopi", &"tritanopi"],
	&"yuksek_kontrast": [true, false],
	&"hareket_azalt": [true, false],
	&"odak_cercevesi": [&"normal", &"kalin"],
	&"pencere_boyutu": [&"1280x720", &"1600x900", &"1920x1080"],
	&"vsync": [true, false],
	&"kare_siniri": [0, 30, 60],
	&"rapor_bekle": [true, false],
	&"olayda_duraklat": [true, false],
	&"karar_onayi": [true, false],
	&"zorluk": [&"kolay", &"olagan", &"siki"],
}
## AYR-07: Çekirdek liste 100/125/150 kalır; 175 yalnız bu dosyadan eklenir.
const METIN_OLCEKLERI := [100, 125, 150, 175]
## AYR-05: Sekme başına sıfırlanacak anahtar kümeleri.
const SEKME_ANAHTARLARI := {
	&"oyun": [&"koy_hizi_varsayilan", &"kamera_eksen_ters", &"otomatik_kayit", &"ipuclari", &"kademeli_hud", &"olayda_duraklat", &"rapor_bekle", &"karar_onayi", &"zorluk"],
	&"goruntu": [&"ekran_modu", &"grafik_profili", &"cozunurluk_3d", &"pencere_boyutu", &"vsync", &"kare_siniri", &"renk_paleti", &"yuksek_kontrast", &"hareket_azalt", &"odak_cercevesi"],
	&"okuma": [&"metin_olcegi", &"belirme_hizi", &"satir_araligi", &"metin_agirligi", &"okunmus_isaret"],
	&"ses": [&"ses_ana", &"ses_muzik", &"ses_efekt", &"arka_planda_sustur"],
}

## AYR-44 günlüğü: reddedilen her değer için bir satır; `_reddet()` doldurur.
static var gecersizler: Array[String] = []


## Açılışta çağrılır (ana.gd tek satır): ek varsayılanları birleştirir, dosyadaki ek değerleri
## doğrulayarak üzerine yazar. Geçersiz değer varsayılanda kalır ve loglanır.
## AYR-43: `surum` anahtarı ve ileri sürümdeki bilinmeyen anahtarlar atılmaz, korunur.
static func bagla(a: Ayarlar, cli_argumanlar: PackedStringArray = PackedStringArray()) -> void:
	gecersizler.clear()
	if not a.degerler.has(&"surum"):
		a.degerler[&"surum"] = SURUM
	for anahtar in VARSAYILAN:
		if not a.degerler.has(anahtar):
			a.degerler[anahtar] = VARSAYILAN[anahtar]
	if FileAccess.file_exists(a.yol):
		var cfg := ConfigFile.new()
		var onceki := Engine.print_error_messages
		Engine.print_error_messages = false
		var sonuc := cfg.load(a.yol)
		Engine.print_error_messages = onceki
		if sonuc == OK and cfg.has_section("ayarlar"):
			for anahtar in cfg.get_section_keys("ayarlar"):
				var k := StringName(anahtar)
				var v: Variant = cfg.get_value("ayarlar", anahtar)
				if k == &"surum":
					if v is int and int(v) >= 1:
						a.degerler[&"surum"] = int(v)
					continue
				if VARSAYILAN.has(k):
					if _gecerli(k, v):
						a.degerler[k] = _donustur(v)
					else:
						_reddet(k, v)
				elif not Ayarlar.VARSAYILAN.has(k):
					# AYR-43: İleri sürüm uyumu için bilinmeyen anahtar atılmaz, saklanır.
					a.degerler[k] = v
	_olcegi_dosyadan(a)
	if not cli_argumanlar.is_empty():
		argumanlari_uygula(a, cli_argumanlar)
	uygula_ek(a)


## Ek anahtarı değiştirir ve hemen uygular (çekirdek `Ayarlar.ayarla` ek anahtarı bilmez).
## Geçersiz değer reddedilir, değer değişmez; `true` döner yalnız değer kabul edildiğinde.
static func ayarla(a: Ayarlar, anahtar: StringName, deger: Variant) -> bool:
	if anahtar == &"metin_olcegi":
		return _olcek_ayarla(a, deger)
	if not _gecerli(anahtar, deger):
		_reddet(anahtar, deger)
		return false
	var eski: Variant = a.degerler.get(anahtar, null)
	var yeni: Variant = _donustur(deger)
	a.degerler[anahtar] = yeni
	a.uygula()
	uygula_ek(a)
	a.degisti.emit(anahtar)
	preload("res://src/debug/tester_izi.gd").ayar(anahtar, eski, yeni)
	return true


## AYR-05: Yalnız belirtilen sekmenin anahtarlarını varsayılana döndürür; onay ister.
static func sekme_sifirla(a: Ayarlar, sekme: StringName, onaylandi: bool = true) -> bool:
	if a == null or not onaylandi or not SEKME_ANAHTARLARI.has(sekme):
		return false
	var liste: Array = SEKME_ANAHTARLARI[sekme]
	for k in liste:
		var anahtar := k as StringName
		if Ayarlar.VARSAYILAN.has(anahtar):
			a.degerler[anahtar] = Ayarlar.VARSAYILAN[anahtar]
		elif VARSAYILAN.has(anahtar):
			a.degerler[anahtar] = VARSAYILAN[anahtar]
	a.uygula()
	a.degisti.emit(sekme)
	return true


## AYR-31: Gece sonu otomatik kayit kosulunu denetler (`her_gece`, `uc_gecede_bir`, `kapali`).
static func otomatik_kayit_yazilmali_mi(a: Ayarlar, gece_no: int) -> bool:
	var mod: StringName = &"her_gece"
	if a != null:
		var ham: Variant = a.al(&"otomatik_kayit")
		if ham != null:
			mod = StringName(ham)
	if mod == &"kapali":
		return false
	if mod == &"uc_gecede_bir":
		return gece_no > 0 and (gece_no % 3 == 0)
	return true


static func _eski_kalan() -> bool:
	return true


## AYR-46: `--ayar anahtar=deger` komut satırı argümanını yalnız bu oturum için uygular;
## `a.yaz()` çağrılsa bile asıl ayar dosyası değişmez.
static func argumanlari_uygula(a: Ayarlar, argumanlar: PackedStringArray = OS.get_cmdline_args()) -> int:
	if a == null:
		return 0
	var uygulanan := 0
	var i := 0
	while i < argumanlar.size():
		var arg := String(argumanlar[i]).strip_edges()
		var cift := ""
		if arg == "--ayar" and i + 1 < argumanlar.size():
			cift = String(argumanlar[i + 1]).strip_edges()
			i += 2
		elif arg.begins_with("--ayar="):
			cift = arg.substr("--ayar=".length()).strip_edges()
			i += 1
		else:
			i += 1
			continue
		var esit := cift.find("=")
		if esit <= 0:
			continue
		var anahtar := StringName(cift.substr(0, esit).strip_edges())
		var ham_deger := cift.substr(esit + 1).strip_edges()
		var deger: Variant = _metin_deger_coz(ham_deger)
		if _anahtar_gecerli_mi(a, anahtar, deger):
			if not a.has_meta(&"gercek_yol"):
				a.set_meta(&"gercek_yol", a.yol)
				a.yol = a.yol + ".cli_gecici"
			a._pasif[anahtar] = deger
			a.degerler[anahtar] = _donustur(deger)
			uygulanan += 1
	if uygulanan > 0:
		a.uygula()
	return uygulanan


static func _anahtar_gecerli_mi(a: Ayarlar, anahtar: StringName, deger: Variant) -> bool:
	if anahtar == &"metin_olcegi":
		return _olcek_tam(deger) in METIN_OLCEKLERI
	if VARSAYILAN.has(anahtar):
		return _gecerli(anahtar, deger)
	if Ayarlar.VARSAYILAN.has(anahtar):
		return a._gecerli(anahtar, deger)
	return false


static func _metin_deger_coz(metin: String) -> Variant:
	if metin == "true":
		return true
	if metin == "false":
		return false
	if metin.is_valid_int():
		return metin.to_int()
	return StringName(metin)


## Ek anahtarın geçerli değerler listesi; bilinmeyen anahtar geçersizdir.
static func _gecerli(anahtar: StringName, deger: Variant) -> bool:
	if not GECERLI.has(anahtar):
		return false
	var liste: Array = GECERLI[anahtar]
	return _donustur(deger) in liste


static func _donustur(deger: Variant) -> Variant:
	return StringName(deger) if deger is String else deger


## AYR-07: 175 çekirdek `yukle()` tarafından reddedilirse dosyadan geri yazılır.
static func _olcegi_dosyadan(a: Ayarlar) -> void:
	if a == null or not FileAccess.file_exists(a.yol):
		return
	var cfg := ConfigFile.new()
	var onceki := Engine.print_error_messages
	Engine.print_error_messages = false
	var sonuc := cfg.load(a.yol)
	Engine.print_error_messages = onceki
	if sonuc != OK or not cfg.has_section_key("ayarlar", "metin_olcegi"):
		return
	var olcek := _olcek_tam(cfg.get_value("ayarlar", "metin_olcegi"))
	if olcek in METIN_OLCEKLERI:
		a.degerler[&"metin_olcegi"] = olcek


static func _olcek_ayarla(a: Ayarlar, deger: Variant) -> bool:
	var olcek := _olcek_tam(deger)
	if olcek not in METIN_OLCEKLERI:
		_reddet(&"metin_olcegi", deger)
		return false
	var eski: Variant = a.degerler.get(&"metin_olcegi", null)
	a.degerler[&"metin_olcegi"] = olcek
	a.uygula()
	uygula_ek(a)
	a.degisti.emit(&"metin_olcegi")
	preload("res://src/debug/tester_izi.gd").ayar(&"metin_olcegi", eski, olcek)
	return true


static func _olcek_tam(deger: Variant) -> int:
	if deger is String and String(deger).is_valid_int():
		return int(deger)
	if deger is StringName and String(deger).is_valid_int():
		return int(String(deger))
	if deger is float and deger == floorf(float(deger)):
		return int(deger)
	if deger is int:
		return int(deger)
	return -1


## Pencere, kare sınırı ve hareket azaltma çekirdek `uygula()` dışında uygulanır.
static func uygula_ek(a: Ayarlar) -> void:
	if a == null:
		return
	var sinir := int(a.degerler.get(&"kare_siniri", 0))
	Engine.max_fps = sinir
	preload("res://src/sistemler/hareket_azalt.gd").guncelle(a)
	if DisplayServer.get_name() == "headless":
		return
	var vsync_acik := bool(a.degerler.get(&"vsync", true))
	var mod := DisplayServer.VSYNC_ENABLED if vsync_acik else DisplayServer.VSYNC_DISABLED
	if DisplayServer.window_get_vsync_mode() != mod:
		DisplayServer.window_set_vsync_mode(mod)
	if a.degerler.get(&"ekran_modu", &"tam_ekran") != &"pencere":
		return
	var olcu := String(a.degerler.get(&"pencere_boyutu", &"1600x900")).split("x")
	if olcu.size() == 2 and olcu[0].is_valid_int() and olcu[1].is_valid_int():
		DisplayServer.window_set_size(Vector2i(int(olcu[0]), int(olcu[1])))


## Tek satır günlük (AYR-44): satır listeye yazılır ve hata olarak basılır.
static func _reddet(anahtar: StringName, deger: Variant) -> void:
	var satir := "Geçersiz ayar %s=%s; varsayılan kullanılıyor" % [anahtar, deger]
	gecersizler.append(satir)
	push_warning(satir)
