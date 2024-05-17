extends Label

@onready var name_label: Label = $%EXPLabel
@onready var experience_manager = $"../../ExperienceManager"


func _ready():
	experience_manager.experience_updated.connect(update_text)



func update_text():
	var currency = MetaProgression.save_data["meta_upgrade_currency"]
	name_label.text = "Souls Collected: " + str(currency)
