extends Control

@onready var label_turno = $LabelTurno

@onready var letra1 = $Letra1
@onready var letra2 = $Letra2
@onready var letra3 = $Letra3
@onready var letra4 = $Letra4
@onready var letra5 = $Letra5

@onready var entrada = $LineEdit
@onready var botao = $BotaoTentar

@onready var pontos_j1_label = $LabelPontosJ1
@onready var pontos_j2_label = $LabelPontosJ2

var letras = []

var palavra = ""
var reveladas = []

var palavras = [
	"AMIGO",
	"AREIA",
	"AVIAO",
	"BANCO",
	"BOLSA",
	"BRAVO",
	"CASAS",
	"CARRO",
	"CORES",
	"DADOS",
	"DENTE",
	"DOCES",
	"ERVAS",
	"EXATO",
	"ENTRA"
]

func _ready():

	letras = [
		letra1,
		letra2,
		letra3,
		letra4,
		letra5
	]

	botao.pressed.connect(_on_botao_tentar)

	iniciar_jogo()


func iniciar_jogo():

	palavra = palavras.pick_random()

	reveladas = ["_", "_", "_", "_", "_"]

	atualizar_letras()
	atualizar_pontos()

	label_turno.text = "Vez do Jogador %d" % GameManager.jogador_atual

	print("Palavra sorteada: ", palavra)


func atualizar_letras():

	for i in range(5):
		letras[i].text = reveladas[i]


func atualizar_pontos():

	pontos_j1_label.text = str(GameManager.pontos_j1)
	pontos_j2_label.text = str(GameManager.pontos_j2)


func adicionar_pontos(valor):

	if GameManager.jogador_atual == 1:
		GameManager.pontos_j1 += valor
	else:
		GameManager.pontos_j2 += valor

	atualizar_pontos()


func trocar_turno():

	if GameManager.jogador_atual == 1:
		GameManager.jogador_atual = 2
	else:
		GameManager.jogador_atual = 1

	label_turno.text = "Vez do Jogador %d" % GameManager.jogador_atual


func palavra_completa():

	for letra in reveladas:
		if letra == "_":
			return false

	return true


func voltar_tabuleiro():

	await get_tree().create_timer(1.5).timeout

	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_botao_tentar():

	var tentativa = entrada.text.strip_edges().to_upper()

	if tentativa.is_empty():
		return

	entrada.clear()

	if tentativa.length() == 1:

		for i in range(5):

			if palavra[i] == tentativa and reveladas[i] == "_":

				reveladas[i] = tentativa
				adicionar_pontos(1)

		atualizar_letras()

		if palavra_completa():

			label_turno.text = "Palavra completa!"

			await voltar_tabuleiro()
			return

		trocar_turno()

	elif tentativa.length() == 5:

		if tentativa == palavra:

			var faltavam = 0

			for letra in reveladas:
				if letra == "_":
					faltavam += 1

			adicionar_pontos(faltavam)

			for i in range(5):
				reveladas[i] = palavra[i]

			atualizar_letras()

			label_turno.text = "Palavra completa!"

			await voltar_tabuleiro()

		else:

			trocar_turno()
