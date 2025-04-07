extends Node2D

func playClick() -> void:
	$Click.play()
	
func playCollect() -> void:
	$Collect.play()
	
func playDriving() -> void:
	$Driving.play()
	
func playHit() -> void:
	$Hit.play()
	
func playUse() -> void:
	$Use.play()

func playWater() -> void:
	$Water.play()
	
func _on_music_finished() -> void:
	print("finished music")
	$Music.play()
