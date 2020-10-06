extends StaticBody2D

signal on_pressed

var is_pressed

func _ready():
	$Area2D.connect("body_entered", self, "on_body_entered")

	unpress()

func press():
	is_pressed = true

	$Sprite.frame = 0

	$ShapePressed.disabled = false
	$ShapeUnpressed.disabled = true

	emit_signal("on_pressed")

func unpress():
	is_pressed = false

	$Sprite.frame = 1

	$ShapePressed.disabled = true
	$ShapeUnpressed.disabled = false

func on_body_entered(body):
	if is_pressed:
		return

	if body.is_in_group("player"):
		call_deferred("press")
