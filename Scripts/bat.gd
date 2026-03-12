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

func recibir_dano(cantidad):
	if esta_muerto: return
	
	# Usamos la variable 'cantidad' para restar vida
	vida -= cantidad 
	
	if vida <= 0:
		$AnimatedSprite2D.play("Hurt") # Tu nueva animación
		esta_muerto = true
		
		var impulso_x = position.x + (200 * -direccion) # Los manda lejos según su dirección
		var tween = create_tween()
		tween.parallel().tween_property(self, "position:x", impulso_x, 0.4).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(self, "position:y", position.y - 100, 0.4) # Un saltito hacia arriba
		tween.tween_property(self, "modulate:a", 0, 0.2) # Se desvanecen
		tween.tween_callback(queue_free)
