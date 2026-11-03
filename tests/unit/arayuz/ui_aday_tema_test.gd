extends SceneTree
## Gece UI adayları yüklenir. Düğme dokusu vardır, gövde puntosu 26'nın altına inmez,
## varsayılan yazı tipi Türkçe glif taşır. Ekran mantığı bu testte değişmez.

const TEMALAR := [
	"res://assets/ui_adaylari/lamoot_ahsap/tema.tres",
	"res://assets/ui_adaylari/itsmars_envanter/tema.tres",
	"res://assets/ui_adaylari/kenney_rpg/tema.tres",
	"res://assets/ui_adaylari/crisp_quest/tema.tres",
	"res://assets/ui_adaylari/kenney_macera/tema.tres",
]
const HARFLER := "ıİşŞğĞüÜöÖçÇ"

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	for yol in TEMALAR:
		var tema := load(yol) as Theme
		_kontrol(tema != null, "Tema yüklenir: %s" % yol)
		if tema == null:
			continue
		var dugme := tema.get_stylebox("normal", "Button")
		_kontrol(dugme is StyleBoxTexture, "Düğme dokusu: %s" % yol)
		var panel := tema.get_stylebox("panel", "Panel")
		_kontrol(panel is StyleBoxTexture, "Panel dokusu: %s" % yol)
		_kontrol(tema.default_font_size >= 26, "Gövde puntosu 26+: %s (%d)" % [yol, tema.default_font_size])
		var yazi: Font = tema.default_font
		_kontrol(yazi != null, "Yazı tipi var: %s" % yol)
		if yazi == null:
			continue
		for i in HARFLER.length():
			var kod := HARFLER.unicode_at(i)
			_kontrol(yazi.has_char(kod), "Glif %s: %s" % [HARFLER[i], yol])
	await process_frame
	print("UI ADAY TEMA: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
