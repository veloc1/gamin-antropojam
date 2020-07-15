extends Node2D

var DestroyBlockParticles = preload("res://src/objects/DestroyBlockParticles.tscn")

export(NodePath) var tilemap

func _ready():
	get_node(tilemap).connect("block_destroyed", self, "on_block_destroyed")

func on_block_destroyed(pos):
	# $player/camera.screenshake()
	var particles = DestroyBlockParticles.instance()
	add_child(particles)

	particles.position = pos
	for c in particles.get_children():
		if c.has_method("restart"):
			c.restart()

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit()
