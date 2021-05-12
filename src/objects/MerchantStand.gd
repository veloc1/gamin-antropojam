extends Area2D

var items = [
	{
		"name": "Heart",
		"path": "res://src/objects/pickables/Heart.tscn",
		"price": 1
	}
]

export(String) var item_name
var item = null
var price = 0

func _ready():
	add_to_group("interactable")
	_instantiate_item()

func on_interaction(player):
	var merchant = get_parent().get_node("Merchant")

	if item != null:
		var is_bought = player.buy(item, price)
		if is_bought:
			item.queue_free()
			$Price.queue_free()

			merchant.on_item_bought()
		else:
			merchant.on_not_enough_money()

func _instantiate_item():
	for i in items:
		if i['name'] == item_name:
			# add item to scene
			var iclass = load(i['path'])
			item = iclass.instance()

			# item should be pickable
			# but in stand we disable it by changing mask
			item.set_collision_mask_bit(0, false)
			item.set_collision_layer_bit(0, false)

			add_child(item)

			# set price label
			price = i['price']
			$Price/Label.text = str(price)

			break
