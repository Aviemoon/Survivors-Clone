extends Projectile


func _ready():
	stats()
	print(speed)

func _physics_process(delta):
	go_to_rotation(delta)


func _on_body_entered(body):
	enemy_hit()


func _on_visible_on_screen_notifier_2d_screen_exited():
	visible = false
	$GPUParticles2D.emitting = false
	await get_tree().create_timer(1).timeout
	queue_free()
