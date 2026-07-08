#aboutmenu.gd
extends Control

signal back_pressed
signal esc_pressed
const DETAIL_PANEL := preload("res://scenes/component/DetailPanel.tscn")

@export var slide_time := 0.3
@export var light_time := 0.5
@onready var fullpanel: Node2D = $fullpanel
@onready var backpanel: Panel = $fullpanel/backpanel
@onready var light: PointLight2D = $PointLight2D
@onready var dark: CanvasModulate = $fullpanel/CanvasModulate
@onready var kev: AnimatedSprite2D = $fullpanel/kevMask/kevface
@onready var dockbuttons: Control = $fullpanel/DockButtons
@onready var dockanimation: AnimationPlayer = $fullpanel/Dock/DockAnimations
@onready var musicaudiobutton: Button = $fullpanel/skillspassions/MusicAudio
@onready var devtinkerbutton: Button = $fullpanel/skillspassions/DevTinker
@onready var photoartbutton: Button = $fullpanel/skillspassions/PhotoArt
@onready var skatefilmbutton: Button = $fullpanel/skillspassions/SkateFilm

const MUSIC_AUDIO = "MUSICAUDIO"
const DEV_TINKER = "DEVTINKER"
const SKATE_FILM = "SKATEFILM"
const PHOTO_ART = "PHOTOART"

var music_audio_panel: DetailPanel
var dev_tinker_panel: DetailPanel
var photo_art_panel: DetailPanel
var skate_film_panel: DetailPanel

var panel_open: bool = false
var current_panel: DetailPanel

func _on_back_button_pressed() -> void:
	back_pressed.emit()

func _ready() -> void:
	musicaudiobutton.skillsButtonPressed.connect(func(): open_panel(MUSIC_AUDIO))
	devtinkerbutton.skillsButtonPressed.connect(func(): open_panel(DEV_TINKER))
	photoartbutton.skillsButtonPressed.connect(func(): open_panel(PHOTO_ART))
	skatefilmbutton.skillsButtonPressed.connect(func(): open_panel(SKATE_FILM))
	
	# ANIMATE BEGINNING
	var w := get_viewport_rect().size.x
	$fullpanel.position.x = w                       # start fully off-screen right
	var tween := create_tween().set_parallel()
	tween.set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(fullpanel, "position:x", 0.0, light_time).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(light, "energy", 1.2, light_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).set_delay(0.5)
	tween.tween_property(light, "position", Vector2(250,275), light_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_delay(0.5)
	await tween.finished
	tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_parallel().set_ease(Tween.EASE_OUT)
	tween.tween_property(kev, "position", Vector2(130,173), 1.5)
	tween.tween_property(kev, "rotation_degrees", 360, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	kev.play()


func exit() -> void:
	var w := get_viewport_rect().size.x
	var tween := create_tween().set_parallel()
	dockbuttons._shift_down()
	dockanimation.play("dockdisappear")
	tween.tween_property(kev, "position", Vector2(130,-100), 0.3).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(fullpanel, "position:x", w, slide_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_delay(0.3)
	tween.tween_property(light, "energy", 0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(light, "position", Vector2(-400,1000), 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	
func _on_musicinstabutton_pressed() -> void:
	OS.shell_open("https://instagram.com/kev_bot.prod")

func _on_emailbutton_pressed() -> void:
	DisplayServer.clipboard_set("kevismakingthings@gmail.com")
	# TODO add popup for clipboard copy

func _on_youtubebutton_pressed() -> void:
	OS.shell_open("https://www.youtube.com/@kev_bot_prod")

func _on_spotifybutton_pressed() -> void:
	OS.shell_open("https://open.spotify.com/artist/1Zi9TJw9EPh17IohlrkrlJ")

func _on_soundcloudbutton_pressed() -> void:
	OS.shell_open("https://soundcloud.com/kev_bot_prod")

func _on_framesbutton_pressed() -> void:
	OS.shell_open("https://instagram.com/duck.truck.kev")

func _on_photoinstabutton_pressed() -> void:
	OS.shell_open("https://instagram.com/kev_bot.dcim")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if(!panel_open):
			esc_pressed.emit()
			get_viewport().set_input_as_handled()

func open_detail_panel(panel: DetailPanel) -> void:
	current_panel = panel
	current_panel.position = Vector2(0,0)
	fullpanel.add_child(current_panel)
	current_panel.grab_focus.call_deferred()
	current_panel.panel_esc_pressed.connect(esc_is_pressed)
	current_panel.focus_released.connect(close_current_panel)
	panel_open = true
	
func open_panel(type: String) -> void:
	if type == MUSIC_AUDIO:
		open_detail_panel(create_panel(SkillsConstants.music_audio_vals))
	elif type == DEV_TINKER:
		open_detail_panel(create_panel(SkillsConstants.dev_tinker_vals))
	elif type == PHOTO_ART:
		open_detail_panel(create_panel(SkillsConstants.photo_art_vals))
	elif type == SKATE_FILM:
		open_detail_panel(create_panel(SkillsConstants.skate_film_vals))
	
func close_current_panel() -> void:
	await current_panel.exit()
	current_panel.queue_free()
	panel_open = false
	self.grab_focus()
	
func esc_is_pressed() -> void:
	current_panel.release_focus()
	close_current_panel()

func create_panel(vals: DetailPanelVals) -> DetailPanel:
	var panel := DETAIL_PANEL.instantiate()
	panel.values = vals
	panel.setup_panel()
	return panel
