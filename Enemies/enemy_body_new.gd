# Enemy.gd
extends Area2D

@export var speed: float = 40.0
@export var min_separation_distance: float = 64.0  # Minimum distance to maintain from other enemies
@export var separation_strength: float = 100.0 # Strength of the separation force
@export var damping_factor: float = 0.9 # Factor to reduce sudden velocity changes

@export var hp: int = 10
@export var knockback_recovery: float = 35.5
@export var experience: int = 1
@export var enemy_damage: int = 1
var knockback: Vector2 = Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite2D
@onready var shadow_sprite: Sprite2D = $Sprite2D/Shadow
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var snd_enemy_hit: AudioStreamPlayer2D = $snd_enemy_hit
@onready var snd_enemy_death = $snd_enemy_death
@onready var hitBox: Area2D = $HitBox
@onready var hurtBox: Area2D = $HurtBox
@onready var hurtBoxCollision: CollisionShape2D = $HurtBox/CollisionShape2D
@onready var hitBoxCollision: CollisionShape2D = $HitBox/CollisionShape2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var hideTimer: Timer = $HideTimer
@onready var bloodSplatter: CPUParticles2D = $BloodSplatter

@onready var dissolve = 1.0
@onready var dissolve_speed = 0.033

@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")

var exp_gem = preload("res://Objects/experience_gem.tscn")
var exp_magnet = preload("res://Objects/experience_magnet.tscn")

var nearby_enemies: Array = []
var current_velocity: Vector2 = Vector2.ZERO

#Signals
signal remove_from_array(object)

@onready var dying: bool = false
@onready var hit: bool = false

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		nearby_enemies.append(area)

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		nearby_enemies.erase(area)
		
func _ready() -> void:
	speed = randf_range(speed - 5.0, speed + 5.0)
	anim.play("walk")
	hitBox.damage = enemy_damage
	hurtBox.connect("hurt", Callable(self, "_on_hurt_box_hurt"))
	hideTimer.connect("timeout", Callable(self, "_on_hide_timer_timeout"))

func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var player_position = player.global_position

	# Calculate the direction towards the player
	var direction_to_player = (player_position - global_position).normalized()
	var target_velocity = direction_to_player * speed
	
	if direction_to_player.x > 0.1:
		sprite.flip_h = false
	elif direction_to_player.x < -0.1:
		sprite.flip_h = true

	# Handle separation behavior from nearby enemies
	var separation_vector = Vector2.ZERO
	for enemy in nearby_enemies:
		if enemy != self:  # Prevent checking against itself
			var distance_to_enemy = global_position.distance_to(enemy.global_position)
			if distance_to_enemy < min_separation_distance:  # Only apply separation if too close
				var away_direction = (global_position - enemy.global_position).normalized()
				# Apply a stronger separation force based on how close the enemies are
				separation_vector += away_direction * (min_separation_distance - distance_to_enemy) * separation_strength

	# Combine target velocity with separation vector
	target_velocity += separation_vector

	# Normalize the velocity to ensure consistent speed
	if target_velocity.length() > 0:
		#target_velocity += knockback
		target_velocity = target_velocity.normalized() * speed
		
	if knockback.length() > 0:
		global_position += knockback * delta
		knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery * delta * 10)
		
	current_velocity = current_velocity.lerp(target_velocity, 1.0 - damping_factor)

	if dying == false:
	# Move the enemy
		global_position += current_velocity * delta
		#global_position += knockback
	if dying == true:
		dissolve -= dissolve_speed
		sprite.material.set_shader_parameter("dying", true)
		sprite.material.set_shader_parameter("dissolve_speed", dissolve)
		shadow_sprite.material.set_shader_parameter("dying", true)
		shadow_sprite.material.set_shader_parameter("dissolve_speed", dissolve)
		
	if hit == true:
		sprite.material.set_shader_parameter("hit", true)
	if hit == false:
		sprite.material.set_shader_parameter("hit", false)

func death():
	#Play death sound if its not already playing
	if !snd_enemy_death.is_playing():
		snd_enemy_death.play()
		snd_enemy_death.set_pitch_scale(randf_range(0.9, 1.1))
		
	hurtBoxCollision.set_deferred("disabled", true)
	hitBoxCollision.set_deferred("disabled", true)
	emit_signal("remove_from_array",self)
	
	#Drop EXP gem
	var exp_drop_chance = randi() % 3
	if exp_drop_chance == 1:
		var new_gem = exp_gem.instantiate()
		new_gem.global_position = global_position
		new_gem.experience = experience
		loot_base.call_deferred("add_child",new_gem)
	
	#Drop Exp Magnet
	var rand_num = randi() % 10000
	if rand_num == 1:
		var new_magnet = exp_magnet.instantiate()
		new_magnet.global_position = global_position
		loot_base.call_deferred("add_child",new_magnet)
		
	#Set dying to true for dissolve shader, and wait before removing object
	dying = true
	await get_tree().create_timer(0.8).timeout
	queue_free()
	
func _on_hurt_box_hurt(damage, angle, knockback_amount):
	hp -= damage
	knockback = angle * knockback_amount
	if bloodSplatter != null:
		bloodSplatter.direction = (global_position - player.global_position).normalized()
		bloodSplatter.emitting = true
	
	if hp <= 0:
		death()
	else:
		#Play hit sound
		snd_enemy_hit.play()
		
		hit = true
		await get_tree().create_timer(0.1).timeout
		hit = false
		
	#Hitstop
	#Engine.time_scale = enemyHitstop
	#await get_tree().create_timer(enemyHitstop * timeFreeze).timeout
	#Engine.time_scale = 1
