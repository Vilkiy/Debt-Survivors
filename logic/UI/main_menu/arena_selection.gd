extends HBoxContainer

@onready var prev_container = $previous
@onready var current_container = $current
@onready var next_container = $next

# Grab nodes inside each container
@onready var prev_preview = prev_container.get_node("preview")
@onready var prev_label = prev_container.get_node("arenaLabel")
@onready var current_preview = current_container.get_node("preview")
@onready var current_label = current_container.get_node("arenaLabel")
@onready var next_preview = next_container.get_node("preview")
@onready var next_label = next_container.get_node("arenaLabel")

# Arena data
var arenas = [
	{
		"name": "Default Arena",
		"scene": "",
		"image": "res://Assets/Sprites/arena/default_arena.png",
		"waves": [
			"res://logic/enemy_spawner/waves/wave1.tres",
			"res://logic/enemy_spawner/waves/wave2.tres",
			"res://logic/enemy_spawner/waves/wave3.tres"
		]
	},
	{
		"name": "Water Arena",
		"scene": "res://Assets/Sprites/arena/water_tile_1080.png",
		"image": "res://Assets/Sprites/arena/water_icon_256.png",
		"waves": [
			"res://logic/enemy_spawner/waves/wave2.tres",
			"res://logic/enemy_spawner/waves/wave1.tres",
			"res://logic/enemy_spawner/waves/wave3.tres"
		]
	},
	{
		"name": "Lava Arena",
		"scene": "res://Assets/Sprites/arena/lava_tile_1080.png",
		"image": "res://Assets/Sprites/arena/lava_icon_256.png",
		"waves": [
			"res://logic/enemy_spawner/waves/wave3.tres",
			"res://logic/enemy_spawner/waves/wave1.tres",
			"res://logic/enemy_spawner/waves/wave2.tres"
		]
	}
]

var index = 0

func _ready():
	update_display()

func update_display():
	# Current arena
	var current = arenas[index]
	current_label.text = current["name"]
	current_preview.texture = load(current["image"])
	
	# Previous arena
	var prev_index = (index - 1 + arenas.size()) % arenas.size()
	prev_label.text = arenas[prev_index]["name"]
	prev_preview.texture = load(arenas[prev_index]["image"])
	
	# Next arena
	var next_index = (index + 1) % arenas.size()
	next_label.text = arenas[next_index]["name"]
	next_preview.texture = load(arenas[next_index]["image"])

	# --- Set opacity for carousel effect ---
	# Current fully visible
	current_preview.modulate = Color(1,1,1,1)
	current_label.modulate   = Color(1,1,1,1)
	
	# Previous/next semi-transparent
	prev_preview.modulate = Color(1,1,1,0.5)
	prev_label.modulate   = Color(1,1,1,0.5)
	next_preview.modulate = Color(1,1,1,0.5)
	next_label.modulate   = Color(1,1,1,0.5)

func _on_left_pressed() -> void:
	index = (index - 1 + arenas.size()) % arenas.size()
	update_display()

func _on_right_pressed() -> void:
	index = (index + 1) % arenas.size()
	update_display()

func get_selected_arena_scene():
	return arenas[index]["scene"]

func get_selected_arena_waves():
	return arenas[index]["waves"]
