extends Node

func load_save():
	var c = get_config()
	return c

func get_video_magnifier():
	var c = get_config()
	return c.get_value('game', 'video_magnifier', 1)

func save(video_magnifier):
	var c = get_config()
	c.set_value('game', 'video_magnifier', video_magnifier)
	c.save("user://settings.cfg")

func get_config() -> ConfigFile:
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK:
		return config
	config.save("user://settings.cfg")
	return config
