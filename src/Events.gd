extends Node

# *** PLAYER ***

signal double_jump(player_pos, orientation)
signal use_no_item(player_pos, orientation)
signal player_health_changed(new_health)
signal player_coins_changed(new_coins)

signal game_over()

# *** MAP ***

signal block_destroyed(position)

# *** EFFECTS ***

signal start_screenshake()
signal effects_double_jump(pos, to_left)
signal effects_double_jump_water(bubbles_emitter)

