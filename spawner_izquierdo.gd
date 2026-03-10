extends Node2D

@export var enemy_scene: PackedScene
@export var direccion_bala: int = 1 # 1 para derecha, -1 para izquierda

func _on_timer_timeout():
	var enemy = enemy_scene.instantiate()
	
	# Lo posicionamos donde esté este Spawner
	enemy.global_position = global_position
	
	# Le pasamos la dirección al murciélago
	enemy.direccion = direccion_bala
	
	# Si dispara hacia la izquierda, espejamos el gráfico del murciélago
	if direccion_bala == -1:
		# Buscamos el sprite del murciélago para darlo vuelta
		for child in enemy.get_children():
			if child is Sprite2D or child is AnimatedSprite2D:
				child.flip_h = true
	
	get_tree().current_scene.add_child(enemy)
