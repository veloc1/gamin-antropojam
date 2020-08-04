extends Node2D

var DestroyBlockParticles = preload("res://src/effects/DestroyBlockParticles.tscn")
var DoubleJumpEffect = preload("res://src/effects/DoubleJumpEffect.tscn")
var Exclamation = preload("res://src/effects/Exclamation.tscn")

func _ready():
	Events.connect("double_jump", self, "on_player_double_jump")
	Events.connect("block_destroyed", self, "on_block_destroyed")
	Events.connect("use_no_item", self, "on_use_with_no_item")

func on_block_destroyed(pos):
	var particles = DestroyBlockParticles.instance()
	get_parent().add_child(particles)

	particles.position = pos
	for c in particles.get_children():
		if c.has_method("restart"):
			c.restart()

func on_player_double_jump(player_pos, to_left):
	var effect = DoubleJumpEffect.instance()
	get_parent().add_child(effect)
	
	var x = player_pos.x
	if to_left:
		x += 7
	else:
		x -= 7
	effect.position = Vector2(x, player_pos.y + 8)
	effect.flip_h = to_left
	effect.play("jump")

func on_use_with_no_item(player_pos, to_left):
	var effect = Exclamation.instance()
	get_parent().add_child(effect)
	
	var x = player_pos.x
	if to_left:
		x -= 12
	else:
		x += 12
	effect.position = Vector2(x, player_pos.y - 18)
	effect.start(to_left)
