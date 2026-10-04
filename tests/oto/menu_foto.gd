## Menü fotoğrafı: ana sahneyi açar, menü oturunca ekran görüntüsünü CIKTI'ya kaydeder.
## Çalıştırma: CIKTI=/yol/menu.png godot --path . tests/oto/menu_foto.tscn
extends Node


func _ready() -> void:
	var ana: Node = load("res://src/arayuz/ana.tscn").instantiate()
	get_tree().root.add_child.call_deferred(ana)
	await get_tree().create_timer(3.0).timeout
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(OS.get_environment("CIKTI"))
	get_tree().quit()
