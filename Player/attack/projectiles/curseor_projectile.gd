extends Projectile

#func _physics_process(delta):
	#global_position = get_global_mouse_position()

@onready var timer = %despawnTimer

func _ready():
	stats()
	timer.start()

func _on_despawn_timer_timeout():
	queue_free()
