extends CharacterBody2D

# on ready variables

@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals




func _ready():
	$HurtboxComponent.hit.connect(on_hit)

# Move to player (more floaty than normal enemy)

func _process(delta):
	
	velocity_component.accelerate_to_player()
	
	velocity_component.move(self)
	
	

	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)




# Plays hit sound effect at a random pitch

func on_hit():
	$RandomAudioStreamPlayer2DComponent.play_random()

