class_name WinGame
extends Map

@onready var submarine_name_label: Label = %SubmarineNameLabel


func _ready() -> void:
	if Currency.totalDives > 1:
		submarine_name_label.text = Currency.submarineName + " -- " + str(Currency.totalDives) + " Dives"
	else:
		submarine_name_label.text = Currency.submarineName + " -- " + str(Currency.totalDives) + " Dive"
	await create_tween().tween_interval(.25).finished
	AudioController.playWater()


func _on_menu_button_pressed() -> void:
	AudioController.playClick()
	get_tree().change_scene_to_file("res://Title/Title.tscn")
