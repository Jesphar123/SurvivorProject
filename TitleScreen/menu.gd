extends Control

var world = "res://World/world_box.tscn"
var character_select = "res://TitleScreen/character_select.tscn"




func _on_btn_play_click_end() -> void:
	get_tree().change_scene_to_file(character_select)



func _on_btn_exit_click_end() -> void:
	get_tree().quit()
