extends Weapon

@onready var marker = %ShootMarker
@onready var attackTimer:Timer = %shootTimer
@onready var sfxshoot = %sfx_shoot

var enemies_near = []

func _ready():
	#projectile = preload("res://Player/attack/projectiles/torpedo_projectile.tscn")
	displayname = 'Staff'
	base_description = 'Shoots magical orbs at a random enemy'

func check_level():
	match level:
		0:
			pass
		1:
			pass
			description = 'Damage + 4, amount increased by 1'
		2:
			base_amount += 1
			base_damage += 4
			description = 'Cooldown decreased by 20%'
		3:
			cooldown -= cooldown / 5
			description = 'Amount and speed increased'
		4:
			base_amount += 1
			speed += 25
			description = 'Cooldown decreased by 10%, pierces 1 more target'
		5:
			cooldown -= cooldown / 10
			hp += 1
			description = 'Damage increased by 5'
		6:
			base_damage += 5
			description = 'Area increased by 10%, cooldown decreased by 10%'
		7:
			area += 0.1
			cooldown -= 0.1
			description = 'Damage, speed and amount increased'
		8:
			base_damage += 2
			speed += 20
			amount += 3
			description = 'All stats improved a tiny bit'
		_:
			base_damage += 3
			speed += 5
			if level % 3:
				base_amount += 1
			else:
				area += 0.1
				cooldown -= cooldown / 20
		
	shoot()
	attackTimer.stop()
	attackTimer.wait_time = cooldown
	attackTimer.start()



func shoot():
	if len(enemies_near) != 0:
		var extra_rotation:float = 0.0
		var rand_enemy = enemies_near.pick_random()
		var enemy_position:Vector2 = rand_enemy.global_position
		for i in range(amount):
			sfxshoot.play()
			var new_projectile = projectile.instantiate()
			new_projectile.global_position = marker.global_position
			new_projectile.look_at(enemy_position)
			if i != 0 and i+1 % 2 != 0:
				extra_rotation += 2.45
			
			new_projectile.rotation += deg_to_rad(extra_rotation * (-1 ** i))
			await get_tree().create_timer(0.08).timeout
			add_child(new_projectile)

#func _on_range_area_entered(area):
	#if area.is_in_group('enemy'):
		#enemies_near.append(area)
#
#
#func _on_range_area_exited(area):
	#if area in enemies_near:
		#enemies_near.erase(area)
#


func _on_shoot_timer_timeout():
	if level > 0:
		shoot()
		


func _on_range_body_entered(body):
	if body.is_in_group('enemy'):
		enemies_near.append(body)


func _on_range_body_exited(body):
	if body in enemies_near:
		enemies_near.erase(body)
