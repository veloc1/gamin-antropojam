extends Camera2D

export (int) var shake_amount = 4

func _ready():
	refresh_zoom()

	Events.connect("start_screenshake", self, "screenshake")

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
