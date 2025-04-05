class_name World
extends Node2D

var currentScenePath : String
var currentScene : Map

@onready var submarine := %Submarine as Submarine
@onready var background := %Background as ColorRect

func _ready() -> void:
	currentScenePath = "res://Ocean/Ocean.tscn"
	currentScene = load(currentScenePath).instantiate() as Map
	currentScene.connect("onSceneChanged", onSceneChanged)
	add_child(currentScene)
	submarine.allowMovement = true
	

func onSceneChanged(newScenePath : String) -> void:
	var fade_out : Tween = create_tween().set_parallel()
	for child in get_children():
		fade_out.tween_property(child, "modulate", Color(0, 0, 0), 0.2)
	await fade_out.finished
	
	currentScene.queue_free()

	currentScene = load(newScenePath).instantiate() as Map
	currentScene.connect("onSceneChanged", onSceneChanged)
	
	add_child(currentScene)
	
	var fade_in : Tween = create_tween().set_parallel()
	for child in get_children():
		if not child.is_queued_for_deletion():
			fade_in.tween_property(child, "modulate", Color(1, 1, 1), 0.2)
	
	if currentScene is Ocean:
		submarine.global_position = Vector2(0,0)
		background.show()
		submarine.allowMovement = true
		submarine.toggleShipScanner(true)
	elif currentScene is Shop:
		submarine.global_position = Vector2(0,0)
		background.hide()
		submarine.allowMovement = false
		submarine.toggleShipScanner(false)
	elif currentScene is WinGame:
		submarine.global_position = Vector2(0,0)
		background.hide()
		submarine.toggleShipScanner(false)
	
	await fade_in.finished
	currentScenePath = newScenePath
