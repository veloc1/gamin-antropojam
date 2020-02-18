extends Area2D

signal skull_collide

var velocity: Vector2 = Vector2(30, 0)
export var bounds_left: int = 0
export var bounds_right: int = 0


func _process(delta):
  if position.x < bounds_left and velocity.x < 0:
    velocity.x = -velocity.x
    $AnimatedSprite.flip_h = true
  if position.x > bounds_right and velocity.x > 0:
    velocity.x = -velocity.x
    $AnimatedSprite.flip_h = false
  
  velocity.y = sin(OS.get_ticks_msec() / 200.0) * 48
  translate(velocity * delta)


func _on_skull_body_entered(body):
  if body.is_in_group("player"):
    # self.queue_free()
    emit_signal("skull_collide")
