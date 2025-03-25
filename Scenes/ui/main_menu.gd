extends CanvasLayer

var options_scene = preload("res://Scenes/ui/options_menu.tscn")


# Connect all menu buttons to events

func _ready():
	
	$%PlayButton.grab_focus()
	$%PlayButton.pressed.connect(on_play_pressed)
	$%ShopButton.pressed.connect(on_upgrades_pressed)
	$%OptionsButton.pressed.connect(on_options_pressed)
	$%QuitButton.pressed.connect(on_quit_pressed)

# Handles play button

func on_play_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")
	

# Handles upgrade button

func on_upgrades_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://Scenes/ui/shop_menu.tscn")
	

# Handles options button

func on_options_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))


# Handles quit button

func on_quit_pressed():
	get_tree().quit()


# Handles closing the options menu

func on_options_closed(options_instance: Node):
	options_instance.queue_free()
	
	
