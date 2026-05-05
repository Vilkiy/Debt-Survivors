class_name GameHandler
extends Node

const GAME_OVER_SCREEN = preload("res://logic/UI/game_over.tscn")

var run_time: float = 0.0
var running: bool = true

@export var island_scene: PackedScene
@export var island_count := 1
@export var spawn_radius := 1200

var active_chunks := {}
var chunk_size := 800
var view_distance := 2

func _ready() -> void:
	GlobalVar.game_handler = self

	var player_scene = load(GameConfig.selected_hero)
	var player = player_scene.instantiate()

	GlobalVar.player = player

	if FileAccess.file_exists(GameConfig.selected_arena):
		$Parallax2D/TextureRect.texture = load(GameConfig.selected_arena)
	else:
		$Parallax2D/TextureRect.texture = null

	add_child(player)

	await get_tree().process_frame

	GlobalVar.player.health_handler.died.connect(_on_player_died)


func _process(delta: float) -> void:
	if running:
		run_time += delta

	var player = GlobalVar.player
	if player == null:
		return

	var player_chunk = world_to_chunk(player.global_position)

	# Spawn chunks
	for x in range(-view_distance, view_distance + 1):
		for y in range(-view_distance, view_distance + 1):
			var chunk_pos = player_chunk + Vector2i(x, y)

			if not active_chunks.has(chunk_pos):
				spawn_chunk(chunk_pos)

	unload_far_chunks(player_chunk)


func _on_player_died() -> void:
	running = false
	get_tree().paused = true

	await get_tree().create_timer(1.0).timeout

	var game_over = GAME_OVER_SCREEN.instantiate()
	add_child(game_over)


func world_to_chunk(pos: Vector2) -> Vector2i:
	return Vector2i(
		floor(pos.x / chunk_size),
		floor(pos.y / chunk_size)
	)


func spawn_chunk(chunk_pos: Vector2i) -> void:
	if GameConfig.selected_arena.find("water") == -1:
		return

	var chunk = Node2D.new()
	add_child(chunk)

	chunk.position = Vector2(
		chunk_pos.x * chunk_size,
		chunk_pos.y * chunk_size
	)

	var rng = RandomNumberGenerator.new()
	rng.seed = hash(chunk_pos)

	for i in island_count:
		var island = island_scene.instantiate()

		var offset = Vector2(
			rng.randf_range(0, chunk_size),
			rng.randf_range(0, chunk_size)
		)

		island.position = chunk.position + offset
		chunk.add_child(island)

	active_chunks[chunk_pos] = chunk


func unload_far_chunks(player_chunk: Vector2i) -> void:
	var to_remove = []

	for chunk_pos in active_chunks.keys():
		if chunk_pos.distance_to(player_chunk) > view_distance:
			active_chunks[chunk_pos].queue_free()
			to_remove.append(chunk_pos)

	for c in to_remove:
		active_chunks.erase(c)
