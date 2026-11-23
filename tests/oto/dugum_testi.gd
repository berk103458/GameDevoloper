## `extends Node` birim testlerini headless `-s` ile çalıştırır.
## Godot `--script` yalnız SceneTree bekler; düğüm betiği ağaca burada girer.
extends SceneTree


func _initialize() -> void:
	# Düğümü derlemeden önce projenin autoload'ları ağaca girsin.
	call_deferred("_betigi_ekle")


func _betigi_ekle() -> void:
	var argumanlar := OS.get_cmdline_user_args()
	if argumanlar.is_empty():
		push_error("düğüm testi yolu yok")
		quit(1)
		return
	var betik := load(argumanlar[0]) as GDScript
	if betik == null or not betik.can_instantiate():
		push_error("düğüm testi yüklenemedi")
		quit(1)
		return
	var dugum: Node = betik.new()
	get_root().add_child(dugum)
