extends Area2D

var level = 1
var damage: int = 5
var knockback_amount: int = 100
var attack_size : float = 1.0
var speed: float = 0.05
var angle: Vector2 = Vector2.ZERO
var target = Vector2.ZERO

signal remove_from_array(object)

@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	update_flail()

func _physics_process(_delta: float) -> void:
	position = player.global_position + angle
	rotation += speed
	angle = global_position.direction_to(-player.global_position)
	
func update_flail():
	print(knockback_amount)
	level = player.flail_level
	match level:
		1:
			speed = 0.05
			damage = 5
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			speed = 0.1
			damage = 5
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			speed = 0.1
			damage = 8
			knockback_amount = 200
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			speed = 0.1
			damage = 8
			knockback_amount = 400
			attack_size = 1.0 * (1 + player.spell_size)
			
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1) * attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func _on_timer_timeout() -> void:
	emit_signal("remove_from_array", self)