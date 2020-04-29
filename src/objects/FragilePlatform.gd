extends StaticBody2D

func _ready():
	$PlayerDetectArea.connect("body_entered", self, "on_body_entered")
	$DestroyTimer.connect("timeout", self, "on_destroy_timer_timeout")

func on_body_entered(body):
	if body.is_in_group("player") and $DestroyTimer.is_stopped():
		$DestroyTimer.start()
		$Particles2D.restart()

func on_destroy_timer_timeout():
	self.queue_free()
