extends Node

const MUSIC_AUDIO_TOP_BOX = preload("res://ASSETS/visual_presets/style_box/musicaudiotop.tres")
const MUSIC_AUDIO_BOTTOM_BOX = preload("res://ASSETS/visual_presets/style_box/musicaudiobottom.tres")
const MUSIC_AUDIO_TITLE = "[w][wave connected = 0 amp=10 freq=2] Music [/wave]+ Audio"
const MUSIC_AUDIO_BLURB = "[b]3+ years experience in music production, audio engineering, sound design. Always looking to find the [wave amp=15 freq=2;peach_puff;sparkle;hue 0.5]feeling[] within the waveform."
const MUSIC_AUDIO_SKILLS: Array[String] = ["Bitwig", "Ableton", "Sound Design"]
const MUSIC_AUDIO_SKILL_VALS: Array[float] = [6, 5, 4]
const MUSIC_AUDIO_BAR_COLORS: Array[Color] = [Color("#ddbafa"), Color("#850faf")]
const MUSIC_AUDIO_PROJECT_TITLE = "My mixtape release!"
const MUSIC_AUDIO_PROJECT_IMG = preload("res://ASSETS/images/albumctry1.png")
const MUSIC_AUDIO_PROJECT_BLURB = "Check it out wherever you listen to music. :)"

const DEV_TINKER_TOP_BOX = preload("res://ASSETS/visual_presets/style_box/devtinkertop.tres")
const DEV_TINKER_BOTTOM_BOX = preload("res://ASSETS/visual_presets/style_box/devtinkerbottom.tres")
const DEV_TINKER_TITLE = "[w][pulse color=green freq=1.0] Dev + Tinker"
const DEV_TINKER_BLURB = "[b][orange]3[] years industry experience building backend dev tooling for [lightblue]Atlassian[]. Since then, I've explored personal projects in other areas, including lighting hardware, light show software, and game dev!"
const DEV_TINKER_SKILLS: Array[String] = ["Java", "Backend Tooling", "Lighting Hardware + Software", "Arduino", "Godot"]
const DEV_TINKER_SKILL_VALS: Array[float] = [7, 6, 3, 3, 2]
const DEV_TINKER_BAR_COLORS: Array[Color] = [Color("#60e6c1"), Color("#2d6942")]
const DEV_TINKER_PROJECT_TITLE = "My game release!"
const DEV_TINKER_PROJECT_IMG = preload("res://ASSETS/images/albumctry1.png")
const DEV_TINKER_PROJECT_BLURB = "Check out a lighting project I did here!"

const PHOTO_ART_TOP_BOX = preload("res://ASSETS/visual_presets/style_box/musicaudiotop.tres")
const PHOTO_ART_BOTTOM_BOX = preload("res://ASSETS/visual_presets/style_box/musicaudiobottom.tres")
const PHOTO_ART_TITLE = "[w][wave connected = 0 amp=10 freq=2] Photo [/wave]+ Art"
const PHOTO_ART_BLURB = "I bought a Nikon Z5 last year and it has been a new obsession to take it wherever I go, capturing candid memories for myself and  others. I also have been dabbling in pixel art recently and have been really enjoying it!"
const PHOTO_ART_SKILLS = ["Photoshop", "Lightroom", "Illustrator"]
const PHOTO_ART_PROJECT_TITLE = "My photo album release!"
const PHOTO_ART_PROJECT_IMG = preload("res://ASSETS/images/albumctry1.png")
const PHOTO_ART_PROJECT_BLURB = "Check it out wherever you listen to music. :)"

# const SKATE_FILM_TOP_BOX = preload("res://ASSETS/visual_presets/style_box/musicaudiotop.tres")
# const SKATE_FILM_BOTTOM_BOX = preload("res://ASSETS/visual_presets/style_box/musicaudiobottom.tres")
# const SKATE_FILM_TITLE = "[w][wave connected = 0 amp=10 freq=2] Skate [/wave]+ Film"
# const SKATE_FILM_BLURB = "3+ years experience in skateboarding, filmmaking, and visual storytelling. Always looking to find the [wave amp=15 freq=2;peach_puff;sparkle;hue 0.5]feeling[] within the frame."
# const SKATE_FILM_SKILLS = ["DaVinci Resolve", "After Effects", "Premiere Pro"]
# const SKATE_FILM_PROJECT_TITLE = "My skate video release!"
# const SKATE_FILM_PROJECT_IMG = preload("res://ASSETS/images/albumctry1.png")
# const SKATE_FILM_PROJECT_BLURB = "Check it out wherever you listen to music. :)"

var music_audio_vals: DetailPanelVals = DetailPanelVals.new()
var dev_tinker_vals: DetailPanelVals = DetailPanelVals.new()
var photo_art_vals: DetailPanelVals = DetailPanelVals.new()
var skate_film_vals: DetailPanelVals = DetailPanelVals.new()

func set_constants():
	music_audio_vals.title = MUSIC_AUDIO_TITLE
	music_audio_vals.blurb = MUSIC_AUDIO_BLURB
	music_audio_vals.top_box = MUSIC_AUDIO_TOP_BOX
	music_audio_vals.bottom_box = MUSIC_AUDIO_BOTTOM_BOX
	music_audio_vals.skills = MUSIC_AUDIO_SKILLS
	music_audio_vals.skill_vals = MUSIC_AUDIO_SKILL_VALS
	music_audio_vals.bar_colors = MUSIC_AUDIO_BAR_COLORS
	music_audio_vals.project_caption= MUSIC_AUDIO_PROJECT_TITLE
	music_audio_vals.project_image = MUSIC_AUDIO_PROJECT_IMG
	music_audio_vals.project_blurb = MUSIC_AUDIO_PROJECT_BLURB
	
	dev_tinker_vals.title = DEV_TINKER_TITLE
	dev_tinker_vals.blurb = DEV_TINKER_BLURB
	dev_tinker_vals.top_box = DEV_TINKER_TOP_BOX
	dev_tinker_vals.bottom_box = DEV_TINKER_BOTTOM_BOX
	dev_tinker_vals.skills = DEV_TINKER_SKILLS
	dev_tinker_vals.skill_vals = DEV_TINKER_SKILL_VALS
	dev_tinker_vals.bar_colors = DEV_TINKER_BAR_COLORS
	dev_tinker_vals.project_caption = DEV_TINKER_PROJECT_TITLE
	dev_tinker_vals.project_image = DEV_TINKER_PROJECT_IMG
	dev_tinker_vals.project_blurb = DEV_TINKER_PROJECT_BLURB
