extends Area2D

var level: int = 1
var hp: int = 1
var speed: int = 0
var damage: int = 5
var knockback_amount: int = 100
var attack_size: float = 1.0

var target: Vector2 = Vector2.ZERO
var angle: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var player_sword_position = get_tree().get_first_node_in_group("sword_position")
@onready var sprite = $Sprite2D

@onready var walkTimer: Node = get_node("walkTimer")

signal remove_from_array(object)

func _ready() -> void:
	match level:
		1:
			hp = 1
			speed = 0
			damage = 5
			knockback_amount = 200
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 1
			speed = 0
			damage = 5
			knockback_amount = 200
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 2
			speed = 0
			damage = 8
			knockback_amount = 300
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			hp = 2
			speed = 0
			damage = 8
			knockback_amount = 300
			attack_size = 1.0 * (1 + player.spell_size)

	
			
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1) * attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	#$AnimationPlayer.play("sword_slash")
	

func _physics_process(_delta: float) -> void:
	position = player_sword_position.global_position
	emit_signal("remove_from_array", self)
	await get_tree().create_timer(0.2).timeout
	queue_free()

#func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
#		queue_free()
#		print("animation finished")
	
#func enemy_hit(charge = 1):
#	hp -= charge
#	if hp <= 0:
#		emit_signal("remove_from_array", self)
#		queue_free()

#func _on_timer_timeout() -> void:
#	emit_signal("remove_from_array", self)
#	queue_free()
