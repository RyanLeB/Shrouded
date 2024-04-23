extends Node

@export var victory_screen_scene: PackedScene

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(on_timer_timeout)


func get_time_elapsed():
	return $Timer.wait_time - $Timer.time_left


func on_timer_timeout():
	var victory_screen_instance = victory_screen_scene.instantiate()
	add_child(victory_screen_instance)
