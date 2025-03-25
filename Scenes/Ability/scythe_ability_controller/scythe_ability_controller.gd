extends Node

# reference scythe ability scene

@export var scythe_ability_scene: PackedScene

# base damage and upgrade values

var base_damage = 50
var additional_damage_percent = 1

# timeout event connection

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvent.ability_upgrade_added.connect(on_ability_upgrade_added)
	

# handle timeout event

func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null:
		return
	
	var scythe_instance = scythe_ability_scene.instantiate() as Node2D
	foreground.add_child(scythe_instance)
	scythe_instance.global_position = player.global_position
	scythe_instance.hitbox_component.damage = base_damage * additional_damage_percent


# add ability when upgrade is earned

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "scythe_damage":
		additional_damage_percent = 1 + (current_upgrades["scythe_damage"]["quantity"] * .10)
	
	
