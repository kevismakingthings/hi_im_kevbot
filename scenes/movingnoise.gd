extends TextureRect

@export var z_amplitude = 200.0
@export var z_speed = 0.5
@export var xy_speed = 0.5
@export var radius = 200

var time = 0.0
var circle_angle = 0
var tex_xy = Vector2(0,0)
var tex_z = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	circle_angle += xy_speed * delta
	tex_xy = Vector2(cos(circle_angle), sin(circle_angle)) * radius
	tex_z = sin(time * z_speed) * z_amplitude
	texture.noise.offset = Vector3(tex_xy.x, tex_xy.y, tex_z)
