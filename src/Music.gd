extends Node

onready var player

func _ready():
	player = AudioStreamPlayer.new()
	add_child(player)
	# set_music("Rondo of crab DEMO")

func set_music(name):
	player.stream = load("res://assets/music/%s.ogg" % name)
	player.play()



