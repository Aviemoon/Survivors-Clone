extends Enemy

@onready var max_hp = hp
var level:int = 0

func _ready():
	await get_tree().create_timer(randf()).timeout
	$upgradeTimer.start()

func level_effect():
	$sfx_lvlup.play()
	modulate += Color('green')
	var tween = get_tree().create_tween()
	tween.tween_property(self, 'modulate:g', 1, 1.1)
	await tween.finished
	tween.kill()

func level_up():
	level_effect()
	level += 1
	var totalhp = max_hp / 15
	
	if level <= 10:
		scale *= 1.1
	if totalhp > level:
		hp += totalhp - level
	else:
		hp += 1
	knockback_recovery -= 0.2
	movement_speed += 1.5
	if level % 3 == 0 and level <= 9:
		armor += 1
	elif level % 2 == 0 and level <= 10:
		damage += 1
	elif level % 5 == 0:
		damage += 1
		xp_amount += 2
	print('hp: ', hp, 'max: ', max_hp, 'armor:', armor, 'level: ', level, 'damage:' , damage)

func _physics_process(delta):
	movement()
	move_and_slide()

func _on_hurtbox_hurt(attacker_type, damage, angle, knockback_amount):
	hurt(attacker_type, damage, angle, knockback_amount)

func _on_upgrade_timer_timeout():
	level_up()
