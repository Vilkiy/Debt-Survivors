class_name PauseMenu
extends Control

@onready var continue_button: Button = %ContinueButton
@onready var exit_button: Button = %ExitButton

func _ready() -> void:
	hide()
	continue_button.pressed.connect(_on_continue_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if visible:
			_resume()
		else:
			_pause()

func _pause() -> void:
	get_tree().paused = true
	show()

func _resume() -> void:
	get_tree().paused = false
	hide()

func _on_continue_pressed() -> void:
	_resume()

func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("uid://dfix7tnp5v2sk")
