extends Node2D

@onready var attackTimer = %attackCooldown
@onready var shootTimer = %shootCooldown
@onready var marker = %shootyPoint
@onready var projectile = preload("res://Player/attack/projectiles/bullet_projectile.tscn")


var displayname = 'Spiral'
var description = 'Shoots bullets in all directions'
@export var level = 0

var projectiles_shot = 0
var projectile_rotation = deg_to_rad(0)

var bonus_damage = 0
var bonus_knockback = 0
var bonus_area = 0
var amount = 8
var cooldown:float = 10


func _ready():
	attackTimer.wait_time = cooldown
	
func check_level():
	# make it so attack timer stops and starts !!! here!@
	attackTimer.stop()

	match level:
		0:
			amount = 0
		1:
			amount += 1
		2:
			bonus_damage += 5
			amount += 1
		3:
			cooldown -= cooldown / 10
		4:
			amount += 1
			bonus_area += 0.1
		5:
			bonus_damage += 5
		6:
			bonus_area += 0.1
			cooldown -= cooldown / 10
	
	attackTimer.wait_time = cooldown
	attackTimer.start()



func shoot():
	var new_bullet = projectile.instantiate()
	new_bullet.global_position = marker.global_position
	new_bullet.rotation += projectile_rotation
	projectile_rotation += deg_to_rad(360 / amount)
	add_child(new_bullet)



func _on_attack_cooldown_timeout():
	shootTimer.start()

func _on_shoot_cooldown_timeout():
	shoot()
	projectiles_shot += 1
	if projectiles_shot == amount:
		shootTimer.stop()
		projectiles_shot = 0
	
