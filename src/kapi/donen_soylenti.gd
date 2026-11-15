## SOY-24: kapıya dönen adlı karakter, köyde duyduğu söylentiyi ilk cümlesinde anar.
## Satır, kapi_ekrani içinde ziyaret_basladi çağrısından sonra yazılır.
## Sayaç bu gelişi de içerir: ilk geliş 1, dönüş 2. Dal eşiği bu yüzden onceki_ziyaret_min 2'dir.
## Ağ yoksa kurulmaz. Ölü kişide dal yoktur.
class_name DonenSoylenti
extends RefCounted

const YOL := "res://data/soz/donen_soylenti.json"
const DAL_ID := "donen_soylenti"
const DONUS_ESIGI := 2

static var _dallar: Array = []


static func sec(o: Oturum, gelen: Gelen) -> Dictionary:
	if o == null or gelen == null or o.kadro == null:
		return {"dal": 0}
	var hafiza := KisiHafizasi.oku(o.kadro, gelen.id, o.gun)
	if bool(hafiza.get("oldu", false)):
		return {"dal": 0}
	if int(hafiza.get("ziyaret", 0)) < DONUS_ESIGI:
		return {"dal": 0}
	if not o.has_meta(SoylentiKoprusu.META):
		return {"dal": 0}
	var dallar := _dal_listesi()
	if dallar.is_empty():
		return {"dal": 0}
	var baglam := _duyan_baglam(o, gelen, SoylentiKoprusu.ag(o))
	baglam = KisiHafizasi.baglama_yaz(baglam, o.kadro, gelen.id, o.gun)
	var secilen := SatirSecici.new().sec(dallar, baglam)
	if String(secilen.get("id", "")) != DAL_ID:
		return {"dal": 0}
	return {
		"dal": 1,
		"id": String(secilen.get("id", "")),
		"metin_anahtari": String(secilen.get("metin_anahtari", "")),
	}


static func satirlar(o: Oturum, gelen: Gelen) -> PackedStringArray:
	var secim := sec(o, gelen)
	if int(secim.get("dal", 0)) != 1 or gelen == null:
		return PackedStringArray()
	var ad := TranslationServer.translate(gelen.ad_anahtari)
	var anahtar := String(secim.get("metin_anahtari", ""))
	return PackedStringArray(["[b]%s:[/b] %s" % [ad, TranslationServer.translate(anahtar)]])


static func _kimlikler(o: Oturum, gelen: Gelen) -> PackedStringArray:
	var sonuc := PackedStringArray()
	var kapi_kimligi := String(gelen.id)
	if not kapi_kimligi.is_empty():
		sonuc.append(kapi_kimligi)
	if o.yonetim == null:
		return sonuc
	for k in o.yonetim.koylular:
		if k.adli_id != gelen.id:
			continue
		var koylu_kimligi := str(int(k.id))
		if not sonuc.has(koylu_kimligi):
			sonuc.append(koylu_kimligi)
	return sonuc


static func _duyan_baglam(o: Oturum, gelen: Gelen, ag: RefCounted) -> Dictionary:
	var sessiz := {SoylentiBaglami.OZET: false}
	for kimlik in _kimlikler(o, gelen):
		var parca := SoylentiBaglami.baglama_yaz({}, ag, kimlik)
		if sessiz.get(SoylentiBaglami.OZET) != true:
			sessiz = parca
		if bool(parca.get(SoylentiBaglami.OZET, false)):
			return parca
	return sessiz


static func _dal_listesi() -> Array:
	if not _dallar.is_empty():
		return _dallar
	if not FileAccess.file_exists(YOL):
		return []
	var okunan: Variant = JSON.parse_string(FileAccess.get_file_as_string(YOL))
	if okunan is Dictionary and (okunan as Dictionary).get("dallar") is Array:
		_dallar = (okunan as Dictionary).get("dallar")
	return _dallar
