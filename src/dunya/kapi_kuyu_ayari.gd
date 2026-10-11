## BUG-25: duran nesnelerin dönüşü; ışık ve su sistemlerinin hesabını değiştirmez.
class_name KapiKuyuAyari
extends RefCounted

static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/ayarlar/kapi_kuyu_sahne.json"))

static func alev_konumu(konum: Vector3) -> Vector3:
	return konum + Vector3(0, float(AYAR.alev_soketi_y), 0)

## İki düğüm de kapı çerçevesinin çocuğudur; aynı yerel konum dünya dönüşünde de eşittir.
static func sokete_bagla(isik: OmniLight3D, alev: Node3D) -> void:
	var soket := Marker3D.new()
	soket.name = "AlevSoketi"
	soket.position = alev.position
	alev.get_parent().add_child(soket)
	isik.position = soket.position
	isik.set_meta("alev_soketi", soket)

static func kuyu() -> Node3D:
	# Yükleyici tek malzeme atar; yenilemede iki ardışık RID oluşturulup bırakılmaz.
	return Dunya3B.nesne("kuyu", float(AYAR.kuyu_yukseklik), "", Color(String(AYAR.kuyu_tas_rengi)))
