extends Weapon

@onready var attackTimer = %attackTimer
@onready var sfx_shoot = %sfx_shoot
var laser_amount = 1

func _ready():
	displayname = 'Bubble Blaster'
	base_description = 'Shoots bubbles that pop into lasers'

func get_laser_amount():
	return laser_amount

func check_level():
	match level:
		1:
			pass
			description = 'Damage increased by 2, amount + 1'
		2:
			base_damage += 2
			base_amount += 1
			description = 'Area increased by 20%, cooldown decreased by 10%'
		3:
			area += 0.2
			cooldown -= cooldown / 10
			description = 'Bubbles shoot 1 more laser'
		4:
			laser_amount += 1
			description = 'Cooldown decreased by 10%'
		5:
			cooldown -= cooldown / 10
			description = 'Amount increased'
		6:
			base_amount += 1
			description = 'Damage and knockback increased'
		7:
			base_damage += 2
			knockback += 40
			description = 'All stats increased, bubbles shoot 1 more laser'
		8:
			laser_amount += 1
			base_damage += 1
			cooldown -= cooldown / 20
			area += 0.13
			speed += 20
			amount += 1
			hp += 1
			description = 'All stats improved a tiny bit'
		_:
			if level % 4 == 0:
				base_amount += 1
			elif level % 20 == 0:
				laser_amount += 1
			else:
				base_damage += 1
				area += 0.05
			
	attack()
	attackTimer.stop()
	attackTimer.wait_time = cooldown
	attackTimer.start()


func attack():
	sfx_shoot.play()
	for i in range(amount):
		
		var new_bubble = projectile.instantiate()
		new_bubble.global_position = global_position
		new_bubble.rotation_degrees = randf_range(0, 360)
		add_child(new_bubble)
		

func _on_attack_timer_timeout():
	if level > 0:
		attack()
