class_name World
extends Node2D

@export var upgradeTypes : Array[UpgradeType]
@export var fishTypes : Array[FishType]

var currentScenePath : String
var currentScene : Map

@onready var submarine := %Submarine as Submarine
@onready var subCamera := %SubCamera as Camera2D
@onready var point_light: PointLight2D = $Submarine/PointLight


func _ready() -> void:
	if Currency.fishCollectedCount.is_empty():
		for i in fishTypes:
			var temp := {i: 0}
			Currency.fishCollectedCount.merge(temp)
	
	if Currency.upgradeLevels.is_empty():
		for i in upgradeTypes:
			var temp := {i: 0}
			Currency.upgradeLevels.merge(temp)
			
	currentScenePath = "res://Ocean/Ocean.tscn"
	currentScene = load(currentScenePath).instantiate() as Map
	currentScene.connect("onSceneChanged", onSceneChanged)
	add_child(currentScene)
	submarine.allowMovement = true
	

func onSceneChanged(newScenePath : String) -> void:
	var fade_out : Tween = create_tween().set_parallel()
	for child in get_children():
		if child is ParallaxBackground:
			fade_out.tween_property(child.get_child(0).get_child(0), "modulate", Color(0, 0, 0), 0.2)
		else:
			fade_out.tween_property(child, "modulate", Color(0, 0, 0), 0.2)
		
	await fade_out.finished
	
	if currentScene is Shop:
		currentScene.fixFishPanel()
	
	currentScene.queue_free()

	currentScene = load(newScenePath).instantiate() as Map
	currentScene.connect("onSceneChanged", onSceneChanged)
	
	add_child(currentScene)
	
	var fade_in : Tween = create_tween().set_parallel()
	for child in get_children():
		if not child.is_queued_for_deletion():
			if child is ParallaxBackground:
				fade_in.tween_property(child.get_child(0).get_child(0), "modulate", Color(1, 1, 1), 0.2)
			else:
				fade_in.tween_property(child, "modulate", Color(1, 1, 1), 0.2)
			
	
	if currentScene is Ocean:
		submarine.global_position = Vector2(0,0)
		submarine.allowMovement = true
		submarine.toggleShipScanner(true)
		subCamera.enabled = true
		point_light.show()
		
	elif currentScene is Shop:
		submarine.global_position = currentScene.getReferenceCenter()
		submarine.allowMovement = false
		submarine.toggleShipScanner(false)
		subCamera.enabled = false
		point_light.hide()
		
	elif currentScene is WinGame:
		submarine.global_position = Vector2(-441,222)
		submarine.toggleShipScanner(false)
		subCamera.enabled = false
		point_light.hide()
	
	await fade_in.finished
	currentScenePath = newScenePath
