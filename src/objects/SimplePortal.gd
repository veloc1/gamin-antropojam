extends Area2D

func _ready():
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if body.is_in_group("player"):
		body.position.x = $SpawnPoint.global_position.x
		body.position.y = $SpawnPoint.global_position.y
