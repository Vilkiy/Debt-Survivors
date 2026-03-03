class_name Enemy
extends CharacterBody2D

@export var speed: float = 80.0
@export var max_hp: int = 10
@export var damage: int = 5

var hp: int
var player: Node2D

#4 da feel
@export var separation_distance: float = 20.0
@export var separation_force: float = 200.0

<<<<<<< Updated upstream
=======
@onready var health_handler: HealthHandler = $HealthHandler
var hp: int
var player: Node2D
const XP :  = preload("uid://lf31uwke02f8")
>>>>>>> Stashed changes

func _ready():
	hp = max_hp
	
	await get_tree().process_frame
	
	player = GlobalVar.player
	
	
	#print("Groups:", get_groups())
	

func _physics_process(_delta):
	if player == null:
		return

	var direction = (player.global_position - global_position).normalized()
	var separation = get_separation_vector()
	
	#+ seperation isnt needed but it smoothens out the feeling of their hitboxes colliding
	velocity = direction * speed + separation
	
	move_and_slide()

func take_damage(amount: int):
	hp -= amount
	if hp <= 0:
		die()

<<<<<<< Updated upstream
func die():
=======

func _on_death():
	var xp_object = XP.instantiate()
	xp_object.
	get_parent().add_child(XP.instantiate())
>>>>>>> Stashed changes
	queue_free()
	
func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		area.take_damage(damage)
		
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
