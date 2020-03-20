extends Node2D

onready var player = $player
onready var tilemap = $TileMap

func _ready():
  get_tree().call_group("sphere", "connect", "sphere_pickup", player, "on_sphere_pickup")
  get_tree().call_group("keys", "connect", "key_pickup", player, "on_key_pickup")  
  get_tree().call_group("doors", "connect", "door_opened", player, "on_door_opened")  
  get_tree().call_group("skull", "connect", "skull_collide", player, "on_skull_collide")

  player.connect("spheres_count_changed", $game_gui, "on_spheres_changed")
  player.connect("keys_count_changed", $game_gui, "on_keys_changed")
  player.connect("lives_count_shanged", $game_gui, "on_lives_changed")
  
  player.refresh_ui_state()
  
  player.connect("attack", self, "on_player_attack")
  player.connect("game_over", self, "on_game_over")

func _process(delta):
  pass

func on_player_attack(turned_right):
  var x = 0
  if turned_right:
    x = player.position.x + 16
  else:
    x = player.position.x - 16
    
  var attack_position = Vector2(x, player.position.y)
  var map_pos = tilemap.world_to_map(attack_position)
  if tilemap.get_cellv(map_pos) == 1:
    tilemap.set_cellv(map_pos, 2)
    play_destroy_particles(attack_position)
  elif tilemap.get_cellv(map_pos) == 2:
    tilemap.set_cellv(map_pos, -1)
    play_destroy_particles(attack_position)

func on_game_over():
  get_tree().change_scene("res://src/levels/game_over.tscn")

func play_destroy_particles(pos):
  $player/camera.screenshake()
  var dup = $destroy_block_particles.duplicate()
  add_child(dup)
  dup.position = pos
  for c in dup.get_children():
    if c.has_method("restart"):
      c.restart()
    if c is Timer:
      c.connect("timeout", self, "on_destroy_particles_timeout", [dup])
      c.start()

func on_destroy_particles_timeout(particles):
  particles.queue_free()
