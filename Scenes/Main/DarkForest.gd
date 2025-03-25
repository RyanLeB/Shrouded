extends Node

@export var end_screen_scene: PackedScene

var pause_menu_scene = preload("res://Scenes/ui/pause_menu.tscn")

func _ready():
	$%Player.health_component.died.connect(on_player_died)

# Handle pause menu

func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()
	

# Handle player death

func on_player_died():
	ProjectMusicController.stop()
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()

