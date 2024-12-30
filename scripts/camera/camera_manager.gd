extends Node2D

@export var player: CharacterBody2D
@export var current_camera: Camera2D
@onready var cameras = get_children()

func _ready() -> void:
	connect_cameras()
	switch_to_camera(current_camera)

func connect_cameras() -> void:
	for camera in cameras:
		if camera.has_signal("Switch"):
			camera.Switch.connect(self.switch_to_camera.bind(camera))

func switch_to_camera(camera: Camera2D):
	print(camera)
	if camera == null or camera == current_camera:
		return
	camera.make_current()
	current_camera = camera
