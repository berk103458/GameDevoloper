## AYR-28 & AYR-32: Uc kayit yuvasi (`user://kayit_1.json` .. `kayit_3.json`) ve iki adimli silme.
## `kayit_deposu.gd` tek dosya kalir; `KayitYuvalari` uc yuva yolu verir.
## Eski `user://kayit.json` varsa ilk yuvaya (`kayit_1.json`) kopyalanarak goc eder, silinmez.
## Silme onay ister (`onaylandi = true`); silinen dosya `user://cop/` altina tasinir, bir sonraki acilista temizlenir.
class_name KayitYuvalari
extends RefCounted

const YUVA_SAYISI := 3
const VARSAYILAN_KOK := "user://"
const ESKI_DOSYA_ADI := "kayit.json"
const COP_KLASOR_ADI := "cop"

var kok_dizin: String = VARSAYILAN_KOK


func _init(kok: String = VARSAYILAN_KOK, acilis_temizligi: bool = true) -> void:
	kok_dizin = kok if kok.ends_with("/") else (kok + "/")
	if acilis_temizligi:
		copu_temizle()
	eski_kaydi_goc_et()


func yuva_yolu(yuva_no: int) -> String:
	var n := clampi(yuva_no, 1, YUVA_SAYISI)
	return "%skayit_%d.json" % [kok_dizin, n]


func tum_yuva_yollari() -> Array[String]:
	return [yuva_yolu(1), yuva_yolu(2), yuva_yolu(3)]


func eski_kayit_yolu() -> String:
	return kok_dizin + ESKI_DOSYA_ADI


func cop_dizini() -> String:
	return kok_dizin + COP_KLASOR_ADI


func depo(yuva_no: int) -> KayitDeposu:
	return KayitDeposu.new(yuva_yolu(yuva_no))


func var_mi(yuva_no: int) -> bool:
	return depo(yuva_no).var_mi()


func yaz(yuva_no: int, veri: Dictionary) -> bool:
	var kopya := veri.duplicate(true)
	if not kopya.has("son_kayit_saati"):
		kopya["son_kayit_saati"] = Time.get_datetime_string_from_system()
	return depo(yuva_no).yaz(kopya)


func oku(yuva_no: int) -> Dictionary:
	return depo(yuva_no).oku()


## AYR-28: Eski `user://kayit.json` varsa ve yuva 1 bossa yuva 1'e kopyalar; eski dosya silinmez.
func eski_kaydi_goc_et() -> bool:
	var eski_yol := eski_kayit_yolu()
	var yuva1_yol := yuva_yolu(1)
	if not FileAccess.file_exists(eski_yol):
		return false
	if FileAccess.file_exists(yuva1_yol):
		return false
	var eski_depo := KayitDeposu.new(eski_yol)
	var veri := eski_depo.oku()
	if veri.is_empty():
		var metin := FileAccess.get_file_as_string(eski_yol)
		if metin.is_empty():
			return false
		var f := FileAccess.open(yuva1_yol, FileAccess.WRITE)
		if f == null:
			return false
		f.store_string(metin)
		f.close()
		return true
	return KayitDeposu.new(yuva1_yol).yaz(veri)


## AYR-32: Yuva silme onay ister; silinen dosya `cop/` altina tasinir, bir sonraki acilista temizlenir.
func yuva_sil(yuva_no: int, onaylandi: bool = false) -> bool:
	if not onaylandi:
		return false
	var kaynak := yuva_yolu(yuva_no)
	if not FileAccess.file_exists(kaynak):
		return false
	var cop_yol := cop_dizini()
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(cop_yol))
	var hedef := "%s/kayit_%d.json" % [cop_yol, clampi(yuva_no, 1, YUVA_SAYISI)]
	var icerik := FileAccess.get_file_as_string(kaynak)
	var f := FileAccess.open(hedef, FileAccess.WRITE)
	if f == null:
		return false
	f.store_string(icerik)
	f.flush()
	f.close()
	depo(yuva_no).sil()
	if FileAccess.file_exists(kaynak):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(kaynak))
	return true


func cop_dosya_sayisi() -> int:
	var d := DirAccess.open(cop_dizini())
	if d == null:
		return 0
	var sayac := 0
	d.list_dir_begin()
	var ad := d.get_next()
	while not ad.is_empty():
		if not d.current_is_dir():
			sayac += 1
		ad = d.get_next()
	d.list_dir_end()
	return sayac


func copu_temizle() -> int:
	var cop_yol := cop_dizini()
	var d := DirAccess.open(cop_yol)
	if d == null:
		return 0
	var silinen := 0
	d.list_dir_begin()
	var ad := d.get_next()
	var dosyalar: Array[String] = []
	while not ad.is_empty():
		if not d.current_is_dir():
			dosyalar.append(ad)
		ad = d.get_next()
	d.list_dir_end()
	for dosya_adi in dosyalar:
		var tam := "%s/%s" % [cop_yol, dosya_adi]
		if DirAccess.remove_absolute(ProjectSettings.globalize_path(tam)) == OK:
			silinen += 1
	return silinen
