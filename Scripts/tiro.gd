extends Area2D

@export var speed: float = 400.0
var direction: Vector2

func _ready() -> void:
	# Conecta automaticamente o sinal de colisão assim que o tiro nasce
	body_entered.connect(_on_body_entered)
	
	var posicao_mouse = get_global_mouse_position()
	direction = (posicao_mouse - global_position).normalized()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	# Imprime no Output para podermos testar se a colisão está acontecendo
	print("Tiro atingiu: ", body.name)
	
	if body.is_in_group("inimigo"):
		if body.has_method("receber_dano"):
			body.receber_dano(1)
		queue_free()
		
	elif body is StaticBody2D:
		queue_free()
