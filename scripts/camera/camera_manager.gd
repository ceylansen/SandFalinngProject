extends Node2D

@export var player : CharacterBody2D
@export var current_camera : Camera2D
@onready var cameras = get_children()

var cam_numbers : Dictionary

var curr_cam_number : int = 1
var prev_cam_number : int = 1


signal CurrPrevCamera(curr_cam_number : int, prev_cam_number : int)
signal WeatherChange(curr_cam_number : int, prev_cam_number : int)

func _ready() -> void:
	connect_cameras()
	switch_to_camera(current_camera)

func connect_cameras() -> void:
	for i in range(cameras.size()):
		if cameras[i].has_signal("Switch"):
			cam_numbers[cameras[i]] = i
			cameras[i].Switch.connect(self.switch_to_camera.bind(cameras[i]))

func switch_to_camera(camera: Camera2D):
	if camera == null:
		return
	prev_cam_number = cam_numbers[current_camera]
	camera.make_current()
	current_camera = camera
	curr_cam_number = cam_numbers[camera]
	CurrPrevCamera.emit(curr_cam_number, prev_cam_number)


func _on_weather_manager_camera_new_day(Day: int) -> void:
	WeatherChange.emit(curr_cam_number, prev_cam_number)
