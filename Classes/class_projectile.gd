extends Area2D
class_name Projectile

@onready var player:Player = get_tree().get_first_node_in_group('player')
@onready var parent = get_parent()
#var player:Player = preload("res://Player/player.tscn")

@export var afterimage: PackedScene
@export var collision:CollisionShape2D

@export var base_damage:int = 0
@export var base_speed:int = 0
@export var base_knockback_amount = 0
@export var base_hp = 1
@export var base_area = 1


var damage:int = 0
var speed:int = 0
var knockback_amount = 0
var hp = 1

var angle = Vector2.ZERO

func stats():
	if parent.level > 0 and parent is Weapon:
		var area_mod = base_area + player.bonus_area + parent.area 
		damage = base_damage + parent.damage
		speed = base_speed + player.bonus_projectile_speed + parent.speed
		knockback_amount = base_knockback_amount + parent.knockback
		hp = base_hp + parent.hp
		scale = Vector2(area_mod, area_mod)
		#print('damage = ', damage, 'speed: ', speed)

func _init():
	add_to_group('attack')
	add_to_group('attack_friendly')

func go_to_rotation(delta) -> bool:
	angle = Vector2.RIGHT.rotated(rotation)
	var direction = angle * speed
	position += direction * delta
	return true

func _ready():
	stats()
	#connect("weapon_upgrade", Callable(self, 'stats'))

func enemy_hit(charge = 1) -> void:
	hp -= charge
	if hp <= 0:
		collision.call_deferred('set', 'disabled', true)
		visible = false
		await get_tree().create_timer(1).timeout
		queue_free()
