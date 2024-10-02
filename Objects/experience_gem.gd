extends Area2D


@export var experience = 1


var spr_green = preload("res://Textures/Items/Gems/gem_green_ph.png")
var spr_blue = preload("res://Textures/Items/Gems/gem_blue_ph.png")
var spr_red = preload("res://Textures/Items/Gems/gem_red_ph.png")

var target = null
var speed = -1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $snd_exp_collected

func _ready() -> void:
	if experience < 5:
		return
	elif experience < 25:
		sprite.texture = spr_blue
	else:
		sprite.texture = spr_red


func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 4 * delta
		
func collect():
	sound.play()
	collision.call_deferred("set", "disabled", true)
	sprite.visible = false
	return experience

func _on_snd_exp_collected_finished() -> void:
	queue_free()
