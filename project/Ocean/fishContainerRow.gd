class_name FishContainerRow
extends HBoxContainer

var fishType : FishType

@onready var fish_sprite := %FishSprite as TextureRect
@onready var fish_name := %FishName as Label
@onready var fish_count := %FishCount as Label


func setFishInfo(fishInfo : FishType) -> void:
	fish_sprite.texture = fishInfo.sprite
	fish_name.text = fishInfo.name
	fish_count.text = "0"
	fishType = fishInfo


func setFishCount() -> void:
	for i in Currency.fishCollectedCount:
		if i == fishType:
			fish_count.text = str(Currency.fishCollectedCount[fishType])
			return
