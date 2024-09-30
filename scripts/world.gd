extends Node2D

@onready var sim : TileMapLayer = $TileMapLayer
@onready var camera : Camera2D = $Camera2D

@export var brush : int = 2
const WATER : int = 1
const SAND : int = 0
const EMPTY : int = -1
const ATLAS_COORDS : Vector2i = Vector2i(0, 0)

var Brush = 0

class TileElement:
	var type : int
	var movement_func: Callable
	
	func _init(t: int, move_func: Callable) -> void:
		type = t
		movement_func = move_func


var elements = {
	SAND: TileElement.new(SAND, handle_sand_movement),
	WATER: TileElement.new(WATER, handle_water_movement),
}


const simulation_top_bound : int = 0
const simulation_bottom_bound : int = 100
const simulation_left_bound : int = 0
const simulation_right_bound : int = 100



func _process(delta: float) -> void:
	var Used_cells = sim.get_used_cells()
	if Input.is_action_just_pressed("1"):
		Brush = SAND
	if Input.is_action_just_pressed("2"):
		Brush = WATER
	if Input.is_action_just_pressed("erase"):
		Brush = EMPTY
	
	if Input.is_action_pressed("LeftMouse"):
		for x in range(-brush, brush + 1):
			for y in range(-brush, 0):
				#sim.set_cell(sim.local_to_map(Vector2i(get_global_mouse_position().x + x, get_global_mouse_position().y + y)), Brush, ATLAS_COORDS)
				sim.set_cell(sim.local_to_map(get_global_mouse_position()), Brush, ATLAS_COORDS)
	for cell in Used_cells:
		var element = elements.get(sim.get_cell_source_id(cell), null)
		if element != null:
			if element.movement_func != null:
				element.movement_func.call(cell)


func handle_sand_movement(cell: Vector2i) -> void:
	var below_cell = cell + Vector2i(0, 1)
	var below_cell_id = sim.get_cell_source_id(below_cell)

	if below_cell_id == WATER:
		sim.set_cell(cell, WATER, ATLAS_COORDS)
		sim.set_cell(below_cell, SAND, ATLAS_COORDS)
		return
	if below_cell_id == EMPTY and below_cell.y < simulation_bottom_bound:
		sim.set_cell(cell, EMPTY)
		sim.set_cell(below_cell, SAND, ATLAS_COORDS)
		return
	var left_cell = cell + Vector2i(-1, 1)
	var right_cell = cell + Vector2i(1, 1)
	var left_cell_id = sim.get_cell_source_id(left_cell)
	var right_cell_id = sim.get_cell_source_id(right_cell)

	var random_direction = randi() % 2

	if random_direction == 0 and left_cell_id == EMPTY and left_cell.y < simulation_bottom_bound:
		sim.set_cell(cell, EMPTY)
		sim.set_cell(left_cell, SAND, ATLAS_COORDS)

	elif random_direction == 1 and right_cell_id == EMPTY and right_cell.y < simulation_bottom_bound:
		sim.set_cell(cell, EMPTY)
		sim.set_cell(right_cell, SAND, ATLAS_COORDS)

func handle_water_movement(cell: Vector2i) -> void:
	var below_cell = cell + Vector2i(0, 1)
	var below_cell_id = sim.get_cell_source_id(below_cell)

	if below_cell_id == EMPTY and below_cell.y < simulation_bottom_bound:
		sim.set_cell(cell, EMPTY)
		sim.set_cell(below_cell, WATER, ATLAS_COORDS)
		return
	var left_cell = cell + Vector2i(-1, 0)
	var right_cell = cell + Vector2i(1, 0)
	var left_cell_id = sim.get_cell_source_id(left_cell)
	var right_cell_id = sim.get_cell_source_id(right_cell)

	if left_cell_id == EMPTY and randi() % 2 == 0 and left_cell.y < simulation_bottom_bound:
		sim.set_cell(cell, EMPTY)
		sim.set_cell(left_cell, WATER, ATLAS_COORDS)

	elif right_cell_id == EMPTY and randi() % 2 == 1 and right_cell.y < simulation_bottom_bound:
		sim.set_cell(cell, EMPTY)
		sim.set_cell(right_cell, WATER, ATLAS_COORDS)
