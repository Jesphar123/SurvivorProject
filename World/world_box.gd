extends Node2D


@onready var Camera = $PlayerCamera

#Screen Shake
var rand_shake_strength: float = 5.0
var shake_decay: float = 10.0
var shake_strength: float = 0.0

@onready var rand = RandomNumberGenerator.new()

func track_camera_to(target_pos):
	if target_pos == null:
		push_error(self.name  + "Camera has been passed a null")
		return
	
	Camera.global_position = target_pos
	
func _ready() -> void:
	rand.randomize()
	GlobalSignals.playerHit.connect(shake_screen)
	GlobalSignals.grenade_explosion.connect(shake_screen)
	
func shake_screen():
	shake_strength = rand_shake_strength
	
func _process(delta: float) -> void:
	shake_strength = lerp(shake_strength, 0.0, shake_decay * delta)
	Camera.offset = get_random_offset()
	
func get_random_offset() -> Vector2:
	return Vector2(
		rand.randf_range(-shake_strength, shake_strength),
		rand.randf_range(-shake_strength, shake_strength)
	)
