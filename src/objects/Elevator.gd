tool
extends Node2D

export var height = 1 setget set_height
export var paddles_count = 1 setget set_paddles
export(NodePath) var button_name

var is_on = false

var block_height = 32

func _ready():
	setup()
	
	var button = get_node_or_null(button_name)
	if button != null:
		if "is_pressed" in button and button.is_pressed:
			on()
		else:
			button.connect("on_pressed", self, "on")


func _process(delta):
	if is_on:
		for p in $Path2D.get_children():
			p.unit_offset += delta / 15 

func on():
	var sprites = get_node("sprites")
	for s in sprites.get_children():
		s.play("default")
	is_on = true

func setup():
	var sprites = get_node("sprites")
	var mid1 = get_node("sprites/mid")
	var paddles = get_node("Path2D")
	
	# remove childs, which were added on previouse setup's
	while(sprites.get_child_count() > 3):
		sprites.remove_child(sprites.get_child(sprites.get_child_count() - 1))
	
	# add mid sprites
	for h in range(1, height):
		var s = mid1.duplicate()
		sprites.add_child(s)
		s.position.y = block_height * (h + 1)
	# move last sprite accordingly
	get_node("sprites/down").position.y = block_height * (height + 1)
	
	# modify curve, so it will be synced with sprites
	var curve = $Path2D.curve 
	curve.set_point_position(3, Vector2(block_height / 2, block_height * (height + 1)))
	curve.set_point_position(4, Vector2(0, block_height * (height + 1.5)))
	curve.set_point_position(5, Vector2(-block_height / 2, block_height * (height + 1)))
	
	# setup paddles
	while(paddles.get_child_count() > 1):
		paddles.remove_child(paddles.get_child(paddles.get_child_count() - 1))
	
	var paddle = paddles.get_child(0)
	
	var offset = 1.0 / paddles_count
	# add new paddles
	for i in range(1, paddles_count):
		var p = paddle.duplicate()
		paddles.add_child(p)
		p.unit_offset = offset * (i)

func set_height(new):
	height = new
	setup()
	update()

func set_paddles(new):
	paddles_count = new
	setup()
	update()
