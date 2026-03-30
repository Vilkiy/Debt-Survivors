extends Node2D

@export var waves: Array[WaveResource]

# enum → scene mapping
@export var enemy_scene_map = {
	SpawnableEnemyTypes.Type.SMALL_FAST: preload("res://logic/enemies/fast_enemy.tscn"),
	SpawnableEnemyTypes.Type.MEDIUM: preload("res://logic/enemies/medium_enemy.tscn"),
	SpawnableEnemyTypes.Type.BIG_SLOW: preload("res://logic/enemies/big_enemy.tscn")
}


var player: Node2D
var current_wave_index := 0
var wave_elapsed := 0.0
var total_elapsed := 0.0

@onready var timer: Timer = $Timer


func _ready():
	await get_tree().process_frame
	player = GlobalVar.player

	timer.timeout.connect(_spawn_enemy)
	_start_wave(0)
	
func _start_wave(index: int):
	current_wave_index = index
	wave_elapsed = 0.0
	print("Started new waves")

	var wave = waves[current_wave_index]

	timer.wait_time = wave.spawn_interval
	timer.start()

func _process(delta):
	if waves.is_empty():
		return

	var wave = waves[current_wave_index]

	total_elapsed += delta
	wave_elapsed += delta

	if not wave.is_last_wave and wave_elapsed >= wave.duration:
		_next_wave()
		
func _next_wave():
	current_wave_index += 1

	if current_wave_index >= waves.size():
		current_wave_index = waves.size() - 1

	_start_wave(current_wave_index)
	
func _choose_enemy_type(wave: WaveResource) -> int:
	var total_weight := 0

	for key in wave.enemy_weights.keys():
		total_weight += wave.enemy_weights[key]

	var roll = randi_range(1, total_weight)
	var cumulative := 0

	for key in wave.enemy_weights.keys():
		cumulative += wave.enemy_weights[key]
		if roll <= cumulative:
			return key

	return wave.enemy_weights[0].type
	
func _spawn_enemy():
	if player == null:
		return

	var wave = waves[current_wave_index]

	var enemy_type = _choose_enemy_type(wave)
	var scene: PackedScene = enemy_scene_map[enemy_type]

	var enemy = scene.instantiate()

	# spawn around player
	var angle = randf() * TAU
	var pos = player.global_position + \
		Vector2.from_angle(angle) * wave.spawn_radius

	enemy.global_position = pos
	get_tree().current_scene.add_child(enemy)

	if wave.scaling_enabled:
		_apply_scaling(enemy)
		
		
func _apply_scaling(enemy):
	var minutes = total_elapsed / 60.0
	var scale = 1.0 + minutes * 0.05

	enemy.speed *= scale
	enemy.max_hp *= scale
	enemy.damage *= scale
	enemy.hp = enemy.max_hp
