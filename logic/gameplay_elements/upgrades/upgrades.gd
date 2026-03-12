class_name Upgrades

static func get_pool(player: Player) -> Array[Dictionary]:
	return [
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
			"name": "More Knockback",
			"description": "Knockback strength increased by 50",
			"apply": func(): player.knockback_strength += 50
		},
		{
			"name": "POW",
			"ad_scaling": 1.0,
			"description": "Fire an extra projectile each shot",
			"apply": func(): player.get_node("Weapons/ProjectileShooter").projectile_count += 1
		},
		{
			"name": "Orbit Orb Orb",
			"description": "Gain an orb that orbits you and damages enemies",
			"ad_scaling": 2.0,
			"condition": func(): return not is_instance_valid(player.get_node_or_null("Weapons/OrbitWeapon")),
			"apply": func():
		var orbit_weapon = load("res://logic/gameplay_elements/weapons/orbit_weapon/orbit_weapon.tscn").instantiate()
		orbit_weapon.name = "OrbitWeapon"
		player.get_node("Weapons").add_child(orbit_weapon)
},
		{
			"name": "Extra Orb",
			"description": "Add another orbiting orb",
			"ad_scaling": 2.0,
			"condition": func(): return is_instance_valid(player.get_node_or_null("Weapons/OrbitWeapon")),
			"apply": func():
		var w = player.get_node("Weapons/OrbitWeapon")
		w.orb_count += 1
		w.update_orbs()
		},
		{
		"name": "Attack Damage Up",
		"description": "Gain 20 Attack Damage",
		"apply": func():
		player.attack_damage_base += 20
		player.recalculate_weapon_damages()
		},
		{
		"name": "Attack Damage Boost",
		"description": "Gain 10% more Attack Damage",
		"apply": func():
		player.attack_damage_multiplier *= 1.1
		player.recalculate_weapon_damages()
		},
		
	]
