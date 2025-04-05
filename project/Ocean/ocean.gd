class_name Ocean
extends Map

@export var fishTypes : Array[FishType]

var submarine : Submarine
var healthPowerBars : HealthPowerBars
var powerLevel := 100.0
var healthLevel := 100.0

@onready var fish := load("res://Fish/fish.tscn") as PackedScene
@onready var healthPowerBarsScene := load("res://Ocean/healthPowerBars.tscn") as PackedScene


func _ready() -> void:
	for i in get_parent().get_child_count():
		if get_parent().get_child(i) is Submarine:
			submarine = get_parent().get_child(i) as Submarine
			healthPowerBars = healthPowerBarsScene.instantiate() as HealthPowerBars
			submarine.add_child(healthPowerBars)
	
	if Currency.fishCollectedCount.is_empty():
		for i in fishTypes:
			var temp := {i.name: 0}
			Currency.fishCollectedCount.merge(temp)


func changeScene() -> void:
	submarine.remove_child(healthPowerBars)
	onSceneChanged.emit("res://Shop/Shop.tscn")


func _on_fish_spawn_timer_timeout() -> void:
	var newFish := fish.instantiate() as Fish
	var newFishType : FishType = fishTypes[randi_range(0, fishTypes.size() - 1)]
	newFish.load_type(newFishType)
	add_child(newFish)
	var randX := randf_range(submarine.global_position.x - 500, submarine.global_position.x + 500)
	var randY := randf_range(submarine.global_position.y + 250, submarine.global_position.y + 750)
	newFish.global_position = Vector2(randX, randY)
	

func _on_power_drain_timer_timeout() -> void:
	powerLevel -= submarine.powerDrain
	healthPowerBars.setPower(powerLevel)
	
	if powerLevel <= 0:
		changeScene()
