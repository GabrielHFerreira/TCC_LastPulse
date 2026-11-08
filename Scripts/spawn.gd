extends Node2D

# Verifique se o caminho da sua cena do inimigo está correto abaixo
@export var enemy_scene: PackedScene = preload("res://Scenes/Inimigo.tscn")
@export var tempo_entre_spawns: float = 2.0

var temporizador: Timer

func _ready() -> void:
	# Cria o Timer automaticamente por código sem depender da cena
	temporizador = Timer.new()
	temporizador.wait_time = tempo_entre_spawns
	temporizador.autostart = true
	temporizador.timeout.connect(_on_timer_timeout)
	add_child(temporizador)
	print("Ponto de Spawn ativo em: ", global_position)

func _on_timer_timeout() -> void:
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		enemy.global_position = global_position
		get_tree().current_scene.add_child(enemy)
		print("Inimigo gerado com sucesso!")
	else:
		print("ERRO: O ficheiro da cena do Inimigo não foi encontrado no spawn.gd!")
