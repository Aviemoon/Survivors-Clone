extends Sprite2D
@onready var target = $Sprite2D
var direction = Vector2.ZERO

func _physics_process(delta):
	if target:
		#direction = Vector2.RIGHT.rotated(get_angle_to(target.global_position))
		direction = target.position
		print(direction)
		look_at(direction)
	else:
		queue_free()
