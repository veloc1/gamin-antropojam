extends Node2D

func _ready():
	$StaticBody2D/PlayerDetectArea.connect("body_entered", self, "on_body_entered")
	# $DestroyTimer.connect("timeout", self, "on_destroy_timer_timeout")

func on_body_entered(body):
	if body.is_in_group("player") and !$DestroyAnimation.is_playing():
		# $DestroyTimer.start()
		$DestroyAnimation.play("destroy")
		$StaticBody2D/Particles2D.restart()

func disable_collision():
	$StaticBody2D.set_collision_layer_bit(0, false)
	$StaticBody2D.set_collision_mask_bit(0, false)

func enable_collision():
	$StaticBody2D.set_collision_layer_bit(0, true)
	$StaticBody2D.set_collision_mask_bit(0, true)
# func on_destroy_timer_timeout():
	# self.queue_free()
