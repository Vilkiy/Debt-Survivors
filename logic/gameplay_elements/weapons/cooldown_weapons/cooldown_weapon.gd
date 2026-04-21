class_name CooldownWeapon
extends Node2D

var damage: float = 50
#var crit_chance: float = 0.1  # 10% base

var cooldown: float = 0.7
var cooldown_timer: Timer
var projectile_speed: float = 25.0

func _ready() -> void:
	cooldown_timer = Timer.new()
	cooldown_timer.autostart = false
	cooldown_timer.one_shot = false
	add_child(cooldown_timer)
	await get_tree().process_frame
	cooldown_timer.start(cooldown / GlobalVar.player.attack_speed_multiplier)
	cooldown_timer.timeout.connect(on_cooldown_reached)

func on_cooldown_reached() -> void:
	cooldown_timer.wait_time = maxf(cooldown / GlobalVar.player.attack_speed_multiplier, 0.1)

func roll_crit(base_damage: float) -> Dictionary:
		var is_crit = randf() < GlobalVar.player.crit_chance
		return {
		"damage": base_damage * 1.5 if is_crit else base_damage,
		"is_crit": is_crit
	}
