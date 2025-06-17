extends Pickup

func increase_range():
	target.magnetRange.scale *= 100
	await get_tree().create_timer(0.1).timeout
	target.magnetRange.scale /= 100

func _on_picked_up():
	if target is Player:
		call_deferred('increase_range')
