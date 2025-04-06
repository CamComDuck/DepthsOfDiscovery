class_name Ocean
extends Map

const maxDepthY := -9000.0

var submarine : Submarine
var healthPowerBars : HealthPowerBars
var depthBar : DepthBar
var fishPanel : FishPanel
var visiblePolygon : Polygon2D

var powerLevel : float
var healthLevel : float
var diveEnded := false

@onready var fish := load("res://Fish/fish.tscn") as PackedScene
@onready var healthPowerBarsScene := load("res://Ocean/healthPowerBars.tscn") as PackedScene
@onready var depthBarScene := load("res://Ocean/depthBar.tscn") as PackedScene
@onready var fish_spawn_timer := %FishSpawnTimer as Timer
@onready var power_drain_timer := %PowerDrainTimer as Timer
@onready var health_regen_timer := %HealthRegenTimer as Timer

func _ready() -> void:
	for i in get_parent().get_child_count():
		if get_parent().get_child(i) is Submarine:
			submarine = get_parent().get_child(i) as Submarine
			submarine.connect("onHealthHit", onHealthHit)
			submarine.connect("onFishCollected", onFishCollected)
			
			healthPowerBars = healthPowerBarsScene.instantiate() as HealthPowerBars
			submarine.add_child(healthPowerBars)
			
			depthBar = depthBarScene.instantiate() as DepthBar
			submarine.add_child(depthBar)
			
			for j in submarine.get_child_count():
				if submarine.get_child(j) is FishPanel:
					fishPanel = submarine.get_child(j) as FishPanel
					if fishPanel.isPanelEmpty():
						fishPanel.hide()
				elif submarine.get_child(j) is Polygon2D:
					visiblePolygon = submarine.get_child(j) as Polygon2D
					visiblePolygon.polygon = submarine.maxVision
			
	powerLevel = submarine.maxPower
	healthLevel = submarine.maxHealth
	healthPowerBars.setMaxHealth(healthLevel)
	healthPowerBars.setMaxPower(powerLevel)
	healthPowerBars.setPower(powerLevel)
	healthPowerBars.setHealth(healthLevel)
	Currency.totalDives += 1
	if submarine.healthRegen > 0:
		health_regen_timer.start()
	

func _physics_process(_delta: float) -> void:
	if not diveEnded:
		var depthPercent := ((submarine.global_position.y / maxDepthY) * -1)
		depthBar.setDepth(depthPercent)
		if depthPercent >= 1: # Win
			submarine.allowMovement = false
			checkDiveEnded(true)


func checkDiveEnded(isWin : bool) -> void:
	if powerLevel > 0 and healthLevel > 0 and not isWin:
		return
	
	if diveEnded:
		return
	
	# Dive Ended:
	diveEnded = true
	healthPowerBars.queue_free()
	depthBar.queue_free()
	fish_spawn_timer.stop()
	power_drain_timer.stop()
	health_regen_timer.stop()
	
	if not isWin:
		onSceneChanged.emit("res://Shop/Shop.tscn")
	else:
		onSceneChanged.emit("res://Win/winGame.tscn")
	


func onHealthHit(minusHealth : float) -> void:
	if not diveEnded:
		healthLevel -= minusHealth
		healthPowerBars.setHealth(healthLevel)
		checkDiveEnded(false)
	

func onFishCollected(fishType : FishType) -> void:
	if not diveEnded:
		if not fishPanel.visible:
			fishPanel.show()
		
		if Currency.fishCollectedCount[fishType] == 0:
			if not fishPanel.hasFishRow(fishType):
				fishPanel.addFishRow(fishType)
			
		Currency.fishCollectedCount[fishType] += 1
		fishPanel.updateFishCounts()
		powerLevel -= submarine.powerHit
		healthPowerBars.setPower(powerLevel)
		checkDiveEnded(false)


func _on_fish_spawn_timer_timeout() -> void:
	if not diveEnded:
		var newFish := fish.instantiate() as Fish
		var fishTypes : Array = Currency.fishCollectedCount.keys()
		var newFishType : FishType
		
		var depthPercent := 1 - ((submarine.global_position.y / maxDepthY) * -1)
		if depthPercent > 0.8: # Only spawn goldfish
			newFishType = fishTypes[0]
		elif depthPercent > 0.6: # Spawn goldfish and squid
			newFishType = fishTypes[randi_range(0, 1)]
		elif depthPercent > 0.4: # Only spawn squid
			newFishType = fishTypes[1]
		elif depthPercent >= 0.2: # Spawn squid and anglerfish
			newFishType = fishTypes[randi_range(1, 2)]
		elif depthPercent < 0.2: # Spawn only anglerfish
			newFishType = fishTypes[2]
		
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
	if not diveEnded:
		powerLevel -= submarine.powerDrain
		healthPowerBars.setPower(powerLevel)
		checkDiveEnded(false)


func _on_health_regen_timer_timeout() -> void:
	if not diveEnded:
		healthLevel += submarine.healthRegen
		if healthLevel > submarine.maxHealth:
			healthLevel = submarine.maxHealth
		healthPowerBars.setHealth(healthLevel)
		health_regen_timer.start()
