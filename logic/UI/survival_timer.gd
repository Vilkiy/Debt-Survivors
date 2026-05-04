extends Label

func _process(_delta: float) -> void:
	var elapsed := 0.0

	if GlobalVar.game_handler:
		elapsed = GlobalVar.game_handler.run_time

	var minutes = int(elapsed) / 60
	var seconds = int(elapsed) % 60

	text = "%02d:%02d" % [minutes, seconds]
