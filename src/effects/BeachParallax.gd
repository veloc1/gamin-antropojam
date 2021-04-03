extends ParallaxBackground

var MIST_VELOCITY = -16
var MIST2_VELOCITY = -24

func _process(delta):
	$MistLayer.motion_offset.x += delta * MIST_VELOCITY
	$MistLayer2.motion_offset.x += delta * MIST2_VELOCITY
