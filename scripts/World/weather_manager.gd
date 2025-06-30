extends Node2D



@onready var weathers = get_children()
@export var Weather : int
@export var weather_amnt = 5

signal Dropper(DropPos : Vector2, type : int)
signal weather_type(Weather : int)
signal CameraNewDay(Day : int)

func _ready() -> void:
	connect_weathers()

func connect_weathers() -> void:
	for weather in weathers:
		if weather.has_signal("DropSpot"):
			weather.DropSpot.connect(self.drop_weather)

func drop_weather(DropPos : Vector2, type : int) -> void:
	Dropper.emit(DropPos, type)

func decide_weather(Weather : int):
	for weather in weathers:
		weather.CurrentWeather = Weather



func _on_camera_manager_curr_prev_camera(curr_cam_number: int, prev_cam_number: int) -> void:
	if weathers == null:
		return
	for weather in weathers:
		weather.CurrentWeather = 0
	if curr_cam_number == prev_cam_number:
		weathers[curr_cam_number].CurrentWeather = Weather
	else:
		weathers[curr_cam_number].CurrentWeather = Weather
		if Weather == 2:
			weathers[prev_cam_number].CurrentWeather = Weather
	#weather_type.emit(Weather)


func _on_time_manager_new_day(Day: int) -> void:
	var weather_chance = randi() % 10
	if Day % 2 == 1:
		if weather_chance < 10:
			Weather = randi() % weather_amnt
			weather_type.emit(Weather)
	else:
		if weather_chance < 10:
			Weather = randi() % weather_amnt
			weather_type.emit(Weather)
	CameraNewDay.emit(Day)
			


func _on_camera_manager_weather_change(curr_cam_number: int, prev_cam_number: int) -> void:
	if weathers == null:
		return
	for weather in weathers:
		weather.CurrentWeather = 0
	if curr_cam_number == prev_cam_number:
		weathers[curr_cam_number].CurrentWeather = Weather
	else:
		weathers[curr_cam_number].CurrentWeather = Weather
		if Weather == 2:
			weathers[prev_cam_number].CurrentWeather = Weather
	#weather_type.emit(Weather)
