extends Node2D
class_name Upgrade



var displayname = 'Upgrade'
var description = 'Does something'
var base_description = 'Does something' # used when level is 0 

@onready var player:Player = get_tree().get_first_node_in_group('player')
var level:int = 0
@export var max_level = 1
@export var player_speed:int = 0
@export var projectile_speed:int = 0
@export var amount:int = 0
@export var damage:int = 0
@export var cooldown_reduction:float = 0
@export var regen_cooldown:float
@export var armor:int = 0
@export var hp:int
@export var magnet:float

func fix_sword():
	if player.sword.level >= 0:
		for i in player.sword.get_children():
			if i.is_in_group('attack'):
				i.queue_free()
		player.sword.call_deferred('spawn_projectile')

func max_reached():
	remove_from_group('weapon')

func check_level():
	pass
