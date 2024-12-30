extends Camera2D

signal Switch

func _on_camera_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		Switch.emit()
