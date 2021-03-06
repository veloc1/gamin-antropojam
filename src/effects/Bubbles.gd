extends AnimatedSprite

const lifetime = 2

var t = 0.0
var original_x = 0
var additional_velocity = Vector2(0, 0)
var phase = 0
var initial_frame = 0

var initial_placement_checked = false

func _ready():
	play("default")
	frame = initial_frame
	original_x = position.x
	# t = rand_range(-1.0, 0.0)

func _process(delta):
	# we skip area check only on first process call
	if t > 0.02 and not initial_placement_checked:
		remove_if_outside_water()
		initial_placement_checked = true

	t += delta

	position.y -= delta * 30 + additional_velocity.y
	position.x = original_x + sin(t * 4 + phase) * 8  + additional_velocity.x

	additional_velocity = additional_velocity.linear_interpolate(Vector2(0, 0), 0.05)

func remove_if_outside_water():
	for area in $Area2D.get_overlapping_areas():
		if area.is_in_group("water"):
			return false
	queue_free()
