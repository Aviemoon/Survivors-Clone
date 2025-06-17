extends Projectile

@onready var sprite = $Sprite2D


func _ready():
	stats()

func _physics_process(delta):
	go_to_rotation(delta)
	
	
	#sprite.rotation_degrees += (speed / 2) * delta
	#collision.rotation_degrees += (speed / 2) * delta
	
