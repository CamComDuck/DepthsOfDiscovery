class_name WinGame
extends Map


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Title/Title.tscn")
