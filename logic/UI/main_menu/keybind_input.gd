class_name KeybindButton
extends HBoxContainer

@export var input_action_string: String = ""
@export var input_action_display: String = ""

@onready var keybind_display: Label = %KeybindDisplay
@onready var keybind_press: Button = %KeybindPress

var _is_rebinding: bool = false

func _ready() -> void:
	
	keybind_press.pressed.connect(_on_keybind_press_pressed)
	if not input_action_string.is_empty() \
			and InputMap.has_action(input_action_string) \
			and InputMap.action_get_events(input_action_string).is_empty():
		InputMap.load_from_project_settings()
	_update_display()

func _input(event: InputEvent) -> void:
	if not _is_rebinding:
		return
	
	if event is InputEventMouseMotion:
		return
	if event is InputEventKey and not event.pressed:
		return
	if event is InputEventMouseButton and not event.pressed:
		return
	
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		_stop_rebinding()
		return
	
	if event is InputEventKey or event is InputEventMouseButton:
		_assign_new_binding(event)
		get_viewport().set_input_as_handled()

func _on_keybind_press_pressed() -> void:
	if _is_rebinding:
		_stop_rebinding()
	else:
		_start_rebinding()

func _start_rebinding() -> void:
	_is_rebinding = true
	keybind_display.text = "Press a key..."
	keybind_press.add_theme_color_override("font_color", Color.YELLOW)

func _stop_rebinding() -> void:
	_is_rebinding = false
	keybind_press.remove_theme_color_override("font_color")
	_update_display()

func _assign_new_binding(event: InputEvent) -> void:
	if input_action_string.is_empty():
		_stop_rebinding()
		return
	
	for existing in InputMap.action_get_events(input_action_string):
		InputMap.action_erase_event(input_action_string, existing)
	
	InputMap.action_add_event(input_action_string, event)
	_stop_rebinding()

func _update_display() -> void:
	var label := input_action_display if not input_action_display.is_empty() \
			else input_action_string
	keybind_display.text = label

	var key_text := "Unbound"
	if not input_action_string.is_empty() \
			and InputMap.has_action(input_action_string):
		var events := InputMap.action_get_events(input_action_string)
		
		if not events.is_empty():
			key_text = _clean_event_text(events[0])
			
	
	keybind_press.text = key_text

func _clean_event_text(event: InputEvent) -> String:
	if event is InputEventKey:
		var keycode = event.keycode
		if keycode == 0:
			keycode = event.physical_keycode
		return OS.get_keycode_string(keycode)
	return event.as_text()
