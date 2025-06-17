extends Weapon

func _ready():
	displayname = 'Cursed Blade'
	base_description = 'Sword and Curseor synergy. Spins a sword around the cursor'
	check_level()

func check_level():
	match level:
		0:
			amount = 0
		1: 
			base_amount += 1
			description = 'Damage increased by 1, spins faster'
		2:
			base_damage += 1
			speed += 15
			description = 'Spins faster'
		3:
			speed += 25
			description = 'Amount increased by 1'
		4:
			base_amount += 1
			description = 'Spins faster'
		5:
			speed += 30
			description = 'Damage and knockback increased by 3'
		6:
			base_damage += 3
			knockback += 3
			description = 'Spins faster'
		7:
			speed += 25
			description = 'All stats increased a bit'
		8:
			base_amount += 1
			base_damage += 2
			area += 0.2
			speed += 50
			description = 'All stats improved a tiny bit'
		_:
			base_damage += 1
			area += 0.025

	for i in get_children():
		if i.is_in_group('attack'):
			i.queue_free()
	spawn_projectile()



func spawn_projectile():
	for i in range(amount):
		var new_projectile = projectile.instantiate()
		new_projectile.rotation = deg_to_rad((i + 1) * (360.0 / amount))
		#new_projectile.rotation = deg_to_rad(360 / (i + 1))
		add_child(new_projectile)
