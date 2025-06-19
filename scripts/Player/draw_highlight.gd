extends Node2D

var i = 0
func _process(_delta):
	queue_redraw()

func _draw():
	var main = get_parent()
	if main == null:
		return
	#var sim = main.sim
	var cell = main.highlighted_cell
	#var cell = sim.local_to_map(get_global_mouse_position())
	#var cell_pos = sim.map_to_local(cell)
	#print(cell)
	#print(cell_pos)
	#var tile_size = sim.tile_set.tile_size if sim.tile_set else Vector2(1, 1)
	draw_rect(Rect2((cell), Vector2(1, 1)), Color(1, 0, 0, 0.75))
	#var mouse_pos = get_global_mouse_position()
	#var cell = sim.local_to_map(mouse_pos)
	#var cell_world_pos = sim.map_to_local(cell)
	## Assuming you're using 1x1 tiles or pixels (adjust size if not)
	#var tile_size = sim.tile_set.tile_size if sim.tile_set else Vector2(1, 1)
	#draw_rect(Rect2((cell + Vector2i(1, 0)), tile_size), Color(1, 1, 0, 0.8))
