extends Upgrade

func _ready():
	displayname = 'Mask of Strength'
	base_description = 'Increases damage by 1'
	description = base_description

func check_level():
	if level <= max_level:
		player.bonus_damage += damage
		if level >= max_level:
			max_reached()
		fix_sword()
