extends Camera2D

export (int) var shake_amount = 4


func _ready():
  refresh_zoom()


func refresh_zoom():
  var save_load = get_node("/root/SaveLoad")
  var v = save_load.get_video_magnifier()
  var z = float(1 / float(v)) 
  zoom = Vector2(z, z)

func _process(delta):
  if $screenshake_timer.time_left > 0:
    _shake()
  else:
    offset.x = 0
    offset.y = 0

func screenshake():
  $screenshake_timer.start()

func _shake():
  offset.x = rand_range(-shake_amount, shake_amount)
  offset.y = rand_range(-shake_amount, shake_amount)
