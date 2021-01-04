tool
extends Sprite

var item

func _ready():
	set_process(false)

func _process(delta):
	position = get_viewport().get_mouse_position()

func set_item(item):
	self.item = item
	if item != null:
		texture = item.icon
		set_process(true)
	else:
		set_process(false)
		texture = null

func has_item():
	return item != null

func get_item():
	return item
