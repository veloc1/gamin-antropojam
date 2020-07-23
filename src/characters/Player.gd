extends KinematicBody2D

onready var movement = $Components/Movement
onready var attack = $Components/Attack
onready var health = $Components/Health
onready var camera = $Camera

func _ready():
	DebugInfo.add_property_monitor("Player pos", self, ":global_position")
	DebugInfo.add_method_monitor("Inventory", $Inventory, "debug_str")
	
	$AnimatedSprite.connect("frame_changed", self, "on_sprite_frame_changed")
	
	Events.emit_signal("player_health_changed", health.value())

# *** Every frame ***

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
