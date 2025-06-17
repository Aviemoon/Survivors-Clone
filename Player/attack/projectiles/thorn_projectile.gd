extends Projectile

var duration = 0.2

func _ready():
	stats()
	await get_tree().create_timer(duration).timeout
	call_deferred('queue_free')

func _physics_process(delta):
	go_to_rotation(delta)




func _on_visible_on_screen_notifier_2d_screen_exited():
	await get_tree().create_timer(1).timeout


func _on_body_entered(body):
	enemy_hit()
