extends Area2D

export var bounds_left: int = 0
export var bounds_right: int = 100

var velocity: Vector2 = Vector2(30, 0)
var is_attacked = false

func _process(delta):
	if not Engine.editor_hint:
		if is_attacked:
			velocity.y = lerp(velocity.y, 100, 0.05)
		else:
			if position.x < bounds_left and velocity.x < 0:
				velocity.x = -velocity.x
				$AnimatedSprite.flip_h = true
			if position.x > bounds_right and velocity.x > 0:
				velocity.x = -velocity.x
				$AnimatedSprite.flip_h = false

			velocity.y = sin(OS.get_ticks_msec() / 200.0) * 48
		translate(velocity * delta)
	update()


func _on_skull_body_entered(body):
	if is_attacked:
		# do nothing if this object is diyng
		return

	if body.is_in_group("player"):
		body.attacked(self)

func attacked(from):
	is_attacked = true

	$AnimationPlayer.play("Diyng")

	velocity.y = -150

	if from.global_position.x < global_position.x:
		velocity.x = 50
	else:
		velocity.x = -50


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Diyng":
		queue_free()
