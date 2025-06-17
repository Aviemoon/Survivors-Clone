extends Weapon

func _ready():
	displayname = 'Boomerang'
	


func _on_attack_timer_timeout():
	var proj = projectile.instantiate()
	
	proj.global_position = global_position
	add_child(proj)
