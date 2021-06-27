extends CanvasLayer

signal entered
signal exited

var line = -1
var is_active = false
var is_enter = false

func _ready():
	$TextureRect.material.set_shader_param("line", -1.0)
	#refresh_zoom()

func refresh_zoom():
	var v = SaveLoad.get_video_magnifier()
	$TextureRect.material.set_shader_param("zoom", float(v))
	$TextureRect.texture = ImageTexture.new()
	$TextureRect.texture.create(320 * v, 240 * v, Image.FORMAT_RGBA8)


func enter_transition():
	line = -1
	is_enter = true
	is_active = true

	$TextureRect.material.set_shader_param("line", line)
	$TextureRect.material.set_shader_param("is_enter", true)

func exit_transition():
	line = -1
	is_enter = false
	is_active = true

	$TextureRect.material.set_shader_param("line", line)
	$TextureRect.material.set_shader_param("is_enter", false)

func _process(delta):
	if is_active:
		$TextureRect.material.set_shader_param("line", line)

		line = line + delta * 2

		if line > 1:
			is_active = false

			if is_enter:
				emit_signal("entered")
			else:
				emit_signal("exited")
