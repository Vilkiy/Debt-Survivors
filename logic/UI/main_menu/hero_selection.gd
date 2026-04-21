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
@onready var hero_description = get_node("/root/MainMenu/heroDescription")
@onready var current_description = get_node("/root/MainMenu/heroDescription/descriptionLabel")

# Hero data
var heroes = [
	{
		"name": "Bum",
		"scene": "res://logic/playable_characters/Shotgun_Character.tscn",
		"image": "res://visuals/characters/homeless_debt_survivor/dept_survivor_idle1.png",
		"description": "Throws a spread of 5 bottles [color=orange](150% AD)[/color]\nStarting container capacity of 2.\nDoes not benefit from attack speed (for now)\nDash to reload containers instantly\n [color=gray]It costs 10000 euros to fire this weapon[/color]\n[color=gray]for 12 seconds.[/color]"
	},
	{
		"name": "Neckbeard Weeb",
		"scene": "res://logic/playable_characters/Sword_Character.tscn",
		"image": "res://visuals/characters/weeb_neckbeard_debt_survivor/place_holder_thumb.png",
		"description": "Dual swords that alternate. [color=orange](120% AD)[/color]
[color=red]Odd swings[/color] deal 3x crit damage
[color=1780ac]Even swings[/color] boost speed. (+80%)
[color=white]Dash to knock enemies back in a small radius *NOT IMPLIMENTED*[/color]"
	}
]

var index = 0

func _ready():
	hero_description.visible = false
	current_preview.mouse_entered.connect(_on_preview_mouse_entered)
	current_preview.mouse_exited.connect(_on_preview_mouse_exited)
	call_deferred("update_display")

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
	
	if heroes[index].has("description"):
		current_description.text = heroes[index]["description"]

func _on_left_pressed() -> void:
	index = (index - 1 + heroes.size()) % heroes.size()
	update_display()

func _on_right_pressed() -> void:
	index = (index + 1) % heroes.size()
	update_display()

func get_selected_hero_scene():
	return heroes[index]["scene"]
	

var _desc_panel: PanelContainer = null

func _on_preview_mouse_entered():
	if heroes[index].has("description"):
		current_description.parse_bbcode(heroes[index]["description"])
		hero_description.reset_size()
		hero_description.visible = true


func _on_preview_mouse_exited():
	hero_description.visible = false

func _process(_delta: float) -> void:
	if hero_description.visible:
		hero_description.global_position = get_global_mouse_position() + Vector2(10, 10)
