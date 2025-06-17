extends Area2D

@export var Raining : bool = false
@export var Snowing : bool = false
@onready var WeatherRange = $WeatherRange
@onready var DropPosY = global_position.y - 64


var WeatherShape
var WeatherSize
var PointA
var PointB

signal DropSpot(DropPos : Vector2)

func _ready() -> void:
	WeatherShape = WeatherRange.shape as RectangleShape2D
	WeatherSize = int(WeatherShape.extents.x) * 2
	PointA = global_position.x - 64
	PointB = global_position.x + WeatherSize
	print(WeatherSize)

#Spawns raindrops on raindroptimeout in a random location in weather area
func _on_rain_drop_timer_timeout() -> void:
	if Raining:
		var DropPosX = randi() % WeatherSize
		var DropPos = Vector2(DropPosX, DropPosY)
		emit_signal("DropSpot", DropPos)
		
