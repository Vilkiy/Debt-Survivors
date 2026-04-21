extends Node

const SAVE_PATH = "user://coins.save"

var coins: int = 0

func _ready() -> void:
	load_coins()

func add_coins(amount: int) -> void:
	coins += amount
	save_coins()

func save_coins() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_32(coins)

func load_coins() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		coins = 0
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		coins = file.get_32()
