## AYR-29 & AYR-33: Kayit yuva karti ve uyumsuz/bozuk kayit aciklamasi.
## Her yuvada gun, nufus, perde, son kayit saati ve muhafizin gecmisi (ACL-06) yazar; ekran goruntusu yok.
## Bozuk kayit "okunamadı" yazar, cokmez; `KAYIT_SURUMU` ileri olan dosya "yeni sürüm kaydı" yazar, acilmaz ve silinmez.
class_name KayitYuvaKarti
extends PanelContainer

const DESTEKLENEN_SURUM := Oturum.KAYIT_SURUMU

var yuva_no: int = 1
var baslik_etiketi: Label
var detay_etiketi: Label
var durum_kodu: String = "bos"
var acilabilir: bool = false
var ozet: Dictionary = {}


func _init(no: int = 1) -> void:
	yuva_no = clampi(no, 1, 3)
	name = "KayitYuvaKarti_%d" % yuva_no
	var kutu := VBoxContainer.new()
	add_child(kutu)
	baslik_etiketi = Label.new()
	baslik_etiketi.name = "Baslik"
	kutu.add_child(baslik_etiketi)
	detay_etiketi = Label.new()
	detay_etiketi.name = "Detay"
	kutu.add_child(detay_etiketi)
	_bos_goster()


func _bos_goster() -> void:
	durum_kodu = "bos"
	acilabilir = false
	ozet.clear()
	baslik_etiketi.text = "Yuva %d — Boş" % yuva_no
	detay_etiketi.text = "Yeni oyun için uygun"


func dosyadan_yukle(yol: String, azami_surum: int = DESTEKLENEN_SURUM) -> Dictionary:
	if not FileAccess.file_exists(yol):
		_bos_goster()
		return {"durum": "bos", "acilabilir": false, "uyari": ""}
	var metin := FileAccess.get_file_as_string(yol)
	var onceki := Engine.print_error_messages
	Engine.print_error_messages = false
	var parsed: Variant = JSON.parse_string(metin)
	Engine.print_error_messages = onceki
	if not (parsed is Dictionary) or (parsed as Dictionary).is_empty():
		durum_kodu = "okunamadi"
		acilabilir = false
		ozet = {"durum": "okunamadi", "acilabilir": false, "uyari": "okunamadı"}
		baslik_etiketi.text = "Yuva %d — okunamadı" % yuva_no
		detay_etiketi.text = "okunamadı"
		return ozet
	return sozlukten_yukle(parsed as Dictionary, azami_surum, FileAccess.get_modified_time(yol))


func sozlukten_yukle(veri: Dictionary, azami_surum: int = DESTEKLENEN_SURUM, dosya_zamani: int = 0) -> Dictionary:
	if veri.is_empty():
		durum_kodu = "okunamadi"
		acilabilir = false
		ozet = {"durum": "okunamadi", "acilabilir": false, "uyari": "okunamadı"}
		baslik_etiketi.text = "Yuva %d — okunamadı" % yuva_no
		detay_etiketi.text = "okunamadı"
		return ozet
	var surum := int(veri.get("surum", 1))
	if surum > azami_surum:
		durum_kodu = "yeni_surum"
		acilabilir = false
		ozet = {
			"durum": "yeni_surum",
			"acilabilir": false,
			"surum": surum,
			"uyari": "yeni sürüm kaydı",
		}
		baslik_etiketi.text = "Yuva %d — yeni sürüm kaydı" % yuva_no
		detay_etiketi.text = "yeni sürüm kaydı (sürüm %d)" % surum
		return ozet
	var gun := int(veri.get("gun", 0))
	var yonetim_soz: Dictionary = {}
	if veri.get("koy_yonetimi", null) is Dictionary:
		yonetim_soz = veri["koy_yonetimi"]
	elif veri.get("yonetim", null) is Dictionary:
		yonetim_soz = veri["yonetim"]
	if gun == 0 and yonetim_soz.has("gun"):
		gun = int(yonetim_soz.get("gun", 0))
	var nufus := int(veri.get("nufus", -1))
	if nufus < 0:
		if yonetim_soz.has("nufus") and yonetim_soz["nufus"] is Array:
			nufus = (yonetim_soz["nufus"] as Array).size()
		elif yonetim_soz.has("koylular") and yonetim_soz["koylular"] is Array:
			nufus = (yonetim_soz["koylular"] as Array).size()
		elif yonetim_soz.has("koyluler") and yonetim_soz["koyluler"] is Array:
			nufus = (yonetim_soz["koyluler"] as Array).size()
		else:
			nufus = int(yonetim_soz.get("nufus_sayisi", 0))
	var perde := int(veri.get("perde", 0))
	if perde <= 0:
		perde = 2 if bool(yonetim_soz.get("agalik", yonetim_soz.get("agalik_acildi", false))) or int(yonetim_soz.get("perde", 1)) >= 2 else 1
	var son_saat := String(veri.get("son_kayit_saati", "")).strip_edges()
	if son_saat.is_empty():
		son_saat = Time.get_datetime_string_from_unix_time(dosya_zamani) if dosya_zamani > 0 else "bilinmiyor"
	var gecmis := String(veri.get("muhafiz_gecmisi", veri.get("gecmis", ""))).strip_edges()
	if gecmis.is_empty() and yonetim_soz.has("muhafiz_gecmisi"):
		gecmis = String(yonetim_soz.get("muhafiz_gecmisi", "")).strip_edges()
	if gecmis.is_empty():
		gecmis = "belirsiz"
	durum_kodu = "hazir"
	acilabilir = true
	ozet = {
		"durum": "hazir",
		"acilabilir": true,
		"uyari": "",
		"gun": gun,
		"nufus": nufus,
		"perde": perde,
		"son_kayit_saati": son_saat,
		"gecmis": gecmis,
	}
	baslik_etiketi.text = "Yuva %d — Gün %d · Perde %d" % [yuva_no, gun, perde]
	detay_etiketi.text = "Nüfus: %d · Geçmiş: %s · Saat: %s" % [nufus, gecmis, son_saat]
	return ozet
