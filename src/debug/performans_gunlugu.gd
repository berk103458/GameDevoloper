## TEK-10: ilk üç gerçek gece; RAM Godot statik ayırmasıdır, süreç RSS'si değil.
## Ölçüm kaydı JSONL, tek eşik uyarısı konsol logundadır. Profil/cache değiştirmez.
class_name PerformansGunlugu
extends Node

const AD := &"PerformansGunlugu"
const TEKNIK := "res://data/teknik.json"
const VARSAYILAN := "res://data/teknik_varsayilan.json"
const GECE_ADEDI := 3

var etkin := OS.is_debug_build() or "--perf-log" in OS.get_cmdline_user_args()
var dosya_yolu := "user://performans_%s_%s.jsonl" % [str(Time.get_unix_time_from_system()).replace(".", "_"), Time.get_ticks_usec()]
var esikler: Dictionary = esikleri_oku()
var satir_sayisi := 0
var uyari_sayisi := 0
var olcum_sayisi := 0
var _oturum: WeakRef
var _geceler: Dictionary = {}
var _fps: Dictionary = {}
var _kare_ms_azami := 0.0
var _io_uyarildi := false

## Aynı oturumun kapı/köy ekranları aynı günlüğü kullanır; yeni oturum yeni dosyadır.
static func bagla(ana: Node, oturum: RefCounted) -> PerformansGunlugu:
	var eski := ana.get_node_or_null(NodePath(String(AD))) as PerformansGunlugu
	if eski != null:
		if eski._oturum.get_ref() == oturum:
			return eski
		ana.remove_child(eski)
		eski.queue_free()
	var gunluk := PerformansGunlugu.new()
	gunluk.name = AD
	gunluk._oturum = weakref(oturum)
	ana.add_child(gunluk)
	return gunluk

## Kilit alınmış gece hesaplaşmasından önce: memory_free çağrısından önceki RAM.
static func gece_bitir(ekran: Node, gece: int) -> void:
	var gunluk := ekran.get_parent().get_node_or_null(NodePath(String(AD))) as PerformansGunlugu
	if gunluk != null:
		gunluk.gece_yaz(gece)

func _ready() -> void:
	set_process(etkin)

func _process(_delta: float) -> void:
	if not etkin or satir_sayisi >= GECE_ADEDI:
		return
	# Ana menü/ayar/duraklat ekranlarını gece ölçümüne katma.
	if _oturum != null:
		var ana := get_parent()
		var ekran: Node = ana.get("_ekran")
		if _oturum.get_ref() == null or ana.get("oturum") != _oturum.get_ref() or ana.get("_ust") != null:
			return
		if ekran == null or not (ekran.has_method("_geceye_gec") or ekran.has_method("gece_baslat")):
			return
		# Bitmiş gecenin raporunu sonraki gecenin FPS örneklerine katma.
		if ekran.has_method("_geceye_gec") and ekran.get("_gece_kilidi").kilitli():
			return
	olcum_ekle(PerformansSeridi.oku())

func olcum_ekle(olcum: Dictionary) -> void:
	if _sayi(olcum.get("fps")) and _sayi(olcum.get("kare_ms")):
		var fps := float(olcum.fps)
		_fps[fps] = int(_fps.get(fps, 0)) + 1
		_kare_ms_azami = maxf(_kare_ms_azami, float(olcum.kare_ms))
		olcum_sayisi += 1

func gece_yaz(gece: int) -> void:
	if not etkin or satir_sayisi >= GECE_ADEDI or _geceler.has(gece):
		return
	var son := PerformansSeridi.oku()
	olcum_ekle(son)  # Çok kısa gecede bile sayısal fps/kare örneği bulunur.
	var satir := ozet(son.get("ram"))
	satir["gece"] = gece
	# res:// veya işletim sistemi yollarına günlük yazılması mümkün değildir.
	if not dosya_yolu.begins_with("user://") or ".." in dosya_yolu:
		_io_uyari()
		return
	var dosya := FileAccess.open(dosya_yolu, FileAccess.READ_WRITE if FileAccess.file_exists(dosya_yolu) else FileAccess.WRITE)
	if dosya == null:
		_io_uyari()
		return
	dosya.seek_end()
	dosya.store_line(JSON.stringify(satir))
	dosya.flush()
	if dosya.get_error() != OK:
		_io_uyari()
		return
	satir_sayisi += 1
	_geceler[gece] = true
	if uyari_sayisi == 0 and esik_asildi(satir):
		uyari_sayisi = 1
		print(JSON.stringify({"uyari": "performans_esigi", "gece": gece, "olcum": satir, "esikler": esikler}))
	_fps.clear()
	_kare_ms_azami = 0.0
	olcum_sayisi = 0
	if satir_sayisi >= GECE_ADEDI:
		set_process(false)

func ozet(ram: Variant) -> Dictionary:
	return {"fps_ortanca": ortanca(_fps), "kare_ms_azami": _kare_ms_azami,
		"bellek_mb": float(ram) / 1048576.0 if _sayi(ram) else null}

func esik_asildi(satir: Dictionary) -> bool:
	return satir.fps_ortanca < esikler.fps_ortanca_en_az or satir.kare_ms_azami > esikler.kare_ms_azami

## Frekans tablosu tekrar eden FPS'leri saklamaz; çift sayıda iki orta değer alınır.
static func ortanca(frekans: Dictionary) -> float:
	var adet := 0
	for sayi in frekans.values(): adet += int(sayi)
	if adet == 0: return 0.0
	var anahtarlar := frekans.keys()
	anahtarlar.sort()
	var sol := (adet - 1) / 2
	var sag := adet / 2
	var birikim := 0
	var ilk := 0.0
	for fps in anahtarlar:
		var sonraki := birikim + int(frekans[fps])
		if birikim <= sol and sol < sonraki: ilk = float(fps)
		if birikim <= sag and sag < sonraki: return (ilk + float(fps)) / 2.0
		birikim = sonraki
	return 0.0

static func esikleri_oku(yol: String = TEKNIK) -> Dictionary:
	# Eşik sayıları kodda bulunmaz; eksik/bozuk ana ayar paket varsayılanına döner.
	var varsayilan := _json_oku(VARSAYILAN).get("performans_gunlugu", {}) as Dictionary
	var ozel: Variant = _json_oku(yol).get("performans_gunlugu", {})
	if ozel is Dictionary:
		for anahtar in varsayilan:
			if _sayi(ozel.get(anahtar)) and float(ozel[anahtar]) > 0.0:
				varsayilan[anahtar] = float(ozel[anahtar])
	return varsayilan

static func _json_oku(yol: String) -> Dictionary:
	if not FileAccess.file_exists(yol): return {}
	var dosya := FileAccess.open(yol, FileAccess.READ)
	if dosya == null: return {}
	var json := JSON.new()
	if json.parse(dosya.get_as_text()) != OK or not json.data is Dictionary: return {}
	return json.data

static func _sayi(deger: Variant) -> bool:
	return (deger is int or deger is float) and is_finite(float(deger)) and float(deger) >= 0.0

func _io_uyari() -> void:
	if not _io_uyarildi:
		_io_uyarildi = true
		print(JSON.stringify({"uyari": "performans_gunlugu_yazilamadi"}))
