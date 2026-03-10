# This script shuffles the full upgrade pool,
# picks the first 3, then creates a button for each one.
# When a button is clicked it calls the upgrade's apply function and emits a signal so the game knows to unpause.

class_name UpgradeScreen
extends CanvasLayer

signal upgrade_chosen

func show_upgrades(player: Player) -> void:
	var pool = Upgrades.get_pool(player)
	pool = pool.filter(func(u): return not u.has("condition") or u["condition"].call())
	pool.shuffle()
	var choices = pool.slice(0, 3)
	
	for choice in choices:
		var panel = PanelContainer.new()
		panel.custom_minimum_size = Vector2(250, 120)
		
		var vbox = VBoxContainer.new()
		panel.add_child(vbox)
		
		var title = Label.new()
		title.text = choice["name"]
		title.add_theme_font_size_override("font_size", 20)
		vbox.add_child(title)
		
		var desc = RichTextLabel.new()
		desc.bbcode_enabled = true
		desc.fit_content = true
		desc.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var text = choice["description"]
		if choice.has("ad_scaling"):
			text += "\n[color=orange](" + str(choice["ad_scaling"] * 100) + "% AD)[/color]"
		desc.text = text
		vbox.add_child(desc)
		
		var button = Button.new()
		button.text = "Choose"
		button.process_mode = Node.PROCESS_MODE_ALWAYS
		vbox.add_child(button)
		
		$HBoxContainer.add_child(panel)
		button.pressed.connect(func():
			choice["apply"].call()
			upgrade_chosen.emit()
		)
