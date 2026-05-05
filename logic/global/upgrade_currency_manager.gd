extends Node

const SAVE_PATH = "user://coins.save"

var coins: int = 0
var health_increase: float = 0
var movement_speed_increase: float = 0
var attack_damage_increase: float = 0

func _ready() -> void:
	load_coins()

func add_coins(amount: int) -> void:
	coins += amount
	save_coins()

func save_coins() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_32(coins)
		file.store_float(health_increase)
		file.store_float(movement_speed_increase)
		file.store_float(attack_damage_increase)

func load_coins() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		coins = 0
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		coins = file.get_32()
		health_increase = file.get_float()
		movement_speed_increase = file.get_float()
		attack_damage_increase = file.get_float()
