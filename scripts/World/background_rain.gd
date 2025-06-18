extends CanvasLayer

func ChangeBackground(Background : int):
	var bgs = get_children()
	for bg in bgs:
		bg.hide()
	match Background:
		1: $RainBackground.show()
		2: $SnowBackground.show()
		3: $RainBackground.show()
