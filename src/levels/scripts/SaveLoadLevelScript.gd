extends Node2D

func _ready():
	$"../Save".connect("pressed", self, "on_save_pressed" )
	$"../Load".connect("pressed", self, "on_load_pressed" )

func on_save_pressed():
	SaveLoad.save_level()

func on_load_pressed():
	SceneChanger.change_scene("res://src/levels/%s.tscn" % "SaveLoadTestLevel", "a")
