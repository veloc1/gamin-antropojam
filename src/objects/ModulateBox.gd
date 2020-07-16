tool
extends StaticBody2D

export(Color) var modulate_color = Color.white setget change_color

func _ready():
	$Area2D.connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if body.is_in_group("player"):
		body.change_color(modulate_color)

func change_color(new_color):
	$Sprite.set_modulate(new_color)
	modulate_color = new_color
