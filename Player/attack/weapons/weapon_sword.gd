extends Weapon


func _ready():
	displayname = 'Sword'
	base_description = 'Spins a sword around the player. Synergizes with Curseor'
	check_level()

func check_level():
	match level:
		0:
			base_amount = 0
		1:
			base_amount += 1
			description = 'Damage increased by 4, spins faster'
		2:
			base_damage += 4
			speed += 7
			description = 'Amount and knockback increased'
		3:
			knockback += 30
			base_amount += 1
			description = 'Area increased by 15%'
			
		4:
			area += 0.15
			description = 'Spins faster'
		5:
			speed += 20
			description = 'Damage and knockback increased'
		6:
			base_damage += 4
			knockback += 30
			description = 'Speed and knockback increased'
		7:
			speed += 3
			knockback += 40
			description = 'All stats increased by a little bit'
		8:
			base_amount += 1
			base_damage += 7
			area += 0.2
			speed += 20
			description = 'All stats improved a tiny bit'
		_:
			base_damage += 1
			area += 0.1
			speed += 3

	for i in get_children():
		if i.is_in_group('attack'):
			i.queue_free()
	call_deferred('spawn_projectile')

func spawn_projectile():
	if level > 0:
		for i in range(amount):
			var new_projectile = projectile.instantiate()
			new_projectile.rotation = deg_to_rad((i + 1) * (360.0 / amount))
			#new_projectile.rotation = deg_to_rad(360 / (i + 1))
			add_child(new_projectile)
