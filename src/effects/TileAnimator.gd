extends Node

var ts_name
var tile_id
var current_tile = 0
var tiles = []
var tilemap
var autotile_coords
var wait_time

onready var timer

func _init(tileset_name, tileset_autotile_coords, anim_wait_time):
	ts_name = tileset_name
	autotile_coords = tileset_autotile_coords
	wait_time = anim_wait_time

func _ready():
	tilemap = get_parent()
	
	tile_id = tilemap.tile_set.find_tile_by_name(ts_name)
	
	if tile_id < 0:
		queue_free()
		
	var cells = tilemap.get_used_cells_by_id(tile_id)
	for c in cells:
		var ac = tilemap.get_cell_autotile_coord(c.x, c.y)
		if ac == autotile_coords[0]:
			tiles.append(c)
	
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = wait_time
	timer.connect("timeout", self, "on_timeout")
	timer.start()

func on_timeout():
	for t in tiles:
		tilemap.set_cell(
			t.x, 
			t.y, 
			tile_id, 
			false, 
			false, 
			false, 
			autotile_coords[current_tile]
		)

	current_tile = current_tile + 1
	if current_tile >= len(autotile_coords):
		current_tile = 0

#func set_animation(tmap, t_names):
#	tilemap = tmap
#	tile_names = t_names
#	
#	var tile_id = tilemap.tile_set.find_tile_by_name(tile_names[0])
#	tiles = tilemap.get_used_cells_by_id(tile_id)
#
#	timer = Timer.new()
#	add_child(timer)
#	timer.wait_time = 0.2
#	timer.connect("timeout", self, "on_timeout")
#	timer.start()
#
#func on_timeout():
#	var new_tile_id = tilemap.tile_set.find_tile_by_name(tile_names[current_tile])
#	for t in tiles:
#		tilemap.set_cellv(t, new_tile_id)
#
#	current_tile = current_tile + 1
#	if current_tile >= len(tile_names):
#		current_tile = 0
