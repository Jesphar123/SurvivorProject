extends CharacterBody2D

var movement_speed = 100.0

#Used for Smooth Movement
#var max_movement_speed = 100.0
#var acceleration = 3.0
#var friction = 7.0

var hp = 20
var max_hp = 20
var last_movement = Vector2.UP
var time = 0

var experience = 0
var experience_level = 1
var collected_experience = 0

#Hitstop
var playerHitstop = 0.3
var timeFreeze = 0.07

@onready var sprite = $CharacterSprite
@onready var walkTimer = get_node("walkTimer")

#GUI
@onready var expBar = get_node("%ExperienceBar")
@onready var lblLevel = get_node("%lbl_level")
@onready var levelPanel = get_node("%LevelUp")
@onready var upgradeOptions = get_node("%UpgradeOptions")
@onready var itemOptions = preload("res://Utility/item_option.tscn")
@onready var sndLevelUp = get_node("%snd_level_up")
@onready var healthBar = get_node("%HealthBar")
@onready var healthBarText = get_node("%HealthBarText")
@onready var lblTimer = get_node("%lbl_timer")
@onready var collectedWeapons = get_node("%CollectedWeapons")
@onready var collectedUpgrades = get_node("%CollectedUpgrades")
@onready var itemContainer = preload("res://Player/GUI/item_container.tscn")

@onready var deathPanel = get_node("%DeathPanel")
@onready var lblResult = get_node("%lbl_Result")
@onready var sndVictory = get_node("%snd_victory")
@onready var sndLose = get_node("%snd_lose")

#Audio
@onready var playerHit = get_node("%PlayerHit")

#Attacks
var iceSpear  = preload("res://Player/Attack/ice_spear.tscn")
var tornado = preload("res://Player/Attack/tornado.tscn")
var javelin = preload("res://Player/Attack/javelin.tscn")
var sword = preload("res://Player/Attack/sword.tscn")
var flail = preload("res://Player/Attack/flail.tscn")
var grenade = preload("res://Player/Attack/grenade.tscn")

#AttackNodes
@onready var iceSpearTimer = get_node("%IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("%IceSpearAttackTimer")
@onready var tornadoTimer = get_node("%TornadoTimer")
@onready var tornadoAttackTimer = get_node("%TornadoAttackTimer")
@onready var javelinBase = get_node("%JavelinBase")
@onready var swordTimer = get_node("%SwordTimer")
@onready var swordAttackTimer = get_node("%SwordAttackTimer")
@onready var flailBase = get_node("%FlailBase")
@onready var grenadeTimer = get_node("%GrenadeTimer")
@onready var grenadeAttackTimer = get_node("%GrenadeAttackTimer")

#Signal
signal playerdeath
signal current_position

#Upgrades
var collected_upgrades = []
var upgrade_options = []
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0

#IceSpear
var ice_spear_ammo = 0
var ice_spear_base_ammo = 0
var ice_spear_attackspeed = 1
var ice_spear_level = 0

#Tornado
var tornado_ammo = 0
var tornado_base_ammo = 0
var tornado_attackspeed = 3
var tornado_level = 0

#Javelin
var javelin_ammo = 0
var javelin_level = 0

#Sword
var sword_ammo = 0
var sword_base_ammo = 0
var sword_attackspeed = 1
var sword_level = 0

#Flail
var flail_ammo = 0
var flail_base_ammo = 0
var flail_attackspeed = 1
var flail_level = 0

#Grenade
var grenade_ammo = 0
var grenade_base_ammo = 0
var grenade_attackspeed = 4
var grenade_level = 0

#Enemy Related
var random_enemy_target = []

#Sword Positioning
#var sword_position = Vector2.ZERO
@onready var last_direction: int = 0

#Mouse Position
var mouse_target = Vector2.ZERO

func _physics_process(_delta):
	movement()
	emit_signal("current_position", self.global_position)
	#get_sword_position()
	
#func get_sword_position():
#	sword_position = $CharacterSprite/SwordAttach.global_position
#	return sword_position
	
func movement():
	mouse_target = get_global_mouse_position()
	
	var x_mov = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_mov = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var mov = Vector2(x_mov,y_mov)
	if mov.x > 0:
		sprite.scale.x = 1
		last_direction = 0
	elif mov.x < 0:
		sprite.scale.x = -1
		last_direction = 180

	if mov != Vector2.ZERO:
		last_movement = mov
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
	else:
		sprite.frame = 1
	
	# Smooth Movement still sucks
	#if mov == Vector2.ZERO:
	#	if velocity.length() > (friction):
	#		velocity -= velocity.normalized() * (friction)
	#	else:
	#		velocity = Vector2.ZERO
	#else:
	#	velocity += (mov * acceleration)
	#	velocity = velocity.limit_length(max_movement_speed)
	
	#Linear Movement
	velocity = mov.normalized() * movement_speed
	move_and_slide()

func _on_hurt_box_hurt(damage, _angle, _knockback):
	#HP UI
	healthBar.max_value = max_hp
	healthBar.value = hp
	healthBarText.text = str(hp)
	hp -= clamp(damage - armor, 1.0, 999.0)
	
	if damage > 0:
			#Audio
			playerHit.play()
			
			#Hitflash
			sprite.modulate = Color(10,10,10)
			await get_tree().create_timer(0.10).timeout
			sprite.modulate = Color.WHITE
			
			#Hitstop
			Engine.time_scale = playerHitstop
			await get_tree().create_timer(playerHitstop * timeFreeze).timeout
			Engine.time_scale = 1
			
			#Screen Shake signal
			GlobalSignals.playerHit.emit()
	
	#Death
	if hp <= 0:
		death()
	
func _ready():
	attack()
	set_exp_bar(experience, calculate_experience_cap())
	_on_hurt_box_hurt(0,0,0)
	GlobalSignals.change_character.connect(change_character)
	
func change_character(character):
	if character == "maeve":
		$CharacterSprite.texture = load("res://Textures/Player/player_test_anim_2.png")
		upgrade_character("sword1")
	if character == "princess":
		$CharacterSprite.texture = load("res://Textures/Player/princess_anim.png")
		upgrade_character("icespear1")
	if character == "avery":
		$CharacterSprite.texture = load("res://Textures/Player/avery_anim.png")
		upgrade_character("grenade1")
	if character == "augbert":
		upgrade_character("flail1")
		$CharacterSprite.texture = load("res://Textures/Player/augbert_anim.png")

func attack():
	if ice_spear_level > 0:
		iceSpearTimer.wait_time = ice_spear_attackspeed * (1 - spell_cooldown)
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()
			
	if tornado_level > 0:
		tornadoTimer.wait_time = tornado_attackspeed * (1 - spell_cooldown)
		if tornadoTimer.is_stopped():
			tornadoTimer.start()
			
	if javelin_level > 0:
		spawn_javelin()
		
	if sword_level > 0:
		swordTimer.wait_time = sword_attackspeed * (1 - spell_cooldown)
		if swordTimer.is_stopped():
			swordTimer.start()
	
	if flail_level > 0:
		spawn_flail()
	
	if grenade_level > 0:
		grenadeTimer.wait_time = grenade_attackspeed * (1 - spell_cooldown)
		if grenadeTimer.is_stopped():
			grenadeTimer.start()
			
		
func _on_grenade_timer_timeout() -> void:
	grenade_ammo += grenade_base_ammo + additional_attacks
	grenadeAttackTimer.start()


func _on_grenade_attack_timer_timeout() -> void:
	if grenade_ammo > 0:
		var grenade_attack = grenade.instantiate()
		grenade_attack.position = position
		grenade_attack.target = get_random_target()
		grenade_attack.level = grenade_level
		add_child(grenade_attack)
		grenade_ammo -= 1
		if grenade_ammo > 0:
			grenadeAttackTimer.start()
		else:
			grenadeAttackTimer.stop()





func _on_sword_timer_timeout() -> void:
	sword_ammo += sword_base_ammo + additional_attacks
	swordAttackTimer.start()

func _on_sword_attack_timer_timeout() -> void:
	if sword_ammo > 0:
		var sword_attack = sword.instantiate()
		sword_attack.set_rotation_degrees(last_direction)
		sword_attack.position = $CharacterSprite/SwordAttach.position
		sword_attack.level = sword_level
		$CharacterSprite/SwordAttach.add_child(sword_attack)
		sword_ammo -= 1
		if sword_ammo > 0:
			swordAttackTimer.start()
		else:
			swordAttackTimer.stop()
	
func _on_ice_spear_timer_timeout() -> void:
	ice_spear_ammo += ice_spear_base_ammo + additional_attacks
	iceSpearAttackTimer.start()
	
func _on_ice_spear_attack_timer_timeout() -> void:
	if ice_spear_ammo > 0:
		var ice_spear_attack = iceSpear.instantiate()
		ice_spear_attack.position = position
		ice_spear_attack.target = mouse_target
		ice_spear_attack.level = ice_spear_level
		add_child(ice_spear_attack)
		ice_spear_ammo -= 1
		if ice_spear_ammo > 0:
			iceSpearAttackTimer.start()
		else:
			iceSpearAttackTimer.stop()
			
			
			
func _on_tornado_timer_timeout() -> void:
	tornado_ammo += tornado_base_ammo + additional_attacks
	tornadoAttackTimer.start()
	
func _on_tornado_attack_timer_timeout() -> void:
	if tornado_ammo > 0:
		var tornado_attack = tornado.instantiate()
		tornado_attack.position = position
		tornado_attack.last_movement = last_movement
		tornado_attack.level = tornado_level
		add_child(tornado_attack)
		tornado_ammo -= 1
		if tornado_ammo > 0:
			tornadoAttackTimer.start()
		else:
			tornadoAttackTimer.stop()

func spawn_javelin():
	var get_javelin_total = javelinBase.get_child_count()
	var calc_spawns = (javelin_ammo + additional_attacks) - get_javelin_total
	while calc_spawns > 0:
		var javelin_spawn = javelin.instantiate()
		javelin_spawn.global_position = global_position
		javelinBase.add_child(javelin_spawn)
		calc_spawns -= 1
	#Update Javelin
	var get_javelins = javelinBase.get_children()
	for i in get_javelins:
		if i.has_method("update_javelin"):
			i.update_javelin()
			
			

func spawn_flail():
	var get_flail_total = flailBase.get_child_count()
	var calc_spawns = (flail_ammo + additional_attacks) - get_flail_total
	while calc_spawns > 0:
		var flail_spawn = flail.instantiate()
		flail_spawn.position = position
		flailBase.add_child(flail_spawn)
		calc_spawns -= 1
	var get_flails = flailBase.get_children()
	for i in get_flails:
		if i.has_method("update_flail"):
			i.update_flail()
			
			
func get_closest_target():
	var enemy_closest = %EnemyDetectionArea.get_overlapping_bodies()
	if enemy_closest.size() > 0:
		var target_enemy =  enemy_closest.front()
		return target_enemy.global_position
	else:
		return Vector2.UP
		
func get_random_target():
	if random_enemy_target.size() > 0:
		return random_enemy_target.pick_random().global_position
	else:
		return Vector2.UP

func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not random_enemy_target.has(body):
		random_enemy_target.append(body)


func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if random_enemy_target.has(body):
		random_enemy_target.erase(body)


func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calculate_experience(gem_exp)
		

func calculate_experience(gem_exp):
	var exp_required = calculate_experience_cap()
	collected_experience +=  gem_exp
	if experience + collected_experience >= exp_required: #Level Up
		collected_experience -= exp_required - experience
		experience_level += 1
		experience = 0
		exp_required = calculate_experience_cap()
		levelup()
	else:
		experience += collected_experience
		collected_experience = 0
		
	set_exp_bar(experience, exp_required)
	
func calculate_experience_cap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level * 5
	elif experience_level < 40:
		exp_cap = 95 + experience_level * (experience_level - 19) * 8
	else:
		exp_cap = 255 + (experience_level - 39) * 12
	return exp_cap

func set_exp_bar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value
	
func levelup():
	#Add HP
	hp += 5
	max_hp += 5
	hp = clamp(hp,0,max_hp)
	_on_hurt_box_hurt(0,0,0)
	
	sndLevelUp.play()
	lblLevel.text = str("Level: ",experience_level)
	var tween = levelPanel.create_tween()
	tween.tween_property(levelPanel,"position",Vector2(220,50),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	levelPanel.visible = true
	var options = 0
	var optionsmax = 3
	while options < optionsmax:
		var option_choice = itemOptions.instantiate()
		option_choice.item = get_random_item()
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused = true

func upgrade_character(upgrade):
	match upgrade:
		"icespear1":
			ice_spear_level = 1
			ice_spear_base_ammo += 1
		"icespear2":
			ice_spear_level = 2
			ice_spear_base_ammo += 1
		"icespear3":
			ice_spear_level = 3
		"icespear4":
			ice_spear_level = 4
			ice_spear_base_ammo += 2
		"tornado1":
			tornado_level = 1
			tornado_base_ammo += 1
		"tornado2":
			tornado_level = 2
			tornado_base_ammo += 1
		"tornado3":
			tornado_level = 3
			tornado_attackspeed -= 0.5
		"tornado4":
			tornado_level = 4
			tornado_base_ammo += 1
		"javelin1":
			javelin_level = 1
			javelin_ammo = 1
		"javelin2":
			javelin_level = 2
		"javelin3":
			javelin_level = 3
		"javelin4":
			javelin_level = 4
		"armor1","armor2","armor3","armor4":
			armor += 1
		"speed1","speed2","speed3","speed4":
			movement_speed += 20.0
		"tome1","tome2","tome3","tome4":
			spell_size += 0.10
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.05
		"ring1","ring2":
			additional_attacks += 1
		"food":
			hp += 20
			hp = clamp(hp,0,max_hp)
			_on_hurt_box_hurt(0,0,0)
		"orb1":
			$GrabArea/CollisionShape2D.shape.radius = 32
		"orb2":
			$GrabArea/CollisionShape2D.shape.radius = 48
		"orb3":
			$GrabArea/CollisionShape2D.shape.radius = 64
		"orb4":
			$GrabArea/CollisionShape2D.shape.radius = 80
		"sword1":
			sword_level = 1
			sword_base_ammo += 1
		"sword2":
			sword_level = 2
		"sword3":
			sword_level = 3
		"sword4":
			sword_level = 4
		"flail1":
			flail_level = 1
			flail_ammo += 1
		"flail2":
			flail_level = 2
		"flail3":
			flail_level = 3
		"flail4":
			flail_level = 4
		"grenade1":
			grenade_level = 1
			grenade_base_ammo += 1
		"grenade2":
			grenade_level = 2
		"grenade3":
			grenade_level = 3
		"grenade4":
			grenade_level = 4
			
	adjust_gui_collection(upgrade)
	attack()
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	levelPanel.visible = false
	levelPanel.position = Vector2(800,50)
	get_tree().paused = false
	calculate_experience(0)
	
func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: #Find already collected upgrades
			pass
		elif i in upgrade_options: #If the upgrade is already an option
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item": #Don't pick food
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0: #Check for PreRequisites
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					to_add = false
			if to_add:
				dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrade_options.append(randomitem)
		return randomitem
	else:
		return null
		
func change_time(argtime = 0):
	time = argtime
	var get_m = int(time / 60)
	var get_s = time % 60
	if get_m < 10:
		get_m = str(0, get_m)
	if get_s < 10:
		get_s = str(0, get_s)
	lblTimer.text = str(get_m, ":", get_s)
	
func adjust_gui_collection(upgrade):
	var get_upgraded_displayname= UpgradeDb.UPGRADES[upgrade]["displayname"]
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"]
	if get_type != "item":
		var get_collected_displaynames = []
		for i in collected_upgrades:
			get_collected_displaynames.append(UpgradeDb.UPGRADES[i]["displayname"])
		if not get_upgraded_displayname in get_collected_displaynames:
			var new_item = itemContainer.instantiate()
			new_item.upgrade = upgrade
			match get_type:
				"weapon":
					collectedWeapons.add_child(new_item)
				"upgrade":
					collectedUpgrades.add_child(new_item)


func death():
	deathPanel.visible = true
	emit_signal("playerdeath")
	get_tree().paused = true
	var tween = deathPanel.create_tween()
	tween.tween_property(deathPanel,"position",Vector2(220,50),3.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	if time >= 300:
		lblResult.text = "You Win"
		sndVictory.play()
	else: 
		lblResult.text = "You Lose"
		sndLose.play()


func _on_btn_menu_click_end() -> void:
	get_tree().paused = false
	var _level = get_tree().change_scene_to_file("res://TitleScreen/menu.tscn")