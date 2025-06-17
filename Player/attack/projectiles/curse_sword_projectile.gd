extends Projectile

#@onready var timer = $spawnTimer

func _ready():
	stats()


func _physics_process(delta):
	global_position = get_global_mouse_position()
	angle = Vector2.UP.rotated(rotation)
	rotation -= deg_to_rad(speed) * delta
