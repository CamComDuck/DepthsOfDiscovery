class_name HealthPowerBars
extends PanelContainer

@onready var healthBar := %HealthBar as ProgressBar
@onready var powerBar := %PowerBar as ProgressBar

func setHealth(newHealth : float) -> void:
	healthBar.value = newHealth
	
	
func setPower(newPower : float) -> void:
	powerBar.value = newPower
