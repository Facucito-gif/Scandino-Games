extends Area2D

var direccion = 1
var vida = 2
var velocidad = 250.0 # Un poco más rápido para que sea desafío
var frecuencia = 0.01
var amplitud = 150.0
var pos_inicial_y = 0

func _ready():
	# Guardamos la altura a la que aparece
	pos_inicial_y = position.y
	# IMPORTANTE: Añadí al murciélago al grupo "enemigos" en el editor (Pestaña Nodo > Grupos)

func _process(delta):
	# Movimiento HORIZONTAL
	position.x += velocidad * direccion * delta
	
	# Zigzag VERTICAL (Seno) para que no sea una línea aburrida
	position.y = pos_inicial_y + sin(Time.get_ticks_msec() * frecuencia) * 20.0
	
	# Si se escapa de la pantalla, borrarlo
	if position.x > 1500 or position.x < -200:
		queue_free()

func recibir_dano(cantidad):
	vida -= cantidad
	if vida <= 0:
		queue_free()
