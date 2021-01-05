extends Node2D

class_name Level

var Effects = preload("res://src/effects/Effects.tscn")

export(Color) var bg_color = Color("72ae30")

func _ready():
	var effects = Effects.instance()
	add_child(effects)
	
	Events.connect("game_over", self, "on_game_over")
	
	VisualServer.set_default_clear_color(bg_color)

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit()

func on_game_over():
	get_tree().change_scene("res://src/levels/GameOver.tscn")
