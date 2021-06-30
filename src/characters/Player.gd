extends KinematicBody2D

onready var movement = $Components/Movement
onready var attack = $Components/Attack
onready var interact = $Components/Interact
onready var health = $Components/Health
onready var camera = $Camera

var is_input_active = true
var carried_box = null
var _is_in_water = false

func _ready():
	#DebugInfo.add_property_monitor("Player pos", self, ":global_position")
	#DebugInfo.add_method_monitor("Inventory", $Inventory, "debug_str")

	$AnimatedSprite.connect("frame_changed", self, "on_sprite_frame_changed")
	$AnimatedSprite.connect("animation_finished", self, "on_sprite_animation_finished")

	Events.emit_signal("player_health_changed", health.value())
	Events.emit_signal("player_coins_changed", $Inventory.get_item_count("Coin"))

	Events.connect("double_jump", self, "on_double_jump")

	movement.set_gravity(_get_world_gravity_scale())

# *** Every frame ***

func _physics_process(_delta):
	var action_right = Input.is_action_pressed('ui_right')
	var action_left = Input.is_action_pressed('ui_left')
	var action_jump = Input.is_action_just_pressed('game_action1')
	var action_attack = Input.is_action_just_pressed('game_action2')
	var action_use = Input.is_action_just_pressed('game_action3')

	if is_input_active:
		if not _is_carring():
			if action_jump and movement.can_jump():
				movement.jump()
				$Sounds/Jump.play()

			if action_attack:
				movement.attack()

		if action_use:
			if interact.can_interact():
				interact.interact(self)
			elif _is_carring():
				putdown_box()
			else:
				Events.emit_signal(
					"use_no_item",
					self.position,
					$AnimatedSprite.flip_h
				)

		if action_right:
			movement.move_right()
			attack.look_right()
			interact.look_right()
			camera.look_right()
			$OnEdgeSensorArea.look_right()
			$BubblesEmitter.look_right()
		elif action_left:
			movement.move_left()
			attack.look_left()
			interact.look_left()
			camera.look_left()
			$OnEdgeSensorArea.look_left()
			$BubblesEmitter.look_left()
		else:
			movement.still()

		if not movement.is_active():
			movement.idle()

			if $OnEdgeSensorArea.on_edge() and is_on_floor():
				$AnimatedSprite.play("on_edge")
			else:
				$AnimatedSprite.play("idle")


func _process(_delta):
	pass
	#$AnimatedSprite.global_position = Vector2(floor(global_position.x) - 12, floor(global_position.y) - 7)
	#var x_d = fmod(position.x, 1.0)
	#var y_d = fmod(position.y, 1.0)
	#$AnimatedSprite.position.x = -sign(x_d) * x_d  - 12
	#$AnimatedSprite.position.y = -sign(y_d) * y_d - 7

	#print($AnimatedSprite.position.x)

# *** INTERACTIONS ***

func attacked(from):
	if $InvincibilityTimer.time_left > 0:
		return
	$InvincibilityTimer.start()

	movement.attacked(from.global_position.x < global_position.x)

	health.damage()
	Events.emit_signal("player_health_changed", health.value())
	Events.emit_signal("start_screenshake")

	if health.value() == 0:
		Events.emit_signal("game_over")

func on_heal_pickup():
	health.heal()
	Events.emit_signal("player_health_changed", health.value())

func pickup(object):
	$PlayerSaveState.track_collected_item(object)
	if object.is_stored_in_inventory:
		$Inventory.add_game_item(object)
	Events.emit_signal("player_coins_changed", $Inventory.get_item_count("Coin"))

func pickup_box(box):
	carried_box = box

	is_input_active = false

	call_deferred("_start_pickup_box", box)

func putdown_box():
	is_input_active = false

	call_deferred("_start_putdown_box")

func at_door(door):
	if $Inventory.has_item("Key"):
		door.open()
		$Inventory.take_item("Key")

func buy(item, price):
	if $Inventory.has_items("Coin", price):
		$Inventory.take_items("Coin", price)
		Events.emit_signal("player_coins_changed", $Inventory.get_item_count("Coin"))

		if item.is_stored_in_inventory:
			$Inventory.add_item(item.item_name)

		item.on_player_pickup(self)

		return true
	return false

func change_color(new_color):
	$AnimatedSprite.set_modulate(new_color)

func enter_to_area(area: Area2D):
	movement.set_gravity(area.gravity)
	movement.modify_speed(0.8)

func exit_from_area(_area):
	movement.set_gravity(_get_world_gravity_scale())
	movement.modify_speed(1)

# *** ABILITIES ***

func enable_double_jump():
	movement.enable_double_jump()
	$PlayerSaveState.add_ability("double_jump")

# *** SIGNALS ***

func on_sprite_frame_changed():
	if $AnimatedSprite.animation == 'walk':
		$Sounds/Walk.play()

func on_sprite_animation_finished():
	if $AnimatedSprite.animation == 'pickup':
		is_input_active = true
		movement.still()
		$AnimatedSprite.play("idle")

	if $AnimatedSprite.animation == 'putdown':
		is_input_active = true

		$CarriedShape.disabled = true
		$CarriedSprite.hide()

		carried_box.putdown(!$AnimatedSprite.flip_h)
		carried_box = null

		movement.still()
		$AnimatedSprite.play("idle")

# *** MECHANICS ***

func _is_carring():
	return carried_box != null

func _start_pickup_box(box):
	movement.stop()
	movement.still()

	movement.modify_speed(0.7)

	$CarriedShape.disabled = false
	$CarriedSprite.texture = box.get_texture()
	$CarriedSprite.show()

	if !$AnimatedSprite.flip_h:
		$AnimationPlayer.play("pickup_box_left")
	else:
		$AnimationPlayer.play("pickup_box_right")


func _start_putdown_box():
	movement.stop()
	movement.idle()
	movement.still()

	movement.modify_speed(1)

	if !$AnimatedSprite.flip_h:
		$AnimationPlayer.play("putdown_box_left")
	else:
		$AnimationPlayer.play("putdown_box_right")

func on_double_jump():
	if _is_in_water:
		Events.emit_signal("effects_double_jump_water", $BubblesEmitter)
	else:
		Events.emit_signal("effects_double_jump", position, $AnimatedSprite.flip_h)

func is_in_water():
	return _is_in_water

func set_in_water(in_water):
	_is_in_water = in_water

func _get_gravity_vector():
	return Physics2DServer.area_get_param(get_world_2d().space, Physics2DServer.AREA_PARAM_GRAVITY_VECTOR)

func _get_world_gravity_scale():
	return Physics2DServer.area_get_param(get_world_2d().space, Physics2DServer.AREA_PARAM_GRAVITY)

func force_camera_position():
	camera.reset_smoothing()

# *** SAVE | LOAD ***
func get_health():
	return health.value()

func get_inventory():
	return $Inventory.get_save_state()

func get_collected_items():
	return $PlayerSaveState.get_collected_items()

func get_abilities():
	return $PlayerSaveState.get_abilities()

func set_health(new_health):
	health.set_value(new_health)
	Events.emit_signal("player_health_changed", health.value())

func set_inventory(new_inv):
	$Inventory.restore_from_save(new_inv)
	Events.emit_signal("player_coins_changed", $Inventory.get_item_count("Coin"))

func set_collected_items(items):
	$PlayerSaveState.set_collected_items(items)

func set_abilities(abilities):
	$PlayerSaveState.set_abilities(abilities)
	for a in abilities:
		if a == "double_jump":
			enable_double_jump()
