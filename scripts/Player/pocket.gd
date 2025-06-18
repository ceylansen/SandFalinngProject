extends Node2D

@export var PocketList : Array
@export var MAX_CAPACITY : int = 10

func _ready() -> void:
	PocketList.clear()

func AddPixel(Pixel : int) -> bool:
	if PocketList.size() < MAX_CAPACITY:
		PocketList.append(Pixel)
		return true
	return false

func EjectTopPixel() -> int:
	if PocketList.size() > 0:
		var Pixel : int = PocketList.pop_back()
		return Pixel
	else:
		return -1
