extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_radius: float = 300.0
@export var spawn_interval: float = 2.0

var player: Node2D

func _ready():
	await get_tree().process_frame
	player = GlobalVar.player
	
	$Timer.wait_time = spawn_interval
	$Timer.start()
	$Timer.timeout.connect(spawn_enemy)

func spawn_enemy():
	if player == null:
		return
	
	#print("spawned enemy")
	var enemy = enemy_scene.instantiate()
	
	var angle = randf() * TAU
	var spawn_position = player.global_position + Vector2(cos(angle), sin(angle)) * spawn_radius
	
	enemy.global_position = spawn_position
	get_parent().add_child(enemy)
	
