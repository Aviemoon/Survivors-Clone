extends ColorRect

#@onready var player:Player = get_tree().get_first_node_in_group('player')

func set_texture(p_texture):
	$TextureRect.texture = p_texture
