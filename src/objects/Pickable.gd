extends Area2D
class_name Pickable

export(String) var item_name

func _ready():
	connect("body_entered", self, "on_body_entered")

	add_to_group("pickable")

func on_body_entered(body):
	if body.is_in_group("player"):
		self.queue_free()
		body.pickup(self)
		play_sound()

func play_sound():
	Sounds.play_sound("pickup")

