## Hedef 3: 10 saniyelik periyodik ve sahne değişimi performans izi.
## Oyuncu sürümünde yazmaz; yalnız --debug-arac veya --perf-log ile etkinleşir.
## Sayılar ve JSONL alanları src/debug/performans_gunlugu.gd ile aynı tabanın devamıdır.
class_name PerformansIzi
extends Node

const AD := &"PerformansIzi"
const ARALIK_SN := 10.0

var etkin := iz_acik()
var dosya_yolu := "user://performans_izi_%s_%s.jsonl" % [str(Time.get_unix_time_from_system()).replace(".", "_"), Time.get_ticks_usec()]
var satir_sayisi := 0
var olcum_sayisi := 0
var _fps: Dictionary = {}
var _kare_ms_azami := 0.0
var _pencere_sn := 0.0
var _toplam_sn := 0.0
var _io_uyarildi := false


static func _varsayilan_argumanlar() -> PackedStringArray:
	var tumu := PackedStringArray()
	tumu.append_array(OS.get_cmdline_args())
	tumu.append_array(OS.get_cmdline_user_args())
	return tumu


static func iz_acik(argumanlar: PackedStringArray = _varsayilan_argumanlar()) -> bool:
	return AdminHud.arac_acik(argumanlar) or argumanlar.has("--perf-log")


static func bagla(ana: Node) -> PerformansIzi:
	var eski := ana.get_node_or_null(NodePath(String(AD))) as PerformansIzi
	if eski != null:
		return eski
	var iz := PerformansIzi.new()
	iz.name = AD
	ana.add_child(iz)
	return iz


func _ready() -> void:
	set_process(etkin)


func ac(evet: bool) -> void:
	etkin = evet
	set_process(evet)


func _process(delta: float) -> void:
	if not etkin:
		return
	var son := PerformansSeridi.oku()
	olcum_ekle(son)
	_pencere_sn += delta
	_toplam_sn += delta
	while _pencere_sn >= ARALIK_SN:
		_pencere_sn -= ARALIK_SN
		aralik_yaz(son)


func olcum_ekle(olcum: Dictionary) -> void:
	if not etkin:
		return
	if PerformansGunlugu._sayi(olcum.get("fps")) and PerformansGunlugu._sayi(olcum.get("kare_ms")):
		var fps := float(olcum["fps"])
		_fps[fps] = int(_fps.get(fps, 0)) + 1
		_kare_ms_azami = maxf(_kare_ms_azami, float(olcum["kare_ms"]))
		olcum_sayisi += 1


func aralik_yaz(son: Dictionary = {}) -> bool:
	if not etkin:
		return false
	if son.is_empty():
		son = PerformansSeridi.oku()
	olcum_ekle(son)
	var satir := _temel_satir(son)
	satir["tur"] = "aralik"
	satir["sure_sn"] = int(round(_toplam_sn))
	if not _satir_yaz(satir):
		return false
	_fps.clear()
	_kare_ms_azami = 0.0
	olcum_sayisi = 0
	return true


func ekran_degisti(e: Node, yukleme_ms: float) -> bool:
	var sahne_adi := ""
	if e != null:
		if e.get_script() is Script:
			sahne_adi = String((e.get_script() as Script).get_global_name())
		if sahne_adi.is_empty():
			sahne_adi = String(e.name) if not e.name.is_empty() else e.get_class()
	return sahne_degisti(sahne_adi, yukleme_ms)


func sahne_degisti(sahne_adi: String, yukleme_ms: float) -> bool:
	if not etkin:
		return false
	var son := PerformansSeridi.oku()
	var satir := _temel_satir(son)
	satir["tur"] = "sahne"
	satir["sahne"] = sahne_adi
	satir["yukleme_ms"] = yukleme_ms
	return _satir_yaz(satir)


func _temel_satir(son: Dictionary) -> Dictionary:
	var ram: Variant = son.get("ram")
	if ram == null:
		var statik_ram := Performance.get_monitor(Performance.MEMORY_STATIC)
		if statik_ram > 0:
			ram = statik_ram
	var dugum := int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))
	if dugum <= 0 and is_inside_tree() and get_tree() != null:
		dugum = get_tree().get_node_count()
	var ortanca := PerformansGunlugu.ortanca(_fps) if not _fps.is_empty() else float(son.get("fps", 0.0))
	var azami := _kare_ms_azami if _kare_ms_azami > 0.0 else float(son.get("kare_ms", 0.0))
	return {
		"fps_ortanca": ortanca,
		"kare_ms_azami": azami,
		"bellek_mb": float(ram) / 1048576.0 if PerformansGunlugu._sayi(ram) else null,
		"fps": float(son.get("fps", 0.0)),
		"kare_ms": float(son.get("kare_ms", 0.0)),
		"dugum_sayisi": dugum,
	}


func _satir_yaz(satir: Dictionary) -> bool:
	if not etkin:
		return false
	if not dosya_yolu.begins_with("user://") or ".." in dosya_yolu:
		_io_uyari()
		return false
	var dosya := FileAccess.open(dosya_yolu, FileAccess.READ_WRITE if FileAccess.file_exists(dosya_yolu) else FileAccess.WRITE)
	if dosya == null:
		_io_uyari()
		return false
	dosya.seek_end()
	dosya.store_line(JSON.stringify(satir))
	dosya.flush()
	if dosya.get_error() != OK:
		_io_uyari()
		return false
	satir_sayisi += 1
	return true


func _io_uyari() -> void:
	if not _io_uyarildi:
		_io_uyarildi = true
		print(JSON.stringify({"uyari": "performans_izi_yazilamadi"}))
