extends Node

var batimentos_bpm: int = 80
var vida: int = 5
var pontos: int = 0

var server := PacketPeerUDP.new()
const PORT := 4242

func _ready() -> void:
	# Garante o fecho de conexões pendentes para não bloquear a porta 4242
	if server.is_bound():
		server.close()
		
	var err = server.bind(PORT, "127.0.0.1")
	if err != OK:
		print("AVISO: Porta UDP ", PORT, " indisponível (Erro ", err, "). O jogo usará o BPM padrão.")
	else:
		print("Godot aguardando dados de BPM na porta ", PORT)

func _process(_delta: float) -> void:
	if not server.is_bound():
		return
		
	while server.get_available_packet_count() > 0:
		var packet = server.get_packet()
		var data = packet.get_string_from_utf8()
		
		if data.is_valid_int():
			batimentos_bpm = data.to_int()
			print("BPM CHEGOU NO GODOT: ", batimentos_bpm) # <-- Adicione esta linha

func reset() -> void:
	vida = 5
	pontos = 0
	batimentos_bpm = 80

# Executado automaticamente ao fechar ou reiniciar o jogo
func _exit_tree() -> void:
	if server.is_bound():
		server.close()
