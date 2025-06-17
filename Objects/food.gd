extends Pickup
#class_name Food

@export var textures:Array[Resource] = []
@export var hp = 20

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $sfx_collect

func _ready():
	sprite.texture = textures.pick_random()

func _on_picked_up():
	sound.play()
	if target:
		if target.get('heal'):
			target.heal(hp)
