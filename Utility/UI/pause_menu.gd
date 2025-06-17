extends Panel

func _on_resume_button_pressed():
	get_tree().paused = false
	

func _on_options_button_pressed():
	for i in get_children():
		i.visible = not i.visible
		if i is Button:
			i.disabled = true
	for i in $Settings.get_children():
		if i.get('disabled'):
			i.disabled = true


func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Utility/main_menu.tscn")


func _on_back_button_pressed():
	for i in $Settings.get_children():
		if i.get('disabled'):
			i.disabled = true
	for i in get_children():
		i.visible = not i.visible
		if i is Button:
			i.disabled = false
