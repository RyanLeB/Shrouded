extends AudioStreamPlayer


@export var streams: Array[AudioStream]

func _ready():
	if streams == null || streams.size() == 0:
		return
	
	stream = streams.pick_random()
	play()
	
	
