extends CharacterBody2D

# on ready variables
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent

func _ready():
	$HurtboxComponent.hit.connect(on_hit)

# move to player
func _process(delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(-move_sign, 1)

# play hit sound effect at a random pitch
func on_hit():
	$RandomAudioStreamPlayer2DComponent.play_random()
