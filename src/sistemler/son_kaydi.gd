## OMR-17: Sonun secildigi an kayda yazilir (son.nihai).
## son_metni donusundeki nihai alani oyun kaydina ve Bolum 39 defterine yazilir;
## epilog sonradan yeniden okunabilir. Eski kayitta alan yoksa bos kalir.
class_name SonKaydi
extends RefCounted

const BOLUM_ANAHTARI := "son"
const NIHAI_ANAHTARI := "nihai"
const BASLIK_ANAHTARI := "baslik"
const METIN_ANAHTARI := "metin"
const EPILOG_ANAHTARI := "epilog"

var nihai: StringName = &""
var baslik: String = ""
var metin: String = ""
var epilog: String = ""


func sifirla() -> void:
	nihai = &""
	baslik = ""
	metin = ""
	epilog = ""


func son_isle(son_verisi: Dictionary) -> void:
	if son_verisi.has(NIHAI_ANAHTARI):
		nihai = StringName(son_verisi[NIHAI_ANAHTARI])
	elif son_verisi.has("son"):
		nihai = StringName(son_verisi["son"])
	if son_verisi.has(BASLIK_ANAHTARI):
		baslik = String(son_verisi[BASLIK_ANAHTARI])
	if son_verisi.has(METIN_ANAHTARI):
		metin = String(son_verisi[METIN_ANAHTARI])
	if son_verisi.has(EPILOG_ANAHTARI):
		epilog = String(son_verisi[EPILOG_ANAHTARI])


func kayda_yaz(kayit_sozlugu: Dictionary) -> Dictionary:
	var mevcut: Variant = kayit_sozlugu.get(BOLUM_ANAHTARI, {})
	var son_soz: Dictionary = mevcut.duplicate(true) if mevcut is Dictionary else {}
	son_soz[NIHAI_ANAHTARI] = String(nihai)
	if not baslik.is_empty():
		son_soz[BASLIK_ANAHTARI] = baslik
	if not metin.is_empty():
		son_soz[METIN_ANAHTARI] = metin
	if not epilog.is_empty():
		son_soz[EPILOG_ANAHTARI] = epilog
	kayit_sozlugu[BOLUM_ANAHTARI] = son_soz
	return kayit_sozlugu


func kayittan_oku(kayit_sozlugu: Variant) -> bool:
	sifirla()
	if not (kayit_sozlugu is Dictionary):
		return true
	var d: Dictionary = kayit_sozlugu
	if not d.has(BOLUM_ANAHTARI) or not (d[BOLUM_ANAHTARI] is Dictionary):
		return true # Eski kayitta alan yoksa bos, oyun cokmez
	var son_soz: Dictionary = d[BOLUM_ANAHTARI]
	nihai = StringName(son_soz.get(NIHAI_ANAHTARI, ""))
	baslik = String(son_soz.get(BASLIK_ANAHTARI, ""))
	metin = String(son_soz.get(METIN_ANAHTARI, ""))
	epilog = String(son_soz.get(EPILOG_ANAHTARI, ""))
	return true


static func kayda_son_ekle(kayit_sozlugu: Dictionary, son_verisi: Dictionary) -> Dictionary:
	var mevcut: Variant = kayit_sozlugu.get(BOLUM_ANAHTARI, {})
	var son_soz: Dictionary = mevcut.duplicate(true) if mevcut is Dictionary else {}
	if son_verisi.has(NIHAI_ANAHTARI):
		son_soz[NIHAI_ANAHTARI] = String(son_verisi[NIHAI_ANAHTARI])
	elif son_verisi.has("son"):
		son_soz[NIHAI_ANAHTARI] = String(son_verisi["son"])
	if son_verisi.has(BASLIK_ANAHTARI):
		son_soz[BASLIK_ANAHTARI] = String(son_verisi[BASLIK_ANAHTARI])
	if son_verisi.has(METIN_ANAHTARI):
		son_soz[METIN_ANAHTARI] = String(son_verisi[METIN_ANAHTARI])
	if son_verisi.has(EPILOG_ANAHTARI):
		son_soz[EPILOG_ANAHTARI] = String(son_verisi[EPILOG_ANAHTARI])
	kayit_sozlugu[BOLUM_ANAHTARI] = son_soz
	return kayit_sozlugu


static func kayittan_nihai_al(kayit_sozlugu: Dictionary) -> StringName:
	var son_soz: Variant = kayit_sozlugu.get(BOLUM_ANAHTARI, null)
	if son_soz is Dictionary:
		return StringName(son_soz.get(NIHAI_ANAHTARI, ""))
	return &""


static func kayittan_epilog_al(kayit_sozlugu: Dictionary) -> String:
	var son_soz: Variant = kayit_sozlugu.get(BOLUM_ANAHTARI, null)
	if son_soz is Dictionary:
		return String(son_soz.get(EPILOG_ANAHTARI, ""))
	return ""
