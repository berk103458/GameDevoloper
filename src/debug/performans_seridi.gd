## Godot Performance sayaçları; RAM=Godot statik ayırmaları, süreç RSS'si değil.
## https://docs.godotengine.org/en/stable/classes/class_performance.html
class_name PerformansSeridi
extends Label

var son_olcum: Dictionary = {}
var _son_zaman := -1000
var olcum_sayisi := 0

func _ready() -> void:
	add_theme_font_size_override("font_size", 18)
	autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tooltip_text = "Kare: TIME_PROCESS (ms); Draw: son çizilen kare. RAM: Godot statik ayırmaları, süreç toplamı değil. VRAM: renderer ayırmaları, kartın toplam kullanımı değil. Sayaçlar gecikmeli güncellenebilir."
	ac(false)

func ac(evet: bool) -> void:
	visible = evet
	set_process(evet)
	if evet:
		_yenile(true)

func _process(_delta: float) -> void:
	_yenile()

func _yenile(zorla: bool = false) -> void:
	var zaman := Time.get_ticks_msec()
	if not zorla and zaman - _son_zaman < 500:
		return
	_son_zaman = zaman
	son_olcum = oku()
	olcum_sayisi += 1
	text = bicim(son_olcum)

static func oku() -> Dictionary:
	var grafik := DisplayServer.get_name() != "headless"
	var ram := Performance.get_monitor(Performance.MEMORY_STATIC)
	var vram := Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) if grafik else 0.0
	return {"fps": Performance.get_monitor(Performance.TIME_FPS),
		"kare_ms": Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0,
		"draw": Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME) if grafik else null,
		"ram": ram if OS.is_debug_build() and ram > 0 else null,
		"vram": vram if vram > 0 else null,
		"kare_siniri": Engine.max_fps,
		"vsync_acik": grafik and DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED}

static func bicim(v: Dictionary) -> String:
	var ram := "ölçüm yok" if v["ram"] == null else "%.1f MiB" % (float(v["ram"]) / 1048576.0)
	var vram := "ölçüm yok" if v["vram"] == null else "%.1f MiB" % (float(v["vram"]) / 1048576.0)
	var draw := "ölçüm yok" if v["draw"] == null else str(int(v["draw"]))
	return "FPS %d · Kare %.2f ms · Draw %s · RAM (Godot) %s · VRAM %s" % [int(v["fps"]), v["kare_ms"], draw, ram, vram]
