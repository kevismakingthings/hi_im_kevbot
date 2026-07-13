extends Area2D

signal pause_pressed

@export var speed = 10 # How fast the player will move (pixels/sec).
@export var max_points := 15      # trail length, in points
@export var point_distance := 16.0   # min pixels moved before adding a point
@onready var trail: Line2D = $Trail
@onready var path: Path2D = $Path
@onready var follow: PathFollow2D = $Path.get_child(0)
@onready var trail2: Line2D = $Trail2
@onready var texture: FastNoiseLite = $Trail.texture.noise
@onready var particles: CPUParticles2D = follow.get_child(0)
@onready var camera: Camera2D = $Camera2D
@onready var spotlight: PointLight2D = $Spotlight

var screen_size # Size of the game window.
var increment = 1
var decrement = 1
var velocity = Vector2.ZERO
var _last_pos := Vector2.ZERO
var _t := 0.0
@onready var timer: Timer = $Timer
@onready var timer2: Timer = $Timer2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_on_timeout)
	timer2.timeout.connect(_on_timeout2)
	screen_size = get_viewport_rect().size
	_last_pos = global_position
	particles.emitting = false
	$Kevsprite.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_t += delta
	if Input.is_action_pressed("move_down") || \
	   Input.is_action_pressed("move_right") || \
	   Input.is_action_pressed("move_left") || \
	   Input.is_action_pressed("move_up") :
		increment += 0.05
		decrement -= 0.3
		speed += increment

	else: 
		speed -= decrement
		increment -= 0.1
		decrement += 0.5
	speed = clampi(speed, 0, 400)
	increment = clampf(increment, 1, 15)
	decrement = clampf(decrement, 1, 5)
	velocity = velocity.normalized()
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.x != 0 && velocity.y == 0:
		$Kevsprite.animation = "jig"
		# See the note below about the following boolean assignment.
		$Kevsprite.flip_h = false
	elif velocity.y > 0:
		$Kevsprite.rotation_degrees = 0
		$Kevsprite.animation = "skate"
		$Kevsprite.flip_v = false
	elif velocity.y < 0:
		$Kevsprite.rotation_degrees = 0
		$Kevsprite.animation = "skateback"	
	else:
		$Kevsprite.animation = "talk"

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	if !$Kevsprite.is_playing():
		$Kevsprite.play()
		$HandSprite.play()
		
	position += velocity * delta
	
	if global_position.distance_to(_last_pos) >= point_distance:
		path.curve.add_point(global_position)
		trail.add_point(follow.transform.get_origin())
		trail.add_point(global_position)
		_last_pos = global_position
		while trail.get_point_count() > max_points:
			trail.remove_point(0)
		while path.curve.point_count > 30:
			path.curve.remove_point(0)
	 
func _on_timeout2() -> void:
	pass
	#trail.remove_point(0)
	#var tween = create_tween()
	#tween.tween_property(self, "follow:progress_ratio", 1.0, 1.0).from(0.0)

	
func _on_timeout() -> void:
	particles.emitting = true
	
func start_the_game() -> void:
	#timer.start()
	#timer2.start()
	print("game starting!")
	$Kevsprite.visible = true
	var tween = create_tween().set_parallel()
	tween.tween_property(camera, "position", Vector2(32,32), 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(camera, "zoom", Vector2(1.4, 1.4), 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(spotlight, "energy", 0.5, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO).set_delay(0.4)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		AudioManager.play_sfx(SamplePreload.UI_KEY_ROLL, -7.0, -1.5)
		pause_pressed.emit()
		get_viewport().set_input_as_handled()
