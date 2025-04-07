class_name WinGame
extends Map

func _ready() -> void:
	await create_tween().tween_interval(.25).finished
	AudioController.playWater()


func _on_menu_button_pressed() -> void:
	AudioController.playClick()
	get_tree().change_scene_to_file("res://Title/Title.tscn")
