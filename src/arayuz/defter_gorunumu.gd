## Defter sayfası adayları. Seçim oyunda görünür; betik ve sinyal aynı kalır.
## Varsayılan `assets/gorsel_adaylari/defter/secili.json` içindeki yırtık yapraktır.
extends RefCounted

const KOK := "res://assets/gorsel_adaylari/defter/"
const KAYIT := "user://defter_aday.txt"
const ADAYLAR: PackedStringArray = ["yirtik", "lif", "acik_kitap"]
const ADLAR := {"yirtik": "Yırtık", "lif": "Lif", "acik_kitap": "Açık kitap"}


static func secili_id() -> String:
	if FileAccess.file_exists(KAYIT):
		var yazili := FileAccess.get_file_as_string(KAYIT).strip_edges()
		if ADAYLAR.has(yazili):
			return yazili
	var dosya := FileAccess.get_file_as_string(KOK + "secili.json")
	var veri: Variant = JSON.parse_string(dosya)
	if veri is Dictionary and ADAYLAR.has(str(veri.get("secili", ""))):
		return str(veri.get("secili", ""))
	return "yirtik"


static func sayfa_yolu(kimlik: String) -> String:
	var uzanti := "jpg" if kimlik == "lif" else "png"
	return KOK + kimlik + "/sayfa." + uzanti


static func bagla(ekran: Control, dikey: VBoxContainer) -> void:
	if ekran == null or dikey == null or ekran.find_child("defter_adaylari", true, false) != null:
		return
	_sayfayi_giydir(ekran, secili_id())
	var satir := HBoxContainer.new()
	satir.name = "defter_adaylari"
	satir.add_theme_constant_override("separation", 8)
	dikey.add_child(satir)
	dikey.move_child(satir, 1)
	for kimlik in ADAYLAR:
		var dugme := Button.new()
		dugme.name = "defter_aday_" + kimlik
		dugme.text = String(ADLAR[kimlik])
		dugme.toggle_mode = true
		dugme.button_pressed = kimlik == secili_id()
		dugme.pressed.connect(func() -> void: sec(ekran, kimlik))
		satir.add_child(dugme)


static func sec(ekran: Control, kimlik: String) -> void:
	if not ADAYLAR.has(kimlik):
		return
	var dosya := FileAccess.open(KAYIT, FileAccess.WRITE)
	if dosya != null:
		dosya.store_string(kimlik)
		dosya.close()
	_sayfayi_giydir(ekran, kimlik)
	var satir := ekran.find_child("defter_adaylari", true, false)
	if satir == null:
		return
	for dugme in satir.get_children():
		if dugme is Button:
			(dugme as Button).set_pressed_no_signal(dugme.name == "defter_aday_" + kimlik)


static func _sayfayi_giydir(ekran: Control, kimlik: String) -> void:
	var doku := load(sayfa_yolu(kimlik)) as Texture2D
	if doku == null:
		return
	var zemin: PanelContainer = null
	for cocuk in ekran.get_children():
		if cocuk is PanelContainer:
			zemin = cocuk
			break
	if zemin == null:
		return
	var kutu := StyleBoxTexture.new()
	kutu.texture = doku
	zemin.add_theme_stylebox_override("panel", kutu)
	zemin.set_meta(&"defter_aday", kimlik)
	GeceKapisiCerceve.muhur_ekle(zemin)
