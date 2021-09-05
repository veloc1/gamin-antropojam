extends Node2D

const Mushroom = preload("res://src/characters/Mushroom.tscn")
const Mushroom2 = preload("res://src/characters/Mushroom2.tscn")
const MushroomExplosion = preload("res://src/effects/MushroomSporesExplosion.tscn")

func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_released("ui_page_down"):
		get_tree().create_timer(0.3).connect("timeout", self, "start_spawn_process")

func start_spawn_process():
	for i in range(3):
		var x = $Position2D.global_position.x + (i * 30)
		var y = $Position2D.global_position.y
		get_tree().create_timer(rand_range(0.2, 0.6)).connect("timeout", self, "create_explosion", [x, y])
	for i in range(3):
		var x = $Position2D2.global_position.x + (i * 30)
		var y = $Position2D2.global_position.y
		get_tree().create_timer(rand_range(0.2, 0.6)).connect("timeout", self, "create_explosion", [x, y])

func create_explosion(x, y):
	var me = MushroomExplosion.instance()
	get_parent().get_parent().add_child(me)

	me.position.x = x
	me.position.y = y

	get_tree().create_timer(0.3).connect("timeout", self, "create_mushroom", [x, y])

func create_mushroom(x, y):
	var m = null
	if rand_range(0, 10) > 6:
		m = Mushroom2.instance()
	else:
		m = Mushroom.instance()

	get_parent().get_parent().add_child(m)

	m.position.x = x
	m.position.y = y

