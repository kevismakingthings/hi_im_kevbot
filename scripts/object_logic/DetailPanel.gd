class_name DetailPanel
extends Control

signal panel_esc_pressed
signal focus_released
const SKILL_BAR_DISPLAY := preload("res://scenes/component/SkillBarDisplay.tscn")

@export var values: DetailPanelVals

@onready var animation: AnimationPlayer = $TopPanel/AnimationPlayer
@onready var top_panel: Panel = $TopPanel
@onready var title: RichTextAnimation = %Title
@onready var blurb: RicherTextLabel = %Blurb
@onready var skills_panel: Panel = %SkillsPanel
@onready var projects_panel: Panel = %ProjectsPanel
@onready var bar_container: VBoxContainer = %BarContainer
@onready var project_caption: RicherTextLabel = %ProjectCaption
@onready var project_blurb: RicherTextLabel = %ProjectBlurb
@onready var project_image: TextureRect = %ProjectImage



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func setup_panel() -> void:
	#SETUP VALUES
	if not top_panel:
		await self.ready
	top_panel.add_theme_stylebox_override("panel", values.top_box)
	skills_panel.add_theme_stylebox_override("panel", values.bottom_box)
	projects_panel.add_theme_stylebox_override("panel", values.bottom_box)
	title.bbcode = values.title
	blurb.bbcode = values.blurb
	project_caption.bbcode = values.project_caption
	project_blurb.bbcode = values.project_blurb
	project_image.texture = values.project_image
	#SETUP SKILL BARS
	for i in range(values.skills.size()):
		var skill_bar := SKILL_BAR_DISPLAY.instantiate()
		skill_bar.skill_name = values.skills[i]
		skill_bar.skill_val = values.skill_vals[i]
		skill_bar.colors = values.bar_colors
		bar_container.add_child(skill_bar)

func _on_focus_exited() -> void:
	AudioManager.play_sfx(SamplePreload.DOCK_RAISE, -7, 1.3)
	animation.play("hidedetailpanel")
	focus_released.emit()


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		AudioManager.play_sfx(SamplePreload.UI_KEY_ROLL, -7.0, -1.5)
		panel_esc_pressed.emit()


func _on_focus_entered() -> void:
	print("Focus entered")
	
func exit() -> void:
	await animation.animation_finished
