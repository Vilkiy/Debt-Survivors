class_name HUD
extends CanvasLayer

@onready var level_label: Label = $VBoxContainer/LevelLabel
@onready var xp_bar: ProgressBar = $Control/XPBar
@onready var ad_label: Label = $VBoxContainer/ADLabel
@onready var currency_label: Label = $VBoxContainer/CurrencyLabel
@onready var boss_bar: ProgressBar = $BossHealthBar
var current_boss: Enemy = null

func update(current_xp: int, xp_to_level_up: int, current_level: int, attack_damage: float) -> void:
	level_label.text = "Level: " + str(current_level)
	xp_bar.max_value = xp_to_level_up
	xp_bar.value = current_xp
	ad_label.text = "AD: " + str(attack_damage)
	currency_label.text = "$ " + str(UpgradeCurrencyManager.coins)
	
func _process(_delta):
	if current_boss == null:
		return

	# ✅ safest check (covers deletion properly)
	if not is_instance_valid(current_boss):
		boss_bar.visible = false
		current_boss = null
		return

	# update HP
	boss_bar.value = current_boss.health_handler.hp

func show_boss(boss: Enemy) -> void:
	current_boss = boss

	boss_bar.visible = true
	boss_bar.max_value = boss.health_handler.max_hp
	boss_bar.value = boss.health_handler.hp

	# ✅ CONNECT DEATH SIGNAL (THIS IS THE FIX)
	if not boss.health_handler.died.is_connected(_on_boss_died):
		boss.health_handler.died.connect(_on_boss_died)

func _on_boss_died() -> void:
	boss_bar.visible = false
	boss_bar.value = 0   # reset
	current_boss = null
