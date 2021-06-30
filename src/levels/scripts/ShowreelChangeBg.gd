extends Area2D

export(Color) var bg_color = Color("72ae30")
export(Array, NodePath) var disable_parallax
export(Array, NodePath) var enable_parallax

func _ready():
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if body.is_in_group("player"):
		VisualServer.set_default_clear_color(bg_color)
		for d in disable_parallax:
			get_node(d).hide()
		for e in enable_parallax:
			get_node(e).show()
