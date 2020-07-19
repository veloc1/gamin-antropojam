extends Node2D

var Effects = preload("res://src/effects/Effects.tscn")

func _ready():
	var effects = Effects.instance()
	add_child(effects)

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit()
