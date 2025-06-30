extends CanvasLayer

var tween_time : int = 2
@onready var children = get_children()
var bgs : Array

func _ready() -> void:
	for child in children:
		if child is ColorRect:
			bgs.append(child)

func ChangeBackground(background : int) -> void:
	print(background)
	var current_bg: ColorRect = null
	for bg in bgs:
		if bg.visible:
			current_bg = bg
			break

	var next_bg: ColorRect = null
	match background:
		1: next_bg = $RainBackground
		2: next_bg = $SnowBackground
		3: next_bg = $RainBackground
		4: next_bg = $SnowBackground
		0: next_bg = $DayTime

	if next_bg != current_bg:
		if current_bg:
			smooth_fade(current_bg, next_bg)
		else:
			next_bg.modulate.a = 0.0
			next_bg.show()
			get_tree().create_tween().tween_property(next_bg, "modulate:a", 1.0, tween_time)

func smooth_fade(from_bg: ColorRect, to_bg: ColorRect) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(from_bg, "modulate:a", 0.0, tween_time)
	to_bg.modulate.a = 0.0
	to_bg.show()
	tween.tween_property(to_bg, "modulate:a", 1.0, tween_time)
	tween.tween_callback(Callable(from_bg, "hide"))
