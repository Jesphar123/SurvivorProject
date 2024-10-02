extends Control

@export var menu : NinePatchRect
@export var inventory : NinePatchRect
@export var characters : NinePatchRect

@export var animation_player : AnimationPlayer

@export var item_description : NinePatchRect
@export var character_description : NinePatchRect

enum STATE { MENU, INVENTORY, CHARACTER }
var ui_state = STATE.MENU

func _input(event):
	if event.is_action_pressed("ui_cancel") and not animation_player.is_playing():
		match ui_state:
			STATE.INVENTORY:
				ui_state = STATE.MENU
				hide_and_show("inventory", "menu")
			STATE.CHARACTER:
				ui_state = STATE.MENU
				hide_and_show("character_menu", "menu")
			STATE.MENU:
				if menu.visible == true:
					animation_player.play("hide_menu")
				else:
					animation_player.play("show_menu")

func set_description(item : Item):
	item_description.find_child("Name").text = item.title
	item_description.find_child("Icon").texture = item.icon
	item_description.find_child("Description").text = item.description
	
func set_character_description(character : CharacterMenu):
	character_description.find_child("CharacterIcon").texture = character.texture
	character_description.find_child("CharacterDescription").text = character.description

func hide_and_show(first : String, second : String):
	animation_player.play("hide_" + first)
	await animation_player.animation_finished
	animation_player.play("show_" + second)


func _on_inventory_pressed() -> void:
	ui_state = STATE.INVENTORY
	hide_and_show("menu", "inventory")


func _on_characters_pressed() -> void:
	ui_state = STATE.CHARACTER
	hide_and_show("menu", "character_menu")


func _on_quit_pressed() -> void:
	get_tree().quit()
