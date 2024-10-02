extends NinePatchRect

@export var character : CharacterMenu:
	set(value):
		character = value
		$Name.text = value.title
		$Icon.texture = value.icon

func _on_mouse_entered() -> void:
	if character != null:
		owner.set_character_description(character)
