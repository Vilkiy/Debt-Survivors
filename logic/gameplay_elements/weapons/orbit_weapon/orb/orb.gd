class_name Orb
extends Area2D

var damage: float = 10.0
var hit_cooldown: float = 0.5
var hit_timers: Dictionary = {}

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy and not hit_timers.has(body):
		body.health_handler.take_damage(damage)
		hit_timers[body] = hit_cooldown

func _process(delta: float) -> void:
	for body in hit_timers.keys():
		hit_timers[body] -= delta
		if hit_timers[body] <= 0.0:
			hit_timers.erase(body)
