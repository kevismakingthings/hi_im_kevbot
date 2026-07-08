class_name TweenPreset
extends Resource

@export var property: String = "scale"
@export var to_value: Variant = Vector2(1.2, 1.2)
@export var duration: float = 0.3
@export var trans: Tween.TransitionType = Tween.TRANS_SINE
@export var easing: Tween.EaseType = Tween.EASE_IN_OUT
@export var loops: bool = false
@export var use_from: bool = false      # force a starting value before animating
@export var from_value: Variant = null
@export var yoyo: bool = false          # animate to target, then back to start
@export var loop_count: int = 1         # 1 = once, <=0 = infinite


func apply(node: Node) -> Tween:
	var start = from_value if use_from else node.get_indexed(property)
	if use_from:
		node.set_indexed(property, from_value)
	var t = node.create_tween()
	if loop_count <= 0:   t.set_loops()
	elif loop_count > 1:  t.set_loops(loop_count)
	t.tween_property(node, property, to_value, duration).set_trans(trans).set_ease(easing)
	if yoyo:
		t.tween_property(node, property, start, duration).set_trans(trans).set_ease(easing)
	return t
