extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitbox") var HurtboxType = 0

@onready var collision = $HurtboxCollisionShape2D
@onready var disableTimer = $DisableTimer

var hit_once_array = []
 
signal hurt(attacker_type, damage, angle, knockback_amount)
#signal enemy_hit(enemy_position)
#signal area_left(object)

func _on_area_entered(area):
	if area.is_in_group("attack") or (area.is_in_group('enemy') and get_parent().is_in_group('enemy') != true):
		if area.get("damage"):
			match HurtboxType:
				0: # cooldown
					collision.call_deferred("set", "disabled", true)
					disableTimer.start()
				1: # HitOnce
					if area not in hit_once_array:
						hit_once_array.append(area)
					else:
						return
				2:
					if area.has_method("tempdisable"):
						area.tempdisable()
			var angle = Vector2.ZERO
			var knockback_amount = 1
			var damage = area.damage
			var attacker_type = ''
			if area.is_in_group("attack_friendly"):
				attacker_type = 'friendly'
			if area.get("angle"):
				angle = area.angle
			if area.get("knockback_amount"):
				knockback_amount = area.knockback_amount
			
			emit_signal("hurt", attacker_type, damage, angle, knockback_amount)
			

func _on_disable_timer_timeout():
	collision.call_deferred("set", "disabled", false)
	


func _on_area_exited(area):
	if area in hit_once_array:
		hit_once_array.erase(area)
