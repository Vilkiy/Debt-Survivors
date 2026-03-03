class_name Player
extends CharacterBody2D

@export var speed := 200.0
@onready var health_handler: HealthHandler = $HealthHandler

var current_xp: int = 0
var current_level : int = 1
var xp_to_level_up : int = 100

func _ready() -> void:
	GlobalVar.player = self
	

func _physics_process(_delta):
	var dir := Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		dir.y -= 1
	if Input.is_action_pressed("move_down"):
		dir.y += 1
	if Input.is_action_pressed("move_left"):
		dir.x -= 1
	if Input.is_action_pressed("move_right"):
		dir.x += 1

	if dir != Vector2.ZERO:
		dir = dir.normalized()

	velocity = dir * speed
	move_and_slide()
	


func _on_health_handler_took_damage() -> void:
	pass
	#print("player took damage: " + str(health_handler.hp))


func collect_xp(amount: int) -> void:
	current_xp += amount;
	if (current_xp >= xp_to_level_up): _level_up()
	
func _level_up() -> void:
	current_level+=1
	xp_to_level_up=ceil(1.5*xp_to_level_up)
	current_xp = 0
	
	
