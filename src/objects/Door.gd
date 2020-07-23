extends StaticBody2D

var is_opened

func _ready():
	$Opened.hide()

	$Area2D.connect("body_entered", self, "on_body_entered")

func open():
	is_opened = true
	$Opened.show()
	$Closed.hide()
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)

func on_body_entered(body):
	if is_opened:
		return

	if body.is_in_group("player"):
		body.at_door(self)

