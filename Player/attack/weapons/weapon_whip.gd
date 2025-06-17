extends Weapon


@onready var attackCooldownTimer:Timer = %attackCooldown


func _ready():

	displayname = 'Whip'
	base_description = 'Attacks horizontally'
	description = ''
	#cooldown = 3.0
	attackCooldownTimer.wait_time = cooldown
	
	check_level()
var rotation_multiplier = 0

func check_level():
	attackCooldownTimer.stop()
	match level:
		0:
			#base_amount = 0
			amount = 0
			
		1:
			#base_amount += 0
			description = 'Projectile amount increased by 1, damage increased by 12'
		2:
			base_damage += 12
			base_amount += 1
			area += 0.05
			description = 'Cooldown decreased by 10%'
		3:
			cooldown -= cooldown / 10
			description = 'Amount and area increased'
		4:
			base_amount += 1
			area += 0.25
			description = 'Damage increased by 13'
		5:
			base_damage += 13
			description = 'Area increased by 20%, cooldown decreased by 20%'
		6:
			area += 0.25
			cooldown -= cooldown / 5
			description = 'Damage increased by 11'
		7:
			base_damage += 11
			description = 'Amount increased by 1, cooldown decreased by 20%'
		8:
			base_amount += 1
			cooldown -= cooldown / 5
			description = 'All stats improved a tiny bit'
		_:
			cooldown -= cooldown / 100
			base_damage += 1
			area += 0.03
	
			
	
	attackCooldownTimer.stop()
	attackCooldownTimer.wait_time = cooldown
	attack()
	attackCooldownTimer.start()

func attack():
	var yoffset = 0
	
	for i in range(amount):
		var new_projectile = projectile.instantiate()
		new_projectile.global_position = global_position
		new_projectile.rotation += deg_to_rad(rotation_multiplier)
		
		if i != 0 and (i) % 2 == 0:
			yoffset += 35
		new_projectile.position.y -= yoffset
		rotation_multiplier += 180
		add_child(new_projectile)
		if rotation_multiplier == 360:
			rotation_multiplier = 0
		
		await get_tree().create_timer(0.125).timeout

func _on_attack_cooldown_timeout():
	attack()
