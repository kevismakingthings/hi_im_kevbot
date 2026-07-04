extends Control

@export var fadein: TweenPreset

var fadeTime = 1.3
var interval = 0.1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var count = 0
	for child in self.get_children():
		child.modulate.a = 0
		child.get_child(1).modulate.a = 0
	await get_tree().create_timer(1).timeout
	var t := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).set_parallel()
	for child in self.get_children():
		count += 1
		t.tween_property(child, "modulate:a", 1.0, fadeTime+0.5).from(0).set_trans(Tween.TRANS_SINE).set_delay(interval * count)
		t.tween_property(child, "position", child.position, fadeTime).from(child.position + Vector2(-20, 100)).set_delay(interval * count)
		t.tween_property(child, "scale", child.scale, fadeTime).from(Vector2(0,0)).set_delay(interval * count)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _shift_down() -> void:
	var t := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE).set_parallel()
	for child in self.get_children():
		t.tween_property(child, "position", child.position + Vector2(0, 100), 0.3).from(child.position)
		t.tween_property(child, "modulate:a", 0, 0.3)
