class_name Enemy
extends CharacterBody2D


@export var speed: float = 80.0
@export var max_hp: int = 10000
@export var damage: int = 5
@export var xpAmount: int = 10

var hit_cooldown := 0.5  # seconds between hits
var hit_timer := 0.0

@export var separation_distance: float = 20.0
@export var separation_force: float = 200.0
const XP_PACKED : PackedScene = preload("uid://lf31uwke02f8")

@onready var health_handler: HealthHandler = $HealthHandler
var hp: int
var player: Node2D
var dead : bool = false

@onready var sprite: Sprite2D = $Sprite2D
const HURT_SHADER = preload("res://logic/enemies/enemy_hurt.gdshader")
var flash_timer: float = 0.0
const FLASH_DURATION: float = 0.5

func _ready():
	health_handler.hp = hp
	health_handler._ready()
	hp = max_hp
	await get_tree().process_frame
	player = GlobalVar.player
	health_handler.died.connect(_on_death)
	health_handler.took_damage.connect(flash_red)

func _physics_process(_delta):
	
	# add this at the top of _physics_process
	if flash_timer > 0.0:
		flash_timer -= _delta
		if flash_timer <= 0.0:
			sprite.material = null
	
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
		player.deal_knockback(global_position)
		hit_timer = hit_cooldown
	
func _on_body_entered(body):
	if body is Player:
		body.deal_knockback(global_position)


func _on_death():
	dead = true
	var xp_object : XP = XP_PACKED.instantiate()
	xp_object.value = xpAmount
	xp_object.global_position = global_position
	#get_parent().add_child(xp_object)
	get_parent().call_deferred("add_child", xp_object)
	queue_free()
	

func flash_red() -> void:
	if flash_timer <= 0.0:
		var flashMaterial = ShaderMaterial.new()
		flashMaterial.shader = HURT_SHADER
		flashMaterial.set_shader_parameter("Flash Speed", 12.5)
		sprite.material = flashMaterial
		flash_timer = FLASH_DURATION


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
