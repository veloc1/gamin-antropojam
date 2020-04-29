extends TileMap

const torch_tile_names = ["torch1", "torch2", "torch3"]

var current_tile = 0
var torch_tiles = []

onready var timer

func _ready():
	var torch_tile_id = tile_set.find_tile_by_name(torch_tile_names[0])
	torch_tiles = get_used_cells_by_id(torch_tile_id)

	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.2
	timer.connect("timeout", self, "on_timeout")
	timer.start()

func _process(_delta):
	pass

func on_timeout():
	var new_torch_tile_id = tile_set.find_tile_by_name(torch_tile_names[current_tile])
	for t in torch_tiles:
		set_cellv(t, new_torch_tile_id)

	current_tile = current_tile + 1
	if current_tile >= len(torch_tile_names):
		current_tile = 0
