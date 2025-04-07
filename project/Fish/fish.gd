@icon("res://Fish/Anglerfish.png")
class_name Fish
extends CharacterBody2D

var fishType : FishType = null

var isUp := false

@onready var sprite := %Sprite as Sprite2D
@onready var swim_timer := %SwimTimer as Timer
@onready var collision_shape_goldfish: CollisionPolygon2D = $CollisionShapeGoldfish
@onready var collision_shape_squid: CollisionPolygon2D = $CollisionShapeSquid
@onready var collision_shape_anglerfish: CollisionPolygon2D = $CollisionShapeAnglerfish



func _ready() -> void:
	sprite.texture = fishType.sprite
	swim_timer.wait_time = randf_range(0.5, 1.5)
	swim_timer.start()
	if fishType.name == "Anglerfish":
		collision_shape_anglerfish.show()
	elif fishType.name == "Squid":
		collision_shape_squid.show()
	elif fishType.name == "Goldfish":
		collision_shape_goldfish.show()


func load_type(newFishType : FishType) -> void:
	fishType = newFishType
	

func _on_swim_timer_timeout() -> void:
	swim_timer.stop()
	var tween := create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	var newPosition : Vector2
	if isUp:
		newPosition = Vector2(global_position.x - 50, global_position.y)
		isUp = false
	else:
		newPosition = Vector2(global_position.x + 50, global_position.y)
		isUp = true
	tween.tween_property(self, "global_position", newPosition, 1)
	await tween.finished
	swim_timer.wait_time = randf_range(0.5, 1.5)
	swim_timer.start()
