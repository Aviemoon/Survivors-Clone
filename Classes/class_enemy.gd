extends CharacterBody2D
class_name Enemy

signal enemy_die()
signal remove_from_array(object)

@export var movement_speed:float = 25.0
@export var hp:int = 10
@export var elite:bool
@export var knockback_recovery:float = 3.5
@export var armor:int = 0
@export var damage:int = 2
@export var xp_amount:int = 1
@export var drops:Array[Resource] = []
var direction:Vector2

var can_dmgnum:bool = true

@onready var player = get_tree().get_first_node_in_group("player")
@export var sprite:AnimatedSprite2D
@export var sfx_hit:AudioStreamPlayer2D = null
@export var death_anim:Resource = preload('res://Utility/explosion.tscn')
var xp = preload("res://Objects/xp.tscn")
var knockback:Vector2 = Vector2.ZERO

var dmg_totes = 0

#func _init():
	#hp = max_hp

func movement() -> void:
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	velocity += knockback
	
	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false

func decelerate(duration:float) -> bool:
	var tween = get_tree().create_tween()
	tween.tween_property(self, 'velocity', Vector2.ZERO, duration)
	await tween.finished
	tween.kill()
	return true


func die():
	await get_tree().physics_frame
	emit_signal("enemy_die")
	var sfx_die = death_anim.instantiate()
	sfx_die.scale = sprite.scale
	sfx_die.global_position = global_position
	
	if len(drops) > 0:
		var new_drop = drops.pick_random().instantiate()
		new_drop.global_position = global_position
		get_parent().call_deferred('add_child', new_drop)
	
	
	drop_xp()
	get_parent().call_deferred("add_child", sfx_die)
	queue_free()

func drop_xp() -> void:
	var dropped_xp = xp.instantiate()
	dropped_xp.global_position = global_position
	dropped_xp.xp = xp_amount
	get_parent().call_deferred("add_child", dropped_xp)

func hurt(p_attacker_type, p_damage, p_angle, p_knockback_amount):
	if p_attacker_type == 'friendly':
		
		emit_signal("remove_from_array", self)
		modulate += Color('white')
		var total_dmg = p_damage - armor
		if total_dmg < 0:
			total_dmg = 0
		hp -= total_dmg
		dmg_totes += total_dmg
		knockback = p_angle * p_knockback_amount
		if hp <= 0:
			die()
		else:
			if sfx_hit:
				var rand_pitch = randf_range(0.01, 0.1)
				sfx_hit.pitch_scale += rand_pitch
				sfx_hit.play()
				sfx_hit.pitch_scale -= rand_pitch
			await get_tree().create_timer(0.1).timeout
			modulate -= Color('white')
		#print(GlobalVar.current_labels, GlobalVar.lbl_limit)
		if total_dmg > 0 and can_dmgnum and GlobalVar.can_dmg_num:
			can_dmgnum = false
			var lbl = Label.new()
			lbl.add_theme_font_override('font', preload("res://Font/Platinum Sign Over.ttf"))
			lbl.add_theme_color_override('font_shadow_color', Color.BLACK)
			lbl.add_theme_constant_override('shadow_offset_x', 2)
			lbl.add_theme_constant_override('shadow_offset_y', 2)
			lbl.add_theme_font_size_override('font_size', 8)
			lbl.text = str(dmg_totes)
			lbl.global_position = global_position
			lbl.scale = scale 
			
			get_parent().add_child(lbl)
			dmg_totes = 0
			#GlobalVar.current_labels += 1
			var tween = get_tree().create_tween()
			tween.tween_property(lbl, 'global_position:y',  lbl.global_position.y - 25, 0.1)
			tween.set_parallel()
			if direction.x > 0.1:
				tween.tween_property(lbl, 'global_position:x',  lbl.global_position.x - 18, 0.1)
			else:
				tween.tween_property(lbl, 'global_position:x',  lbl.global_position.x + 18, 0.1)
			
			tween.set_parallel(false)
			tween.tween_property(lbl, 'modulate:a', 0, 0.30).set_delay(0.25)
			
			await tween.finished
			tween.kill()
			#GlobalVar.current_labels -= 1
			lbl.call_deferred('queue_free')
			await get_tree().create_timer(0.13).timeout
			can_dmgnum = true
			
	
