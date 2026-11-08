extends Label

func _process(_delta: float) -> void:
	# Acessa o Autoload C# diretamente pelo caminho /root/SerialReader
	var serial = get_node_or_null("/root/SerialReader")
	if serial:
		var bpm = serial.GetBpm()
		text = "Batimentos: " + str(bpm) + " BPM"
