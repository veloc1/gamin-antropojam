extends TileMap

signal block_destroyed(pos)


func attacked(from):
	var attack_position = Vector2(from.global_position.x, from.global_position.y)
	var map_pos = world_to_map(attack_position)
	var center = map_to_world(map_pos) + Vector2(8, 8)
	if get_cellv(map_pos) == 1:
		set_cellv(map_pos, 2)
		emit_signal("block_destroyed", center)
	elif get_cellv(map_pos) == 2:
		set_cellv(map_pos, -1)
		emit_signal("block_destroyed", center)
