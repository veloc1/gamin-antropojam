extends Area2D

func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

func on_body_entered(body):
	if body.is_in_group("player"):
		body.enter_to_area(self)
		play_sound()

func on_body_exited(body):
	if body.is_in_group("player"):
		body.exit_from_area(self)
		play_sound()

func play_sound():
	Sounds.play_sound("pickup")
