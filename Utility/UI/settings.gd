extends Panel

func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))



func _on_dmgnum_check_toggled(toggled_on):
	GlobalVar.can_dmg_num = not GlobalVar.can_dmg_num
	print('Can damage numbers appear? ', GlobalVar.can_dmg_num)


func _on_check_box_toggled(toggled_on):
	GlobalVar.can_afterimage = not GlobalVar.can_afterimage
