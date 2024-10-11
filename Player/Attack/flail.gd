extends Area2D

var level = 1
var damage: int = 5
var knockback_amount: int = 10
var attack_size : float = 1.0
var speed: float = 0.05
var angle: Vector2 = Vector2.ZERO
var target = Vector2.ZERO

signal remove_from_array(object)

@onready var player = get_tree().get_first_node_in_group("player")
@onready var flail = get_node("CollisionShape2D")

func _ready() -> void:
	update_flail()

func _physics_process(_delta: float) -> void:
	position = player.global_position
	rotation += speed
	angle = (flail.global_position - player.global_position).normalized()
	
func update_flail():
	level = player.flail_level
	match level:
		1:
			speed = 0.05
			damage = 5
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			speed = 0.05
			damage = 10
			knockback_amount = 120
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			speed = 0.1
			damage = 10
			knockback_amount = 140
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			speed = 0.1
			damage = 15
			knockback_amount = 160
			attack_size = 1.0 * (1 + player.spell_size)
		5:
			speed = 0.15
			damage = 15
			knockback_amount = 180
			attack_size = 1.0 * (1 + player.spell_size)
		6:
			speed = 0.15
			damage = 15
			knockback_amount = 200
			attack_size = 1.0 * (1 + player.spell_size)
		7:
			speed = 0.2
			damage = 20
			knockback_amount = 220
			attack_size = 1.0 * (1 + player.spell_size)
		8:
			speed = 0.2
			damage = 30
			knockback_amount = 240
			attack_size = 1.0 * (1 + player.spell_size)
		9:
			speed = 0.25
			damage = 30
			knockback_amount = 300
			attack_size = 1.0 * (1 + player.spell_size)
			
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1) * attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func _on_timer_timeout() -> void:
	emit_signal("remove_from_array", self)


func _on_update_timer_timeout() -> void:
	update_flail()
