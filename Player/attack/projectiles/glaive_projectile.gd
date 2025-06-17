extends Projectile

@onready var range = $Range
@onready var timer = $bounceCooldown
var duration = 6.5
@onready var sprite = $Sprite2D
func _ready():
	stats()
	$despawnTimer.wait_time = duration
	print($despawnTimer.wait_time)

func _physics_process(delta):
	go_to_rotation(delta)
	sprite.rotation_degrees += speed * delta * 4
	#$CollisionShape2D.rotation_degrees += speed * delta * 4
	if GlobalVar.can_afterimage:
		new_afterimage()
	

func new_afterimage():
	var new_sprite = afterimage.instantiate() 
	sprite.add_child(new_sprite)

func _on_body_entered(body):
	var enemies_in_range:Array = range.get_overlapping_bodies()
	if len(enemies_in_range) > 0:
		var rand_enemy = enemies_in_range.pick_random()
		if body in enemies_in_range:
			enemies_in_range.erase(body)
		if timer.is_stopped():
			await get_tree().create_timer(0.085).timeout
			if rand_enemy:
				look_at(rand_enemy.global_position)
			timer.start()

func _on_despawn_timer_timeout():
	var tween = get_tree().create_tween()
	tween.tween_property(self, 'modulate:a', 0, 0.75).set_trans(Tween.TRANS_ELASTIC)
	await tween.finished
	tween.kill()
	queue_free()


func _on_screen_notif_screen_exited():
	visible = false


func _on_screen_notif_screen_entered():
	visible = true
