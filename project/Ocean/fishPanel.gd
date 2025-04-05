class_name FishPanel
extends PanelContainer

var fishRows : Array[FishContainerRow]

@onready var fishContainerRow := load("res://Ocean/fishContainerRow.tscn") as PackedScene
@onready var vBox := %VBoxContainer as VBoxContainer

func addFishRow(fishInfo : FishType) -> void:
	var fishRow := fishContainerRow.instantiate() as FishContainerRow
	vBox.add_child(fishRow)
	fishRow.setFishInfo(fishInfo)
	fishRows.append(fishRow)
	global_position.y -= fishRow.size.y


func updateFishCounts() -> void:
	for i in fishRows:
		i.setFishCount()


func isPanelEmpty() -> bool:
	return fishRows.is_empty()
