extends KinematicBody2D

onready var movement = $Components/Movement
onready var attack = $Components/Attack
onready var interact = $Components/Interact
onready var health = $Components/Health
onready var camera = $Camera

var is_input_active = true
var carried_box = null

func _ready():
	DebugInfo.add_property_monitor("Player pos", self, ":global_position")
	DebugInfo.add_method_monitor("Inventory", $Inventory, "debug_str")
	
	$AnimatedSprite.connect("frame_changed", self, "on_sprite_frame_changed")
	$AnimatedSprite.connect("animation_finished", self, "on_sprite_animation_finished")
	
	Events.emit_signal("player_health_changed", health.value())

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
	
		if action_use and not movement.is_active():
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
		elif action_left:
			movement.move_left()
			attack.look_left()
			interact.look_left()
			camera.look_left()
		else:
			movement.still()
	
		if not movement.is_active():
			movement.idle()

# *** INTERACTIONS ***

func attacked(from):
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
	$Inventory.add_game_item(object)

func pickup_box(box):
	carried_box = box
	
	movement.still()
	movement.idle()
	is_input_active = false
	
	$CarriedShape.disabled = false
	$CarriedSprite.texture = box.get_texture()
	$CarriedSprite.show()
	if !$AnimatedSprite.flip_h:
		$AnimationPlayer.play("pickup_box_left")
	else:
		$AnimationPlayer.play("pickup_box_right")

func putdown_box():
	movement.still()
	movement.idle()
	is_input_active = false
	
	if !$AnimatedSprite.flip_h:
		$AnimationPlayer.play("putdown_box_left")
	else:
		$AnimationPlayer.play("putdown_box_right")

func at_door(door):
	if $Inventory.has_item("Key"):
		door.open()
		$Inventory.take_item("Key")

func change_color(new_color):
	$AnimatedSprite.set_modulate(new_color)

# *** ABILITIES ***

func enable_double_jump():
	movement.enable_double_jump()

# *** SIGNALS ***

func on_sprite_frame_changed():
	if $AnimatedSprite.animation == 'walk':
		$Sounds/Walk.play()

func on_sprite_animation_finished():
	if $AnimatedSprite.animation == 'pickup':
		is_input_active = true
		movement.still()
		movement.idle()
		$AnimatedSprite.play("idle")
		
	if $AnimatedSprite.animation == 'putdown':
		is_input_active = true
		
		$CarriedShape.disabled = true
		$CarriedSprite.hide()
		
		carried_box.putdown(!$AnimatedSprite.flip_h)
		carried_box = null
		
		movement.still()
		movement.idle()
		$AnimatedSprite.play("idle")

func _is_carring():
	return carried_box != null
