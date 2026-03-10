extends CharacterBody2D

var daño_ataque = 2
# Referencias
@onready var sprite = $AnimatedSprite2D
@onready var ghost_timer = $GhostTimer

# Configuración del mini-dash permanente
var dash_distancia = 35.0
var dash_duracion = 0.1

# Pre-cargar la escena de la estela
const GHOST_SCENE = preload("res://ghost_effect.tscn")

func _process(_delta):
	if Input.is_action_just_pressed("atacar_izq"):
		ejecutar_ataque("izq")
		
	if Input.is_action_just_pressed("atacar_der"):
		ejecutar_ataque("der")

func ejecutar_ataque(direccion):
	var destino_x = position.x

	
	if direccion == "izq":
		# -- ESTO ES LO NUEVO --
		# En lugar de flipear la imagen, 'espejamos' el cuerpo entero.
		# Así, la cápsula de colisión y el área de ataque también se espejan.
		scale.x = -1 # Mira a la izquierda
		destino_x -= dash_distancia
	else:
		# Mira a la derecha (escala normal)
		scale.x = 1
		destino_x += dash_distancia

	# 2. PRENDER el golpe (Lo que hicimos en el paso B)
	$AttackArea/CollisionShape2D.disabled = false
	
	# 3. Animación y Estela
	sprite.stop()
	sprite.play("ATTACK")
	ghost_timer.start()
	
	# 4. Movimiento (DASH)
	var tween = create_tween()
	tween.tween_property(self, "position:x", destino_x, dash_duracion)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# 5. Apagar todo al terminar
	tween.tween_callback(ghost_timer.stop)
	
	# Esperamos un toque y apagamos la colisión de ataque
	await get_tree().create_timer(0.1).timeout
	$AttackArea/CollisionShape2D.disabled = true

# --- CONECTAR LA SEÑAL DEL GHOSTTIMER ---
# En el panel de Nodos, conecta la señal 'timeout()' del GhostTimer aquí:
func _on_ghost_timer_timeout():
	# Instanciar el fantasma
	var ghost = GHOST_SCENE.instantiate()
	
	# Configurar sus propiedades con los datos actuales del sprite
	ghost.set_ghost_properties(
		sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame),
		sprite.flip_h,
		position # Usamos la posición global/del cuerpo
	)
	
	# Añadirlo a la escena principal (no como hijo del personaje, o se movería con él)
	get_tree().current_scene.add_child(ghost)

# --- VOLVER AL IDLE  ---
func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "ATTACK":
		sprite.play("IDLE")

func _on_attack_area_area_entered(area):
	# Si lo que tocamos es un enemigo (asegúrate de que el enemigo tenga un grupo llamado "enemigo")
	if area.is_in_group("enemigo"):
		area.recibir_dano()
		
