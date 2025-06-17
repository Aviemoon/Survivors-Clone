extends Pickup
class_name Xp

@export var xp = 1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $sound_collected

func collect():
	super.collect()
	sound.play()
	return xp


func _on_sound_collected_finished():
	queue_free()
