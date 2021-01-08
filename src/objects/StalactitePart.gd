extends KinematicBody2D

var is_falling = false
var velocity = Vector2(0,0)
var acceleration = 10

func _ready():
	$DangerArea.connect("body_entered", self, "on_body_entered_in_danger_area")
	set_collision_mask_bit(2, false)

func _physics_process(_delta):
	if is_falling:
		velocity.y += acceleration
		
		move_and_slide(velocity, Vector2.UP) 
		if is_on_floor():
			is_falling = false
			set_collision_layer_bit(2, true)
			position.x = round(position.x)
			position.y = round(position.y)

func fall():
	is_falling = true

func on_body_entered_in_danger_area(body):
	if body.is_in_group("player"):
		body.attacked(self)
		# velocity.y = 0
