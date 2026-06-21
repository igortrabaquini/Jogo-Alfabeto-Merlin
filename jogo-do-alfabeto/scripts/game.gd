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

var casa_atual := 0
var jogador_atual := 1
var jogo_finalizado := false

func _ready():

	label_turno.text = "Vez do Jogador 1"

	moeda.moeda_lancada.connect(_on_moeda_lancada)

	# Chegada da nave ao início
	var tween = create_tween()

	tween.tween_property(
		nave,
		"global_position",
		casas[0].global_position,
		1.5
	)

	await tween.finished

	label_turno.text = "Vez do Jogador 1"


func _on_moeda_lancada(resultado):

	if jogo_finalizado:
		return

	await mover_nave(resultado)

	if casa_atual == casas.size() - 1:

		jogo_finalizado = true

		# Por enquanto ninguém tem pontos
		label_turno.text = "Empate!"

		return

	trocar_turno()


func mover_nave(passos):

	var destino = min(
		casa_atual + passos,
		casas.size() - 1
	)

	casa_atual = destino

	var tween = create_tween()

	tween.tween_property(
		nave,
		"global_position",
		casas[casa_atual].global_position,
		0.8
	)

	await tween.finished


func trocar_turno():

	if jogador_atual == 1:
		jogador_atual = 2
	else:
		jogador_atual = 1

	label_turno.text = "Vez do Jogador %d" % jogador_atual
