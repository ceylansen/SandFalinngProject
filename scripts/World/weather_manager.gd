extends Node2D



@onready var weathers = get_children()
@export var Weather : int

signal Dropper(DropPos : Vector2, type : int)
signal weather_type(Weather : int)

func _ready() -> void:
	connect_weathers()

func connect_weathers() -> void:
	for weather in weathers:
		if weather.has_signal("DropSpot"):
			weather.DropSpot.connect(self.drop_weather.bind(weather))

func drop_weather(DropPos : Vector2, type : int, weather : Node2D) -> void:
	emit_signal("Dropper", DropPos, type)
	emit_signal("weather_type", Weather)

func decide_weather(Weather : int):
	for weather in weathers:
		weather.CurrentWeather = Weather


func _on_camera_manager_curr_prev_camera(curr_cam_number: int, prev_cam_number: int) -> void:
	for weather in weathers:
		weather.CurrentWeather = 0
	if curr_cam_number == prev_cam_number:
		weathers[curr_cam_number].CurrentWeather = Weather
	else:
		weathers[curr_cam_number].CurrentWeather = Weather
		if Weather == 2:
			weathers[prev_cam_number].CurrentWeather = Weather
