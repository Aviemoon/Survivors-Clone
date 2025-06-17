extends Projectile

@onready var lockOnTimer = %lockOnTimer
@onready var explosion = preload("res://Utility/explosion.tscn")
@onready var enemyRange = %EnemyRange
var enemies_in_range:Array = []
var target = null

func _ready():
	stats()

func _physics_process(delta):
	angle = Vector2.RIGHT.rotated(rotation)
	var direction = angle * speed 
	var targetAngle = Vector2.ZERO
	var enemy_distance = 75
	for i in enemies_in_range:
		var local_distance = global_position.distance_to(i.global_position)
		if local_distance < enemy_distance:
			enemy_distance = local_distance
			target = i
	
	if len(enemies_in_range) != 0 and target != null:
		targetAngle = global_position.direction_to(target.global_position)
		look_at(((angle - targetAngle) / 2).normalized())
	
	
	position += direction * delta



func enemy_hit(charge = 1) -> void:
	hp -= charge
	if hp <= 0:
		call_deferred('set', 'damage', 0)
		call_deferred('set', 'disabled', true)
		explosion.call_deferred('set', 'enabled', true)
		
		
		var explode = explosion.instantiate()
		explode.scale = scale
		explode.global_position = global_position
		explode.visible = true
		
		get_parent().call_deferred("add_child", explode)
		visible = false
		
		#await get_tree().create_timer(1).timeout
		queue_free()





func _on_body_entered(body):
	if body.is_in_group('enemy'):
		enemy_hit()

func _on_enemy_range_area_entered(area):
	if area.is_in_group('enemy'):
		enemies_in_range.append(area)

func _on_enemy_range_area_exited(area):
	enemies_in_range.erase(area)
