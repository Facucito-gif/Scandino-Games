extends Node2D

@export var enemy_scene: PackedScene # Aquí arrastrarás tu archivo Bat.tscn
@onready var timer = $Timer

func _on_timer_timeout():
	spawn_enemy()

func spawn_enemy():
	# 1. Instanciamos el enemigo
	var enemy = enemy_scene.instantiate()
	
	# 2. Elegimos una posición X aleatoria (de izquierda a derecha de la pantalla)
	# Supongamos que tu pantalla mide 1152 píxeles de ancho
	var random_x = randf_range(100, 1052) 
	
	# 3. Lo ponemos arriba de la pantalla (y = -50 para que no aparezca de golpe)
	enemy.global_position = Vector2(random_x, -50)
	
	# 4. Lo añadimos a la escena
	get_tree().current_scene.add_child(enemy)
