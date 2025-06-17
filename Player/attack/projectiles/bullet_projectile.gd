extends Projectile
class_name BulletProjectile

@onready var sfx_shoot = %sfx_shoot

func _ready():
	stats()
	sfx_shoot.pitch_scale += randf_range(-0.1, 0.1)
	sfx_shoot.play()

func _physics_process(delta):
	go_to_rotation(delta)

func _on_death_timer_timeout():
	queue_free()

func _on_body_entered(_body):
	#print(body)
	#if body.is_in_group("enemy"):
	enemy_hit()

func _on_despawn_timer_timeout():
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
