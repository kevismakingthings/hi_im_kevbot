extends Button

@export var hover_lift := 4.0
@export var duration := 0.3
@export var scale_amp := Vector2(.2,.2)
@export var frames_scale := Vector2(.05,.05)

var _rest_pos: Vector2
var save_scale: Vector2
var hint: RichTextLabel
var hint_pos: Vector2
var shake_tween: Tween
var init_rotation: float
var t: Tween
var t2: Tween
var frames: bool = true

func _ready() -> void:
	if self.rotation_degrees == 0:
		frames = false
		pivot_offset = size / 2.0   # scale from center, not top-left
	save_scale = self.scale
	_rest_pos = self.position
	hint = self.get_child(1)
	hint_pos = hint.position
	init_rotation = rotation_degrees
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_unhover)

func _on_hover() -> void:
	focus_or_hover()

func _on_button_down() -> void:
	t.kill()
	shake_tween = create_tween().set_loops()
	shake_tween.tween_property(self, "rotation_degrees", init_rotation -.5, 0.09).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	shake_tween.tween_property(self, "rotation_degrees", init_rotation + .5, 0.09).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	t = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_parallel()
	t.tween_property(self, "scale", Vector2.ONE * (save_scale - scale_amp), 1.0)
	t.tween_property(hint, "modulate:a", 0, 0.6)

func _on_button_up() -> void:
	t.kill()
	t2 = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	t.tween_property(self, "scale", Vector2.ONE * (save_scale + scale_amp), duration)		
	t2.tween_property(self, "rotation_degrees", init_rotation -10, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	t2.tween_property(self, "rotation_degrees", init_rotation, 0.5).from(init_rotation-370).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	await t2.finished


func _on_unhover() -> void:
	unfocus_or_unhover()

func _on_focus_entered() -> void:
	focus_or_hover()

func _on_focus_exited() -> void:
	unfocus_or_unhover()

func unfocus_or_unhover() -> void:
	if self.modulate.a != 1:
		pass
	t = create_tween().set_parallel()
	t.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	t.tween_property(self, "scale", Vector2.ONE * save_scale, duration)
	t.tween_property(self, "position:y", _rest_pos.y, duration)
	t.tween_property(self, "rotation_degrees", init_rotation, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	t.tween_property(hint, "modulate:a", 0, duration)
	t.tween_property(hint, "position:y", hint_pos.y + hover_lift, duration).from(hint_pos.y)

func focus_or_hover() -> void:
	if self.modulate.a != 1:
		pass
	if t != null:
		t.kill()
	t = create_tween().set_parallel()
	t.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if frames:
		t.tween_property(self, "scale", Vector2.ONE * (save_scale + frames_scale), duration)
	else:
		t.tween_property(self, "scale", Vector2.ONE * (save_scale + scale_amp), duration)		
	t.tween_property(self, "position:y", _rest_pos.y - hover_lift, duration)
	t.tween_property(hint, "modulate:a", 1, duration)
	t.tween_property(hint, "position:y", hint_pos.y, duration).from(hint_pos.y + hover_lift)
	
func shake() -> void:
	if shake_tween != null:
		shake_tween.kill()
	shake_tween = create_tween().set_loops()
	shake_tween.tween_property(self, "rotation_degrees", init_rotation -1, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	shake_tween.tween_property(self, "rotation_degrees", init_rotation + 1, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
