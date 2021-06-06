extends Node

const SAVE_PATH = "user://savegame.save"
const EMPTY_SAVE = {
	"levels":{},
	"player":{}
}
const PLAYER_STATE = {
	"health": 0,
	"inventory": [],
	"abilities": [],
	"location": {
		"level": "",
		"spawn": ""
	},
	"collected_items":{}, # key - level name, value array of collected items from level
}
const LEVEL_STATE = {
	"meta": {},
	"items": []
}

func load_save():
	var c = get_config()
	return c

func get_video_magnifier():
	var c = get_config()
	return c.get_value('game', 'video_magnifier', 1)

func save_level():
	# read old save
	# find current level or create entry for level
	# rewrite current level
	# rewrite collected items dict
	# rewrite player state dict
	# write save file

	var current_level = _find_current_level()
	if current_level == null:
		return

	# ok, there we get a level

	var old_save = _read_save_file()

	var level_name = current_level.get_name()

	# lets save current level state
	var nodes = get_tree().get_nodes_in_group("save")
	var new_state = LEVEL_STATE.duplicate(true)
	for item in nodes:
		var item_state = item.get_save_dict()
		item_state['path'] = current_level.get_path_to(item)
		new_state['items'].append(item_state)

	old_save['levels'][level_name] = new_state

	# level state is saved, lets save player
	var player = current_level.get_node("Player")
	var player_state = _get_player_state(player)
	old_save['player'] = player_state

	_write_save_file(old_save)

func save_new_player_location(level, spawn):
	var old_save = _read_save_file()
	old_save['player']['location']['level'] = level
	old_save['player']['location']['spawn'] = spawn
	_write_save_file(old_save)

func load_level():
	# read save
	# find current level
	# if item has position, place item to position
	# if item in collected items dict, then remove item from scene
	# read player state

	var current_level = _find_current_level()
	if current_level == null:
		return

	var level_name = current_level.get_name()

	var save = _read_save_file()

	if not save['levels'].has(level_name):
		# we dont have saved state, so use standart level layout
		return

	var level_state = save['levels'][level_name]
	for item_state in level_state['items']:
		var _item_name = item_state['name']

		var item = current_level.get_node(item_state['path'])
		# TODO make a method `load_from_dict` in every item in `save` group

		if item_state.has('position'):
			var p = item_state['position']
			item.position.x = p['x']
			item.position.y = p['y']

	# check player collected items and remove this items
	var level_collected_items = save['player']['collected_items'][level_name]
	for item_name in level_collected_items:
		var item = current_level.get_node(item_name)

		# item is collected, so we remove it
		item.queue_free()

	var player = current_level.get_node("Player")
	_restore_player_state(save['player'], player)


func save_config(video_magnifier):
	var c = get_config()
	c.set_value('game', 'video_magnifier', video_magnifier)
	c.save("user://settings.cfg")

func get_config() -> ConfigFile:
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK:
		return config
	config.save("user://settings.cfg")
	return config

func _get_player_state(player):
	var state = PLAYER_STATE.duplicate(true)

	state['health'] = player.get_health()
	state['inventory'] = player.get_inventory()
	state['collected_items'] = player.get_collected_items()
	state['abilities'] = player.get_abilities()
#"location": {
#		"name": null,
#		"spawn_index": 0
#	},
	return state

func _restore_player_state(save, player):
	player.set_health(save['health'])
	player.set_inventory(save['inventory'])
	player.set_collected_items(save['collected_items'])
	player.set_abilities(save['abilities'])

func _get_save_file():
	var save_game = File.new()
	save_game.open(SAVE_PATH, File.WRITE)
	return save_game

func _read_save_file():
	var save_game = File.new()
	if !save_game.file_exists(SAVE_PATH):
		return EMPTY_SAVE.duplicate(true)
	save_game.open(SAVE_PATH, File.READ)
	var content = save_game.get_as_text()
	save_game.close()
	return parse_json(content)

func _write_save_file(save):
	var save_game = File.new()
	save_game.open(SAVE_PATH, File.WRITE)
	var content = to_json(save)
	save_game.store_line(content)
	save_game.close()
	return parse_json(content)

func _find_current_level():
	var current_level = null
	var root = get_tree().get_root()
	for i in range(root.get_child_count()):
		if root.get_child(i) is Level:
			current_level = root.get_child(i)
	return current_level
