extends Node2D

@export var boss_spawns: Array[BossSpawnResource]

var player: Node2D
var total_elapsed := 0.0
var next_spawn_index := 0


func _ready():
	await get_tree().process_frame
	player = GlobalVar.player

	# ensure ordered execution
	boss_spawns.sort_custom(func(a, b):
		return a.spawn_time_seconds < b.spawn_time_seconds
	)


func _process(delta):
	if boss_spawns.is_empty():
		return

	total_elapsed += delta
	_check_spawn()
	
	
func _check_spawn():
	if next_spawn_index >= boss_spawns.size():
		return

	var spawn_data = boss_spawns[next_spawn_index]

	if total_elapsed >= spawn_data.spawn_time_seconds:
		_spawn_boss(spawn_data)
		next_spawn_index += 1

func _spawn_boss(spawn_data: BossSpawnResource):
	if player == null:
		return

	if spawn_data.boss_scene == null:
		push_error("BossSpawner: Missing boss scene.")
		return

	var boss = spawn_data.boss_scene.instantiate()

	var angle = randf() * TAU
	var spawn_pos = player.global_position + Vector2.from_angle(angle) * 1000.0

	boss.global_position = spawn_pos

	get_tree().current_scene.add_child(boss)

	print("Boss spawned at time:", total_elapsed)
