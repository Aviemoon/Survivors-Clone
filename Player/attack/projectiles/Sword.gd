extends Projectile



func _ready():
	stats()

func _physics_process(delta):
	angle = Vector2.UP.rotated(rotation)
	rotation += deg_to_rad(speed) * delta
	
