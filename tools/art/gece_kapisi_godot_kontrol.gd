extends SceneTree
## Run in an isolated project containing asset_manifest.json and assets/.

func _initialize() -> void:
	call_deferred("_check")

func _check() -> void:
	var rows = JSON.parse_string(FileAccess.get_file_as_string("res://asset_manifest.json"))
	var viewport := SubViewport.new()
	viewport.size = Vector2i(1840, 1270)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	var canvas := Control.new()
	viewport.add_child(canvas)
	var index := 0
	for row in rows:
		var texture = load("res://assets/" + row.name) as Texture2D
		if texture == null or texture.get_size() != Vector2(row.size[0], row.size[1]):
			push_error("Texture size/import: " + row.name)
			quit(1)
			return
		if not row.get("opaque", false):
			var pixels := texture.get_image()
			if pixels.get_pixel(0, 0).a != 0.0:
				push_error("Missing alpha: " + row.name)
				quit(1)
				return
		var preview := TextureRect.new()
		preview.texture = texture
		preview.position = Vector2(16 + (index % 6) * 260, 12 + (index / 6) * 180)
		preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		canvas.add_child(preview)
		preview.size = Vector2(240, 145)
		var label := Label.new()
		label.text = row.name
		label.position = preview.position + Vector2(0, 148)
		canvas.add_child(label)
		var margins = row.get("slice", [0,0,0,0])
		if margins[0] + margins[2] >= row.size[0] or margins[1] + margins[3] >= row.size[1]:
			push_error("Invalid nine-slice: " + row.name)
			quit(1)
			return
		if row.name in ["dialogue_panel.png", "button_normal.png", "villager_card.png"]:
			var slot := ["dialogue_panel.png", "button_normal.png", "villager_card.png"].find(row.name)
			for variant in range(2):
				var patch := NinePatchRect.new()
				patch.texture = texture
				patch.set_patch_margin(SIDE_LEFT, margins[0])
				patch.set_patch_margin(SIDE_TOP, margins[1])
				patch.set_patch_margin(SIDE_RIGHT, margins[2])
				patch.set_patch_margin(SIDE_BOTTOM, margins[3])
				patch.position = Vector2(16 + slot * 600 + variant * 300, 925)
				patch.size = Vector2(300, 300) if variant == 0 else Vector2(210, 190)
				# A patch cannot be smaller than the sum of its fixed corners.
				patch.size = patch.size.max(Vector2(margins[0]+margins[2]+8, margins[1]+margins[3]+8))
				canvas.add_child(patch)
		index += 1
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		viewport.get_texture().get_image().save_png(args[0])
	print("GECE_KAPISI_IMPORT_9SLICE_PASS ", index)
	quit(0)
