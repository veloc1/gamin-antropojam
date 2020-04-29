extends Node2D

var DestroyBlockParticles = preload("res://src/objects/DestroyBlockParticles.tscn")

func _ready():
	$TileMap.connect("block_destroyed", self, "on_block_destroyed")


func on_block_destroyed(pos):
	# $player/camera.screenshake()
	var particles = DestroyBlockParticles.instance()
	add_child(particles)
	
	particles.position = pos
	for c in particles.get_children():
		if c.has_method("restart"):
			c.restart()

