extends AnimatedSprite


func _ready():
	connect("animation_finished", self, "on_animation_finished")
	play("explosion")

	$DamageArea.connect("body_entered", self, "on_body_entered")

func on_animation_finished():
	queue_free()

func on_body_entered(body):
	if body.is_in_group("player"):
		body.attacked(self)
