extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_radius: float = 300.0
@export var spawn_interval: float = 2.0

var player: Node2D
var elapsed: float = 0.0

func _ready():
	await get_tree().process_frame
	player = GlobalVar.player
	
	$Timer.wait_time = spawn_interval
	$Timer.start()
	$Timer.timeout.connect(spawn_enemy)

func _process(delta: float) -> void:
	elapsed += delta
	var minutes = elapsed / 60.0
	
	# every minute, reduce spawn interval by 0.2 seconds, minimum 0.3
	var new_interval = maxf(spawn_interval - minutes * 0.2, 0.3)
	$Timer.wait_time = new_interval

func spawn_enemy():
	if player == null:
		return
	
	var minutes = elapsed / 60.0
	var enemy = enemy_scene.instantiate()
	
	var angle = randf() * TAU
	var spawn_position = player.global_position + Vector2(cos(angle), sin(angle)) * spawn_radius
	enemy.global_position = spawn_position
	get_parent().add_child(enemy)
	
	# scale stats with time
	enemy.speed *= 1.0 + minutes * 0.05
	enemy.health_handler.hp *= 1.0 + minutes * 0.05
	enemy.health_handler.max_hp *= 1.0 + minutes * 0.05
