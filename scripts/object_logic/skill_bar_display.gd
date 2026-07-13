@tool
extends RicherTextLabel
class_name SkillBarDisplay

@onready var bar: TextureProgressBar = %Bar
@export var skill_name: String
@export var skill_val: float
@export var colors: Array[Color]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	custom_minimum_size = Vector2(200,50)
	custom_maximum_size = Vector2(200,50)
	var mat := bar.material as ShaderMaterial
	mat.set_shader_parameter("color_gap", colors[0])
	mat.set_shader_parameter("color_stripe", colors[1])
	bar.value = skill_val
	bbcode = skill_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
