extends ColorRect

# How high/low the object floats
@export var amplitude: float = -0.5
# How fast the bobbing happens
@export var frequency: float = 0.05
var start_speed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if material is ShaderMaterial:
		# Set a uniform parameter value
		material.set_shader_parameter("Center", Vector2(0,0))
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var screen_size = get_viewport_rect().size
	#var spriteCenter = get_parent().get_child(0).global_position
	#material.set_shader_parameter("center", Vector2(spriteCenter.x / screen_size.x, ((spriteCenter.y + 32) / screen_size.y)))
		# sin() takes radians, so we multiply Time.get_time_dict_from_system() 
	 #or delta accumulation to drive continuous progress
	var t = Time.get_ticks_msec() / 1000.0
	#var new_speed = start_speed + sin(t * frequency) * amplitude
	#material.set_shader_parameter("speed", new_speed)
