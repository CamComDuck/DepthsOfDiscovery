@icon("res://Submarine/TEMP_submarine.png")
class_name Submarine
extends CharacterBody2D

const MOVE_SPEED = 300.0
const SCAN_SPEED = 100.0

@onready var scannerCast := %ScannerCast as ShapeCast2D
@onready var scannerSprite := %SpriteScanner as Sprite2D


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.y = minf(velocity.y, 100)


	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * MOVE_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, MOVE_SPEED)
		
	scannerCast.target_position.x = move_toward(scannerCast.target_position.x, direction * 100, SCAN_SPEED * delta)
	scannerSprite.rotation_degrees = move_toward(scannerSprite.rotation_degrees, -1 * direction * 50, (SCAN_SPEED * delta) / 2)

	print("target position: " + str(scannerCast.target_position.x))
	print("rotation degrees: " + str(scannerSprite.rotation_degrees))

	move_and_slide()
