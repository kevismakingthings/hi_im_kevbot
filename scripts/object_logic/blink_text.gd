extends RichTextLabel

@export var amplitude = .5
@export var speed = 5
var time = 0.0
var alpha = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = alpha
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	modulate.a = 0.5 + sin(time * speed) * amplitude
