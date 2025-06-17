extends Area2D
class_name Pickup

signal picked_up

var target = null
var speed = -1
@export var speed_mod:float = 5

func _physics_process(delta):
	if target:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += speed_mod * delta

func collect():
	$CollisionShape2D.call_deferred('set', 'disabled', true)
	visible = false
	emit_signal('picked_up')
	#await get_tree().create_timer(1).timeout
	#queue_free()
