extends Control

@onready var warning_sprite: AnimatedSprite2D = %warning_sprite
@onready var splash_animation: AnimationPlayer = $animation
@onready var ambience: AudioStreamPlayer = $ambience
@onready var warmup_vp: SubViewport = $warmup
var main_scene = "res://scenes/main.tscn"
var progress = []
var packed_main: PackedScene
var shaders_loaded = false
var scene_loaded = false
var splashed = false
var scene_change = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_window().content_scale_factor = 1.25
	ResourceLoader.load_threaded_request(main_scene)
	warmup_vp.warmup(ShaderRegistry.all_shaders)
	warning_sprite.play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !scene_loaded:
		var status = ResourceLoader.load_threaded_get_status(main_scene, progress)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			# Retrieve the completely loaded PackedScene
			packed_main = ResourceLoader.load_threaded_get(main_scene)
			print("loaded!")
			scene_loaded = true
		elif status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			print("Loading progress: ", progress[0] * 100, "%")
	if scene_loaded and shaders_loaded and !splashed:
		splash_animation.play("splash")
		var t = create_tween().tween_property(ambience, "volume_db", 0, 1.0).set_trans(Tween.TRANS_SINE)
		splashed = true
	


func _on_warmup_warmup_complete() -> void:
	shaders_loaded = true

func _input(event: InputEvent) -> void:
	var keyboard_pressed = event is InputEventKey and event.pressed and not event.is_echo()
	var mouse_pressed = event is InputEventMouseButton and event.pressed
	var gamepad_pressed = event is InputEventJoypadButton and event.pressed

	if keyboard_pressed or mouse_pressed or gamepad_pressed:
		if scene_loaded and shaders_loaded and is_inside_tree() and !scene_change:
			scene_change = true;
			AudioManager.play_sfx(SamplePreload.SPLASH_VERB)
			var t = create_tween().tween_property(ambience, "volume_db", -80, 0.05).set_trans(Tween.TRANS_QUAD)
			splash_animation.play("fade_to_main")
			await splash_animation.animation_finished
			get_tree().change_scene_to_packed(packed_main)
