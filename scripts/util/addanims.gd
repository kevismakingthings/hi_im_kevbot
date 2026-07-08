@tool
extends EditorScript

func _run():
	var dir := "res://anim_presets"
	if not DirAccess.dir_exists_absolute(dir):
		DirAccess.make_dir_recursive_absolute(dir)

	# 1. POP IN — overshoot entrance (scale 0 → 1)
	_save("pop_in", {
		property = "scale", use_from = true, from_value = Vector2.ZERO,
		to_value = Vector2.ONE, duration = 0.35,
		trans = Tween.TRANS_BACK, ease = Tween.EASE_OUT })

	# 2. FADE IN — modulate alpha 0 → 1
	_save("fade_in", {
		property = "modulate:a", use_from = true, from_value = 0.0,
		to_value = 1.0, duration = 0.4,
		trans = Tween.TRANS_SINE, ease = Tween.EASE_OUT })

	# 3. FADE OUT — modulate alpha → 0 (exit)
	_save("fade_out", {
		property = "modulate:a", to_value = 0.0, duration = 0.3,
		trans = Tween.TRANS_SINE, ease = Tween.EASE_IN })

	# 4. BREATHE — looping scale pulse (idle / "look at me")
	_save("breathe", {
		property = "scale", to_value = Vector2(1.08, 1.08), duration = 0.8,
		yoyo = true, loop_count = 0,
		trans = Tween.TRANS_SINE, ease = Tween.EASE_IN_OUT })

	# 5. HIT FLASH — overbright punch then back (damage / impact feedback)
	_save("hit_flash", {
		property = "modulate", to_value = Color(3, 3, 3, 1), duration = 0.08,
		yoyo = true,
		trans = Tween.TRANS_QUAD, ease = Tween.EASE_OUT })

	print("Saved 5 presets to ", dir)

func _save(preset_name: String, props: Dictionary) -> void:
	var r := TweenPreset.new()
	for k in props:
		r.set(k, props[k])
	ResourceSaver.save(r, "res://anim_presets/%s.tres" % preset_name)
