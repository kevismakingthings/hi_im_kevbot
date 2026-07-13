# startmenu.gd
extends Control

signal play_pressed
signal about_pressed
@onready var container: SubViewportContainer = $SubViewportContainer

func _on_quitbutton_pressed() -> void:
	get_tree().quit()


func _on_startbutton_pressed() -> void:
	AudioManager.play_sfx(SamplePreload.SFX_CONFIRM, -5.0)
	play_pressed.emit()

func _on_aboutbutton_pressed() -> void:
	AudioManager.play_sfx(SamplePreload.UI_SELECT, -3.0)
	about_pressed.emit()
	
func _ready() -> void:               
	var mat := container.material as ShaderMaterial
	mat.set_shader_parameter("pixel_size", 32)
	mat.set_shader_parameter("blur_amount", 2)	
	var t := create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	t.tween_method(func(v): mat.set_shader_parameter("pixel_size", v), 16, 1, 1.2).set_ease(Tween.EASE_OUT)
	t.tween_method(func(v): mat.set_shader_parameter("blur_amount", v), 1, 0, 1.2).set_ease(Tween.EASE_OUT)

func exit() -> void:
	var mat := container.material as ShaderMaterial
	var t := create_tween().set_parallel().set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	t.tween_method(func(v): mat.set_shader_parameter("pixel_size", v), 1, 16, 1).set_ease(Tween.EASE_IN_OUT)
	t.tween_method(func(v): mat.set_shader_parameter("blur_amount", v), 0.0, 1.3, 1).set_ease(Tween.EASE_IN_OUT)
	await t.finished
