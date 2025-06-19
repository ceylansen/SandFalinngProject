extends CharacterBody2D


const SPEED = 40.0
const JUMP_VELOCITY = -150.0
const WATER_SPEED = 30.0
const WATER_GRAVITY = 0.10
const WATER_JUMP = -50

var stair_step : bool = false
var stepped : bool = false
var step_wait : float = 0.04
var first_step : bool = true
var first_step_timeout : float = 0.1
var too_high : bool = false
var submerged : bool = false
var water_top : bool = false
var water_bottom : bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var costume : AnimatedSprite2D = $Hat

signal picked_up(cell : Vector2, type : int)
signal ejected(cell : Vector2, type : int)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		if !submerged:
			velocity.y += gravity * delta
		elif submerged:
			velocity.y = clampf(velocity.y + (gravity * delta * WATER_GRAVITY), -100, 50)

	if Input.is_action_just_pressed("ui_accept") and submerged:
		velocity.y = WATER_JUMP
	elif Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("left", "right")
	if direction == -1:
		costume.flip_h = true
	elif direction == 1:
		costume.flip_h = false
	if direction:
		costume.play("walk")
		if stair_step:
			#position += Vector2(direction, -1)
			if not stepped and not too_high:
				check_first_step()
				step_logic(direction)
		if submerged:
			velocity.x = direction * WATER_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		costume.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_pressed("down"):
		costume.play("down")
		velocity.x = 0
	move_and_slide()

func step_logic(direction):
	stepped = true
	if first_step:
		position += Vector2(direction, -1)
		first_step = false
	else:
		await get_tree().create_timer(step_wait).timeout
		position += Vector2(direction, -1)
	stepped = false

func check_first_step():
	if first_step:
		return
	else:
		await get_tree().create_timer(first_step_timeout).timeout
		first_step = true

func _on_single_step_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		stair_step = true

func _on_single_step_body_exited(body: Node2D) -> void:
	if body is TileMapLayer:
		stair_step = false

func _on_too_high_step_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		too_high = true

func _on_too_high_step_body_exited(body: Node2D) -> void:
	if body is TileMapLayer:
		too_high = false

func _on_water_top_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		if water_tile_check(body):
			print("entered")
			submerged = true

func _on_water_top_body_exited(body: Node2D) -> void:
	if body is TileMapLayer:
		if water_tile_check(body):
			print("exited")
			submerged = false

func water_tile_check(body: TileMapLayer) -> bool:
	var tilemap := body as TileMapLayer
	var tile_pos = tilemap.local_to_map(tilemap.to_local($WaterTop.global_position))

	var source_id = tilemap.get_cell_source_id(tile_pos)
	if source_id == 1 or source_id == 6 or source_id == 7:
		return true
	else:
		return false

func _on_water_detect_water_state(is_in_water: bool) -> void:
	submerged = is_in_water

func pocket_pickup(cell : Vector2, type : int) -> void:
	if type == -1:
		return
	if global_position.distance_to(cell) < 20:
		if %Pocket.AddPixel(type):
			emit_signal("picked_up", cell, type)

func eject_pixel(cell : Vector2) -> void:
	if global_position.distance_to(cell) < 20:
		var type : int = %Pocket.EjectTopPixel()
		emit_signal("ejected", cell, type)
