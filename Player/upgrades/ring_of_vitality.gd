extends Upgrade

func _ready():
	displayname = 'Ring of Vitality'
	base_description = 'Increases max HP by 20'
	description = base_description

func check_level():
	if level <= max_level:
		player.bonus_max_hp += hp
		player.call_deferred('heal', hp)
		if level >= max_level:
			max_reached()
