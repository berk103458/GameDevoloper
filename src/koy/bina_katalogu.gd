## Köy yapı kataloğu (`data/koy/binalar.json`; design/gdd/koy-yonetimi.md, 7): yapı türlerinin değişmez verisi.
class_name BinaKatalogu
extends RefCounted

const YOL := "res://data/koy/binalar.json"

var turler: Dictionary = {}


func _init(yol: String = YOL) -> void:
	var v: Variant = JSON.parse_string(FileAccess.get_file_as_string(yol))
	if not (v is Dictionary):
		push_error("Yapı kataloğu okunamadı: " + yol)
		return
	for k in v:
		if not String(k).begins_with("_"):
			turler[String(k)] = v[k]
	turler.merge(MeslekYapilari.ekler(turler), false)
	turler.merge(DegirmenUretimi.ekler(turler), false)
	turler.merge(Sifahane.ekler(), false)
	OdunZinciri.uygula(turler)
	CekiLojistigi.katalog_ekle(turler)
	TahilZinciri.ekle(turler)
	HarcZinciri.ekle(turler)
	DemirZinciri.ekle(turler)
	MuhafizMaasi.ekle(turler)
	CobanSurusu.ekle(turler)
	GozcuKulesi.ekle(turler)
	# Kaynak CHR konumları ayrı türdür; mevcut yapı verileri ezilmez.
	turler.merge(preload("res://src/koy/chr_bina_sozlugu.gd").katalog_ekleri(), false)

func chr_hedef_turleri(ad: String) -> PackedStringArray:
	return preload("res://src/koy/chr_bina_sozlugu.gd").turler(ad)


func var_mi(tur: String) -> bool:
	return turler.has(tur)


func veri(tur: String) -> Dictionary:
	return turler.get(tur, {})


func boyut(tur: String) -> Vector2i:
	var b: Array = veri(tur).get("boyut", [1, 1])
	return Vector2i(int(b[0]), int(b[1]))


func maliyet(tur: String) -> Dictionary:
	return veri(tur).get("maliyet", {})


func kategori(tur: String) -> String:
	return String(veri(tur).get("kategori", ""))


func slot(tur: String) -> int:
	return int(veri(tur).get("slot", 0))


func yatak(tur: String) -> int:
	return int(veri(tur).get("yatak", 0))


func receteler(tur: String) -> Dictionary:
	return TahilZinciri.tarifler(tur, OdunZinciri.tarifler(tur, veri(tur).get("receteler", {})))


## Kategoriye göre tür adları (arayüz menüsü).
func kategoridekiler(kategori_: String) -> PackedStringArray:
	var s := PackedStringArray()
	for t in turler:
		if kategori(t) == kategori_:
			s.append(t)
	return s
