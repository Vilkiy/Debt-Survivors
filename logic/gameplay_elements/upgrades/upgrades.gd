class_name Upgrades

static func get_pool(player: Player) -> Array[Dictionary]:
	return [
		{
			"name": "More Damage",
			"description": "Projectiles deal 10 more damage",
			"apply": func(): player.get_node("Weapons/ProjectileShooter").damage += 10
		},
		{
			"name": "Faster Firing",
			"description": "Shoots 0.1s more frequently",
			"apply": func(): player.get_node("Weapons/ProjectileShooter").cooldown -= 0.1
		},
		{
			"name": "Wider Spread",
			"description": "Projectiles spread 5 more degrees",
			"apply": func(): player.get_node("Weapons/ProjectileShooter").spread_angle += 5
		},
		{
			"name": "Move Faster",
			"description": "Player moves 20 units faster",
			"apply": func(): player.speed += 20
		},
		{
			"name": "More Health",
			"description": "Gain 20 max HP and heal to full",
			"apply": func(): player.health_handler.max_hp += 20; player.health_handler.hp = player.health_handler.max_hp
		},
		{
			"name": "Knockback King",
			"description": "Knockback strength increased by 50",
			"apply": func(): player.knockback_strength += 50
		},
		{
		 "name": "Double Shot",
		"description": "Fire an extra projectile each shot",
		"apply": func(): player.get_node("Weapons/ProjectileShooter").projectile_count += 1
		},
	]
