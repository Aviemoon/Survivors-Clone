extends Projectile

func _ready():
	stats()

func _physics_process(delta):
	go_to_rotation(delta)


func _on_body_entered(body):
	enemy_hit()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
