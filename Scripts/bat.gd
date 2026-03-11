extends Area2D

var direccion = 1
var vida = 2
var velocidad = 250.0 # Un poco más rápido para que sea desafío
var frecuencia = 0.01
var amplitud = 150.0
var pos_inicial_y = 0
var esta_muerto = false

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
	if position.x > 2500 or position.x < -1500: # Límites mucho más amplios
		queue_free()

# ... (tus variables de velocidad, frecuencia, etc.)

func recibir_dano(cantidad):
	if esta_muerto: return
	
	# Usamos la variable 'cantidad' para restar vida
	vida -= cantidad 
	
	if vida <= 0:
		esta_muerto = true
		
		# Feedback visual: Parpadeo blanco
		modulate = Color(10, 10, 10) 
		
		var tween = create_tween()
		# Se vuelve transparente al 50% y cae
		tween.tween_property(self, "modulate", Color(1, 1, 1, 0.5), 0.1)
		tween.tween_property(self, "position:y", 1000, 0.8).set_ease(Tween.EASE_IN)
		tween.tween_callback(queue_free)
