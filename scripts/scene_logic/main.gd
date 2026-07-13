# main.gd
extends Node

const START_MENU := preload("res://scenes/core/startmenu.tscn")
const ABOUT := preload("res://scenes/core/aboutmenu.tscn")
const GAME := preload("res://scenes/core/kev.tscn")

@onready var game: Node = $Game
@onready var start_layer: CanvasLayer = $StartLayer
@onready var blur_layer: CanvasLayer = $BlurLayer
@onready var about_layer: CanvasLayer = $AboutLayer
@onready var blur: ColorRect = $BlurLayer/SecondBlur
@onready var start_music: AudioStreamPlayer = $StartMusic
@onready var about_music: AudioStreamPlayer = $AboutMusic

var start_menu = null
var game_scene = null

func _ready() -> void:
	SkillsConstants.set_constants()	
	#game_scene = GAME.instantiate()
	#game_scene.pause_pressed.connect(pause_game)
	#game.add_child(game_scene)
	#game.get_tree().paused = false
	show_start_menu()


func _clear_ui() -> void:
	for child in start_layer.get_children():
		if child.has_method("exit"):
			await child.exit()
		child.queue_free()		

func show_start_menu() -> void:
	start_menu = START_MENU.instantiate()
	start_layer.add_child(start_menu)
	start_menu.play_pressed.connect(start_game)
	start_menu.about_pressed.connect(show_about)
	start_menu.grab_focus()
	play_start()

func start_game() -> void:
	await _clear_ui()
	game.get_tree().paused = false
	game_scene.start_the_game()
	
func pause_game() -> void:
	if(!game.get_tree().paused):
		game.get_tree().paused = true
		var t := create_tween().set_parallel()
		var mat := blur.material as ShaderMaterial
		t.tween_method(func(v): mat.set_shader_parameter("blur", v), 0.0, 1.5, 0.3).set_ease(Tween.EASE_IN_OUT)
		t.tween_method(func(v): mat.set_shader_parameter("dim", v), 0, 0.6, 0.3).set_ease(Tween.EASE_IN_OUT)
		show_start_menu()

func show_about() -> void:
	play_about()
	var about := ABOUT.instantiate()
	about.back_pressed.connect(back_to_main)
	about.esc_pressed.connect(back_to_main)
	blur.visible = true
	var mat := blur.material as ShaderMaterial
	mat.set_shader_parameter("blur", 0.0)
	mat.set_shader_parameter("dim", 0.0)
	var t := create_tween().set_parallel()
	t.tween_method(func(v): mat.set_shader_parameter("blur", v), 0.0, 1.5, 0.4)
	t.tween_method(func(v): mat.set_shader_parameter("dim", v), 0.0, 0.95, 0.4)
	about_layer.add_child(about)
	await get_tree().process_frame
	about.grab_focus.call_deferred()

func back_to_main() -> void:
	var mat := blur.material as ShaderMaterial
	var t := create_tween().set_parallel()
	t.tween_method(func(v): mat.set_shader_parameter("blur", v), 1.5, 0, 0.75).set_delay(0.15)
	t.tween_method(func(v): mat.set_shader_parameter("dim", v), 0.95, 0, 0.75).set_delay(0.15)
	blur.visible = false
	for child in about_layer.get_children():
		if child.has_method("exit"):
			await child.exit()
		child.queue_free()
	play_start()
	
func play_about() -> void:
	about_music.play()
	var t := create_tween().set_parallel().set_ease(Tween.EASE_OUT)
	t.tween_property(about_music, "volume_db", 0.0, 0.7)
	t.tween_property(start_music, "volume_db", -80.0, 0.7)
	
func play_start() -> void:
	start_music.play()
	var t := create_tween().set_parallel().set_ease(Tween.EASE_OUT)
	t.tween_property(start_music, "volume_db", 0.0, 0.7)
	t.tween_property(about_music, "volume_db", -80.0, 0.7)
