@icon("res://Submarine/Submarine.png")
class_name Submarine
extends CharacterBody2D

signal onHealthHit (minusHealth : float)
signal onFishCollected (fishType : FishType)

const MOVE_SPEED = 150.0
const SCAN_SPEED = 50.0

var allowMovement := false
var bestDiveDepth : float

# Ship Stats:
var maxHealth := 100.0
var maxPower := 100.0
var healthRegen := 0.0
var powerDrain := 5.0
var powerHit := 5.0
var healthHit := 25.0
var horizontalSpeed := 1.0
var verticalSpeed := 1.0
var maxVision : Array[Vector2] = [
	Vector2(250, -100),
	Vector2(-250, -100),
	Vector2(-250, 225),
	Vector2(250, 225)]

@onready var scannerCast := %ScannerCast as ShapeCast2D
@onready var shipCast := %ShipCast as ShapeCast2D
@onready var scannerSprite := %SpriteScanner as Sprite2D
@onready var submarineSprite := %SpriteSubmarine as Sprite2D


func _physics_process(delta: float) -> void:
	handle_movement(delta)
	if allowMovement:
		handle_scanner_collisions()
		handle_ship_collisions()
	

func handle_movement(delta: float) -> void:
	if not is_on_floor() and allowMovement:
		velocity += get_gravity() * delta
		velocity.y = minf(velocity.y, 100 * verticalSpeed)

	var direction := Input.get_axis("move_left", "move_right")
	if direction > 0:
		submarineSprite.flip_h = false
	elif direction < 0:
		submarineSprite.flip_h = true
		
	if allowMovement:
		if direction != 0:
			velocity.x = direction * MOVE_SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, (MOVE_SPEED * delta) / 2 )
		scannerCast.target_position.x = move_toward(scannerCast.target_position.x, direction * 150, SCAN_SPEED * delta * 1.5 * horizontalSpeed)
		scannerSprite.rotation_degrees = move_toward(scannerSprite.rotation_degrees, -1 * direction * 50, ((SCAN_SPEED * delta) / 2) * horizontalSpeed)
		move_and_slide()
	else:
		scannerCast.target_position.x = 0
		scannerSprite.rotation_degrees = 0
		

func handle_scanner_collisions() -> void:
	for i in scannerCast.get_collision_count():
		if scannerCast.get_collider(i) is Fish and Input.is_action_just_pressed("collect"):
			var scannedFish := scannerCast.get_collider(i) as Fish
			scannedFish.queue_free()
			onFishCollected.emit(scannedFish.fishType)


func handle_ship_collisions() -> void:
	for i in shipCast.get_collision_count():
		if shipCast.get_collider(i) is Fish:
			onHealthHit.emit(healthHit)
			shipCast.get_collider(i).queue_free()


func toggleShipScanner(isVisible : bool) -> void:
	scannerSprite.visible = isVisible
