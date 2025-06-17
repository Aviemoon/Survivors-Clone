extends Weapon

signal choose_target()
var closest_enemy = Vector2.ZERO

func check_level():
	match level:
		0:
			amount = 0
		1:
			amount = 2
	
	for i in get_children():
		if i.is_in_group('attack'):
			i.queue_free()
	spawn_projectile()



func spawn_projectile():
	for i in range(amount):
		var new_projectile:Projectile = projectile.instantiate()

		connect('choose_target', Callable(new_projectile, 'shoot'))
		new_projectile.rotation = deg_to_rad((i + 1) * (360.0 / amount))
		add_child(new_projectile)


func _on_attack_timer_timeout():
	
	emit_signal('choose_target')
