extends RichTextLabel


onready var tween = $Tween

func _ready():
	start()

func start():
	percent_visible = 0
	var duration = len(text) / 15

	tween.interpolate_property(self, "percent_visible", 0, 1.0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
