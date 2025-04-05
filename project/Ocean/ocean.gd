class_name Ocean
extends Node2D

var fishCollectedCount := {} 

@export var fishTypes : Array[FishType]

@onready var fish := load("res://Fish/fish.tscn") as PackedScene
@onready var submarine := %Submarine as Submarine


func _ready() -> void:
	for i in fishTypes:
		var temp := {i.name: 0}
		fishCollectedCount.merge(temp)


func _on_timer_timeout() -> void:
	var newFish := fish.instantiate() as Fish
	var newFishType : FishType = fishTypes[randi_range(0, fishTypes.size() - 1)]
	newFish.load_type(newFishType)
	add_child(newFish)
	var randX := randf_range(submarine.global_position.x - 500, submarine.global_position.x + 500)
	var randY := randf_range(submarine.global_position.y + 250, submarine.global_position.y + 750)
	newFish.global_position = Vector2(randX, randY)


func _on_submarine_on_fish_scanned(fishScanned: FishType) -> void:
	fishCollectedCount[fishScanned.name] = fishCollectedCount[fishScanned.name] + 1
	print(fishCollectedCount)
