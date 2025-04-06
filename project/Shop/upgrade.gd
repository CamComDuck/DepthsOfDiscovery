class_name Upgrade
extends HBoxContainer

signal onUpgradePurchased (upgradePurchased : UpgradeType)

@export var upgradeType : UpgradeType

var descriptionLabel : Label
var levelLabel : Label
var levelBar : ProgressBar
var upgradeIcon : TextureRect
var upgradeCost : Label

func _ready() -> void:
	for i in get_child_count():
		if get_child(i).name == "Description" and get_child(i) is Label:
			descriptionLabel = get_child(i)
		elif get_child(i).name == "LevelLabel" and get_child(i) is Label:
			levelLabel = get_child(i)
		elif get_child(i).name == "LevelBar" and get_child(i) is ProgressBar:
			levelBar = get_child(i)
		elif get_child(i).name == "UpgradeButton" and get_child(i) is Button:
			for j in get_child(i).get_child(0).get_child(0).get_child_count():
				if get_child(i).get_child(0).get_child(0).get_child(j).name == "UpgradeSprite" and get_child(i).get_child(0).get_child(0).get_child(j) is TextureRect:
					upgradeIcon = get_child(i).get_child(0).get_child(0).get_child(j)
				elif get_child(i).get_child(0).get_child(0).get_child(j).name == "UpgradeCost" and get_child(i).get_child(0).get_child(0).get_child(j) is Label:
					upgradeCost = get_child(i).get_child(0).get_child(0).get_child(j)
					
	updateVisual()

func updateVisual() -> void:
	descriptionLabel.text = upgradeType.name
	levelLabel.text = "LVL" + str(Currency.upgradeLevels[upgradeType] + 1)
	levelBar.max_value = upgradeType.maxLevel - 1
	levelBar.value = Currency.upgradeLevels[upgradeType]
	upgradeIcon.texture = upgradeType.fishCost[Currency.upgradeLevels[upgradeType]].sprite
	upgradeCost.text = str(upgradeType.fishCount[Currency.upgradeLevels[upgradeType]])


func _on_upgrade_button_pressed() -> void:
	var fishTypeNeeded : FishType = upgradeType.fishCost[Currency.upgradeLevels[upgradeType]]
	var fishCountNeeded : int = upgradeType.fishCount[Currency.upgradeLevels[upgradeType]]
	var currentFishTypeCount : int = Currency.fishCollectedCount[fishTypeNeeded]
	
	if currentFishTypeCount >= fishCountNeeded:
		Currency.upgradeLevels[upgradeType] += 1
		Currency.fishCollectedCount[fishTypeNeeded] -= fishCountNeeded
		updateVisual()
	onUpgradePurchased.emit(upgradeType)
