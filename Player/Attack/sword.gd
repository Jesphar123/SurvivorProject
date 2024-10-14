extends Area2D

var level: int = 1
var damage: int = 5
var knockback_amount: int = 2
var attack_size: float = 1.0
var speed: int = 0

var target: Vector2 = Vector2.ZERO
var angle: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var player_sword_position = get_tree().get_first_node_in_group("sword_position")
@onready var sprite = $Sprite2D
@onready var anim = get_node("AnimationPlayer")
@onready var snd_sword_swing = get_node("snd_sword_swing")
@onready var hitBox = get_node("CollisionShape2D2")
@onready var timer = get_node("Timer")

signal remove_from_array(object)

func _ready() -> void:
	
	match level:
		1:
			damage = 5
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
			speed = 200
			timer.wait_time = 0.1
			anim.speed_scale = 2.0
		2:
			damage = 10
			knockback_amount = 150
			attack_size = 1.0 * (1.05 + player.spell_size)
			speed = 200
			timer.wait_time = 0.1
			anim.speed_scale = 2.0
		3:
			damage = 10
			knockback_amount = 200
			attack_size = 1.0 * (1.1 + player.spell_size)
			speed = 200
			timer.wait_time = 0.15
			anim.speed_scale = 2.5
		4:
			damage = 15
			knockback_amount = 200
			attack_size = 1.0 * (1.15 + player.spell_size)
			speed = 200
			timer.wait_time = 0.15
			anim.speed_scale = 2.5
		5:
			damage = 15
			knockback_amount = 250
			attack_size = 1.0 * (1.2 + player.spell_size)
			speed = 250
			timer.wait_time = 0.1
			anim.speed_scale = 2.0
		6:
			damage = 20
			knockback_amount = 250
			attack_size = 1.0 * (1.25 + player.spell_size)
			speed = 250
			timer.wait_time = 0.2
			anim.speed_scale = 1.0
		7:
			damage = 20
			knockback_amount = 300
			attack_size = 1.0 * (1.3 + player.spell_size)
			speed = 300
			timer.wait_time = 0.2
			anim.speed_scale = 1.0
		8:
			damage = 25
			knockback_amount = 350
			attack_size = 1.0 * (1.35 + player.spell_size)
			speed = 300
			timer.wait_time = 0.2
			anim.speed_scale = 1.0
		9:
			damage = 40
			knockback_amount = 400
			attack_size = 1.0 * (1.5 + player.spell_size)
			speed = 400
			timer.wait_time = 0.4
			anim.speed_scale = 0.5
	
	timer.start()
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1) * attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	anim.play("sword_slash")
	snd_sword_swing.play()
	
func _physics_process(delta: float) -> void:
	angle = (hitBox.global_position - player.global_position).normalized()
	position += direction * speed * delta
	#if level == 9:
		#position += direction * speed * delta
	#else:
		#position = player_sword_position.global_position

func _on_timer_timeout() -> void:
	emit_signal("remove_from_array", self)
	queue_free()
