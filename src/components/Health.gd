extends Node

export var initial_health = 3

var health

func _ready():
	health = initial_health

func heal():
	health += 1

func damage():
	health -= 1

func value():
	return health

func set_value(new_health):
	health = new_health
