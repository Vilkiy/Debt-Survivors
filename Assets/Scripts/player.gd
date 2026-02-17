extends CharacterBody2D

@export var speed := 200.0
var hp: int = 100

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
	
func take_damage(amount: int):
	hp -= amount
	print("Player HP:", hp)
