extends Node

onready var player

func _ready():
	player = AudioStreamPlayer.new()
	add_child(player)

func play_sound(name):
	player.stream = load("res://assets/sounds/%s.wav" % name)
	player.play()



