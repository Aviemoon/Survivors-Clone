extends Node2D
class_name Weapon

@export var projectile:Resource
@onready var player:Player = get_tree().get_first_node_in_group('player')

var displayname = 'Weapon'
var description = 'Attacks somehow'
var base_description = 'Attacks somehow' # used when level is 0 
@export var level = 0
@export var synergy:bool = false
@export var base_amount:int = 0
@export var cooldown:float = 1.0

@export var base_damage:int = 0
@export var knockback:float = 0
@export var area:float = 0
@export var speed:int = 0
@export var hp:int = 0

var damage:int = 0
var amount:int = 0

#func stats():
	#projectile.stats()

#func set_level(p_level):
	#level = p_level
#
#func upgrade_item():
	#level += 1

func check_passives():
	if level > 0:
		damage = base_damage + player.bonus_damage
		amount = base_amount + player.bonus_amount

func check_level():
	pass

func attack():
	pass

func check_description():
	pass
