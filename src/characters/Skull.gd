tool
extends Area2D

export var bounds_left: int = 0 setget set_bounds_left
export var bounds_right: int = 100 setget set_bounds_right
export var show_borders_in_editor: bool = false setget set_show_borders

var stranding_velocity = Vector2(30, 0)
var velocity: Vector2 = Vector2(30, 0)
var original_height = 0
var is_attacked = false
var target = null
var is_going_back_to_patrol = false

func _ready():
	$PlayerDetector.connect("body_entered", self, "on_body_entered_in_player_detector")
	$PlayerDetector.connect("body_exited", self, "on_body_exited_in_player_detector")
	original_height = position.y

func _process(delta):
	if not Engine.editor_hint:
		if is_attacked:
			velocity.y = lerp(velocity.y, 100, 0.05)
		elif target != null:
			var angle_to_target = get_angle_to(target.position)
			velocity = Vector2(cos(angle_to_target), sin(angle_to_target)) * 50
		elif is_going_back_to_patrol:
			if position.y > original_height - 3 and position.y < original_height + 3:
				is_going_back_to_patrol = false
				velocity = stranding_velocity
			else:
				var y_speed = clamp((original_height - position.y) * 2 , -50, 50)
				if position.x > bounds_left and position.x < bounds_right:
					# skull in bound, we need to setup original height
					velocity = Vector2(0, y_speed)
				if position.x < bounds_left:
					velocity = Vector2(30, y_speed)
					face_right()
				if position.x > bounds_right:
					velocity = Vector2(-30, y_speed)
					face_left()
		else:
			if position.x < bounds_left and velocity.x < 0:
				velocity.x = -velocity.x
				face_right()
			if position.x > bounds_right and velocity.x > 0:
				velocity.x = -velocity.x
				face_left()

			velocity.y = cos(OS.get_ticks_msec() / 200.0) * 48
		translate(velocity * delta)
	update()


func _draw():
	if Engine.editor_hint and show_borders_in_editor:
		draw_line(
			Vector2(-position.x + bounds_left, 0),
			Vector2(-position.x + bounds_right, 0),
			Color(0.8, 0.5, 0.5, 0.5),
			36
		)

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

func face_left():
	$AnimatedSprite.flip_h = false
	if $PlayerDetector.position.x > 0:
		$PlayerDetector.position.x = -$PlayerDetector.position.x

func face_right():
	$AnimatedSprite.flip_h = true
	if $PlayerDetector.position.x < 0:
		$PlayerDetector.position.x = -$PlayerDetector.position.x

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Diyng":
		queue_free()

func set_bounds_left(new_left):
	bounds_left = new_left
	update()

func set_bounds_right(new_right):
	bounds_right = new_right
	update()

func set_show_borders(new_set):
	show_borders_in_editor = new_set
	update()

func on_body_entered_in_player_detector(body):
	if body.is_in_group("player"):
		target = body

func on_body_exited_in_player_detector(body):
	if body == target:
		target = null
		is_going_back_to_patrol = true
