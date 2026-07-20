extends TextureRect

@export var z_amplitude = 20.0
@export var z_speed = 6.5
@export var xy_speed = 0.5
@export var radius = 200
@export var speed_amp = 300
@onready var sprite: AnimatedSprite2D = %Kevsprite
@onready var light: PointLight2D = $borderlight

const start_speed = 5
const cycles_per_loop = 2
const freq = 6.5
var time = 0.0
var circle_angle = 0
var tex_xy = Vector2(0,0)
var tex_z = 6.5
var looped = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#time += delta
	#circle_angle += xy_speed * delta
	#var z_speed = (sin(time * freq) * speed_amp) + start_speed
	#tex_z = sin(time * z_speed) * z_amplitude
	#
	#var frame_count := sprite.sprite_frames.get_frame_count(sprite.animation)
	#var progress := (float(sprite.frame) / frame_count) # 0.0 → 1.0 across the loop
	##var move_speed = (sin(progress * TAU * cycles_per_loop) * speed_amp) + start_speed
	var move_speed = 50
	if sprite.frame == 32 and not looped:
		looped = true
		var t = create_tween()
		t.tween_property(light, "energy", 0, 2.1).from(3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	elif sprite.frame == 0:
		looped = false
	var current_pos = texture.noise.offset
	tex_z = current_pos.z
	texture.noise.offset = Vector3(current_pos.x, current_pos.y + (move_speed * delta), tex_z + (z_speed * delta))
