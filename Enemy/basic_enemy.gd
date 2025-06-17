extends Enemy


func _physics_process(_delta):
	movement()
	move_and_slide()

func _on_hurtbox_hurt(attacker_type, damage, angle, knockback_amount):
	hurt(attacker_type, damage, angle, knockback_amount)
