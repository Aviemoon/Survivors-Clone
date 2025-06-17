extends Weapon

@onready var timer = $attackTimer

func _ready():
	displayname = 'Thorn Vine'
	base_description = 'Shoots thorns in all directions'
	description = base_description

func check_level():
	match level:
		1:
			description = 'Speed and amount increased'
		2:
			base_amount += 1
			speed += 24
			cooldown -= cooldown / 10
			description = 'Damage and amount increased, pierces an additional target'
		3:
			base_damage += 2
			hp += 1
			area += 0.03
			base_amount += 1
			description = 'Knockback and amount increased'
		4:
			knockback += 9
			base_amount += 1
			cooldown -= cooldown / 10
			description = 'Area, damage and amount increased'
		5:
			area += 0.1
			base_amount += 1
			base_damage += 1
			description = 'Cooldown reduced, area increased'
		6:
			cooldown -= 0.1
			area += 0.1
			description = 'Knockback and amount increased'
		7:
			base_amount += 1
			cooldown -= cooldown / 10
			area += 0.2
			knockback += 10
			description = 'Speed and piercing increased'
		8:
			speed += 10
			hp += 1
			description = 'All stats increased'
		9:
			base_amount += 1
			base_damage += 2
			knockback += 3
			area += 0.15
			speed += 3
			description = 'All stats increased'
		_:
			if level % 5 == 0:
				base_amount += 1
			base_damage += 1
			speed += 1
			
	timer.wait_time = cooldown
	timer.start()
	attack()


func attack():
	$sfx.play()
	var projectile_rotation:float = randf_range(-1, 1)
	for i in range(amount):
		var new_bullet = projectile.instantiate()
		new_bullet.global_position = global_position
		new_bullet.rotation += projectile_rotation
		projectile_rotation -= deg_to_rad(360 / amount)
		add_child(new_bullet)
		#await get_tree().create_timer(0.05).timeout




func _on_attack_timer_timeout():
	attack()
