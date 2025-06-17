extends Button

@export var wep:Weapon
@onready var itemIcon = %ItemIcon
@onready var name_label = $ItemLabel

func _ready():
	if wep:
		name_label.text = wep.display_name
		itemIcon.texture = wep.get_node('ItemIcon').texture
