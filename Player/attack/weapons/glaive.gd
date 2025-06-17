extends Weapon

@onready var timer = $attackTimer
@onready var range = $Range
var duration:float = 0


func _ready():
	displayname = 'Glaive'
	base_description = 'Throws a glaive that bounces to other enemies'
	description = base_description

func check_level():
	match level:
		1:
			description = 'Damage increased by 5'
		2:
			duration += 0.2
			base_damage += 5
			knockback += 13
			description = 'Speed, duration and area increased'
		3:
			duration += 1
			speed += 20
			area += 0.15
			description = 'Damage + 5, knockback and duration increased'
		4:
			base_damage += 5
			
			knockback += 9
			description = 'Amount and duration increased by 1'
		5:
			duration += 1
			base_amount += 1
			description = 'Cooldown reduced by 10%, speed increased'
		6:
			speed += 10
			cooldown -= 0.3
			duration += 0.25
			description = 'Damage increased by 9, area increased by 0.1'
		7:
			base_damage += 9
			area += 0.1
			description = 'Knockback and cooldown improved'
		8:
			knockback += 10
			cooldown -= 0.5
			base_damage += 1
			description = 'Amount and duration increased by 1, cooldown decreased'
		9:
			duration += 1.3
			base_amount += 1
			cooldown -= cooldown / 10
			description = 'All stats slightly increased'
		_:
			cooldown -= cooldown / 100
			duration += 0.015
			base_damage += 2
			area += 0.01
	
	
	timer.wait_time = cooldown
	attack()
	timer.start()

func attack():
	for i in amount:
		var new_proj:Projectile = projectile.instantiate()
		new_proj.global_position = global_position
		new_proj.duration += duration
		if len(range.get_overlapping_bodies()) > 0:
			var rand_enemy = range.get_overlapping_bodies().pick_random()
			new_proj.look_at(rand_enemy.global_position)
		else:
			new_proj.look_at(Vector2(randf(), randf()))
		
		if amount > 1:
			await get_tree().create_timer(0.165).timeout
		add_child(new_proj)


func _on_attack_timer_timeout():
	if level > 0:
		attack()
