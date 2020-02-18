extends Control

var current_resolution = 2

func _ready():
  var save_load = get_node("/root/SaveLoad")
  current_resolution = save_load.get_video_magnifier()
  setup_window()

func _on_start_pressed():
  get_tree().change_scene("res://src/levels/test.tscn")

func _on_exit_pressed():
  get_tree().quit()

func _on_resolution_pressed():
  toggle_resolution()
  setup_window()
  
func toggle_resolution():
  if current_resolution == 2:
    current_resolution = 4
  elif current_resolution == 4:
    current_resolution = 2

func setup_window():
  if current_resolution == 2:
    OS.set_window_size(Vector2(640, 480))
  elif current_resolution == 4:
    OS.set_window_size(Vector2(1280, 960))
    
  OS.center_window()
  refresh_resolution_text()
  var save_load = get_node("/root/SaveLoad")
  save_load.save(current_resolution)
  $camera.refresh_zoom()

func refresh_resolution_text():
  $VBoxContainer/Resolution.text = 'Resolution: x%d' % current_resolution
  
  var s = OS.get_screen_size()
  if s.x <= 1280 or s.y <= 960:
    $VBoxContainer/Resolution.hide()
