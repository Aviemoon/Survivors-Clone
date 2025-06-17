extends CharacterBody2D
class_name Player

signal died
signal levelup

var is_dead:bool = false

#for upgrades:
#player upgrades
var bonus_move_speed:float = 0.0
var bonus_max_hp:int = 0
@export var bonus_armor:int = 0
var bonus_magnet:float = 0.0
var bonus_regen_cooldown:float = 0.0
var bonus_heal:int = 0
#weapon upgrades
@export var bonus_damage:int = 0
var bonus_cooldown:float = 0.0
var bonus_amount:int = 0
var bonus_projectile_speed:int = 0
var bonus_area:float = 0.0

#player stats
var movement_speed:float = 85.0
@export var max_hp:int = 100
var hp:int = max_hp
var armor:int = 0
var regen_cooldown:float = 0.0

@export var base_movement_speed:float = 85.0
var base_max_hp:int = 100
var base_armor:int = 0
var base_regen_cooldown:float = 12

var xp:int = 0
var xp_level:int = 1
var xp_collected:int = 0

var weapon_list = []
var item_list = []

var current_wep = 0
var current_item = 0
@export var item_limit:int


@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")
#@onready var enemyDetectionArea = $EnemyDetectionArea
@onready var weapons = %Weapons
@onready var regenTimer = $regenTimer
@onready var knockbackArea = %KnockbackArea
@onready var magnetRange = $MagnetArea
@onready var sword = $Weapons/Weapon_Sword
# weapons

# gui
@onready var xpBar = get_node('GUI_layer/GUI/xpBar')
@onready var label_level = %Label_level
@onready var levelup_select = %LevelUp_select
@onready var item_option = preload("res://Utility/UI/item_choice.tscn")
@onready var levelup_choices = %LevelUp_choices
@onready var label_lvlup = %Label_levelup
@onready var hpBar = %HpBar
@onready var label_hp = %Label_hp
@onready var stopwatch:Stopwatch = get_tree().get_first_node_in_group('stopwatch')
@onready var label_stopwatch = %Label_stopwatch
@onready var game_over_gui = $GUI_layer/GUI/GameOver
@onready var blackOverlay = %bg

signal weapon_upgrade()

func _ready():
	connect('died', Callable(self, 'die'))
	label_hp.text = str('Health:', hp, ' / ', max_hp)
	set_hp_bar(hp, max_hp)
	set_xp_bar(xp, calculate_xp_cap())
	knockbackArea.call_deferred('set', 'disabled', true)
	choose_starting_weapon()
	check_stats()

func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	
	if mov.x > 0:
		sprite.flip_h = true
	elif mov.x < 0:
		sprite.flip_h = false
	
	if mov != Vector2.ZERO:
		if walkTimer.is_stopped():
			sprite.frame = (sprite.frame+1) % sprite.hframes
			walkTimer.start()
	velocity = mov.normalized() * movement_speed

	move_and_slide()

func heal(amount:int):
	hp += amount + bonus_heal
	if hp > max_hp:
		hp = max_hp
	set_hp_bar(hp, max_hp)
	label_hp.text = str('Health: ', hp, ' / ', max_hp)

func _physics_process(_delta):
	#var enemies_in_range = enemyDetectionArea.get_overlapping_bodies()
	update_stopwatch()
	
	if is_dead != true:
		movement()
		if Input.is_action_just_pressed('pause'):
			pause()


func update_stopwatch():
	label_stopwatch.text = stopwatch.time_to_string()

func _on_hurtbox_hurt(attacker_type, damage, _angle, _knockback_amount):
	if attacker_type != 'friendly':
		var final_damage = damage - armor
		if final_damage < 0:
			final_damage = 0
		hp -= final_damage
		label_hp.text = str('Health: ', hp, ' / ', max_hp)
		set_hp_bar(hp, max_hp)
		if hp <= 0:
			emit_signal("died")
			if died.is_connected(Callable(self, 'die')):
				disconnect('died', Callable(self, 'die'))
			return
		knockbackArea.call_deferred('set', 'disabled', false)
		await get_tree().physics_frame
		knockbackArea.call_deferred('set', 'disabled', true)


func choose_starting_weapon():
	label_lvlup.text = 'Choose a weapon!'
	levelup_select.visible = true
	
	var starting_weapons = [$Weapons/Thorn, $Weapons/Weapon_Whip, $Weapons/Weapon_Staff]
	for i in range(3):
		var new_item_option = item_option.instantiate()
		new_item_option.position.y += i*60
		new_item_option.item = starting_weapons[i]
		levelup_choices.add_child(new_item_option)
	GlobalVar.clear_upgrades()
	get_tree().paused = true
	await get_tree().create_timer(0.1).timeout
	levelup_select.scale = Vector2.ZERO
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(levelup_select, 'position:y', 60, 0.1)
	tween.set_parallel()
	tween.tween_property(levelup_select, 'scale', Vector2(1, 1), 0.1)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.play()
	await tween.finished
	tween.kill()

func level_up():
	#print('lvel up')
	%sfx_lvl_up.play()
	get_tree().paused = true
	label_lvlup.text = 'Level up!'
	xp = 0
	xp_level += 1
	levelup_select.visible = true
	
	
	if xp_level == 10 and $Weapons/Chestplate.level < $Weapons/Chestplate.max_level and $Weapons/Chestplate.is_in_group('weapon') != true and len(item_list) < item_limit:
		$Weapons/Chestplate.add_to_group('weapon')
		print('Added chestplate to loot pool')
	elif xp_level == 15 and $Weapons/Duplicator.level < $Weapons/Duplicator.max_level:
		$Weapons/Duplicator.add_to_group('weapon')
		print('Added duplicator to loot pool')
	
	
	
	# limit
	for i in weapons.get_children():
		if i is Weapon and len(weapon_list) >= item_limit and i.level == 0:
			i.remove_from_group('weapon')
		elif i is Upgrade and len(item_list) >= item_limit and i.level == 0:
			i.remove_from_group('weapon')
	
	
	
	# synergies:
	if $Weapons/Curseor.level == 3 and $Weapons/Weapon_Sword.level == 3 and $Weapons/CurseSword.is_in_group('weapon') != true and len(weapon_list) < item_limit:
		$Weapons/CurseSword.add_to_group('weapon')
	
	for i in range(3):
		var new_item_option = item_option.instantiate()
		new_item_option.position.y += i*60
		#new_item_option.set_item_random()
		levelup_choices.add_child(new_item_option)
	
	
	await get_tree().create_timer(0.1).timeout
	levelup_select.scale = Vector2.ZERO
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(levelup_select, 'position:y', 60, 0.1)
	tween.set_parallel()
	tween.tween_property(levelup_select, 'scale', Vector2(1, 1), 0.1)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.play()
	await tween.finished
	tween.kill()
	
	regenTimer.wait_time = regen_cooldown
	regenTimer.start()

func upgrade_character(upgrade):
	if upgrade is Weapon or upgrade is Upgrade:
		connect("weapon_upgrade", Callable(upgrade, 'check_level'))
		
		upgrade.level += 1
		emit_signal("weapon_upgrade")
		
		check_stats()
		if upgrade is Weapon and upgrade.level == 1:
			current_wep += 1
			
			weapon_list.append(upgrade)
		elif upgrade is Upgrade and upgrade.level == 1:
			current_item += 1
			item_list.append(upgrade)
	#print('weapons: ', len(weapon_list), 'items: ', len(item_list))
	levelup_select.position.y += 400
	disconnect("weapon_upgrade", Callable(upgrade, 'check_level'))
	
	var format = str('%s: %s / %s')
	%Label_weapons.text = format % ['Weapons', current_wep, item_limit]
	%Lable_powerups.text = format % ['Upgrades', current_item, item_limit]
	
	for i in weapons.get_children():
		if i is Weapon:
			i.check_passives()
	
	get_tree().paused = false
	levelup_select.visible = false
	for i in levelup_choices.get_children():
		i.queue_free()
		
	label_hp.text = str('Health: ', hp, ' / ', max_hp)
	set_hp_bar(hp, max_hp)
	
	calculate_xp(0)
	

func calculate_xp_cap():
	var xp_cap:int
	if xp_level < 3:
		xp_cap = xp_level + 5
	elif xp_level <= 5:
		xp_cap = (xp_level * 6)
		if xp_level > 3:
			xp_cap += 5
	elif xp_level < 25:
		xp_cap = (xp_level * 15)
	elif xp_level < 50:
		xp_cap = (xp_level * 25) + (50 * (xp_level / 25)) 
	else:
		xp_cap = (xp_level * 65)
	return xp_cap

func calculate_xp(item_xp):
	#print('calculte xp: ', item_xp)
	var xp_required = calculate_xp_cap()
	xp_collected += item_xp
	if xp + xp_collected >= xp_required: #level up
		#connect('levelup', Callable(self, 'level_up'))
		xp_collected -= (xp_required - xp)
		xp_required = calculate_xp_cap()
		#print('xp collected:  ', xp_collected)
		get_tree().paused = true
		level_up()
		
		
		#emit_signal('levelup')
		#disconnect('levelup', Callable(self, 'level_up'))
	else:
		xp += item_xp
		xp_collected = 0
	
	set_xp_bar(xp, xp_required)
	label_level.set_text(str('Level: ', xp_level))

func _on_magnet_area_area_entered(area):
	if area.is_in_group('loot'):
		area.target = self

func _on_collect_area_area_entered(area):
	if area is Xp:
		%CollectCollision.call_deferred('set', 'disabled', true)
		#print('xp pickup')
		var item_xp = area.collect()
		#area.queue_free()
		calculate_xp(item_xp)
		
		await get_tree().physics_frame
		%CollectCollision.call_deferred('set', 'disabled', false)
	elif area.is_in_group('loot'):
		area.collect()

func set_hp_bar(set_value = 1, set_max_value = 100):
	hpBar.value = set_value
	hpBar.max_value = set_max_value

func set_xp_bar(set_value = 1, set_max_value = 100):
	xpBar.value = set_value
	xpBar.max_value = set_max_value

func check_stats():
	#player stats
	max_hp = base_max_hp + bonus_max_hp
	movement_speed = base_movement_speed + bonus_move_speed
	armor = base_armor + bonus_armor
	magnetRange.scale = Vector2(1 + bonus_magnet, 1 + bonus_magnet)
	regen_cooldown = base_regen_cooldown - bonus_cooldown

func _on_try_again_button_pressed():
	get_tree().change_scene_to_file("res://World/world.tscn")

func _on_main_menu_button_pressed():
	print('menu button pressed')
	get_tree().change_scene_to_file("res://Utility/main_menu.tscn")

func die():
	is_dead = true
	var tween1 = get_tree().create_tween()
	tween1.tween_property(self, 'modulate:a', 0, 1)
	await tween1.finished
	tween1.kill()
	
	print('dead')
	%TryAgainButton.position.y += 300
	%MainMenuButton.position.y += 300
	%Label_game_over.scale *= 0
	%TryAgainButton.scale *= 0
	%MainMenuButton.scale *= 0
	game_over_gui.position.y = 0
	get_tree().paused = true
	
	var button_duration = 0.58
	
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(blackOverlay, 'modulate:a', 0.5, 2.7).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel(true)
	tween.tween_property(%Label_game_over, 'scale', Vector2(1, 1), 1).set_delay(0.5)
	tween.tween_property(%Label_game_over, 'modulate:a', 1 , 1.1).set_delay(0.4)
	tween.tween_property(%TryAgainButton, 'position:y', 160, button_duration).set_delay(1.4)
	tween.tween_property(%TryAgainButton, 'scale', Vector2(1, 1), button_duration).set_delay(1.4)
	tween.tween_property(%MainMenuButton, 'position:y', 215, button_duration).set_delay(1.55)
	tween.tween_property(%MainMenuButton, 'scale', Vector2(1, 1), button_duration).set_delay(1.55)
	await tween.finished
	
	tween.kill()

func pause():
	#print('paused')
	get_tree().paused = true
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(blackOverlay, 'modulate:a', 0.3, 0.3)
	tween.tween_property(%PauseMenu, 'position:x', 470, 0.4).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	tween.kill()

func unpause():
	process_mode = Node.PROCESS_MODE_INHERIT
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_parallel()
	tween.tween_property(blackOverlay, 'modulate:a', 0, 0.3)
	tween.tween_property(%PauseMenu, 'position:x', 670, 0.4).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	tween.kill()

func _on_resume_button_pressed():
	unpause()


func _on_regen_timer_timeout():
	heal(1)
