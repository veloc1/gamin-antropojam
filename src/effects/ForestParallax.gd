extends ParallaxBackground

var CLOUD_VELOCITY = -16

func _process(delta):
	get_child(0).motion_offset.x += delta * CLOUD_VELOCITY
