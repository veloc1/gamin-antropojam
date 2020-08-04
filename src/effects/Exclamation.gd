extends Sprite

func _ready():
	$Tween.connect("tween_all_completed", self, "on_tween_completed")

func start(go_left):
	var dx = 10
	if go_left:
		dx = -10
	
	var dr = 4
	
	$Tween.interpolate_property(
		self, 
		"position", 
		position + Vector2(rand_range(-dr, dr), rand_range(-dr, dr)),
		position + Vector2(dx, -10) + Vector2(rand_range(-dr, dr), rand_range(-dr, dr)),
		1,
		Tween.TRANS_CUBIC
	)
	$Tween.start()

func on_tween_completed():
	queue_free()
