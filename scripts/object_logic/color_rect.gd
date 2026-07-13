extends ColorRect

# How high/low the object floats
var c1_time: float = 0.0
var c2_time: float = 0.0
var c1_freq: float = -0.1
var c2_freq: float = 0.0
var rate: float = 0
var time_to_start: float = 9.8
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if material is ShaderMaterial:
		# Set a uniform parameter value
		material.set_shader_parameter("Center", Vector2(0,0))
	get_tree().create_timer(time_to_start).timeout.connect(_sync)
	#get_tree().create_timer(2).timeout.connect(_sync)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	c1_time += c1_freq * delta
	c2_time += c2_freq * delta
	material.set_shader_parameter("custom1_time", c1_time)
	material.set_shader_parameter("custom2_time", c2_time)

	#var spriteCenter = get_parent().get_child(0).global_position
	#material.set_shader_parameter("center", Vector2(spriteCenter.x / screen_size.x, ((spriteCenter.y + 32) / screen_size.y)))
		# sin() takes radians, so we multiply Time.get_time_dict_from_system() 
	 #or delta accumulation to drive continuous progress
	#var new_speed = start_speed + sin(t * frequency) * amplitude
	#material.set_shader_parameter("speed", new_speed)


func _sync() -> void:
	print("syncing!")
	var mat := self.material as ShaderMaterial
	#mat.set_shader_parameter("color_a", Color(.6,.8,.6))
	#mat.set_shader_parameter("color_b", Color(.6,.8,.6))
	var t = create_tween().set_parallel().set_loops()
	t.tween_property(self, "c1_freq", 3, 1.05).set_ease(Tween.EASE_IN)
	t.tween_property(self, "c1_freq", 0.5, 1.05).from(0).set_ease(Tween.EASE_IN).set_delay(1.05)
	t.tween_property(self, "c2_freq", 0, 1.05).from(.5).set_ease(Tween.EASE_OUT).set_delay(1.05)
	var t2 = create_tween().set_parallel().set_loops()
	t2.tween_method(func(v): mat.set_shader_parameter("shift", v), .5, 0, 1.05).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE).set_delay(1.05)
	t2.tween_method(func(v): mat.set_shader_parameter("rings2", v), 5, 12, 1.05).set_ease(Tween.EASE_OUT).set_delay(1.05)
	t2.tween_method(func(v): mat.set_shader_parameter("color_b", v), Color(1,1,1,0.3), Color(0.12,0.1,0.1,0.6), 1.05).set_ease(Tween.EASE_OUT).set_delay(1.05)

	
