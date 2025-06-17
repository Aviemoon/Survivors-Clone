extends Projectile
class_name WhipProjectile

@onready var sprite = %Sprite2D
@onready var deferredTimer = %deferredTimer
@onready var sfx = %sfx


var delay = 0.15

#func flip_v() -> void:
	#sprite.flip_h = true

func _ready():
	super._ready()
	sfx.play()
	angle = Vector2.RIGHT.rotated(rotation)
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.call_deferred('set', 'disabled', true)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, 'modulate:a', 0, delay)
	tween.play()
	await tween.finished
	tween.kill()
	
	deferredTimer.wait_time = delay
	deferredTimer.start()

	await sfx.finished
	queue_free()


	
