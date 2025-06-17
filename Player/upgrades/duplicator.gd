extends Upgrade

func _ready():
	displayname = 'Duplicator'
	base_description = 'Increases projectile amount of all weapons by 1'
	description = base_description
	
func check_level():
	if level <= max_level:
		player.bonus_amount += amount
	if level >= max_level:
		max_reached()
	fix_sword()
