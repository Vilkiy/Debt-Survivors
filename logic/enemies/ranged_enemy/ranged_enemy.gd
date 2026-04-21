extends Enemy

@export var attack_range: float = 550.0
@export var shoot_cooldown: float = 5.0

var shoot_timer: float = 0.0
const PROJECTILE = preload("res://logic/enemies/ranged_enemy/projectile.tscn")

func _ready():
	hp = 200
	max_hp = 300
	speed = 100
	damage = 10
	xpAmount = 30
	
	health_handler.resistances["physical"] = 0.0
	health_handler.resistances["magic"] = 0.7

	super()


func _physics_process(delta):

	if flash_timer > 0.0:
		flash_timer -= delta
		if flash_timer <= 0.0:
			sprite.material = null
	
	if player == null:
		return

	# cooldown
	if shoot_timer > 0:
		shoot_timer -= delta

	var distance = global_position.distance_to(player.global_position)
	var direction = (player.global_position - global_position).normalized()

	if distance > attack_range:
		# 🔁 CHASE
		velocity = direction * speed
	else:
		# 🛑 STOP + SHOOT
		velocity = Vector2.ZERO

		if shoot_timer <= 0:
			shoot()
			shoot_timer = shoot_cooldown

	move_and_slide()

func shoot():
	var projectile = PROJECTILE.instantiate()
	projectile.global_position = global_position

	var dir = (player.global_position - global_position).normalized()
	projectile.direction = dir

	get_parent().add_child(projectile)
