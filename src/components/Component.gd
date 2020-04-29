extends Node2D
class_name Component

func get_component(name):
	return get_parent().get_node(name)
