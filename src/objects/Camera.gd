extends Camera2D

export (int) var shake_amount = 4

onready var original_limit
onready var target_limit
onready var float_limit

func _ready():
	refresh_zoom()

	Events.connect("start_screenshake", self, "screenshake")

	original_limit = {
		"left": limit_left,
		"right": limit_right,
		"top": limit_top,
		"bottom": limit_bottom
	}

func refresh_zoom():
	var v = SaveLoad.get_video_magnifier()
	var z = float(1 / float(v))
	zoom = Vector2(z, z)

func _process(_delta):
	if $ScreenshakeTimer.time_left > 0:
		_shake()
	else:
		offset.x = 0
		offset.y = 0

	process_limit()

func screenshake():
	$ScreenshakeTimer.start()

func look_left():
	if offset_h > 0:
		offset_h = -offset_h

func look_right():
	if offset_h < 0:
		offset_h = -offset_h

func _shake():
	offset.x = rand_range(-shake_amount, shake_amount)
	offset.y = rand_range(-shake_amount, shake_amount)

func limit_to(limiter):
	var shape = limiter.get_node("AreaToLimitCamera/CollisionShape2D")
	limit_left = int(global_position.x - get_viewport_rect().size.x)
	limit_right = int(global_position.x + get_viewport_rect().size.x)
	limit_top = int(global_position.y - get_viewport_rect().size.y)
	limit_bottom = int(global_position.y + get_viewport_rect().size.y)

	float_limit = {
		"left": limit_left,
		"right": limit_right,
		"top": limit_top,
		"bottom": limit_bottom
	}

	target_limit = {
		"left": shape.global_position.x - shape.shape.extents.x,
		"right": shape.global_position.x + shape.shape.extents.x,
		"top": shape.global_position.y - shape.shape.extents.y,
		"bottom": shape.global_position.y + shape.shape.extents.y
	}

func reset_limit():
	target_limit = null
	limit_left = original_limit["left"]
	limit_right = original_limit["right"]
	limit_top = original_limit["top"]
	limit_bottom = original_limit["bottom"]

func process_limit():
	if target_limit:
		float_limit["left"] = lerp(float_limit["left"], target_limit["left"], 0.05)
		float_limit["right"] = lerp(float_limit["right"], target_limit["right"], 0.05)
		float_limit["top"] = lerp(float_limit["top"], target_limit["top"], 0.05)
		float_limit["bottom"] = lerp(float_limit["bottom"], target_limit["bottom"], 0.05)

		limit_left = float_limit["left"]
		limit_right = float_limit["right"]
		limit_top = float_limit["top"]
		limit_bottom = float_limit["bottom"]
