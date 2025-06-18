extends Node2D


func _process(_delta):
	queue_redraw()

func _draw():
	var main = get_parent()
	if main == null:
		return
	var sim = main.sim
	var cell = sim.local_to_map(get_global_mouse_position())
	var cell_pos = sim.map_to_local(cell)
	draw_rect(Rect2((cell + Vector2i(1, 1)), Vector2.ONE ), Color(1, 1, 0, 0.5))
