extends Node2D

@export var CurrentTime := 0.0
@export var StartingTime := 0.0
@export var CurrentDay := 0
@export var DayLength := 1000

@export var TimeSpeed := 5.0

signal NewDay(Day : int)

func _process(_delta: float) -> void:
	CurrentTime += 1.0 * TimeSpeed
	if CurrentTime >= DayLength:
		CurrentDay += 1
		CurrentTime = StartingTime
		NewDay.emit(CurrentDay)
	queue_redraw()


func _draw() -> void:
	var default_font = ThemeDB.fallback_font
	var default_font_size = ThemeDB.fallback_font_size
	var daytime = "Time: " + str(CurrentTime) + "Day: " + str(CurrentDay)
	draw_string(default_font, Vector2(-64, 0), daytime, HORIZONTAL_ALIGNMENT_RIGHT, -1, default_font_size, Color(0, 1, 0, 1))
