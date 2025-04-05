class_name Shop
extends Map


func _on_timer_timeout() -> void:
	onSceneChanged.emit("res://Ocean/Ocean.tscn")
