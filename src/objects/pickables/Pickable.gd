extends Area2D
class_name Pickable

export(String) var item_name
export var is_stored_in_inventory = false

func _ready():
	connect("body_entered", self, "on_body_entered")

	add_to_group("pickable")
	add_to_group("save")

func on_body_entered(body):
	if body.is_in_group("player"):
		self.queue_free()
		body.pickup(self)
		self.on_player_pickup(body)
		play_sound()

func play_sound():
	Sounds.play_sound("pickup")

func on_player_pickup(_player):
	pass

func get_save_dict():
	return {
		"name": name
	}
