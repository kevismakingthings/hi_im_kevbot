# startmenu.gd
extends Control

signal play_pressed
signal about_pressed
@onready var container: SubViewportContainer = $SubViewportContainer

func _on_quitbutton_pressed() -> void:
	get_tree().quit()


func _on_startbutton_pressed() -> void:
	AudioManager.play_sfx(SamplePreload.SFX_CONFIRM, 0.0)
	play_pressed.emit()

func _on_aboutbutton_pressed() -> void:
	AudioManager.play_sfx(SamplePreload.UI_SELECT, 2.0)
	about_pressed.emit()
	
func _ready() -> void:               
	var mat := container.material as ShaderMaterial
	mat.set_shader_parameter("pixel_size", 32)
	var t := create_tween().set_parallel()
	t.tween_method(func(v): mat.set_shader_parameter("pixel_size", v), 32, 1, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	t.tween_method(func(v): mat.set_shader_parameter("blur_amount", v), 1.5, 0, 1).set_ease(Tween.EASE_OUT)

func exit() -> void:
	
	print(">>> exit() called at ", Time.get_ticks_msec())
	var mat := container.material as ShaderMaterial
	var t := create_tween().set_parallel().set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	t.tween_method(func(v): mat.set_shader_parameter("pixel_size", v), 1, 12, 1).set_ease(Tween.EASE_IN_OUT)
	t.tween_method(func(v): mat.set_shader_parameter("blur_amount", v), 0.0, 1.3, 1).set_ease(Tween.EASE_IN_OUT)
	await t.finished
