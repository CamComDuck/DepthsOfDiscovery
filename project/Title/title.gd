class_name Title
extends Node2D

@onready var text_edit := %TextEdit as TextEdit

var namePicked := false

func _on_play_button_pressed() -> void:
	if not namePicked:
		Currency.submarineName = "My Submarine"
	Currency.fishCollectedCount = {} 
	Currency.totalDives = 0
	Currency.upgradeLevels = {}

	get_tree().change_scene_to_file("res://World/World.tscn")


func _on_text_edit_text_changed() -> void:
	if text_edit.text.length() < 70:
		Currency.submarineName = text_edit.text
		namePicked = true
