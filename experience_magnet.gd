extends Area2D

var target = null
var speed = -1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $snd_collected

@onready var player = get_tree().get_first_node_in_group("player")

func collect():
	sound.play()
	collision.call_deferred("set", "disabled", true)
	sprite.visible = false
	var tween = player.create_tween()
	var previous_size = player.get_node("GrabArea/CollisionShape2D").shape.radius
	player.get_node("GrabArea/CollisionShape2D").shape.radius = 99999.0
	tween.tween_property(player.get_node("GrabArea/CollisionShape2D").shape, "radius", previous_size, 0.1)
	tween.play()
	return 0
	
func _on_snd_collected_finished() -> void:
	queue_free()
