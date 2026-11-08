extends Node

# Variáveis globais do jogo
var batimentos_bpm: int = 80
var vida: int = 5
var pontos: int = 0

# Configuração do servidor UDP para comunicação com o Python
var server := PacketPeerUDP.new()
const PORT := 4242

func _ready() -> void:
	# Inicia a escuta da porta UDP local
	var err = server.bind(PORT, "127.0.0.1")
	if err != OK:
		print("Erro ao conectar à porta UDP: ", err)
	else:
		print("Godot aguardando dados de BPM na porta ", PORT)

func _process(_delta: float) -> void:
	# Lê continuamente todos os pacotes enviados pela ponte Python
	while server.get_available_packet_count() > 0:
		var packet = server.get_packet()
		var data = packet.get_string_from_utf8()
		
		# Atualiza o BPM se o valor recebido for um número válido
		if data.is_valid_int():
			batimentos_bpm = data.to_int()

# Função chamada pelo game_manager.gd para reiniciar o estado do jogo
func reset() -> void:
	vida = 5
	pontos = 0
	batimentos_bpm = 80
