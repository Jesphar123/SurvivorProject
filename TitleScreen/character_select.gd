extends Control

@export var character_description : NinePatchRect

var world = "res://World/world_box.tscn"

const world_bg_load : String = "res://World/world_box.tscn"

func set_character_description(character : CharacterMenu):
	character_description.find_child("CharacterIcon").texture = character.texture
	character_description.find_child("CharacterDescription").text = character.description

var load_player_scene = preload("res://Player/player.tscn").instantiate()

func _ready():
	ResourceLoader.load_threaded_request(world_bg_load)

func _on_button_1_pressed() -> void:
	var world_load = ResourceLoader.load_threaded_get(world_bg_load)
	var load_scene = world_load.instantiate()
	add_child(load_scene)
	GlobalSignals.change_character.emit("maeve")
	
func _on_button_2_pressed() -> void:
	var world_load = ResourceLoader.load_threaded_get(world_bg_load)
	var load_scene = world_load.instantiate()
	add_child(load_scene)
	GlobalSignals.change_character.emit("princess")

func _on_button_3_pressed() -> void:
	var world_load = ResourceLoader.load_threaded_get(world_bg_load)
	var load_scene = world_load.instantiate()
	add_child(load_scene)
	GlobalSignals.change_character.emit("avery")

func _on_button_4_pressed() -> void:
	var world_load = ResourceLoader.load_threaded_get(world_bg_load)
	var load_scene = world_load.instantiate()
	add_child(load_scene)
	GlobalSignals.change_character.emit("augbert")
