extends Upgrade

func _ready():
	displayname = 'Chestplate'
	base_description = 'Decreases damage taken by 1, slows you down a bit'
	description = base_description
	
func check_level():
	if level <= max_level:
		player.bonus_armor += armor
		player.bonus_move_speed -= player_speed
	
	if level >= max_level:
		max_reached()
