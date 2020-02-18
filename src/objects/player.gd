extends KinematicBody2D

signal spheres_count_changed
signal lives_count_shanged
signal attack
signal game_over

export (int) var run_speed = 100
export (int) var jump_speed = -200
export (int) var gravity = 800

var velocity = Vector2()
var is_jumping = false
var is_attacking = false
var lives = 3
var spheres = 0

onready var sprite: AnimatedSprite = $AnimatedSprite

func refresh_ui_state():
  emit_signal("spheres_count_changed", spheres)
  emit_signal("lives_count_shanged", lives)


func process_input():
    velocity.x = 0
    var right = Input.is_action_pressed('ui_right')
    var left = Input.is_action_pressed('ui_left')
    var jump = Input.is_action_just_pressed('ui_select')
    var attack = Input.is_action_just_pressed("ui_up")
    var anim = 'idle'

    if jump and is_on_floor() and not is_attacking:
        is_jumping = true
        velocity.y = jump_speed
        $sounds/jump.play()
    if attack and not is_jumping:
      is_attacking = true
      anim = 'attack'
      $camera.screenshake()

    if right and not is_attacking:
        velocity.x += run_speed
        sprite.flip_h = false
        anim = 'walk'
    if left and not is_attacking:
        velocity.x -= run_speed
        sprite.flip_h = true
        anim = 'walk'

    if is_jumping and not is_attacking:
        anim = 'jump_start'

    control_animation(anim)


func _physics_process(delta):
    process_input()
    velocity.y += gravity * delta

    velocity = move_and_slide(velocity, Vector2(0, -1))
    
    if is_jumping and is_on_floor():
        is_jumping = false
        sprite.play('jump_end')


func on_sphere_pickup():
  $sounds/pickup.play()
  spheres = spheres + 1
  emit_signal("spheres_count_changed", spheres)

func on_skull_collide():
  lives = lives - 1
  if lives < 0:
    lives = 0
    emit_signal("game_over")
  emit_signal("lives_count_shanged", lives)


func control_animation(new_anim):
  if sprite.animation == 'jump_start' or sprite.animation == 'jump_end' or sprite.animation == 'attack':
    return
    
  if sprite.animation != new_anim:
    sprite.play(new_anim)


func _on_sprite_frame_changed():
  if sprite.animation == 'walk':
    $sounds/walk.play()
  if sprite.animation == 'attack' and sprite.frame == 2:
    emit_signal("attack", not sprite.flip_h)


func _on_sprite_animation_finished():
  if sprite.animation == 'jump_start':
    sprite.stop()
  if sprite.animation == 'jump_end':
    sprite.play('idle')
  if sprite.animation == 'attack':
    sprite.play('idle')
    is_attacking= false
