extends Button

@export var hover_lift := 4.0
@export var duration := 0.3

var _rest_pos = null
var save_scale = null
var hint = null
var hint_pos = null
var shake_tween = null
var init_rotation = null

func _ready() -> void:
	save_scale = self.scale
	_rest_pos = self.position
	hint = self.get_child(1)
	hint_pos = hint.position
	init_rotation = rotation_degrees
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_unhover)

func _on_hover() -> void:
	if self.modulate.a != 1:
		pass
	var t := create_tween().set_parallel()
	t.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	t.tween_property(self, "scale", Vector2.ONE * (save_scale + Vector2(.05,.05)), duration)
	t.tween_property(self, "position:y", _rest_pos.y - hover_lift, duration)
	t.tween_property(hint, "modulate:a", 1, duration)
	t.tween_property(hint, "position:y", hint_pos.y, duration).from(hint_pos.y + hover_lift)
	shake_tween = create_tween().set_loops()
	shake_tween.tween_property(self, "rotation_degrees", init_rotation -1, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	shake_tween.tween_property(self, "rotation_degrees", init_rotation + 1, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_button_down() -> void:
	shake_tween.kill()
	shake_tween = create_tween().set_loops()
	shake_tween.tween_property(self, "rotation_degrees", init_rotation -.5, 0.05).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	shake_tween.tween_property(self, "rotation_degrees", init_rotation + .5, 0.05).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _on_unhover() -> void:
	if self.modulate.a != 1:
		pass
	shake_tween.kill()
	var t := create_tween().set_parallel()
	t.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	t.tween_property(self, "scale", Vector2.ONE * save_scale, duration)
	t.tween_property(self, "position:y", _rest_pos.y, duration)
	t.tween_property(self, "rotation_degrees", init_rotation, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	t.tween_property(hint, "modulate:a", 0, duration)
	t.tween_property(hint, "position:y", hint_pos.y + hover_lift, duration).from(hint_pos.y)


func _on_focus_entered() -> void:
	pass # Replace with function body.


func _on_button_up() -> void:
	pass # Replace with function body.


func _on_focus_exited() -> void:
	pass # Replace with function body.
