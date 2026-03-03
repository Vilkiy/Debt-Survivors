class_name Enemy
extends CharacterBody2D


@export var speed: float = 80.0
@export var max_hp: int = 10
@export var damage: int = 5

var hit_cooldown := 0.5  # seconds between hits
var hit_timer := 0.0

@export var separation_distance: float = 20.0
@export var separation_force: float = 200.0
const XP : PackedScene = preload("uid://lf31uwke02f8")

@onready var health_handler: HealthHandler = $HealthHandler
var hp: int
var player: Node2D
var dead : bool = false

func _ready():
	hp = max_hp
	
	await get_tree().process_frame
	
	player = GlobalVar.player
	
	health_handler.died.connect(_on_death)
	
	#print("Groups:", get_groups())
	

func _physics_process(_delta):
	if player == null:
		return

	# Update hit cooldown timer
	if hit_timer > 0.0:
		hit_timer -= _delta

	var direction = (player.global_position - global_position).normalized()
	var separation = get_separation_vector()
	
	velocity = direction * speed + separation
	move_and_slide()

	# Automatic hit check (optional if not using signals)
	if global_position.distance_to(player.global_position) < 20.0 and hit_timer <= 0.0:
		player._on_health_handler_took_damage(global_position)
		hit_timer = hit_cooldown
	
func _on_body_entered(body):
	if body is Player:
		body._on_health_handler_took_damage(global_position)


func _on_death():
	dead = true
	var xp_object : XP = XP.instantiate()
	xp_object.global_position = global_position
	get_parent().add_child(xp_object)
	queue_free()
	




func get_separation_vector():
	var push_vector = Vector2.ZERO

	for body in get_tree().get_nodes_in_group("enemy"):
		if body == self:
			continue

		var distance = global_position.distance_to(body.global_position)

		if distance < separation_distance:
			print("close")
			push_vector += (global_position - body.global_position).normalized() * separation_force

	return push_vector
