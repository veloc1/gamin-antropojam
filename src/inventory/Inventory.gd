extends Node2D
class_name Inventory

var items = []

func add_game_item(object: Node2D):
	# convert this item to inventory item and add it to inventory
	if object.is_in_group("pickable"):
		add_item(object.item_name)
	else:
		print("Object " + object.name + " is not pickable")

func add_item(name):
	var item = get_item(name)
	if item == null:
		item = InventoryItem.new()
		item.name = name
		item.count = 1
		items.append(item)
	else:
		item.count = item.count + 1

func has_item(name):
	return get_item(name) != null

func has_items(name, count):
	var item = get_item(name)
	return item != null and item.count >= count

func get_item(name):
	for i in items:
		if i.name == name:
			return i
	return null

func get_item_count(name):
	for i in items:
		if i.name == name:
			return i.count
	return 0

func take_item(name):
	var item = get_item(name)
	if item == null:
		print("There is no item " + name)
	else:
		item.count = item.count - 1
		if item.count <= 0:
			remove_item(name)

func take_items(name, count):
	var item = get_item(name)
	if item == null:
		print("There is no item " + name)
	else:
		if item.count >= count:
			item.count = item.count - count
			if item.count <= 0:
				remove_item(name)
		else:
			print("There is not enough " + name)

func remove_item(name):
	for i in len(items):
		if items[i].name == name:
			items.remove(i)
			return
	return null

func debug_print():
	for i in items:
		print(i.name)

	print("=======")
	print(" ")

func debug_str():
	var text = "\n"
	for i in items:
		text += "    " + i.name + ": " + str(i.count)
		text += "\n"
	return text

