extends Projectile



@onready var sprite = $Marker2D/Sprite2D
@export var proj:Resource
var direction:Vector2 = Vector2.ZERO

func _ready():
	stats()


func sort_closest(a, b):
	return a.position < b.position

func shoot():
	var closest_enemy
	var enemies:Array
	for i in $Range.get_overlapping_bodies():
		if i is Enemy:
			enemies.append(i)
	if len(enemies) > 0:
		enemies.sort_custom(Callable(self, 'sort_closest'))
		closest_enemy = enemies.front().position
		var laser = proj.instantiate()
		laser.global_position = sprite.global_position
		laser.look_at(closest_enemy)
		parent.add_child(laser)
	

func _physics_process(delta):
	angle = Vector2.UP.rotated(rotation)
	rotation -= deg_to_rad(speed) * delta
	direction = get_global_mouse_position()
	sprite.look_at(direction)
