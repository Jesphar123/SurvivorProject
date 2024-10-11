extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 10
var knockback_amount = 100
var attack_size = 1.0
var radius = 32
var particle_scale = Vector2(1, 1)

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var snd_explosion = get_node("snd_explosion")
@onready var spr_explosion = get_node("spr_explosion")
@onready var anim_explosion = get_node("spr_explosion/AnimationPlayer")
@onready var grenade = get_node("CollisionShape2D")
@onready var grenade_particles = get_node("ExplosionParticles")
@onready var grenadeRadius = get_node("CollisionShape2D")

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
			radius = 32
			particle_scale = Vector2(1, 1)
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 9999
			speed = 200
			damage = 10
			knockback_amount = 75
			radius = 40
			particle_scale = Vector2(1.25, 1.25)
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 9999
			speed = 200
			damage = 15
			knockback_amount = 100
			radius = 48
			particle_scale = Vector2(1.5, 1.5)
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			hp = 9999
			speed = 200
			damage = 20
			knockback_amount = 150
			radius = 56
			particle_scale = Vector2(1.75, 1.75)
			attack_size = 1.0 * (1 + player.spell_size)
		5:
			hp = 9999
			speed = 200
			damage = 25
			knockback_amount = 50
			radius = 64
			particle_scale = Vector2(2, 2)
			attack_size = 1.0 * (1 + player.spell_size)
		6:
			hp = 9999
			speed = 200
			damage = 30
			knockback_amount = 75
			radius = 72
			particle_scale = Vector2(2.25, 2.25)
			attack_size = 1.0 * (1 + player.spell_size)
		7:
			hp = 9999
			speed = 200
			damage = 35
			knockback_amount = 100
			radius = 80
			particle_scale = Vector2(2.5, 2.5)
			attack_size = 1.0 * (1 + player.spell_ssize)
		8:
			hp = 9999
			speed = 200
			damage = 50
			knockback_amount = 150
			radius = 88
			particle_scale = Vector2(2.75, 2.75)
			attack_size = 1.0 * (1 + player.spell_size)
		9:
			hp = 9999
			speed = 200
			damage = 100
			knockback_amount = 350
			radius = 104
			particle_scale = Vector2(3.25, 3.25)
			attack_size = 1.0 * (1 + player.spell_size)
			
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1) * attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func _physics_process(delta: float) -> void:
	position = global_position.move_toward(target, speed * delta)
	if position == target:
		grenade.set_deferred("disabled", false)
		grenadeRadius.shape.radius = radius
		grenade_particles.scale = particle_scale
		await get_tree().create_timer(0.1).timeout
		sprite.visible = false
		grenade.set_deferred("disabled", true)
		if !snd_explosion.is_playing() and snd_may_play:
			snd_explosion.play()
			grenade_particles.emitting = true
			snd_may_play = false
			
			#Screenshake signal
			GlobalSignals.grenade_explosion.emit()
	
func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)


func _on_snd_explosion_finished() -> void:
	queue_free()
