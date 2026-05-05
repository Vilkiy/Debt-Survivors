extends Control

@onready var coin_label: Label = $CurrencyContainer/Currency

@onready var health_upgrade_label: Label = %HealthUpgradeLabel
@onready var buy_health_button: Button = %BuyHealthButton
@onready var attack_upgrade_label: Label = %AttackUpgradeLabel
@onready var speed_upgrade_label: Label = %SpeedUpgradeLabel

@onready var buy_attack_button: Button = %BuyAttackButton
@onready var buy_speed_button: Button = %BuySpeedButton

func _ready() -> void:
	update_ui()

func _on_back_pressed() -> void:
	UpgradeCurrencyManager.save_coins()
	get_tree().change_scene_to_file("res://logic/UI/main_menu/main_menu.tscn")
	


func update_ui()->void:
	
	health_upgrade_label.text = "Health Upgrade " + str(roundi(UpgradeCurrencyManager.health_increase)) + " Cost: 5" 
	attack_upgrade_label.text = "Attack Upgrade " + str(roundi(UpgradeCurrencyManager.attack_damage_increase)) + " Cost: 5" 
	speed_upgrade_label.text = "Speed Upgrade " + str(roundi(UpgradeCurrencyManager.movement_speed_increase)) + " Cost: 5" 
	
	
	coin_label.text = "$ " + str(UpgradeCurrencyManager.coins)
	
	
	buy_health_button.disabled =not UpgradeCurrencyManager.coins >= 5
	buy_attack_button.disabled =not UpgradeCurrencyManager.coins >= 5
	buy_speed_button.disabled = not UpgradeCurrencyManager.coins >= 5
	

func _on_buy_health_button_pressed() -> void:
	if not UpgradeCurrencyManager.coins >= 5:
		return
	
	UpgradeCurrencyManager.coins -= 5
	
	UpgradeCurrencyManager.health_increase += 5
	update_ui()
	


func _on_buy_attack_button_pressed() -> void:
	if not UpgradeCurrencyManager.coins >= 5:
		return
	
	UpgradeCurrencyManager.coins -= 5
	
	UpgradeCurrencyManager.attack_damage_increase += 5
	update_ui()


func _on_buy_speed_button_pressed() -> void:
	if not UpgradeCurrencyManager.coins >= 5:
		return
	
	UpgradeCurrencyManager.coins -= 5
	
	UpgradeCurrencyManager.movement_speed_increase += 5
	update_ui()
