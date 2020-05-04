extends Control

var current_resolution = 2

func _ready():
	current_resolution = SaveLoad.get_video_magnifier()
	setup_window()

func _on_start_pressed():
	SceneChanger.change_scene("res://src/levels/Castle1.tscn")

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

	SaveLoad.save(current_resolution)
	$Camera.refresh_zoom()

func refresh_resolution_text():
	$VBoxContainer/Resolution.text = 'Resolution: x%d' % current_resolution

	var s = OS.get_screen_size()
	if s.x <= 1280 or s.y <= 960:
		$VBoxContainer/Resolution.hide()
