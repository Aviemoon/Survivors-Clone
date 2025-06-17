extends CanvasLayer



func _ready():
	get_tree().paused = false



func _on_play_button_pressed():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_parallel()
	tween.tween_property(%PlayButton, 'position:y', %PlayButton.position.y + 230, 1.2).set_delay(0.1)
	tween.tween_property(%QuitButton, 'position:y', %QuitButton.position.y + 230, 1.2)
	
	
	tween.tween_property(%ClassicButton, 'position:y', 120, 1).set_delay(0.5)
	tween.tween_property(%EndlessButton, 'position:y', 120, 1).set_delay(0.5)
	
	await tween.finished
	tween.kill()
	
	


func _on_quit_button_pressed():
	get_tree().quit()

func _on_classic_button_pressed():
	GlobalVar.endless = false
	print(GlobalVar.endless)
	get_tree().change_scene_to_file("res://World/world.tscn")

func _on_endless_button_pressed():
	GlobalVar.endless = true
	print(GlobalVar.endless)
	get_tree().change_scene_to_file("res://World/world.tscn")
