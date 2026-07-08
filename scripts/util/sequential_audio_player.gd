# sequential_audio_player.gd
extends Node

@onready var player := AudioStreamPlayer.new()
var queue: Array[AudioStream] = []

func _ready():
	add_child(player)
	player.finished.connect(_on_finished)

func queue_audio(stream: AudioStream):
	queue.append(stream)
	if not player.playing:
		_play_next()

func _play_next():
	if queue.is_empty():
		return
	player.stream = queue.pop_front()
	player.play()

func _on_finished():
	_play_next()
