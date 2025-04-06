class_name DepthBar
extends TextureProgressBar

@onready var line_2d: Line2D = $Line2D
@onready var label: Label = $Label


func setDepth(newDepth : float) -> void:
	value = newDepth
	

func setBestDive(divePercent : float) -> void:
	if divePercent != 0:
		line_2d.points[0].y = 200.0 * divePercent
		line_2d.points[1].y = 200.0 * divePercent
		label.position.y = (200.0 * divePercent) - 13
	else:
		line_2d.hide()
		label.hide()
