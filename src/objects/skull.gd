tool
extends Area2D

signal skull_collide

var original_position: Vector2

var velocity: Vector2 = Vector2(30, 0)
export var bounds_left: int = 0
export var bounds_right: int = 0

func _enter_tree():
  original_position = Vector2(global_position.x, global_position.y)

func _process(delta):
  if not Engine.editor_hint:
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
  if body.is_in_group("player"):
    # self.queue_free()
    emit_signal("skull_collide", self)

func _draw():
  if Engine.editor_hint:
    var left = original_position.x - position.x + bounds_left
    var right = original_position.x - position.x + bounds_right
    var top = original_position.y - 24
    var bottom = original_position.y + 24

    draw_line(
      Vector2(left, bottom), 
      Vector2(left, top), 
      Color.red
    )

    draw_line(
      Vector2(right, bottom), 
      Vector2(right, top), 
      Color.red
    )
