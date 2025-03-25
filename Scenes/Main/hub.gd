extends Node

var pause_menu_scene = preload("res://Scenes/ui/pause_menu.tscn")


# Handle pause menu

func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()
