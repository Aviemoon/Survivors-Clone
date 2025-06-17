extends Weapon

@onready var spriteOut = %SpriteOutside
@onready var spriteIn = %SpriteInside
@onready var timer = %attackTimer
@onready var spriteTimer = %spriteSizeTimer

@export var afterimage:PackedScene

func _ready():

	displayname = 'Curseor'
	base_description = 'Curses the area around your cursor. Synergizes with Sword'
	
	check_level()
	
	
func _physics_process(delta):
	spriteIn.global_position = get_global_mouse_position()
	spriteOut.global_position = get_global_mouse_position()
	spriteIn.rotation -= deg_to_rad(speed + 10) * delta
	spriteOut.rotation += deg_to_rad(speed + 10) * delta
	


func check_level():
	match level:
		1:
			cooldown = 0.3
			description = 'Damage increased by 1, area increased by 10%'
		2:
			area += 0.1
			base_damage += 1
			description = 'Area increased by 20%, damage + 3'
		3:
			area += 0.2
			base_damage += 3
			description = 'Cooldown decreased by 20%'
		4:
			cooldown -= cooldown / 5
			speed += 15
			description = 'Damage + 3, area increased by 15%'
		5:
			base_damage += 3
			area += 0.15
			description = 'Area increased by 35%'
		6:
			area += 0.35
			speed += 10
			description = 'Cooldown decreased by 20%'
		7:
			cooldown -= cooldown / 5
			description = 'All stats increased'
		8:
			area += 0.15
			cooldown -= cooldown / 5
			base_damage += 1
			#knockback += 25
			speed += 2
			description = 'All stats improved a tiny bit'
		_:
			base_damage += 1
			area += 0.05


	if level < 10:
		speed += 5
	timer.wait_time = cooldown
	if level > 0:
		timer.start()
		spriteTimer.start()

func attack():
	var size_mod = Vector2(1 + area, 1 + area)
	spriteIn.visible = true
	spriteOut.visible = true
	spriteIn.scale = size_mod
	spriteOut.scale = size_mod
	for i in get_children():
		if i.is_in_group('attack'):
			i.queue_free()
	var new_projectile = projectile.instantiate()
	new_projectile.global_position = get_global_mouse_position()
	add_child(new_projectile)
	

func _on_attack_timer_timeout():
	attack()

func _on_sprite_size_timer_timeout():
	pass
