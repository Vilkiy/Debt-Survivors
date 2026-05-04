class_name Upgrades

static func get_pool(player: Player) -> Array[Dictionary]:
	return [
		{
			"name": "Attack Speed Up",
			"description": "All weapons attack [color=yellow]10% faster[/color]",
			"apply": func(): player.attack_speed_multiplier *= 1.1
		},
		{
			"name": "Move Faster",
			"description": "Player moves 50 units faster",
			"apply": func(): player.speed += 50
		},
		{
			"name": "More Health",
			"description": "Gain 20 max HP and heal to full",
			"apply": func(): player.health_handler.max_hp += 20; player.health_handler.hp = player.health_handler.max_hp
		},
		{
			"name": "POW",
			"description": "1 Extra max bullet",
			"condition": func(): return is_instance_valid(player.get_node_or_null("Weapons/ProjectileShooter")),
			"apply": func():
		var shooter = player.get_node("Weapons/ProjectileShooter")
		shooter.max_ammo += 1
		shooter.refill_ammo()
		player.get_node("BulletDisplay").setup(shooter.max_ammo)
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
		{
		"name": "Eye of the Golem",
		"description": "Gain 10% critical hit chance [color=red](50% extra damage)[/color]",
		"apply": func(): player.crit_chance += 0.1
		},
		{
		"name": "One to Seal",
		"description": "Even swing speed boost increased by [color=cyan]10%[/color]",
		"condition": func(): return is_instance_valid(player.get_node_or_null("Weapons/SwordWeapon")),
		"apply": func():
		var sword = player.get_node("Weapons/SwordWeapon")
		sword.speed_boost_amount *= 1.1
		},
		
	]
