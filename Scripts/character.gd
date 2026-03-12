extends CharacterBody2D

var daño_ataque = 2
# Referencias
@onready var sprite = $AnimatedSprite2D
@onready var ghost_timer = $GhostTimer

# Configuración del mini-dash permanente
var dash_distancia = 35.0
var dash_duracion = 0.1

# Pre-cargar la escena de la estela
#const GHOST_SCENE = preload("res://ghost_effect.tscn")
#ALERT -NO SÉ QUE ES LO DE ARRIBA Y TE LO COMENTÉ 

func _process(_delta):
	if Input.is_action_just_pressed("atacar_izq"):
		ejecutar_ataque("izq")
		
	if Input.is_action_just_pressed("atacar_der"):
		ejecutar_ataque("der")

func ejecutar_ataque(direccion):
	var destino_x = position.x # Guardamos la posición actual
	
	if direccion == "der":
		destino_x += dash_distancia
		scale.x = 1
	else:
		destino_x -= dash_distancia
		scale.x = -1
	
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

# --- VOLVER AL IDLE  ---
func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "ATTACK":
		sprite.play("IDLE")


func _on_attack_area_area_entered(area):
	if area.is_in_group("enemigos"):
		print("¡Golpeando a: ", area.name, "!")
		if area.has_method("recibir_dano"):
			area.recibir_dano(2) # Le mandamos 2 de daño para matarlo de un toque
