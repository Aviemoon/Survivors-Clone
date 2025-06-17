extends Sprite2D



func _ready():
	if get_parent() is Sprite2D:
		texture = get_parent().texture
		scale = get_parent().scale
	global_position = get_parent().global_position
	rotation = get_parent().rotation
	
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(self, 'modulate:a', 0, 0.3)
	tween.tween_property(self, 'scale', Vector2.ZERO, 0.3)
	await tween.finished
	tween.kill()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
