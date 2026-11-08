extends Area2D

# Esta função roda automaticamente quando o jogo começa e adiciona a torre ao grupo
func _ready() -> void:
	add_to_group("torre_alvo")

# Função ativada automaticamente quando um corpo físico entra na área da árvore
func _on_body_entered(body: Node2D) -> void:
	# Verifica se o objeto que colidiu tem a etiqueta "inimigo"
	if body.is_in_group("inimigo"):
		# Reduz a vida guardada no script global
		Global.vida -= 1
		
		# Destrói o fantasma após o impacto
		body.queue_free()
