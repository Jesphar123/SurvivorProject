extends Area2D

class_name NewEnemyArea

@export var movement_speed: float = 20.0
@export var hp: int = 10
@export var knockback_recovery: float = 1
@export var experience: int = 1
@export var enemy_damage: int = 1
@export var knockback: Vector2 = Vector2.ZERO

var enemyHitstop: float = 0.3
var timeFreeze: float = 0.07

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var snd_enemy_hit: AudioStreamPlayer2D = $snd_enemy_hit
@onready var hitBox: Area2D = $HitBox
@onready var hurtBox: Area2D = $HurtBox
#@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var hideTimer: Timer = $HideTimer

@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")

var death_anim = preload("res://Enemies/death_explosion.tscn")
var exp_gem = preload("res://Objects/experience_gem.tscn")
var exp_magnet = preload("res://Objects/experience_magnet.tscn")

@onready var softCollision: Area2D = $SoftCollision

signal remove_from_array(object)

#Performance
var screen_size

func _ready():
	#Using this?
	add_to_group("enemy")
	
	anim.play("walk")
	hitBox.damage = enemy_damage
	screen_size = get_viewport_rect().size
	hurtBox.connect("hurt", Callable(self, "_on_hurt_box_hurt"))
	hideTimer.connect("timeout", Callable(self, "_on_hide_timer_timeout"))
	
	GlobalSignals.enemy_softcap.connect(disable_collisions)
	
	movement_speed = randf_range(movement_speed - 5.0, movement_speed + 5.0)

#gets triggered when EnemySpawner Node reaches enemy softcap (currently 600)
func disable_collisions():
	softCollision.process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	
	#Soft Collision
	if softCollision.is_colliding():
		position += softCollision.get_push_vector() * get_physics_process_delta_time() * 50
	
	position += direction * movement_speed * 0.05
	position += knockback
	
#	var collider = move_and_collide(velocity * delta)
#	if collider:
#		if collider.get_collider() is TileMapLayer:
#			return
#		else:
#			collider.get_collider().knockback = (collider.get_collider().global_position - global_position).normalized() * 25
	
	if direction.x > 0.1:
		sprite.flip_h = false
	elif direction.x < -0.1:
		sprite.flip_h = true
		
	#Optimization
	var separation = (player.position - position).length()
	if separation >= 500:
		queue_free()

func death():
	emit_signal("remove_from_array",self)
	#var enemy_death = death_anim.instantiate()
	#enemy_death.scale = sprite.scale
	#enemy_death.global_position = global_position
	#get_parent().call_deferred("add_child",enemy_death)
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
	queue_free()

	
func _on_hurt_box_hurt(damage, angle, knockback_amount):
	print("HP: ", hp, " Damage: ", damage)
	hp -= damage
	knockback = angle * knockback_amount
	
	if hp <= 0:
		death()
	else:
		snd_enemy_hit.play()
		
	#Hit Flash
	sprite.modulate = Color(10,10,10)
	await get_tree().create_timer(0.10).timeout
	sprite.modulate = Color.WHITE
	
	#Hitstop
	#Engine.time_scale = enemyHitstop
	#await get_tree().create_timer(enemyHitstop * timeFreeze).timeout
	#Engine.time_scale = 1
