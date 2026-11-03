## GIR-01…20: eylemler çalışma anında kurulur. Atama `ayarlar.cfg` içindeki `girdi`
## bölümündedir; `project.godot` `[input]` açılmaz, oyun kaydına yazılmaz.
class_name GirdiEylemleri
extends RefCounted

const VERI := "res://data/girdi.json"
const BOLUM := "girdi"

const YEDEK_KLAVYE := {
	"geri": "escape", "menu": "f10",
	"kisayol_1": "1", "kisayol_2": "2", "kisayol_3": "3", "kisayol_4": "4", "kisayol_5": "5",
	"bina_cevir": "r", "bina_barinma": "b", "nufus": "p",
	"hiz_1": "1", "hiz_2": "2", "hiz_3": "3", "hiz_dur": "space", "kip_kapat": "escape",
	"kapi_kabul": "y", "kapi_ret": "n",
}
const YEDEK_EKRAN := {
	"geri": "genel", "menu": "genel",
	"kisayol_1": "kapi", "kisayol_2": "kapi", "kisayol_3": "kapi", "kisayol_4": "kapi", "kisayol_5": "kapi",
	"bina_cevir": "koy", "bina_barinma": "koy", "nufus": "koy",
	"hiz_1": "koy", "hiz_2": "koy", "hiz_3": "koy", "hiz_dur": "koy", "kip_kapat": "koy",
	"kapi_kabul": "kapi", "kapi_ret": "kapi",
	"sec": "koy", "iptal_kip": "koy", "yakinlas": "koy", "uzaklas": "koy",
}
const YEDEK_OS := {
	"escape": "Escape", "space": "Space", "f10": "F10",
	"1": "1", "2": "2", "3": "3", "4": "4", "5": "5",
	"r": "R", "b": "B", "p": "P", "y": "Y", "n": "N",
}
const YEDEK_AD := {
	"escape": "Esc", "space": "Space", "f10": "F10",
	"1": "1", "2": "2", "3": "3", "4": "4", "5": "5",
	"r": "R", "b": "B", "p": "P", "y": "Y", "n": "N",
}

static var hata_sayisi := 0
static var _yol := "user://ayarlar.cfg"
static var _veri: Dictionary = {}
static var _kayitli: Dictionary = {}
static var _cakisan: Dictionary = {}
static var _dinlenen: Dictionary = {}
static var _atama_sira: Dictionary = {}
static var _atama_sayac := 0


## Ayar dosyasındaki girdi bölümünü okur ve InputMap'i kurar. Json yoksa klavye yedeği kalır.
static func kur(yol: String = "user://ayarlar.cfg", veri_yolu: String = VERI) -> void:
	_yol = yol
	hata_sayisi = 0
	_atama_sira.clear()
	_atama_sayac = 0
	_veri_yukle(veri_yolu)
	_dosyadan_oku()
	_coz_ve_uygula()


static func varsayilana_don(yol: String = "") -> void:
	if yol != "":
		_yol = yol
	_kayitli.clear()
	_atama_sira.clear()
	_atama_sayac = 0
	_bolumu_sil()
	_coz_ve_uygula()


## Sonraki tuşu eyleme yazar. Karar eylemi fare düğmesi almaz. Kayıt hemen yazılır.
static func ata(eylem: String, olay: InputEvent) -> bool:
	if not _bilinen(eylem):
		return false
	var jeton := _olaydan_jeton(olay)
	if jeton == "":
		return false
	if jeton.begins_with("mouse:") and bool(_eylem(eylem).get("fare_yasak", false)):
		return false
	_atama_sayac += 1
	_atama_sira[eylem] = _atama_sayac
	_kayitli[eylem] = [jeton]
	_coz_ve_uygula()
	_dosyaya_yaz()
	return true


static func tus_adi(eylem: String) -> String:
	var jetonlar: Array = _dinlenen.get(eylem, [])
	if jetonlar.is_empty():
		jetonlar = _istenen(eylem)
	var adlar: PackedStringArray = []
	for jeton in jetonlar:
		var ad := _jeton_adi(str(jeton))
		if ad != "":
			adlar.append(ad)
	return " / ".join(adlar)


static func cakisiyor(eylem: String) -> bool:
	return bool(_cakisan.get(eylem, false))


static func dinler(eylem: String, olay: InputEvent) -> bool:
	return InputMap.has_action(eylem) and InputMap.event_is_action(olay, eylem)


## Aynı karede yalnız bu ekranın (ve genel) eylemleri kalır.
static func karede(basilan: PackedStringArray, ekran: String) -> PackedStringArray:
	var sonuc: PackedStringArray = []
	for id in basilan:
		var sahibi := _ekran_adi(id)
		if sahibi != ekran and sahibi != "genel":
			continue
		if cakisiyor(id) and _dinlenen.get(id, []).is_empty():
			continue
		sonuc.append(id)
	return sonuc


static func esc_kademe(ust_panel: bool, kip_acik: bool) -> StringName:
	if ust_panel:
		return &"ust_panel"
	if kip_acik:
		return &"kip"
	return &"duraklat"


## Esc nöbet yuvasına, meclis oyuna, tezgâh teslimine ve yıl kaynağına yazmaz.
static func esc_yan_etki(kademe: StringName) -> Dictionary:
	return {
		"nobet_yuva": false,
		"cinar_sadakat": false,
		"cinar_moral": false,
		"tezgah_ucret": false,
		"tezgah_parca": false,
		"yil_kapanir": kademe == &"ust_panel",
		"yil_moral": false,
		"yil_erzak": false,
		"duraklat": kademe == &"duraklat",
	}


static func cubuk_ayari() -> Dictionary:
	var cubuk: Variant = _veri.get("cubuk", {})
	if cubuk is Dictionary:
		return cubuk
	return {}


static func kontroller_sekmesi_acik(_debug_acik: bool) -> bool:
	return true


static func proje_girdisi_var() -> bool:
	var metin := FileAccess.get_file_as_string("res://project.godot")
	return metin.begins_with("[input]") or metin.contains("\n[input]")


static func kayit_dosyasinda_mi() -> bool:
	return _yol.ends_with("kayit.json")


static func ayar_yolu() -> String:
	return _yol


static func eylem_kimlikleri() -> PackedStringArray:
	var sonuc: PackedStringArray = []
	for eylem in _eylem_listesi():
		sonuc.append(str(eylem.get("id", "")))
	return sonuc


static func _veri_yukle(veri_yolu: String) -> void:
	_veri = {}
	if not FileAccess.file_exists(veri_yolu):
		return
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(veri_yolu))
	if parsed is Dictionary:
		_veri = parsed


static func _eylem_listesi() -> Array:
	var ham: Variant = _veri.get("eylemler", [])
	if ham is Array and not (ham as Array).is_empty():
		return ham
	var yedek: Array = []
	for id in YEDEK_KLAVYE:
		yedek.append({
			"id": id,
			"ekran": YEDEK_EKRAN.get(id, "genel"),
			"klavye": YEDEK_KLAVYE[id],
			"fare_yasak": id == "kapi_kabul" or id == "kapi_ret",
		})
	for id in ["sec", "iptal_kip", "yakinlas", "uzaklas"]:
		yedek.append({"id": id, "ekran": "koy", "fare": id})
	return yedek


static func _eylem(id: String) -> Dictionary:
	for eylem in _eylem_listesi():
		if str(eylem.get("id", "")) == id and eylem is Dictionary:
			return eylem
	return {}


static func _bilinen(id: String) -> bool:
	return not _eylem(id).is_empty()


static func _ekran_adi(id: String) -> String:
	return str(_eylem(id).get("ekran", ""))


static func _istenen(id: String) -> Array:
	if _kayitli.has(id):
		return (_kayitli[id] as Array).duplicate()
	var eylem := _eylem(id)
	var sonuc: Array = []
	if str(eylem.get("klavye", "")) != "":
		sonuc.append("key:" + str(eylem["klavye"]))
	if str(eylem.get("gamepad", "")) != "":
		sonuc.append("joy:" + str(eylem["gamepad"]))
	if str(eylem.get("fare", "")) != "":
		sonuc.append("mouse:" + str(eylem["fare"]))
	return sonuc


static func _coz_ve_uygula() -> void:
	_cakisan.clear()
	_dinlenen.clear()
	var grup: Dictionary = {}
	var sira: PackedStringArray = eylem_kimlikleri()
	for id in sira:
		_dinlenen[id] = []
		for jeton in _istenen(id):
			var anahtar := str(jeton)
			if not grup.has(anahtar):
				grup[anahtar] = []
			(grup[anahtar] as Array).append(id)
	for jeton in grup:
		var kazanan: Array = _kazananlar(grup[jeton])
		for id in grup[jeton]:
			if id in kazanan:
				(_dinlenen[id] as Array).append(jeton)
			else:
				_cakisan[id] = true
	for id in sira:
		if not InputMap.has_action(id):
			InputMap.add_action(id)
		InputMap.action_erase_events(id)
		for jeton in _dinlenen[id]:
			var olay := _jetondan_olay(str(jeton))
			if olay != null:
				InputMap.action_add_event(id, olay)


static func _kazananlar(idler: Array) -> Array:
	var kalan: Array = idler.duplicate()
	kalan.sort_custom(func(a: String, b: String) -> bool: return _sira(a) < _sira(b))
	var sonuc: Array = []
	for id in kalan:
		var carpti := false
		for onceki in sonuc:
			if _carpisir(str(onceki), str(id)):
				carpti = true
				break
		if not carpti:
			sonuc.append(id)
	return sonuc


static func _sira(id: String) -> int:
	if _atama_sira.has(id):
		return -200000 - int(_atama_sira[id])
	if _kayitli.has(id):
		return -100000 + _indeks(id)
	if id == "nufus":
		return -1
	return _indeks(id)


static func _indeks(id: String) -> int:
	var i := 0
	for eylem in _eylem_listesi():
		if str(eylem.get("id", "")) == id:
			return i
		i += 1
	return 1000


static func _carpisir(a: String, b: String) -> bool:
	if a == b or _ciftte(a, b, "birlikte_serbest"):
		return false
	if _ciftte(a, b, "yasak_cift"):
		return true
	var ea := _ekran_adi(a)
	var eb := _ekran_adi(b)
	return ea != "" and ea == eb


static func _ciftte(a: String, b: String, alan: String) -> bool:
	var ham: Variant = _veri.get(alan, [])
	if alan == "yasak_cift" and not (ham is Array and not (ham as Array).is_empty()):
		ham = [["menu", "nufus"]]
	if alan == "birlikte_serbest" and not (ham is Array and not (ham as Array).is_empty()):
		ham = [["hiz_1", "kisayol_1"], ["hiz_2", "kisayol_2"], ["hiz_3", "kisayol_3"], ["kip_kapat", "geri"]]
	if not (ham is Array):
		return false
	for cift in ham:
		if cift is Array and cift.size() == 2:
			var x := str(cift[0])
			var y := str(cift[1])
			if (x == a and y == b) or (x == b and y == a):
				return true
	return false


static func _klavye_kodu(ad: String) -> int:
	var os_adi := str(_tablo("klavye_os").get(ad, YEDEK_OS.get(ad, "")))
	if os_adi == "":
		return 0
	return int(OS.find_keycode_from_string(os_adi))


static func _tablo(alan: String) -> Dictionary:
	var ham: Variant = _veri.get(alan, {})
	if ham is Dictionary:
		return ham
	return {}


static func _jetondan_olay(jeton: String) -> InputEvent:
	if jeton.begins_with("key:"):
		var ad := jeton.substr(4)
		var kod := ad.substr(4).to_int() if ad.begins_with("kod:") else _klavye_kodu(ad)
		if kod == 0:
			return null
		var tus := InputEventKey.new()
		tus.physical_keycode = kod as Key
		return tus
	if jeton.begins_with("joy:"):
		var indeks: Variant = _tablo("gamepad").get(jeton.substr(4), null)
		if indeks == null:
			return null
		var dugme := InputEventJoypadButton.new()
		dugme.button_index = int(indeks) as JoyButton
		return dugme
	if jeton.begins_with("mouse:"):
		var fare: Variant = _tablo("fare").get(jeton.substr(6), null)
		if fare == null:
			return null
		var fare_olayi := InputEventMouseButton.new()
		fare_olayi.button_index = int(fare) as MouseButton
		return fare_olayi
	return null


static func _olaydan_jeton(olay: InputEvent) -> String:
	if olay is InputEventKey:
		var kod := int((olay as InputEventKey).physical_keycode)
		if kod == 0:
			kod = int((olay as InputEventKey).keycode)
		var ad := _koddan_klavye(kod)
		if ad != "":
			return "key:" + ad
		return "key:kod:%d" % kod if kod != 0 else ""
	if olay is InputEventJoypadButton:
		var ad := _indeksten(_tablo("gamepad"), int((olay as InputEventJoypadButton).button_index))
		return "joy:" + ad if ad != "" else ""
	if olay is InputEventMouseButton:
		var ad := _indeksten(_tablo("fare"), int((olay as InputEventMouseButton).button_index))
		return "mouse:" + ad if ad != "" else ""
	return ""


static func _koddan_klavye(kod: int) -> String:
	var tablo := _tablo("klavye_os")
	if tablo.is_empty():
		tablo = YEDEK_OS
	for ad in tablo:
		if _klavye_kodu(str(ad)) == kod:
			return str(ad)
	return ""


static func _indeksten(tablo: Dictionary, indeks: int) -> String:
	for ad in tablo:
		if int(tablo[ad]) == indeks:
			return str(ad)
	return ""


static func _jeton_adi(jeton: String) -> String:
	var adlar := _tablo("ad")
	if adlar.is_empty():
		adlar = YEDEK_AD
	if jeton.begins_with("key:"):
		var ad := jeton.substr(4)
		if ad.begins_with("kod:"):
			return _kisa_os(OS.get_keycode_string(ad.substr(4).to_int() as Key))
		return str(adlar.get(ad, ad))
	if jeton.begins_with("joy:"):
		return str(adlar.get("joy_" + jeton.substr(4), jeton.substr(4)))
	if jeton.begins_with("mouse:"):
		return str(adlar.get(jeton.substr(6), jeton.substr(6)))
	return ""


static func _kisa_os(ad: String) -> String:
	if ad == "Escape":
		return "Esc"
	return ad


static func _jeton_gecerli(jeton: String) -> bool:
	if jeton.begins_with("key:kod:"):
		return jeton.substr(8).is_valid_int()
	if jeton.begins_with("key:"):
		return _klavye_kodu(jeton.substr(4)) != 0
	if jeton.begins_with("joy:"):
		return _tablo("gamepad").has(jeton.substr(4))
	if jeton.begins_with("mouse:"):
		return _tablo("fare").has(jeton.substr(6))
	return false


static func _dosyadan_oku() -> void:
	_kayitli.clear()
	if not FileAccess.file_exists(_yol):
		return
	var cfg := ConfigFile.new()
	var onceki := Engine.print_error_messages
	Engine.print_error_messages = false
	var sonuc := cfg.load(_yol)
	Engine.print_error_messages = onceki
	if sonuc != OK or not cfg.has_section(BOLUM):
		return
	for anahtar in cfg.get_section_keys(BOLUM):
		if not _bilinen(anahtar):
			_yut(anahtar, cfg.get_value(BOLUM, anahtar))
			continue
		var ham := str(cfg.get_value(BOLUM, anahtar)).strip_edges()
		if ham == "":
			_yut(anahtar, "")
			continue
		var jetonlar: Array = []
		var bozuk := false
		for parca in ham.split(","):
			var jeton := parca.strip_edges()
			if not _jeton_gecerli(jeton):
				bozuk = true
				break
			jetonlar.append(jeton)
		if bozuk or jetonlar.is_empty():
			_yut(anahtar, ham)
			continue
		_kayitli[anahtar] = jetonlar


static func _yut(anahtar: String, deger: Variant) -> void:
	push_warning("Geçersiz ayar %s=%s; varsayılan kullanılıyor" % [anahtar, deger])


static func _dosyaya_yaz() -> void:
	var cfg := ConfigFile.new()
	if FileAccess.file_exists(_yol):
		var onceki := Engine.print_error_messages
		Engine.print_error_messages = false
		cfg.load(_yol)
		Engine.print_error_messages = onceki
	if cfg.has_section(BOLUM):
		for anahtar in cfg.get_section_keys(BOLUM):
			cfg.erase_section_key(BOLUM, anahtar)
	for id in _kayitli:
		cfg.set_value(BOLUM, id, ",".join(_kayitli[id]))
	cfg.save(_yol)


static func _bolumu_sil() -> void:
	if not FileAccess.file_exists(_yol):
		return
	var cfg := ConfigFile.new()
	var onceki := Engine.print_error_messages
	Engine.print_error_messages = false
	var sonuc := cfg.load(_yol)
	Engine.print_error_messages = onceki
	if sonuc != OK or not cfg.has_section(BOLUM):
		return
	cfg.erase_section(BOLUM)
	cfg.save(_yol)
