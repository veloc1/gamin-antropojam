extends AnimatedSprite

func _ready():
	connect("animation_finished", self, "on_anim_finished")

func on_anim_finished():
	queue_free()
