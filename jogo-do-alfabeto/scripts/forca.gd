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

var jogador_atual = 1

var pontos_j1 = 0
var pontos_j2 = 0

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

	label_turno.text = "Vez do Jogador 1"

	atualizar_pontos()

	print("Palavra sorteada: ", palavra)


func atualizar_letras():

	for i in range(5):
		letras[i].text = reveladas[i]


func atualizar_pontos():

	pontos_j1_label.text = "%d" % pontos_j1
	pontos_j2_label.text = "%d" % pontos_j2


func adicionar_pontos(valor):

	if jogador_atual == 1:
		pontos_j1 += valor
	else:
		pontos_j2 += valor

	atualizar_pontos()


func trocar_turno():

	if jogador_atual == 1:
		jogador_atual = 2
	else:
		jogador_atual = 1

	label_turno.text = "Vez do Jogador %d" % jogador_atual


func palavra_completa():

	for letra in reveladas:
		if letra == "_":
			return false

	return true


func _on_botao_tentar():

	var tentativa = entrada.text.strip_edges().to_upper()

	if tentativa.is_empty():
		return

	entrada.clear()

	# Tentativa de letra
	if tentativa.length() == 1:

		var encontrou = false

		for i in range(5):

			if palavra[i] == tentativa and reveladas[i] == "_":

				reveladas[i] = tentativa

				adicionar_pontos(1)

				encontrou = true

		atualizar_letras()

		if palavra_completa():

			label_turno.text = "Palavra completa!"
			botao.disabled = true
			return

		trocar_turno()

	# Tentativa da palavra inteira
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
			botao.disabled = true

		else:

			trocar_turno()
