extends Button
@onready var lock: AnimatedSprite2D = %locksprite
var t = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("focus_entered", _onfocus)
	connect("focus_exited", _onlosefocus)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _onfocus() -> void:
	#AudioManager.play_sfx(SamplePreload.UI_SELECT, -0.0)	
	var offset = self.icon.noise.offset
	t = create_tween().set_parallel()
	t.tween_property(self, "modulate", Color(1.1,0.7,1.2), 0.3) # Make it brighter
	t.tween_property(self.icon.noise, "offset", offset + Vector3(100,100,300), 20).set_ease(Tween.EASE_IN_OUT)
	
	
func _onlosefocus() -> void:
	var e_t := create_tween().set_parallel()
	var offset = self.icon.noise.offset
	e_t.tween_property(self, "modulate", Color(0.9,0.9,0.9), 0.5) # Make it brighter
	e_t.tween_property(self.icon.noise, "offset", offset + Vector3(5,5,5), 1).set_ease(Tween.EASE_OUT)

	if t != null:
		t.kill()
	


func _on_button_down() -> void:
	if self.name == "startbutton":
		lock.play()
	else:
		AudioManager.play_sfx(SamplePreload.BLIP_SELECT, -5.0)

	pass # Replace with function body.


func _on_button_up() -> void:
	pass # Replace with function body.


func _on_mouse_entered() -> void:
	lock.play()
