extends Resource
class_name WaveResource

@export var duration: float = 30.0
@export var spawn_interval: float = 2.0
@export var spawn_radius: float = 300.0
@export var enemy_weights: Dictionary = {
	SpawnableEnemyTypes.Type.SMALL_FAST: 10,
	SpawnableEnemyTypes.Type.MEDIUM	: 10,
	SpawnableEnemyTypes.Type.BIG_SLOW: 10,
	SpawnableEnemyTypes.Type.RANGED: 10

}
@export var scaling_enabled: bool = true
@export var is_last_wave: bool = false
