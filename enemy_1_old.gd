extends CharacterBody2D

@export var movement_speed = 20.0
@export var hp = 10
@export var knockback_recovery = 3.5
@export var experience = 1
@export var enemy_damage = 1
var knockback = Vector2.ZERO


@onready var player = get_tree().get_first_node_in_group("player")

@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var snd_enemy_hit = $snd_enemy_hit
@onready var hitBox = $HitBox

signal remove_from_array(object)

var death_anim = preload("res://Enemies/death_explosion.tscn")
var exp_gem = preload("res://Objects/experience_gem.tscn")
var exp_magnet = preload("res://Objects/experience_magnet.tscn")

#Performance
var screen_size

func _ready():
	#anim.play("walk")
	hitBox.damage = enemy_damage
	screen_size = get_viewport_rect().size

func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	velocity += knockback
	move_and_slide()

func death():
	emit_signal("remove_from_array",self)
	var enemy_death = death_anim.instantiate()
	enemy_death.scale = sprite.scale
	enemy_death.global_position = global_position
	get_parent().call_deferred("add_child",enemy_death)
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.experience = experience
	loot_base.call_deferred("add_child",new_gem)
	
	#Drop Exp Magnet
	var rand_num = randi() % 100
	if rand_num == 1:
		var new_magnet = exp_magnet.instantiate()
		new_magnet.global_position = global_position
		loot_base.call_deferred("add_child",new_magnet)
	queue_free()

func _on_hurt_box_hurt(damage, angle, knockback_amount):
	hp -= damage
	knockback = angle * knockback_amount
	if hp <= 0:
		death()
	else:
		snd_enemy_hit.play()
		
#func frame_save(amount = 20):
#	var rand_disable = randi() % 100
#	if rand_disable < amount:
#		collision.call_deferred("set", "disable", true)
#		anim.stop()
		

func _on_hide_timer_timeout() -> void:
	var location_dif = global_position - player.global_position
	if abs(location_dif.x) > (screen_size.x / 2) * 1.4 || abs(location_dif.y) > (screen_size.y / 2) * 1.4:
		visible = false
	else:
		visible = true
