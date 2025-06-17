extends Button
class_name ItemChoice

@onready var player = get_tree().get_first_node_in_group('player')
@onready var weapons = get_tree().get_nodes_in_group('weapon')
@onready var item_icon = %Icon
@onready var label_name = $Label_name
@onready var label_level = $Label_level
@onready var label_description = $Label_description
#@onready var upgrades = %Upgrades


var item = null

signal upgrade_select(upgrade)

func get_random_item():
	var upgrade = weapons.pick_random()
	return upgrade



func set_item_random():
	item = get_random_item()

func _ready():
	if item == null:
		item = get_random_item()
	
	if item.has_node('ItemIcon'):
		item_icon.texture = item.get_node('ItemIcon').texture
		#item_icon.scale -= Vector2(4, 4)
		#item_icon.position += Vector2(1, 1)
	connect('upgrade_select', Callable(player, 'upgrade_character'))
	label_level.text += str(item.get('level') + 1)
	label_name.text = str(item.get('displayname'))
	if item.get('level') == 0:
		label_description.text = str(item.get('base_description'))
	else:
		label_description.text = str(item.get('description'))

func _on_pressed():
	emit_signal('upgrade_select', item)
	
	
