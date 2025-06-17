extends Node2D
@export var enemylist:Array[PackedScene] = []
@onready var EnemyPath = $Player/EnemySpawner/PathFollow2D
@onready var timer = %GameTimer
@onready var player = $Player
@export var pointer: Resource
@export var spawns:Array[Spawn_info] = []
@export var elite_spawns:Array[Elite_Spawn_info] = []


var all_pickups = []

var can_tp = false

var spawn_limit:int = 194
var enemies_alive:int = 0
var time:int = 0
var stat_mod:float = 1.0

#func _physics_process(delta):
	#pass

func spawn_mob(): #function that spawns enemies :3
	enemies_alive = get_enemy_num()
	#print('enemies alive: ', enemies_alive)
	
	var enemy_spawn = spawns
	var elites = elite_spawns
	
	for i in elites:
		if time in i.times:
			for s in range(i.enemy_num):
				var new_elite:Enemy = i.enemy.instantiate()
				if i.stat_modifier:
					new_elite.movement_speed += i.stat_modifier.speed_bonus
					new_elite.hp += i.stat_modifier.hp_bonus
					new_elite.armor += i.stat_modifier.armor_bonus
					new_elite.knockback_recovery += i.stat_modifier.kbres_bonus
					new_elite.damage += i.stat_modifier.dmg_bonus
					new_elite.xp_amount += i.stat_modifier.xp_bonus
					new_elite.scale *= i.stat_modifier.size_mod
				EnemyPath.progress_ratio = randf()
				new_elite.global_position = EnemyPath.global_position
				add_child(new_elite)
	
	for i in enemy_spawn:
		if time >= i.time_start and time < i.time_end:
			for new_enemy in range(i.enemy_num):
				if enemies_alive <= spawn_limit:
					var new_mob:Enemy = i.enemy.instantiate()
					if i.stat_modifier:
						new_mob.movement_speed += i.stat_modifier.speed_bonus
						new_mob.hp += i.stat_modifier.hp_bonus
						new_mob.armor += i.stat_modifier.armor_bonus
						new_mob.knockback_recovery += i.stat_modifier.kbres_bonus
						new_mob.damage += i.stat_modifier.dmg_bonus
						new_mob.xp_amount += i.stat_modifier.xp_bonus
						new_mob.scale *= i.stat_modifier.size_mod
					EnemyPath.progress_ratio = randf()
					new_mob.global_position = EnemyPath.global_position
					add_child(new_mob)
				else:
					return false

func get_enemy_num():
	var num:int = 0
	for i in get_children():
		if i is Enemy:
			num += 1
	return num

func _on_spawn_timer_timeout():
	time += 1
	
	if time == 900 and GlobalVar.endless == false:
		$winTimer.start()
	elif time == 900 and GlobalVar.endless:
		var new_info1 = new_spawninfo(time + 2, time + 30)
		var new_info2 = new_spawninfo(time + 5, time + 35)
		spawns.append(new_info1)
		spawns.append(new_info2)
		$endlessTimer.start()
	spawn_mob()

func new_spawninfo(p_time_start, p_time_end):
	var info = Spawn_info.new()
	info.time_start = p_time_start
	info.time_end = p_time_end
	info.enemy = enemylist.pick_random()
	info.enemy_num = randi_range(5, 11)
	info.stat_modifier = StatUpgrade.new()
	info.stat_modifier.speed_bonus = randi_range(p_time_start / 10, p_time_end / 10)
	info.stat_modifier.hp_bonus = randi_range(p_time_start / 10, p_time_end / 10)
	info.stat_modifier.dmg_bonus = randi_range(2, 8)
	info.stat_modifier.armor_bonus = randi_range(1, 10)
	info.stat_modifier.kbres_bonus = randf_range(4, 25)
	info.stat_modifier.xp_bonus = randi_range(2, 10)
	info.stat_modifier.size_mod = randf_range(2, 3.8)
	
	return info



func _on_view_area_body_exited(body):
	can_tp = true
	if body is Enemy:
		await get_tree().create_timer(0.25).timeout
		if body and can_tp == true:
			EnemyPath.progress_ratio = randf()
			body.global_position = EnemyPath.global_position

func _on_view_area_area_entered(area):
	can_tp = false


func _on_win_timer_timeout():
	if enemies_alive <= 0:
		get_tree().paused = true
		%Label_win.scale *= 0
		$Player/CanvasLayer.visible = true
		$Player/CanvasLayer.layer += 2
		var tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.set_parallel()
		tween.tween_property(%BlackRect, 'modulate:a', 0.5, 2.7).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(%Label_win, 'scale', Vector2(1, 1), 1).set_delay(0.4)
		tween.tween_property(%playButton, 'position:y', 200, 0.6).set_delay(0.6)
		tween.tween_property(%quitButton, 'position:y', 250, 0.6).set_delay(0.7)
		await tween.finished
		tween.kill()

func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://Utility/main_menu.tscn")

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://World/world.tscn")


func _on_endless_timer_timeout():
	var new_info1 = new_spawninfo(time + 2, time + 30)
	var new_info2 = new_spawninfo(time + 5, time + 35)
	spawns.append(new_info1)
	spawns.append(new_info2)
