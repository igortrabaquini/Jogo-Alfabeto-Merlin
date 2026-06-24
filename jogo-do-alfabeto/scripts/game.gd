extends Node2D

@onready var nave = $Player
@onready var moeda = $Moeda
@onready var label_turno = $LabelTurno

@onready var casas = [
	$Casas/Inicio,
	$Casas/A,
	$Casas/B,
	$Casas/C,
	$Casas/D,
	$Casas/E,
	$Casas/Fim
]

var jogo_finalizado := false

func _ready():

	moeda.moeda_lancada.connect(_on_moeda_lancada)

	if GameManager.primeira_entrada:

		GameManager.primeira_entrada = false

		GameManager.casa_atual = 0
		GameManager.jogador_atual = 1
		GameManager.pontos_j1 = 0
		GameManager.pontos_j2 = 0

		label_turno.text = "Vez do Jogador 1"

		var tween = create_tween()

		tween.tween_property(
			nave,
			"global_position",
			casas[0].global_position,
			1.5
		)

		await tween.finished

	else:

		nave.global_position = casas[GameManager.casa_atual].global_position

		if GameManager.jogador_atual == 1:
			label_turno.text = "Vez do Jogador 1"
		else:
			label_turno.text = "Vez do Jogador 2"

	if GameManager.casa_atual == casas.size() - 1:
		finalizar_jogo()


func _on_moeda_lancada(resultado):

	if jogo_finalizado:
		return

	await mover_nave(resultado)

	if GameManager.casa_atual == casas.size() - 1:

		finalizar_jogo()
		return

	get_tree().change_scene_to_file("res://scenes/forca.tscn")


func mover_nave(passos):

	var destino = min(
		GameManager.casa_atual + passos,
		casas.size() - 1
	)

	GameManager.casa_atual = destino

	var tween = create_tween()

	tween.tween_property(
		nave,
		"global_position",
		casas[destino].global_position,
		0.8
	)

	await tween.finished


func finalizar_jogo():

	jogo_finalizado = true

	if GameManager.pontos_j1 > GameManager.pontos_j2:
		label_turno.text = "Jogador 1 venceu!"
	elif GameManager.pontos_j2 > GameManager.pontos_j1:
		label_turno.text = "Jogador 2 venceu!"
	else:
		label_turno.text = "Empate!"
