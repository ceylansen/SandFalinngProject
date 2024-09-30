extends Node2D

@onready var sim : TileMapLayer = $TileMapLayer
@onready var camera : Camera2D = $Camera2D

const WATER : int = 1
const SAND : int = 0
const EMPTY : int = -1
const ATLAS_COORDS : Vector2i = Vector2i(0, 0)
const simulation_top_bound : int = 0
const simulation_bottom_bound : int = 100
const simulation_left_bound : int = 0
const simulation_right_bound : int = 100
@onready var chunk_manager : ChunkManager = ChunkManager.new(16)

@export var brush_size : int = 1
var Brush : int = 0
@export var debug : bool = false

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


class Chunk:
	var is_awake : bool = true
	var is_awake_nextframe: bool = true
	var size : int 
	var top_left : Vector2
	
	func set_top_left(left_top : Vector2) -> void:
		top_left = left_top
	
	func get_top_left() -> Vector2:
		return top_left
	
	func set_awake(awakeness : bool) -> void:
		is_awake_nextframe = awakeness
	
	func shift_set_awake() -> void:
		is_awake = is_awake_nextframe
		is_awake_nextframe = false
		
	func is_chunk_awake() -> bool:
		return is_awake
		
class ChunkManager:
	var chunk_size : int
	var chunks : Dictionary = {}

	func _init(chunk_size: int):
		self.chunk_size = chunk_size

	func get_chunk_key(position: Vector2) -> Vector2:
		return Vector2(floor(position.x / chunk_size), floor(position.y / chunk_size))

	func get_or_create_chunk(position: Vector2) -> Chunk:
		var chunk_key = get_chunk_key(position)
		if not chunks.has(chunk_key):
			var chunk = Chunk.new()
			chunk.set_top_left(chunk_key * chunk_size)
			chunks[chunk_key] = chunk
		return chunks[chunk_key]

	#func wake_chunks_around(position: Vector2):
		#var chunk_key = get_chunk_key(position)
		#var current_chunk = chunks[chunk_key]
		#if current_chunk.is_chunk_awake():
			#for dx in [-1, 0, 1]:
				#for dy in [-1, 0, 1]:
					#if dx == 0 and dy == 0:
						#continue  # Skip the current chunk
#
					#var neighbor_key = chunk_key + Vector2(dx, dy)
					#if chunks.has(neighbor_key):
						#var neighbor_chunk = chunks[neighbor_key]
						#neighbor_chunk.set_awake(true)

	#func wake_chunks_on_border(position: Vector2i):
		#var chunk_key = get_chunk_key(position)
		#if position.x % chunk_size == 0 and chunks.has(chunk_key + Vector2(-1, 0)):
			#chunks[chunk_key + Vector2(-1, 0)].set_awake(true)
		#if (position.x + 1) % chunk_size == 0 and chunks.has(chunk_key + Vector2(1, 0)):
			#chunks[chunk_key + Vector2(1, 0)].set_awake(true)
		#if position.y % chunk_size == 0 and chunks.has(chunk_key + Vector2(0, -1)):
			#chunks[chunk_key + Vector2(0, -1)].set_awake(true)
		#if (position.y + 1) % chunk_size == 0 and chunks.has(chunk_key + Vector2(0, 1)):
			#chunks[chunk_key + Vector2(0, 1)].set_awake(true)


func get_cells_in_chunk(chunk: Chunk) -> Array:
	var chunk_cells = []
	var chunk_top_left = chunk.get_top_left()
	var chunk_bottom_right = chunk_top_left + Vector2(chunk_manager.chunk_size, chunk_manager.chunk_size)
	for x in range(chunk_top_left.x, chunk_bottom_right.x):
		for y in range(chunk_top_left.y, chunk_bottom_right.y):
			var cell = Vector2i(x, y)
			if sim.get_cell_source_id(cell) != EMPTY:
				chunk_cells.append(cell)
	return chunk_cells

	
func _draw():
	for chunk_key in chunk_manager.chunks.keys():
		var chunk = chunk_manager.chunks[chunk_key]
		var chunk_top_left = chunk.get_top_left()
		var chunk_size = chunk_manager.chunk_size
		if chunk.is_chunk_awake():
			draw_rect(Rect2(chunk_top_left, Vector2(chunk_size, chunk_size)), Color(0, 1, 0, 0.5))  # Green with transparency
		else:
			draw_rect(Rect2(chunk_top_left, Vector2(chunk_size, chunk_size)), Color(1, 0, 0, 0.5))  # Red with transparency


func _process(_delta: float) -> void:
	var Used_cells = sim.get_used_cells()
	if Input.is_action_just_pressed("1"):
		Brush = SAND
	if Input.is_action_just_pressed("2"):
		Brush = WATER
	if Input.is_action_just_pressed("erase"):
		Brush = EMPTY
	
	if Input.is_action_pressed("LeftMouse"):
		for x in range(-brush_size, brush_size + 1):
			for y in range(-brush_size, 0):
				var pos = sim.local_to_map(Vector2i(get_global_mouse_position().x + x, get_global_mouse_position().y + y))
				#var pos = sim.local_to_map(get_global_mouse_position())
				#sim.set_cell(sim.local_to_map(Vector2i(get_global_mouse_position().x + x, get_global_mouse_position().y + y)), Brush, ATLAS_COORDS)
				place_cell(pos, Brush)

	for chunk in chunk_manager.chunks.values():
		if chunk.is_chunk_awake():
			var chunk_cells = get_cells_in_chunk(chunk) # Implement this function to get cells in a chunk
			for cell in chunk_cells:
				var element = elements.get(sim.get_cell_source_id(cell), null)
				if element != null and element.movement_func != null:
					element.movement_func.call(cell)
						#chunk_manager.get_or_create_chunk(cell).set_awake(true)
						#chunk_manager.wake_chunks_around(chunk.get_top_left())
	for chunk in chunk_manager.chunks.values():
		chunk.shift_set_awake()
	if debug:
		queue_redraw()


func place_cell(cell: Vector2i, type: int):
	sim.set_cell(cell, type, ATLAS_COORDS)
	chunk_manager.get_or_create_chunk(cell).set_awake(true)
	chunk_manager.get_or_create_chunk(cell).set_awake(true)
	if cell.x % chunk_manager.chunk_size == 0 or cell.y % chunk_manager.chunk_size == 0:
		wake_neighboring_chunks(cell)


func move_cell(cell: Vector2i, type: int, cell_direction: Vector2i):
	sim.set_cell(cell, EMPTY)
	sim.set_cell(cell_direction, type, ATLAS_COORDS)
	chunk_manager.get_or_create_chunk(cell).set_awake(true)
	chunk_manager.get_or_create_chunk(cell_direction).set_awake(true)
	if cell_direction.x % chunk_manager.chunk_size == 0 or cell_direction.y % chunk_manager.chunk_size == 0:
		wake_neighboring_chunks(cell_direction)

	if cell.x % chunk_manager.chunk_size == 0 or cell.y % chunk_manager.chunk_size == 0:
		wake_neighboring_chunks(cell)



func swap_cell(cell: Vector2i, type: int, cell_direction: Vector2i, type_direction: int):
	sim.set_cell(cell, type_direction, ATLAS_COORDS)
	sim.set_cell(cell_direction, type, ATLAS_COORDS)
	chunk_manager.get_or_create_chunk(cell).set_awake(true)
	chunk_manager.get_or_create_chunk(cell_direction).set_awake(true)
	if cell_direction.x % chunk_manager.chunk_size == 0 or cell_direction.y % chunk_manager.chunk_size == 0:
		wake_neighboring_chunks(cell_direction)
	if cell.x % chunk_manager.chunk_size == 0 or cell.y % chunk_manager.chunk_size == 0:
		wake_neighboring_chunks(cell)

func wake_neighboring_chunks(position: Vector2i):
	var chunk_key = chunk_manager.get_chunk_key(position)
	if position.x % chunk_manager.chunk_size == 0:
		var left_chunk = chunk_manager.get_or_create_chunk(position - Vector2i(1, 0))
		left_chunk.set_awake(true)
	if (position.x + 1) % chunk_manager.chunk_size == 0:
		var right_chunk = chunk_manager.get_or_create_chunk(position + Vector2i(1, 0))
		right_chunk.set_awake(true)
	if position.y % chunk_manager.chunk_size == 0:
		var top_chunk = chunk_manager.get_or_create_chunk(position - Vector2i(0, 1))
		top_chunk.set_awake(true)
	if (position.y + 1) % chunk_manager.chunk_size == 0:
		var bottom_chunk = chunk_manager.get_or_create_chunk(position + Vector2i(0, 1))
		bottom_chunk.set_awake(true)


func handle_sand_movement(cell: Vector2i) -> void:
	var current_chunk = chunk_manager.get_or_create_chunk(cell)
	if not current_chunk.is_chunk_awake():
		return

	var below_cell = cell + Vector2i(0, 1)
	var below_cell_id = sim.get_cell_source_id(below_cell)
	if below_cell_id == WATER:
		swap_cell(cell, SAND, below_cell, below_cell_id)
		return
	if below_cell_id == EMPTY and below_cell.y < simulation_bottom_bound:
		move_cell(cell, SAND, below_cell)
		return
	var left_cell = cell + Vector2i(-1, 1)
	var right_cell = cell + Vector2i(1, 1)
	var left_cell_id = sim.get_cell_source_id(left_cell)
	var right_cell_id = sim.get_cell_source_id(right_cell)

	var random_direction = randi() % 2

	if random_direction == 0 and left_cell_id == EMPTY and left_cell.y < simulation_bottom_bound:
		move_cell(cell, SAND, left_cell)

	elif random_direction == 1 and right_cell_id == EMPTY and right_cell.y < simulation_bottom_bound:
		move_cell(cell, SAND, right_cell)


func handle_water_movement(cell: Vector2i) -> void:
	var current_chunk = chunk_manager.get_or_create_chunk(cell)
	if not current_chunk.is_chunk_awake():
		return

	var below_cell = cell + Vector2i(0, 1)
	var below_cell_id = sim.get_cell_source_id(below_cell)
	if below_cell_id == EMPTY and below_cell.y < simulation_bottom_bound:
		move_cell(cell, WATER, below_cell)
		return
	var left_cell = cell + Vector2i(-1, 0)
	var right_cell = cell + Vector2i(1, 0)
	var left_cell_id = sim.get_cell_source_id(left_cell)
	var right_cell_id = sim.get_cell_source_id(right_cell)
	var random_direction = randi() % 2
	if random_direction == 0 and left_cell_id == EMPTY and left_cell.y < simulation_bottom_bound:
		move_cell(cell, WATER, left_cell)

	elif random_direction == 1 and right_cell_id == EMPTY and right_cell.y < simulation_bottom_bound:
		move_cell(cell, WATER, right_cell)		
		
