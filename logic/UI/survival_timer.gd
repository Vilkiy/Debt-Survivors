extends Label

var elapsed : float = 0.0

func _process(delta: float) -> void:
	elapsed += delta
	@warning_ignore("integer_division")
	var minutes = int(elapsed) / 60
	var seconds = int(elapsed) % 60
	text = "%02d:%02d" % [minutes, seconds]
