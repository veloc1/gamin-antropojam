extends Node


var current_tile = 0
var tiles = []
var tilemap
var tile_names

onready var timer

func set_animation(tmap, t_names):
	tilemap = tmap
	tile_names = t_names
	
	var tile_id = tilemap.tile_set.find_tile_by_name(tile_names[0])
	tiles = tilemap.get_used_cells_by_id(tile_id)

	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.2
	timer.connect("timeout", self, "on_timeout")
	timer.start()

func on_timeout():
	var new_tile_id = tilemap.tile_set.find_tile_by_name(tile_names[current_tile])
	for t in tiles:
		tilemap.set_cellv(t, new_tile_id)

	current_tile = current_tile + 1
	if current_tile >= len(tile_names):
		current_tile = 0
