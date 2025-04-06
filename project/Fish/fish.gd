@icon("res://Fish/Anglerfish.png")
class_name Fish
extends CharacterBody2D

var fishType : FishType = null

@onready var sprite := %Sprite as Sprite2D

func _ready() -> void:
	sprite.texture = fishType.sprite


func load_type(newFishType : FishType) -> void:
	fishType = newFishType
