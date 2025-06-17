extends Upgrade

func _ready():
	displayname = 'Coffee Cup'
	base_description = 'Increases movement speed'
	description = base_description

func check_level():
	if level <= max_level:
		player.bonus_move_speed += player_speed
		if level >= max_level:
			max_reached()
