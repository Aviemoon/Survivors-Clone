extends Projectile

signal stopped

var can_move:bool = true
#var callable = 
@onready var laser = preload("res://Player/attack/projectiles/laser_projectile.tscn")
@onready var disableTimer = %despawnTimer
@onready var sfx_laser = %sfx_laser

func _ready():
	stats()
	var tween = get_tree().create_tween()
	tween.tween_property(self, 'speed', 0, 0.25)
	await tween.finished
	tween.kill()
	emit_signal('stopped')
	

func _physics_process(delta):
	if can_move:
		go_to_rotation(delta)
	else:
		return


func _on_stopped():
	can_move = false
	
	var laser_amount:int
	if parent.get('laser_amount'):
		laser_amount = parent.get('laser_amount')
	else:
		laser_amount = 1
	
	await get_tree().create_timer(0.5).timeout
	
	for i in range(laser_amount):
		sfx_laser.play()
		var new_projectile = laser.instantiate()
		new_projectile.global_position = global_position
		new_projectile.look_at(get_global_mouse_position())
		parent.call_deferred('add_child', new_projectile)
		
		if i+1 < laser_amount:
			await get_tree().create_timer(0.11).timeout
	call_deferred('set', 'disabled', true)
	visible = false
	disableTimer.start()


func _on_despawn_timer_timeout():
	queue_free()
