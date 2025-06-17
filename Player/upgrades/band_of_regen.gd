extends Upgrade

func _ready():
	displayname = 'Band of Regeneration'
	base_description = 'Improves regeneration and healing effectiveness'
	description = base_description

func check_level():
	if level <= max_level:
		player.bonus_regen_cooldown += regen_cooldown
		if level % 2 == 0:
			player.bonus_heal += 1
		if level >= max_level:
			max_reached()
