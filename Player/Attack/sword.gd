extends Area2D

var level: int = 1
var hp: int = 1
var speed: int = 0
var damage: int = 5
var knockback_amount: int = 2
var attack_size: float = 1.0

var target: Vector2 = Vector2.ZERO
var angle: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var player_sword_position = get_tree().get_first_node_in_group("sword_position")
@onready var sprite = $Sprite2D
@onready var sword1 = get_node("CollisionShape2D")
@onready var sword2 = get_node("CollisionShape2D2")
@onready var sword3 = get_node("CollisionShape2D3")
@onready var anim = get_node("AnimationPlayer")
@onready var snd_sword_swing = get_node("snd_sword_swing")

@onready var walkTimer: Node = get_node("walkTimer")

signal remove_from_array(object)

func _ready() -> void:
	
	match level:
		1:
			hp = 1
			speed = 0
			damage = 5
			knockback_amount = 2
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 1
			speed = 0
			damage = 5
			knockback_amount = 10
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 2
			speed = 0
			damage = 8
			knockback_amount = 15
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			hp = 2
			speed = 0
			damage = 8
			knockback_amount = 15
			attack_size = 1.0 * (1 + player.spell_size)
		5:
			hp = 1
			speed = 0
			damage = 5
			knockback_amount = 2
			attack_size = 1.0 * (1 + player.spell_size)
		6:
			hp = 1
			speed = 0
			damage = 5
			knockback_amount = 10
			attack_size = 1.0 * (1 + player.spell_size)
		7:
			hp = 2
			speed = 0
			damage = 8
			knockback_amount = 15
			attack_size = 1.0 * (1 + player.spell_size)
		8:
			hp = 2
			speed = 0
			damage = 8
			knockback_amount = 15
			attack_size = 1.0 * (1 + player.spell_size)
	
			
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1) * attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	anim.play("sword_slash")
	snd_sword_swing.play()
	
	

func _physics_process(_delta: float) -> void:
	angle = ((sword1.global_position + sword2.global_position + sword3.global_position) / 3 - player.global_position)
	position = player_sword_position.global_position
	#emit_signal("remove_from_array", self)
	await get_tree().create_timer(0.1).timeout
	queue_free()
