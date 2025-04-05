class_name Ocean
extends Map

@export var fishTypes : Array[FishType]

var submarine : Submarine
var healthPowerBars : HealthPowerBars
var powerLevel := 100.0
var healthLevel := 100.0
var missionFailed := false

@onready var fish := load("res://Fish/fish.tscn") as PackedScene
@onready var healthPowerBarsScene := load("res://Ocean/healthPowerBars.tscn") as PackedScene


func _ready() -> void:
	for i in get_parent().get_child_count():
		if get_parent().get_child(i) is Submarine:
			submarine = get_parent().get_child(i) as Submarine
			healthPowerBars = healthPowerBarsScene.instantiate() as HealthPowerBars
			submarine.add_child(healthPowerBars)
			submarine.connect("onPowerHit", onPowerHit)
			submarine.connect("onHealthHit", onHealthHit)
	
	if Currency.fishCollectedCount.is_empty():
		for i in fishTypes:
			var temp := {i.name: 0}
			Currency.fishCollectedCount.merge(temp)
			
	healthPowerBars.setPower(powerLevel)
	healthPowerBars.setHealth(healthLevel)


func checkMissionFailed() -> void:
	if powerLevel > 0 and healthLevel > 0:
		return
	
	if missionFailed:
		return
	
	# Mission Failed:
	missionFailed = true
	healthPowerBars.queue_free()
	onSceneChanged.emit("res://Shop/Shop.tscn")
	
	
func onPowerHit(minusPower : float) -> void:
	powerLevel -= minusPower
	healthPowerBars.setPower(powerLevel)
	checkMissionFailed()


func onHealthHit(minusHealth : float) -> void:
	healthLevel -= minusHealth
	healthPowerBars.setHealth(healthLevel)
	checkMissionFailed()


func _on_fish_spawn_timer_timeout() -> void:
	var newFish := fish.instantiate() as Fish
	var newFishType : FishType = fishTypes[randi_range(0, fishTypes.size() - 1)]
	newFish.load_type(newFishType)
	
	var randX1 := randf_range(submarine.global_position.x - 600, submarine.global_position.x - 350)
	var randX2 := randf_range(submarine.global_position.x + 600, submarine.global_position.x + 350)
	var randX := randi_range(0, 1)
	var randY := randf_range(submarine.global_position.y + 400, submarine.global_position.y + 800)
	
	if randX == 0:
		newFish.global_position = Vector2(randX1, randY)
	else:
		newFish.global_position = Vector2(randX2, randY)

	add_child(newFish)
	

func _on_power_drain_timer_timeout() -> void:
	powerLevel -= submarine.powerDrain
	healthPowerBars.setPower(powerLevel)
	checkMissionFailed()
