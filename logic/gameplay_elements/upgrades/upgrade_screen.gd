# This script shuffles the full upgrade pool,
# picks the first 3, then creates a button for each one.
# When a button is clicked it calls the upgrade's apply function and emits a signal so the game knows to unpause.

class_name UpgradeScreen
extends CanvasLayer

signal upgrade_chosen

func show_upgrades(player: Player) -> void:
	var pool = Upgrades.get_pool(player)
	pool.shuffle()
	var choices = pool.slice(0, 3)
	
	for choice in choices:
		var button = Button.new()
		button.text = choice["name"] + "\n" + choice["description"]
		button.custom_minimum_size = Vector2(200, 80)
		button.process_mode = Node.PROCESS_MODE_ALWAYS
		$HBoxContainer.add_child(button)
		button.pressed.connect(func():
			choice["apply"].call()
			upgrade_chosen.emit()
		)
