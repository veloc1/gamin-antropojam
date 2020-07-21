extends Control

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://src/levels/TestRoom.tscn")
