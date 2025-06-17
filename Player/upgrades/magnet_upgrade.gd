extends Upgrade

func _ready():
	displayname = 'Magnet'
	base_description = 'Increases magnet range by 40%'
	description = base_description

func check_level():
	if level <= max_level:
		player.bonus_magnet += magnet
		
		if level >= max_level:
			max_reached()
