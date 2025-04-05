class_name Shop
extends Map

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


func getReferenceCenter() -> Vector2:
	return Vector2(-464, -200)


func fixFishPanel() -> void:
	fishPanel.reparent(submarine)
	fishPanel.size = fishPanelSize
	fishPanel.position = fishPanelPosition


func _on_dive_button_pressed() -> void:
	onSceneChanged.emit("res://Ocean/Ocean.tscn")
	
