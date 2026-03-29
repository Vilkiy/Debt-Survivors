extends HBoxContainer

@onready var prev_container = $previous
@onready var current_container = $current
@onready var next_container = $next

# Grab nodes inside each container
@onready var prev_preview = prev_container.get_node("preview")
@onready var prev_label = prev_container.get_node("heroLabel")
@onready var current_preview = current_container.get_node("preview")
@onready var current_label = current_container.get_node("heroLabel")
@onready var next_preview = next_container.get_node("preview")
@onready var next_label = next_container.get_node("heroLabel")

# Hero data
var heroes = [
	{
		"name": "Bum",
		"scene": "res://Assets/Scenes/Player.tscn",
		"image": "res://visuals/characters/homeless_debt_survivor/dept_survivor_idle1.png"
	},
	{
		"name": "Mage",
		"scene": "res://Assets/Scenes/Player.tscn",
		"image": "res://visuals/characters/homeless_debt_survivor/dept_survivor_idle1.png"
	},
	{
		"name": "Rogue",
		"scene": "res://Assets/Scenes/Player.tscn",
		"image": "res://visuals/characters/homeless_debt_survivor/dept_survivor_idle1.png"
	}
]

var index = 0

func _ready():
	update_display()

func update_display():
	# Current hero
	var current = heroes[index]
	current_label.text = current["name"]
	current_preview.texture = load(current["image"])
	
	# Previous hero
	var prev_index = (index - 1 + heroes.size()) % heroes.size()
	prev_label.text = heroes[prev_index]["name"]
	prev_preview.texture = load(heroes[prev_index]["image"])
	
	# Next hero
	var next_index = (index + 1) % heroes.size()
	next_label.text = heroes[next_index]["name"]
	next_preview.texture = load(heroes[next_index]["image"])

	# --- Set opacity for carousel effect ---
	current_preview.modulate = Color(1, 1, 1, 1)
	current_label.modulate   = Color(1, 1, 1, 1)
	prev_preview.modulate    = Color(1, 1, 1, 0.5)
	prev_label.modulate      = Color(1, 1, 1, 0.5)
	next_preview.modulate    = Color(1, 1, 1, 0.5)
	next_label.modulate      = Color(1, 1, 1, 0.5)

func _on_left_pressed() -> void:
	index = (index - 1 + heroes.size()) % heroes.size()
	update_display()

func _on_right_pressed() -> void:
	index = (index + 1) % heroes.size()
	update_display()

func get_selected_hero_scene():
	return heroes[index]["scene"]
