extends Area2D

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knockback_amount = 100
var attack_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

var snd_may_play: bool = true

@onready var player = get_tree().get_first_node_in_group("player")
@onready var snd_attack = get_node("snd_ice_spear_attack_play")
@onready var iceSpear = get_node("Sprite2D")
@onready var iceSpearCol = get_node("CollisionShape2D")

signal remove_from_array(object)

func _ready() -> void:
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135)
	match level:
		1:
			hp = 2
			speed = 400
			damage = 5
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 3
			speed = 400
			damage = 5
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 4
			speed = 400
			damage = 10
			knockback_amount = 110
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			hp = 5
			speed = 400
			damage = 10
			knockback_amount = 110
			attack_size = 1.0 * (1 + player.spell_size)
		5:
			hp = 6
			speed = 400
			damage = 15
			knockback_amount = 120
			attack_size = 1.0 * (1 + player.spell_size)
		6:
			hp = 7
			speed = 400
			damage = 15
			knockback_amount = 120
			attack_size = 1.0 * (1 + player.spell_size)
		7:
			hp = 8
			speed = 400
			damage = 20
			knockback_amount = 130
			attack_size = 1.0 * (1 + player.spell_size)
		8:
			hp = 10
			speed = 400
			damage = 25
			knockback_amount = 150
			attack_size = 1.0 * (1 + player.spell_size)
		9:
			hp = 20
			speed = 500
			damage = 30
			knockback_amount = 250
			attack_size = 1.0 * (1 + player.spell_size)
			
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1) * attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func _physics_process(delta: float) -> void:
	position += angle * speed * delta
	
func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)
		iceSpear.set_deferred("visible", false)
		iceSpearCol.set_deferred("disabled", true)

func _on_timer_timeout() -> void:
	emit_signal("remove_from_array", self)
	queue_free()
