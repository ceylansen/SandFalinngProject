extends Area2D

signal water_state(is_in_water : bool)

var is_in_water : bool = false

func _on_body_entered(body: Node2D) -> void:
	if !is_in_water:
		var overlapping = get_overlapping_bodies()
		if (overlapping.size() >= 1):
			is_in_water = true
			water_state.emit(true)

func _on_body_exited(body: Node2D) -> void:
	var overlapping = get_overlapping_bodies()
	if (overlapping.size() == 0):
		is_in_water = false
		water_state.emit(false)
