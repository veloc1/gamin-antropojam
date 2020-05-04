extends KinematicBody2D

onready var movement = $Components/Movement
onready var attack = $Components/Attack
onready var camera = $Camera

func _ready():
	$AnimatedSprite.connect("frame_changed", self, "on_sprite_frame_changed")

func _physics_process(_delta):
	var action_right = Input.is_action_pressed('ui_right')
	var action_left = Input.is_action_pressed('ui_left')
	var action_jump = Input.is_action_just_pressed('game_action1')
	var action_attack = Input.is_action_just_pressed('game_action2')

	if action_jump and movement.can_jump():
		movement.jump()
		$Sounds/Jump.play()

	if action_attack:
		movement.attack()

	if action_right:
		movement.move_right()
		attack.look_right()
		camera.look_right()
	elif action_left:
		movement.move_left()
		attack.look_left()
		camera.look_left()
	else:
		movement.still()

	if not movement.is_active():
		movement.idle()

func attacked(from):
	movement.attacked(from.global_position.x < global_position.x)

	Events.emit_signal("start_screenshake")

func pickup(object):
	$Inventory.add_game_item(object)

func at_door(door):
	if $Inventory.has_item("Key"):
		door.open()
		$Inventory.take_item("Key")


func on_sprite_frame_changed():
	if $AnimatedSprite.animation == 'walk':
		$Sounds/Walk.play()


# signal spheres_count_changed
# signal keys_count_changed
# signal lives_count_shanged
# signal attack
# signal game_over

# var lives = 3
# var spheres = 0
# var keys = 0

# func refresh_ui_state():
#   emit_signal("spheres_count_changed", spheres)
#   emit_signal("keys_count_changed", keys)
#   emit_signal("lives_count_shanged", lives)

# func on_sphere_pickup():
#   $sounds/pickup.play()
#   spheres = spheres + 1
#   emit_signal("spheres_count_changed", spheres)

# func on_key_pickup():
#   $sounds/pickup.play()
#   keys = keys + 1
#   emit_signal("keys_count_changed", keys)

# func on_door_opened():
#   $sounds/pickup.play()
#   keys = keys - 1
#   emit_signal("keys_count_changed", keys)

# func on_skull_collide(skull: Node2D):
#   if is_invulnerable:
# 	return
#   lives = lives - 1
#   if lives < 0:
# 	lives = 0
# 	emit_signal("game_over")
#   else:
# 	on_collide_with_enemy(skull.global_position.x > global_position.x)
#   emit_signal("lives_count_shanged", lives)


# func on_collide_with_enemy(from_right):
#   is_invulnerable = true
#   $AnimationPlayer.play("invulnerable")
#   $camera.screenshake()

#   impact_force.y = default_impact.y
#   if from_right:
# 	impact_force.x = -default_impact.x
#   else:
# 	impact_force.x = default_impact.x


# func _on_AnimationPlayer_animation_finished(anim_name):
#   if anim_name == "invulnerable":
# 	is_invulnerable = false
