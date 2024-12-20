extends CharacterBody2D

class_name EnemyBody

@export var movement_speed: float = 20.0
@export var hp: int = 10
@export var knockback_recovery: float = 3.5
@export var experience: int = 1
@export var enemy_damage: int = 1
var knockback: Vector2 = Vector2.ZERO

var enemyHitstop: float = 0.3
var timeFreeze: float = 0.07

@onready var sprite: Sprite2D = $EnemyBase/Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var snd_enemy_hit: AudioStreamPlayer2D = $EnemyBase/snd_enemy_hit
@onready var snd_enemy_death = $EnemyBase/snd_enemy_death
@onready var hitBox: Area2D = $EnemyBase/HitBox
@onready var hurtBox: Area2D = $EnemyBase/HurtBox
@onready var hurtBoxCollision: CollisionShape2D = $EnemyBase/HurtBox/CollisionShape2D
@onready var hitBoxCollision: CollisionShape2D = $EnemyBase/HitBox/CollisionShape2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var hideTimer: Timer = $EnemyBase/HideTimer

@onready var dissolve = 1.0
@onready var dissolve_speed = 0.033


@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")

var death_anim = preload("res://Enemies/death_explosion.tscn")
var exp_gem = preload("res://Objects/experience_gem.tscn")
var exp_magnet = preload("res://Objects/experience_magnet.tscn")

signal remove_from_array(object)

@onready var dying: bool = false
@onready var hit: bool = false

#Performance
var screen_size

#Respawn
var respawn_enemy = []

func _ready():
	#Using this?
	add_to_group("enemy")
	
	anim.play("walk")
	hitBox.damage = enemy_damage
	screen_size = get_viewport_rect().size
	hurtBox.connect("hurt", Callable(self, "_on_hurt_box_hurt"))
	hideTimer.connect("timeout", Callable(self, "_on_hide_timer_timeout"))
	
	movement_speed = randf_range(movement_speed - 5.0, movement_speed + 5.0)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	if dying == false:
		velocity = direction * movement_speed
		velocity += knockback
		
		var collider = move_and_collide(velocity * delta)
		if collider:
			if collider.get_collider() is TileMapLayer:
				return
			else:
				collider.get_collider().knockback = (collider.get_collider().global_position - global_position).normalized() * 25
		
		if direction.x > 0.1:
			sprite.flip_h = false
		elif direction.x < -0.1:
			sprite.flip_h = true
		
	if dying == true:
		dissolve -= dissolve_speed
		sprite.material.set_shader_parameter("dying", true)
		sprite.material.set_shader_parameter("dissolve_speed", dissolve)
		
	if hit == true:
		sprite.material.set_shader_parameter("hit", true)
		#await get_tree().create_timer(0.1).timeout
		#sprite.material.set_shader_parameter("hit", false)
	if hit == false:
		sprite.material.set_shader_parameter("hit", false)
		
	#Optimization
	#var separation = (player.position - position).length()
	#if separation >= 500:
		#queue_free()
	#	respawn_enemy.append(Resource)
	#	print(respawn_enemy)

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
	
	if hp <= 0:
		death()
	else:		
		#Play hit sound
		snd_enemy_hit.play()
		
		hit = true
		await get_tree().create_timer(0.1).timeout
		hit = false
		
		#sprite.modulate = Color(10,10,10)
		#await get_tree().create_timer(0.1).timeout
		#sprite.modulate = Color.WHITE
		
	#Hit Flash

	
	#Hitstop
	#Engine.time_scale = enemyHitstop
	#await get_tree().create_timer(enemyHitstop * timeFreeze).timeout
	#Engine.time_scale = 1
