extends KinematicBody2D

var gravity = 1200
var velocity = Vector2(0, 0)
export var is_carried = false
var player = null

func _ready():
	add_to_group("interactable")
	add_to_group("save")

func _physics_process(delta):
	if is_carried:
		pass
		position.x = player.position.x + 16
		position.y = player.position.y
	else:
		velocity.y += gravity * delta
		velocity = move_and_slide(velocity, Vector2.UP)

func _process(_delta):
	$Sprite.global_position.x = round(position.x)
	$Sprite.global_position.y = round(position.y)

func on_interaction(player_obj):
	player = player_obj

	player.pickup_box(self)

	is_carried = true

	_disable()

func putdown(to_left):
	if to_left:
		position.x = player.position.x + 16
	else:
		position.x = player.position.x - 16
	is_carried = false
	player = null

	call_deferred("_enable")

func get_texture():
	return $Sprite.texture

func _disable():
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)

	$Sprite.hide()

func _enable():
	set_collision_layer_bit(0, true)
	set_collision_mask_bit(0, true)

	$Sprite.show()

func get_save_dict():
	return {
		"name": name,
		"position": {
			"x": position.x,
			"y": position.y,
		}
	}

