# audio_manager.gd
extends Node

var sfx_players: Array[AudioStreamPlayer] = []
const SFX_POOL_SIZE = 8

@onready var music_player := AudioStreamPlayer.new()

func _ready():
	music_player.bus = "Music"
	add_child(music_player)

	for i in SFX_POOL_SIZE:
		var p = AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		sfx_players.append(p)

func play_sfx(stream: AudioStream, volume_db: float = 0.0, pitch: float = 1.0):
	for p in sfx_players:
		if not p.playing:
			p.stream = stream
			p.volume_db = volume_db
			p.pitch_scale = pitch
			p.play()
			return
	# pool exhausted, steal the first one
	sfx_players[0].stream = stream
	sfx_players[0].play()

func stop_sfx():
	for p in sfx_players:
		if p.playing:
			p.stop()
			return


func play_music(stream: AudioStream, fade_in: float = 0.0):
	music_player.stream = stream
	music_player.play()
