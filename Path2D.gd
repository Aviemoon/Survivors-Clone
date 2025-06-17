extends Path2D

@onready var EnemyPath = $FollowEnemyPath


func spawn_mob():
	var new_mob = preload("res://Enemy/enemy_kolbold_weak.tscn").instantiate()
	
	EnemyPath.progress_ratio = randf()
	new_mob.global_position = EnemyPath.global_position
	add_child(new_mob)




func _on_timer_timeout():
	spawn_mob()
