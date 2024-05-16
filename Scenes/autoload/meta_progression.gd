extends Node

const SAVE_FILE_PATH = "user://save.data"




var save_data: Dictionary = {
	
	"meta_upgrade_currency": 0,
	"meta_upgrades": {},
	"Music_Volume": 0,
	"SFX_Volume": 0,
}


func _ready():
	
	GameEvent.experience_vial_collected.connect(on_experience_collected)
	load_save_file()
	


func load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		return
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()
	
	set_bus_volume_percent("SFX", clamp(save_data["SFX_Volume"], 0.0, 1.0))
	set_bus_volume_percent("Music", clamp(save_data["Music_Volume"], 0.0, 1.0))
	print(save_data)
	
	

func save():
	var sfx_volume = get_bus_volume_percent("SFX")
	var music_volume = get_bus_volume_percent("Music")
	
	sfx_volume = clamp(sfx_volume, 0.0, 1.0)
	music_volume = clamp(music_volume, 0.0, 1.0)
	
	# Store the volume levels in the save data dictionary
	save_data["SFX_Volume"] = sfx_volume
	save_data["Music_Volume"] = music_volume
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)

func add_meta_upgrade(upgrade: MetaUpgrade):
	if !save_data["meta_upgrades"].has(upgrade.id):
		save_data["meta_upgrades"][upgrade.id] = {
			"quantity": 0
		}
	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1
	save()
	
	
func get_upgrade_count(upgrade_id: String):
	if save_data["meta_upgrades"].has(upgrade_id):
		return save_data["meta_upgrades"][upgrade_id]["quantity"]
	return 0

func on_experience_collected(number: float):
	save_data["meta_upgrade_currency"] += number
	

# Music and SFX

func get_bus_volume_percent(bus_name: String) -> float:
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)

func set_bus_volume_percent(bus_name: String, percent: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
	
