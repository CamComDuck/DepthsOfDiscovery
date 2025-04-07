class_name Title
extends Node2D

@onready var text_edit := %TextEdit as TextEdit
@onready var tutorial: Sprite2D = $Tutorial
@onready var back_button: Button = $BackButton


var namePicked := false

func _ready() -> void:
	tutorial.hide()
	back_button.hide()

func _on_play_button_pressed() -> void:
	if not namePicked:
		Currency.submarineName = "My Submarine"
	Currency.fishCollectedCount = {} 
	Currency.totalDives = 0
	Currency.upgradeLevels = {}
	AudioController.playClick()
	get_tree().change_scene_to_file("res://World/World.tscn")


func _on_text_edit_text_changed() -> void:
	if text_edit.text.length() < 70:
		Currency.submarineName = text_edit.text
		namePicked = true
		AudioController.playClick()


func _on_tutorial_button_pressed() -> void:
	AudioController.playClick()
	tutorial.show()
	back_button.show()


func _on_back_button_pressed() -> void:
	AudioController.playClick()
	tutorial.hide()
	back_button.hide()
