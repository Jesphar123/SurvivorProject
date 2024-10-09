extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 10
var knockback_amount = 100
var attack_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var snd_explosion = get_node("snd_explosion")
#var spr_explosion = preload("res://Enemies/death_explosion.tscn")
@onready var spr_explosion = get_node("spr_explosion")
@onready var anim_explosion = get_node("spr_explosion/AnimationPlayer")
@onready var grenade = get_node("CollisionShape2D")
@onready var grenade_particles = get_node("ExplosionParticles")

signal remove_from_array(object)

var snd_may_play = true
var anim_may_play = true

func _ready() -> void:
	spr_explosion.visible = false
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135)
	match level:
		1:
			hp = 9999
			speed = 200
			damage = 5
			knockback_amount = 50
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 9999
			speed = 200
			damage = 5
			knockback_amount = 75
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 9999
			speed = 200
			damage = 10
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			hp = 9999
			speed = 200
			damage = 20
			knockback_amount = 150
			attack_size = 1.0 * (1 + player.spell_size)
			
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1) * attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func _physics_process(delta: float) -> void:
	position =  global_position.move_toward(target, speed * delta)
	if position == target:
		grenade.set_deferred("disabled", false)
		await get_tree().create_timer(0.1).timeout
		sprite.visible = false
		grenade.set_deferred("disabled", true)
		if !snd_explosion.is_playing() and snd_may_play:
			snd_explosion.play()
			grenade_particles.emitting = true
			snd_may_play = false
			
			#Screenshake signal
			GlobalSignals.grenade_explosion.emit()
			
		#if !anim_explosion.is_playing() and anim_may_play:
		#	spr_explosion.visible = true
		#	anim_explosion.play("anim_explosion")
		#	anim_may_play = false
			
	#var enemy_death = death_anim.instantiate()
	#enemy_death.scale = sprite.scale
	#enemy_death.global_position = global_position
	#get_parent().call_deferred("add_child",enemy_death)
	
func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)

#func _on_timer_timeout() -> void:
#	emit_signal("remove_from_array", self)
#	queue_free()


func _on_snd_explosion_finished() -> void:
	queue_free()
