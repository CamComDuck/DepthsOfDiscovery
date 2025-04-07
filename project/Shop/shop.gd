class_name Shop
extends Map

@export var batteryUpgrade : UpgradeType
@export var dangerVisionUpgrade : UpgradeType
@export var fishVisionUpgrade : UpgradeType
@export var healthRegenUpgrade : UpgradeType
@export var hSpeedUpgrade : UpgradeType
@export var maxHealthUpgrade : UpgradeType
@export var maxVisionUpgrade : UpgradeType
@export var vSpeedUpgrade : UpgradeType

var submarine : Submarine
var fishPanel : FishPanel
var fishPanelPosition : Vector2
var fishPanelSize : Vector2

@onready var reference_rect := %ReferenceRect as ReferenceRect
@onready var submarine_name_label := %SubmarineNameLabel as Label
@onready var fish_panel_parent := %FishPanelParent as MarginContainer

func _ready() -> void:
	if Currency.totalDives > 1:
		submarine_name_label.text = Currency.submarineName + " -- " + str(Currency.totalDives) + " Dives"
	else:
		submarine_name_label.text = Currency.submarineName + " -- " + str(Currency.totalDives) + " Dive"
		
	for i in get_parent().get_child_count():
		if get_parent().get_child(i) is Submarine:
			submarine = get_parent().get_child(i) as Submarine
			for j in submarine.get_child_count():
				if submarine.get_child(j) is FishPanel:
					fishPanel = submarine.get_child(j) as FishPanel
					fishPanelPosition = fishPanel.position
					fishPanelSize = fishPanel.size
					fishPanel.reparent(fish_panel_parent)
					fishPanel.self_modulate = Color.TRANSPARENT


func getReferenceCenter() -> Vector2:
	return Vector2(-464, -200)


func fixFishPanel() -> void:
	fishPanel.reparent(submarine)
	fishPanel.size = fishPanelSize
	fishPanel.position = fishPanelPosition
	fishPanel.self_modulate = Color.WHITE


func _on_dive_button_pressed() -> void:
	AudioController.playClick()
	onSceneChanged.emit("res://Ocean/Ocean.tscn")


func _on_upgrade_purchased(upgradePurchased: UpgradeType) -> void:
	fishPanel.updateFishCounts()
	if upgradePurchased == batteryUpgrade:
		submarine.powerDrain -= 0.5
		submarine.maxPower += 35
		submarine.powerHit -= 0.5
	elif upgradePurchased == dangerVisionUpgrade:
		pass
	elif upgradePurchased == fishVisionUpgrade:
		pass
	elif upgradePurchased == healthRegenUpgrade:
		submarine.healthRegen += 7.0

	elif upgradePurchased == hSpeedUpgrade:
		submarine.horizontalSpeed += 0.5
		
	elif upgradePurchased == maxHealthUpgrade:
		submarine.maxHealth += 25
		
	elif upgradePurchased == maxVisionUpgrade:
		for i in submarine.maxVision:
			i.x += 20
			i.y += 20
			
	elif upgradePurchased == vSpeedUpgrade:
		submarine.verticalSpeed += 0.5
		

func _on_purchasing_container_tab_changed(_tab: int) -> void:
	AudioController.playClick()
