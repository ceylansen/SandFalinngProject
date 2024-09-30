extends Node2D

@onready var sim : TileMapLayer = $TileMapLayer
@onready var camera : Camera2D = $Camera2D  # Reference to your camera node

@export var brush : int = 5
const SAND : int = 0
const EMPTY : int = -1
const ATLAS_COORDS : Vector2i = Vector2i(0, 0)

var simulation_top_bound : int = 0
var simulation_bottom_bound : int = 250

func _process(delta: float) -> void:
	var Used_cells = sim.get_used_cells()
	if Input.is_action_pressed("LeftMouse"):
		#var mouse_cell = sim.local_to_map(get_global_mouse_position())
		#sim.set_cell(mouse_cell, SAND, ATLAS_COORDS)
		for x in brush:
			for y in brush:
				sim.set_cell(sim.local_to_map(Vector2i(get_global_mouse_position().x - x, get_global_mouse_position().y - y)), SAND, ATLAS_COORDS)
				sim.set_cell(sim.local_to_map(Vector2i(get_global_mouse_position().x + x, get_global_mouse_position().y - y)), SAND, ATLAS_COORDS)
				sim.set_cell(sim.local_to_map(Vector2i(get_global_mouse_position().x - x, get_global_mouse_position().y + y)), SAND, ATLAS_COORDS)
				sim.set_cell(sim.local_to_map(Vector2i(get_global_mouse_position().x + x, get_global_mouse_position().y + y)), SAND, ATLAS_COORDS)


	for cell in Used_cells:
		var below_cell = cell + Vector2i(0, 1)
		var below_cell_id = sim.get_cell_source_id(below_cell)

		if below_cell_id == EMPTY and below_cell.y < simulation_bottom_bound:
			sim.set_cell(cell, EMPTY)
			sim.set_cell(below_cell, SAND, ATLAS_COORDS)
			continue
		var left_cell = cell + Vector2i(-1, 1)
		var right_cell = cell + Vector2i(1, 1)
		var left_cell_id = sim.get_cell_source_id(left_cell)
		var right_cell_id = sim.get_cell_source_id(right_cell)
		if left_cell_id == EMPTY and left_cell.y < simulation_bottom_bound:
			sim.set_cell(cell, EMPTY)
			sim.set_cell(left_cell, SAND, ATLAS_COORDS)
			continue
		if right_cell_id == EMPTY and right_cell.y < simulation_bottom_bound:
			sim.set_cell(cell, EMPTY)
			sim.set_cell(right_cell, SAND, ATLAS_COORDS)



#func _input(event: InputEvent) -> void:
	#if Input.is_action_pressed("LeftMouse"):
		##var mouse_cell = sim.local_to_map(get_global_mouse_position())
		##sim.set_cell(mouse_cell, SAND, ATLAS_COORDS)
		#for x in brush:
			#for y in brush:
				#sim.set_cell(sim.local_to_map(Vector2i(get_global_mouse_position().x - x, get_global_mouse_position().y - y)), SAND, ATLAS_COORDS)
				#sim.set_cell(sim.local_to_map(Vector2i(get_global_mouse_position().x + x, get_global_mouse_position().y - y)), SAND, ATLAS_COORDS)
				#sim.set_cell(sim.local_to_map(Vector2i(get_global_mouse_position().x - x, get_global_mouse_position().y + y)), SAND, ATLAS_COORDS)
				#sim.set_cell(sim.local_to_map(Vector2i(get_global_mouse_position().x + x, get_global_mouse_position().y + y)), SAND, ATLAS_COORDS)
