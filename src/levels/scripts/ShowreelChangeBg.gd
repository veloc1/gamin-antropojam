extends Area2D

export(Color) var bg_color = Color("72ae30")

func _ready():
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if body.is_in_group("player"):
		VisualServer.set_default_clear_color(bg_color)
