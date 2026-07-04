class_name DetailPanel
extends Control

signal panel_esc_pressed
signal focus_released
@onready var animation: AnimationPlayer = $TopPanel/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_focus_exited() -> void:
	animation.play("hidedetailpanel")
	focus_released.emit()


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		panel_esc_pressed.emit()


func _on_focus_entered() -> void:
	print("Focus entered")
	
func exit() -> void:
	await animation.animation_finished
