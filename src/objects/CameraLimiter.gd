extends Node2D

func _ready():
	$AreaToGetPlayer.connect("body_entered", self, "on_body_entered")
	$AreaToGetPlayer.connect("body_exited", self, "on_body_exited")

func on_body_entered(body):
	if body.is_in_group("player"):
		var camera = body.get_node("Camera")
		camera.limit_to(self)

func on_body_exited(body):
	if body.is_in_group("player"):
		var camera = body.get_node("Camera")
		camera.reset_limit()
