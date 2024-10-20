extends CharacterBody2D

const SPEED = 40.0
const JUMP_VELOCITY = -150.0

var stair_step : bool = false
var stepped : bool = false
var step_wait : float = 0.05
var first_step : bool = true
var first_step_timeout : float = 0.1
var too_high : bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("left", "right")
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	elif direction == 1:
		$AnimatedSprite2D.flip_h = false
	if direction:
		$AnimatedSprite2D.play("walk")
		if stair_step:
			#position += Vector2(direction, -1)
			if not stepped and not too_high:
				check_first_step()
				step_logic(direction)
		velocity.x = direction * SPEED
	else:
		$AnimatedSprite2D.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
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
