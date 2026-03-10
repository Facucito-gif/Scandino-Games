extends Area2D

var vida = 2
var velocidad = 150.0  # Velocidad de caída
var frecuencia = 0.05  # Qué tan rápido hace el zigzag
var amplitud = 100.0   # Qué tan ancho es el zigzag
var pos_inicial_x = 0

func _ready():
	pos_inicial_x = position.x

func _process(delta):
	# Movimiento hacia abajo
	position.y += velocidad * delta
	
	# Movimiento zigzag (Seno)
	position.x = pos_inicial_x + sin(position.y * frecuencia) * amplitud
	
	# Si se sale de pantalla, borrarlo
	if position.y > 800:
		queue_free()

func recibir_dano():
	vida -= 1
	if vida <= 0:
		queue_free() # ¡Muerto!
