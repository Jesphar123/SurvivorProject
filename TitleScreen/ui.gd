extends Control

@export var menu : NinePatchRect
@export var inventory : NinePatchRect

@export var animation_player : AnimationPlayer

@export var item_description : NinePatchRect

enum STATE { MENU, INVENTORY, SETTINGS }
var ui_state = STATE.MENU

signal resolution_changed(new_resolution)
signal vsync_toggled()

@onready var option_button: OptionButton = $Settings/Resolution
@onready var volumeSlider: HSlider = $Settings/Volume
@onready var vsyncCheckbutton: CheckButton= $"Settings/VsyncToggle"
@onready var fullscreenCheckbutton: CheckButton = $Settings/FullscreenToggle

func _ready():
	GlobalSignals.menu_trigger.connect(_input)
	vsyncCheckbutton.button_pressed = true

func _input(event):
	if Input.is_action_pressed("menu") and not animation_player.is_playing():
		match ui_state:
			STATE.INVENTORY:
				ui_state = STATE.MENU
				hide_and_show("inventory", "menu")
			STATE.MENU:
				if menu.visible == true:
					animation_player.play("hide_menu")
					await animation_player.animation_finished
					get_tree().paused = false
				else:
					menu.visible = true
					animation_player.play("show_menu")
					get_tree().paused = true
			STATE.SETTINGS:
				ui_state = STATE.MENU
				hide_and_show("settings", "menu")
	if get_tree().paused:
		print("paused")
	elif !get_tree().paused:
		print("unpaused")

func set_description(item : Item):
	item_description.find_child("Name").text = item.title
	item_description.find_child("Icon").texture = item.icon
	item_description.find_child("Description").text = item.description

func hide_and_show(first : String, second : String):
	animation_player.play("hide_" + first)
	await animation_player.animation_finished
	animation_player.play("show_" + second)


func _on_inventory_pressed() -> void:
	ui_state = STATE.INVENTORY
	hide_and_show("menu", "inventory")

func _on_settings_pressed() -> void:
	ui_state = STATE.SETTINGS
	hide_and_show("menu", "settings")

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://TitleScreen/menu.tscn")
	

func _on_vsync_toggle_toggled(toggled_on: bool) -> void:
	var mode := DisplayServer.window_get_vsync_mode()
	var is_vsync: bool = mode != DisplayServer.VSYNC_ENABLED
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if is_vsync else DisplayServer.VSYNC_DISABLED)
	print(DisplayServer.window_get_vsync_mode())

func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	var mode := DisplayServer.window_get_mode()
	var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)

#Resolution Selection
func _on_resolution_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(640, 360))
		1:
			DisplayServer.window_set_size(Vector2i(1280, 720))
		2:
			DisplayServer.window_set_size(Vector2i(1920, 1080))

#Volume settings
func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)

#Reset all settings
func _on_reset_pressed() -> void:
	#Resolution
	_on_resolution_item_selected(2)
	#Fullscreen
	fullscreenCheckbutton.button_pressed = false
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	#Vsync
	vsyncCheckbutton.button_pressed = true
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	#Volume
	_on_volume_value_changed(0)
	volumeSlider.value = 0
