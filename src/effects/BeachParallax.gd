extends ParallaxBackground


var BG_VELOCITY = -3
var MIST_VELOCITY = -5
var MIST2_VELOCITY = -8

func _process(delta):
	#$BG.motion_offset.x += delta * BG_VELOCITY
	$MistLayer.motion_offset.x += delta * MIST_VELOCITY
	$MistLayer2.motion_offset.x += delta * MIST2_VELOCITY
