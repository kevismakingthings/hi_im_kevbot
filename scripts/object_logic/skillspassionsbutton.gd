extends Button

signal skillsButtonPressed

var mouse_inside = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pressed() -> void:
	skillsButtonPressed.emit()

	


func _on_mouse_entered() -> void:
	mouse_inside = true
	AudioManager.play_sfx(SamplePreload.ICON_SHOOT, -4.0, 1.2)


func _on_focus_entered() -> void:
	if(!mouse_inside):
		AudioManager.play_sfx(SamplePreload.ICON_SHOOT, -4.0, 1.2)


func _on_mouse_exited() -> void:
	mouse_inside = false
	pass # Replace with function body.


func _on_button_down() -> void:
	AudioManager.play_sfx(SamplePreload.BLIP_SELECT, -2.0)
	pass # Replace with function body.
