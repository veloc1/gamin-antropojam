extends AnimatedSprite

func _ready():
	$HandsAnimationTimer.connect("timeout", self, "on_hands_animation_timer")
	connect("animation_finished", self, "on_animation_finished")

func _process(_delta):
	pass

func on_hands_animation_timer():
	play("hands")

func on_animation_finished():
	if animation == "hands":
		play("idle")
		$HandsAnimationTimer.wait_time = rand_range(2, 5)
		$HandsAnimationTimer.start()

