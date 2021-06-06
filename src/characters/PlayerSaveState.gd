extends Node

var collected_items = {}
var abilities = []

func _ready():
	pass # Replace with function body.

func track_collected_item(item):
	var level = get_parent().get_parent()
	var level_name = level.get_name()
	var item_path = level.get_path_to(item)

	var level_state = []
	if collected_items.has(level_name):
		level_state = collected_items[level_name]

	level_state.append(item_path)
	collected_items[level_name] = level_state

func get_collected_items():
	return collected_items

func set_collected_items(items):
	collected_items = items

func add_ability(ability):
	if ability in abilities:
		return
	abilities.append(ability)

func get_abilities():
	return abilities

func set_abilities(items):
	abilities = items
