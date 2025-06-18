extends Node2D

@export var CurrentWeather : int = 0
@onready var DropPosY = global_position.y - 64


var WeatherSize = 128
var PointA
var PointB
const WATER = 1
const SNOW = 8

signal DropSpot(DropPos : Vector2, type : int)

func _ready() -> void:

	PointA = global_position.x - 64
	PointB = PointA + WeatherSize

#Spawns raindrops on raindroptimeout in a random location in weather area
func _on_rain_drop_timer_timeout() -> void:
	if CurrentWeather == 1:
		var DropPosX = PointB - (randi() % WeatherSize)
		var DropPos = Vector2(DropPosX, DropPosY)
		emit_signal("DropSpot", DropPos, WATER)
		


func _on_snow_timer_timeout() -> void:
	if CurrentWeather == 2:
		var DropPosX = PointB - (randi() % WeatherSize)
		var DropPos = Vector2(DropPosX, DropPosY)
		emit_signal("DropSpot", DropPos, SNOW)


func _on_heavy_rain_timeout() -> void:
	if CurrentWeather == 3:
		var DropPosX = PointB - (randi() % WeatherSize)
		var DropPos = Vector2(DropPosX, DropPosY)
		emit_signal("DropSpot", DropPos, WATER)
