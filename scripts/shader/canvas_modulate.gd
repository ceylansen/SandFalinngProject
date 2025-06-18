extends CanvasModulate

var time : float = 0.0

@export var gradient : GradientTexture1D
const Timecheck : float = (2 * PI) / 60

@export var TimeSpeed : float = 1.0

func _process(delta: float) -> void:
	time += delta * Timecheck * TimeSpeed
	var value = (sin(time) + 1) / 2.0
	self.color = gradient.gradient.sample(value)
