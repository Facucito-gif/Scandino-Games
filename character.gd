extends CharacterBody2D

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
		sprite.flip_h = true
		destino_x -= dash_distancia
	else:
		sprite.flip_h = false
		destino_x += dash_distancia

	sprite.stop()
	sprite.play("ATTACK")
	
	# 1. EMPEZAR A CREAR ESTELA
	ghost_timer.start() # Empieza a soltar fantasmas cada 0.03 seg.

# DASH PERMANENTE (Tween)
	var tween = create_tween()
	tween.tween_property(self, "position:x", destino_x, dash_duracion)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# PARAR LA ESTELA AL TERMINAR EL DASH
	tween.tween_callback(ghost_timer.stop)

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
