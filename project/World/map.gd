class_name Map
extends Node2D

@warning_ignore("unused_signal") # Only children classes implement this signal
signal onSceneChanged(newScenePath : String)

func _ready() -> void:
	modulate = Color(Color.WHITE, 0)
	child_ready()


func child_ready() -> void:
	pass
