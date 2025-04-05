class_name Ocean
extends Node2D

@export var fishTypes : Array[FishType]

@onready var fish := load("res://Fish/fish.tscn") as PackedScene
@onready var submarine := %Submarine as Submarine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var newFish := fish.instantiate() as Fish
	var newFishType : FishType = fishTypes[randi_range(0, fishTypes.size() - 1)]
	newFish.load_type(newFishType)
	add_child(newFish)
	var randX := randf_range(submarine.global_position.x - 500, submarine.global_position.x + 500)
	var randY := randf_range(submarine.global_position.y + 250, submarine.global_position.y + 750)
	newFish.global_position = Vector2(randX, randY)
	
