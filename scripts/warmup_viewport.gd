# warmup_viewport.gd
extends SubViewport

signal warmup_complete

func warmup(materials: Array[ShaderMaterial]) -> void:
	var rect := ColorRect.new()
	rect.size = Vector2(4, 4)  # tiny, doesn't matter visually
	add_child(rect)

	for mat in materials:
		rect.material = mat
		# Force a render pass by waiting for the viewport to actually draw
		render_target_update_mode = SubViewport.UPDATE_ONCE
		await RenderingServer.frame_post_draw

	rect.queue_free()
	warmup_complete.emit()
