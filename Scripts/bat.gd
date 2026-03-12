extends Area2D

var vida = 2
var esta_muerto = false
var velocidad = 100
var direccion = 1 # <-- OBLIGATORIO para que el Spawner no tire error

func _process(delta):
	if !esta_muerto:
		position.x += velocidad * direccion * delta
		# Si direccion es -1, invertimos el sprite
		$AnimatedSprite2D.flip_h = (direccion == 1)

# Esta función ayuda a que el spawner le asigne el lado correctamente
func set_direccion(nueva_dir):
	direccion = nueva_dir

func recibir_dano(cantidad):
	if esta_muerto: return
	
	vida -= cantidad
	print("Vida restante del bicho: ", vida) # Mirá la consola para ver si baja
	
	if vida <= 0:
		morir()
	else:
		$AnimatedSprite2D.play("Hurt")

func morir():
	esta_muerto = true
	$AnimatedSprite2D.play("Hurt") # O "Death" si tenés
	
	# Efecto de muerte: gira y se desvanece
	var tween = create_tween()
	tween.parallel().tween_property(self, "rotation_degrees", 180, 0.3)
	tween.parallel().tween_property(self, "modulate:a", 0, 0.3)
	tween.tween_callback(queue_free)

func _on_area_entered(area):
	print("SOY UN BAT Y ME TOCÓ: ", area.name)
	if area.name == "AttackArea":
		recibir_dano(2)

func _on_body_entered(body):
	if body.name == "Character" and !esta_muerto:
		if body.has_method("recibir_dano_jugador"):
			body.recibir_dano_jugador(1)
