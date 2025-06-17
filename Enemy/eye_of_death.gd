extends Enemy
class_name Eye


var can_dash:bool = false
@onready var dashTimer = %dashTimer
@onready var spawnTimer = %spawnTimer
@export var spawn:Resource
@export var proj:Resource

#var direction:Vector2 = Vector2.ZERO
var attack_counter:int = 0
#sounds 
@onready var sfx_dash = %sfx_dash




func _ready():
	print(hp)
	sfx_hit = %sfx_hit
	
	
func _physics_process(delta):
	if dashTimer.is_stopped() == false:
		go_to_player()
	move_and_slide()


func spin(amount:int = 1, duration:float = 1):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", 360 * amount, duration).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	tween.kill()

func dash(wait_time:float = 0) -> bool:
	sfx_dash.play()
	direction = global_position.direction_to(player.global_position)
	await get_tree().create_timer(wait_time).timeout
	velocity = direction * movement_speed * 12.5
	await decelerate(0.8)
	return true

func go_to_player():
	var acceleration:float = 0
	var tween = get_tree().create_tween()
	direction = global_position.direction_to(player.global_position)
	tween.tween_property(self, 'velocity', direction * movement_speed , 0.2)
	await tween.finished
	tween.kill()

func _on_hurtbox_hurt(attacker_type, damage, angle, knockback_amount):
	hurt(attacker_type, damage, angle, knockback_amount)

func die():
	emit_signal("enemy_die")
	var sfx_die = death_anim.instantiate()
	var dropped_xp = xp.instantiate()
	
	var rand_drop = drops.pick_random().instantiate()
	rand_drop.global_position = global_position
	
	dropped_xp.global_position = global_position
	dropped_xp.xp = xp_amount
	#sfx_die.scale = sprite.scale
	#sfx_die.global_position = global_position
	
	get_parent().call_deferred("add_child", sfx_die)
	get_parent().call_deferred("add_child", dropped_xp)
	get_parent().call_deferred("add_child", rand_drop)
	queue_free()


func _on_dash_timer_timeout():
	attack_counter += 1
	dashTimer.stop()
	if attack_counter < 3:
		await decelerate(0.5)
		await dash(0.25)
		
	else:
		decelerate(0.25)
		var spin_duration = 1.2
		await spin(1, spin_duration)
		#var new_enemy = spawn.instantiate()
		#new_enemy.scale = Vector2.ZERO
		#new_enemy.global_position = global_position
		#get_parent().add_child(new_enemy)
		
		#var tween = get_tree().create_tween()
		#tween.tween_property(new_enemy, 'scale', Vector2(1, 1), 1)
		#await tween.finished
		#tween.kill()
		
		#var bullet = proj.instantiate()
		#bullet.global_position = global_position
		#bullet.look_at(player.global_position)
		#get_parent().add_child(bullet)
		
		attack_counter = 0
	
	dashTimer.start()

#func _on_spawn_timer_timeout():
	
	
