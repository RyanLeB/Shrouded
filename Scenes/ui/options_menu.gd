extends CanvasLayer
class_name Options

signal volume_settings_changed
signal options_closed
signal back_pressed

@onready var window_button = $%WindowButton
@onready var sfx_slider = %SFXSlider
@onready var music_slider = %MusicSlider
@onready var back_button = $%BackButton

func _ready():
	
	
	back_button.pressed.connect(on_back_pressed)
	window_button.pressed.connect(on_window_button_pressed)
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind("SFX"))
	
	music_slider.value_changed.connect(on_audio_slider_changed.bind("Music"))
	load_volume_settings()
	update_display()

func load_volume_settings():
	# Load saved volume settings from the MetaProgression script
	var sfx_volume = MetaProgression.get_bus_volume_percent("SFX")
	var music_volume = MetaProgression.get_bus_volume_percent("Music")
	
	# Set the slider values to the saved volume settings
	sfx_slider.value = sfx_volume
	music_slider.value = music_volume


func update_display():
	window_button.text = "Windowed"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		window_button.text = "Fullscreen"
	var saved_sfx_volume = MetaProgression.get_bus_volume_percent("SFX")
	var saved_music_volume = MetaProgression.get_bus_volume_percent("Music")
	sfx_slider.value = saved_sfx_volume
	music_slider.value = saved_music_volume
	print("Saved SFX Volume:", saved_sfx_volume)
	print("Saved Music Volume:", saved_music_volume)
	

func get_bus_volume_percent(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func set_bus_volume_percent(bus_name: String, percent: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
	


func on_window_button_pressed():
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	update_display()

func on_audio_slider_changed(value: float, bus_name: String):
	set_bus_volume_percent(bus_name, value)
	MetaProgression.save()


func on_back_pressed():
	MetaProgression.save()
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	back_pressed.emit()
	
