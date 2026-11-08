extends CharacterBody2D

@export var speed: float = 150.0

# Certifique-se de que o caminho corresponde ao nome exato da sua cena de tiro
@onready var shoot_scene = preload("res://Scenes/Tiro.tscn") 

func _physics_process(_delta: float) -> void:
	# Captura as teclas pressionadas para movimentação
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	
	velocity.x = direction_x * speed
	velocity.y = direction_y * speed
	
	# Ação de atirar
	if Input.is_action_just_pressed("Shoot"):
		atirar()
		
	move_and_slide()

func atirar():
	var tiro = shoot_scene.instantiate()
	# O tiro agora é instanciado diretamente no centro do personagem
	tiro.global_position = global_position
	get_tree().root.add_child(tiro)
