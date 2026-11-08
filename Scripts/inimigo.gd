extends CharacterBody2D

@export var speed_base: float = 60.0
var speed: float
var vida_inimigo: int
var torre: Node2D

func _ready() -> void:
	add_to_group("inimigo")
	
	# Configura a dificuldade baseada no BPM
	var multiplicador = float(Global.batimentos_bpm) / 80.0
	if multiplicador < 1.0:
		multiplicador = 1.0
		
	speed = speed_base * multiplicador
	vida_inimigo = max(1, round(1.0 * multiplicador))

func _physics_process(_delta: float) -> void:
	# Tenta encontrar a torre a cada frame se ela ainda não tiver sido localizada
	if torre == null:
		torre = get_tree().get_first_node_in_group("torre_alvo")

	# Só se move se a torre já tiver sido encontrada
	if torre != null:
		var direction = (torre.global_position - global_position).normalized()
		velocity = direction * speed
		
		# Vira o sprite para a direção do movimento
		var sprite = get_node_or_null("Sprite2D")
		if sprite:
			if direction.x > 0:
				sprite.flip_h = true
			elif direction.x < 0:
				sprite.flip_h = false
				
		move_and_slide()
		
		
func receber_dano(dano: int):
	vida_inimigo -= dano
	print("Fantasma atingido! Vida restante: ", vida_inimigo)
	
	if vida_inimigo <= 0:
		var game_manager = get_tree().root.get_node_or_null("Jogo/Game_Manager")
		if game_manager and game_manager.has_method("add_point"):
			game_manager.add_point()
		
		queue_free() # Elimina o fantasma do jogo
