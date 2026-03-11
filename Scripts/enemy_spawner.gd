extends Node2D

@export var enemy_scene: PackedScene
@export var direccion_enemigo: int = 1 # 1 para Derecha, -1 para Izquierda
@onready var timer = $Timer

func _on_timer_timeout():
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		
		# Lo posicionamos donde está el spawner
		enemy.global_position = global_position
		
		# Le pasamos la dirección (importante para el movimiento en bat.gd)
		enemy.direccion = direccion_enemigo
		
		# Si va a la izquierda, espejamos el nodo entero
		if direccion_enemigo == -1:
			enemy.scale.x = -1
			
		get_tree().current_scene.add_child(enemy)
