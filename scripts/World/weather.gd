extends Area2D

@export var Raining : bool = false
@export var Snowing : bool = false
@onready var DropPosY = global_position.y - 64


var WeatherSize = 128
var PointA
var PointB

signal DropSpot(DropPos : Vector2)

func _ready() -> void:

	PointA = global_position.x - 64
	print(PointA)
	PointB = PointA + WeatherSize
	print(PointB)

#Spawns raindrops on raindroptimeout in a random location in weather area
func _on_rain_drop_timer_timeout() -> void:
	if Raining:
		var DropPosX = PointB - (randi() % WeatherSize)
		var DropPos = Vector2(DropPosX, DropPosY)
		emit_signal("DropSpot", DropPos)
		
