#aboutmenu.gd
extends Control

signal back_pressed
signal esc_pressed

const MUSIC_AUDIO_PANEL := preload("res://scenes/musicaudiopanel.tscn")
const DEV_TINKER_PANEL := preload("res://scenes/devtinkerpanel.tscn")
const PHOTO_ART_PANEL := preload("res://scenes/photoartpanel.tscn")
const SKATE_FILM_PANEL := preload("res://scenes/skatefilmpanel.tscn")

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

var panel_open: bool = false
var current_panel: DetailPanel
#@onready var backbutton_shadow: Sprite2D = $fullpanel/back_button/Sprite2D

func _on_back_button_pressed() -> void:
	back_pressed.emit()

func _ready() -> void:
	
	musicaudiobutton.skillsButtonPressed.connect(open_music_audio_panel)
	devtinkerbutton.skillsButtonPressed.connect(open_dev_tinker_panel)
	photoartbutton.skillsButtonPressed.connect(open_photo_art_panel)
	skatefilmbutton.skillsButtonPressed.connect(open_skate_film_panel)
	
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

func open_detail_panel(scene: PackedScene) -> void:
	current_panel = scene.instantiate()
	current_panel.position = Vector2(0,0)
	fullpanel.add_child(current_panel)
	current_panel.grab_focus.call_deferred()
	current_panel.panel_esc_pressed.connect(esc_is_pressed)
	current_panel.focus_released.connect(close_current_panel)
	panel_open = true
	
func open_music_audio_panel() -> void:
	open_detail_panel(MUSIC_AUDIO_PANEL)

func open_dev_tinker_panel() -> void:
	open_detail_panel(DEV_TINKER_PANEL)
	
func open_photo_art_panel() -> void:
	open_detail_panel(PHOTO_ART_PANEL)
	
func open_skate_film_panel() -> void:
	open_detail_panel(SKATE_FILM_PANEL)
	
func close_current_panel() -> void:
	await current_panel.exit()
	current_panel.queue_free()
	panel_open = false
	self.grab_focus()
	
func esc_is_pressed() -> void:
	current_panel.release_focus()
	close_current_panel()
