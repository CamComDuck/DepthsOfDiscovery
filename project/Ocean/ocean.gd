class_name Ocean
extends Map

@export var fishTypes : Array[FishType]

const maxDepthY := -1000.0

var submarine : Submarine
var healthPowerBars : HealthPowerBars
var depthBar : DepthBar
var powerLevel := 100.0
var healthLevel := 100.0
var missionEnded := false
var currentDepth := 100.0

@onready var fish := load("res://Fish/fish.tscn") as PackedScene
@onready var healthPowerBarsScene := load("res://Ocean/healthPowerBars.tscn") as PackedScene
@onready var depthBarScene := load("res://Ocean/depthBar.tscn") as PackedScene


func _ready() -> void:
	for i in get_parent().get_child_count():
		if get_parent().get_child(i) is Submarine:
			submarine = get_parent().get_child(i) as Submarine
			healthPowerBars = healthPowerBarsScene.instantiate() as HealthPowerBars
			submarine.add_child(healthPowerBars)
			depthBar = depthBarScene.instantiate() as DepthBar
			submarine.add_child(depthBar)
			submarine.connect("onPowerHit", onPowerHit)
			submarine.connect("onHealthHit", onHealthHit)
	
	if Currency.fishCollectedCount.is_empty():
		for i in fishTypes:
			var temp := {i.name: 0}
			Currency.fishCollectedCount.merge(temp)
			
	healthPowerBars.setPower(powerLevel)
	healthPowerBars.setHealth(healthLevel)
	

func _physics_process(_delta: float) -> void:
	if not missionEnded:
		var depthPercent := 1 - ((submarine.global_position.y / maxDepthY) * -1)
		depthBar.setDepth(depthPercent)
		if depthPercent <= 0: # Win
			submarine.allowMovement = false
			checkMissionEnded(true)
		


func checkMissionEnded(isWin : bool) -> void:
	if powerLevel > 0 and healthLevel > 0 and not isWin:
		return
	
	if missionEnded:
		return
	
	# Mission Ended:
	missionEnded = true
	healthPowerBars.queue_free()
	depthBar.queue_free()
	if not isWin:
		onSceneChanged.emit("res://Shop/Shop.tscn")
	else:
		onSceneChanged.emit("res://Win/winGame.tscn")
	
	
func onPowerHit(minusPower : float) -> void:
	powerLevel -= minusPower
	healthPowerBars.setPower(powerLevel)
	checkMissionEnded(false)


func onHealthHit(minusHealth : float) -> void:
	healthLevel -= minusHealth
	healthPowerBars.setHealth(healthLevel)
	checkMissionEnded(false)


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
	checkMissionEnded(false)
