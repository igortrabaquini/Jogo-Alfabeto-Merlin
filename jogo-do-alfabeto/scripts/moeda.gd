extends Area2D

signal moeda_lancada(resultado)
@onready var sprite = $AnimatedSprite2D

var mouse_por_cima : bool = false
var esta_girando : bool = false
# Guarda a escala original para nunca deformar o sprite permanentemente
var escala_original : Vector2 

func _ready():
	# Salva a escala que você definiu no editor (geralmente (1, 1))
	escala_original = sprite.scale
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	mouse_por_cima = true

func _on_mouse_exited():
	mouse_por_cima = false

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if mouse_por_cima and not esta_girando:
			jogar_moeda()

func jogar_moeda():
	esta_girando = true
	
	# Garante que a moeda comece o giro no tamanho certo
	sprite.scale = escala_original
	
	# --- Loop de Giro ---
	for i in range(6):
		if sprite.animation == "1":
			sprite.play("2")
		else:
			sprite.play("1")
		
		var tween = create_tween()
		# Achata em direção ao zero usando a escala original como base
		tween.tween_property(sprite, "scale:x", 0.01, 0.05)
		# Volta exatamente para a escala original de X
		tween.tween_property(sprite, "scale:x", escala_original.x, 0.05)
		
		await get_tree().create_timer(0.1).timeout

	# --- Resultado Final ---
	var resultado = randi() % 2
	if resultado == 0:
		sprite.play("1")
		print("Caiu o número 1!")
		moeda_lancada.emit(1)
	else:
		sprite.play("2")
		print("Caiu o número 2!")
		moeda_lancada.emit(2)
		
	# Garante que, independente do que aconteça, a escala termine perfeita
	sprite.scale = escala_original
	esta_girando = false
