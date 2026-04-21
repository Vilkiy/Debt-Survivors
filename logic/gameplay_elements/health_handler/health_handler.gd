class_name HealthHandler
extends Control

@onready var health_bar: ProgressBar = $HealthBar
@onready var dash_bar: ProgressBar = $DashBar
const DAMAGE_NUMBER = preload("res://logic/UI/damage_numbers/damage_number.tscn")
const CRIT_NUMBER = preload("res://logic/UI/damage_numbers/damage_crit_number.tscn")

var resistances := {
	"physical": 0.0,
	"magic": 0.0
}

@export var hp : float = 100:
	set(value):
		hp = value
		if health_bar:
			health_bar.value = hp
var max_hp : float

signal died
signal took_damage

var _pending_damage: float = 0.0
var _pending_is_crit: bool = false
var _damage_queued: bool = false

func _ready() -> void:
	max_hp = hp
	health_bar.max_value = hp
	health_bar.value = hp

func take_damage(damage_amount: float, damage_type: String = "physical", is_crit: bool = false) -> void:
	if damage_amount <= 0.0:
		return

	var resistance = resistances.get(damage_type, 0.0)
	resistance = clamp(resistance, 0.0, 1.0)

	var final_damage = damage_amount * (1.0 - resistance)

	_pending_damage += final_damage

	if is_crit:
		_pending_is_crit = true

	if not _damage_queued:
		_damage_queued = true
		call_deferred("_flush_damage")

func _flush_damage() -> void:
	if not _damage_queued:
		return
	_damage_queued = false
	took_damage.emit()
	var dn = (CRIT_NUMBER if _pending_is_crit else DAMAGE_NUMBER).instantiate()
	get_tree().root.get_child(0).add_child(dn)
	dn.global_position = global_position + Vector2(0, -80)
	dn.setup(_pending_damage)
	hp = clampf(hp - _pending_damage, 0.0, max_hp)
	_pending_damage = 0.0
	_pending_is_crit = false
	if hp <= 0.0:
		die()

func update_dash_cooldown(dash_timer: float, dash_cooldown: float) -> void:
	dash_bar.max_value = dash_cooldown
	dash_bar.value = dash_cooldown - dash_timer

func die() -> void:
	died.emit()
