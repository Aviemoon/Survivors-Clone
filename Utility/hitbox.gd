extends Area2D

@export var damage = 1

@onready var collision = $HitboxCollisionShape2D
@onready var disableTimer = $DisableHitboxTimer

func _ready():
	if get_parent().get('damage'):
		damage = get_parent().get('damage')

func tempdisable():
	collision.call_deferred("set", "disabled", true)
	disableTimer.start()

func _on_disable_hitbox_timer_timeout():
	collision.call_deferred("set", "disabled", false)
