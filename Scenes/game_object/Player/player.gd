extends CharacterBody2D



@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var animated_sprite = $Visuals/AnimatedSprite2D



var number_colliding_bodies = 0
var base_speed = 0

func _ready():
	base_speed = velocity_component.max_speed
	
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvent.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()
	

func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if Input.is_action_pressed("move_up") and Input.is_action_pressed("move_left"):
		animated_sprite.play("Run-Up-Left")
	
	elif Input.is_action_pressed("move_up") and Input.is_action_pressed("move_right"):
		animated_sprite.play("Run-Up-Right")
	
	elif Input.is_action_pressed("move_down") and Input.is_action_pressed("move_left"):
		animated_sprite.play("Run-Down-Left")
	
	elif Input.is_action_pressed("move_down") and Input.is_action_pressed("move_right"):
		animated_sprite.play("Run-Down-Right")

	elif Input.is_action_pressed("move_right"):
		animated_sprite.play("Run-Right")
	
	elif Input.is_action_pressed("move_left"):
		animated_sprite.play("Run-Left")
	
	elif Input.is_action_pressed("move_down"):
		animated_sprite.play("Run-Down")
	
	elif Input.is_action_pressed("move_up"):
		animated_sprite.play("Run-Up")
		
	else:
		animated_sprite.play("Idle")

	
func get_movement_vector():
	
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)
	

func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	damage_interval_timer.start()
	print(health_component.current_health)

func update_health_display():
	health_bar.value = health_component.get_health_percent()


func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()

func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1

func on_damage_interval_timer_timeout():
	check_deal_damage()


func on_health_changed():
	GameEvent.emit_player_damaged()
	update_health_display()
	$HitRandomStreamPlayer.play_random()

func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())	
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * .1)

