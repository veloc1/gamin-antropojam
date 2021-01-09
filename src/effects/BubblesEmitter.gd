extends Node2D

const Bubbles = preload("res://src/effects/Bubbles.tscn")

const emit_time = 1

var t = 0.0
var player

func _ready():
	player = get_parent()

func _process(delta):
	if player.is_on_floor() and player.is_in_water():
		t += delta
		if t > emit_time:
			t = 0
			var b = Bubbles.instance()
			# b.position.x = global_position.x
			# b.position.y = global_position.y
			
			b.position.x = get_parent().position.x
			b.position.y = get_parent().position.y
			
			get_parent().get_parent().add_child(b)

func look_left():
	if position.x < 0:
		position.x = -position.x

func look_right():
	if position.x > 0:
		position.x = -position.x
	
